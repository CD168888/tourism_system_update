package org.example.springboot.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.memory.ChatMemoryRepository;
import org.springframework.ai.chat.memory.MessageWindowChatMemory;
import org.springframework.http.MediaType;
import org.springframework.http.codec.ServerSentEvent;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;
import jakarta.servlet.http.HttpServletResponse;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

@RestController
@RequestMapping("/ai")
@Slf4j
public class AiChatController {

    private final ChatClient dashScopeChatClient;

    // 存储每个会话的流式状态标识
    private final ConcurrentHashMap<String, AtomicBoolean> streamingStates = new ConcurrentHashMap<>();

    public AiChatController(ChatClient.Builder chatClientBuilder, ChatMemoryRepository chatMemoryRepository) {
        this.dashScopeChatClient = chatClientBuilder
                .defaultAdvisors(MessageChatMemoryAdvisor.builder(
                                MessageWindowChatMemory.builder().chatMemoryRepository(chatMemoryRepository).build())
                        .build()) // 通过不同角色Message方式传递聊天记忆
                .build();
    }

    /**
     * 流式对话接口，支持 SSE 输出并能中断
     * @param message 用户输入的消息
     * @param conversationId 会话ID，用于记忆上下文
     * @return Flux<ServerSentEvent<String>> 流式响应数据
     */
    @GetMapping(value = "/chatStream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<ServerSentEvent<String>> generate(
            @RequestParam(value = "message", required = true) String message,
            @RequestParam(value = "conversationId", required = true) Long conversationId,
            HttpServletResponse response) {

        log.info("接收到 AI 对话请求 - 消息: {}, 会话ID: {}", message, conversationId);

        // 设置响应头，禁用缓存，确保流式输出实时推送
        response.setHeader("Cache-Control", "no-cache, no-transform");
        response.setHeader("X-Accel-Buffering", "no");

        // 创建会话标识
        String chatId = String.valueOf(conversationId);

        // 为当前会话创建流式状态标识
        AtomicBoolean isStreaming = streamingStates.computeIfAbsent(chatId, k -> new AtomicBoolean(true));
        isStreaming.set(true);

        // 生成流式对话
        return dashScopeChatClient.prompt()
                .user(message)
                .advisors(a -> a.param(ChatMemory.CONVERSATION_ID, conversationId))
                .stream()
                .content()
                .takeWhile(data -> isStreaming.get())  // 支持流的中断
                .map(content -> ServerSentEvent.<String>builder()
                        .data(content)
                        .build())  // 封装为 ServerSentEvent
                .concatWith(Flux.just(ServerSentEvent.<String>builder()
                        .data("\u0003")  // 发送 ETX 结束标记
                        .build()))
                .doOnComplete(() -> {
                    // 对话完成时的操作
                    streamingStates.remove(chatId);
                    log.info("流式对话完成 [会话ID: {}]", chatId);
                })
                .doOnCancel(() -> {
                    // 流被取消时的操作
                    streamingStates.remove(chatId);
                    log.info("流式对话被取消 [会话ID: {}]", chatId);
                })
                .doOnError(error -> {
                    // 流出错时的操作
                    streamingStates.remove(chatId);
                    log.error("流式对话出错 [会话ID: {}]", chatId, error);
                })
                .onErrorResume(error -> {
                    // 发生错误时返回错误消息给前端
                    String errorMsg = "AI服务暂时不可用，请稍后重试";
                    log.error("AI对话异常: {}", error.getMessage(), error);
                    return Flux.just(ServerSentEvent.<String>builder()
                            .event("error")
                            .data(errorMsg)
                            .build());
                });
    }

    /**
     * 中断流式输出接口
     * @param conversationId 会话ID，用于标识要中断的流
     */
    @PostMapping("/cancelStream")
    public void cancelStream(@RequestParam(value = "conversationId", required = true) Long conversationId) {
        String chatId = String.valueOf(conversationId);
        AtomicBoolean isStreaming = streamingStates.get(chatId);

        if (isStreaming != null) {
            isStreaming.set(false);  // 设置为 false，停止流
            log.info("已触发流式输出中断 [会话ID: {}]", chatId);
        } else {
            log.warn("未找到活跃的流式对话 [会话ID: {}]", chatId);
        }
    }
}
