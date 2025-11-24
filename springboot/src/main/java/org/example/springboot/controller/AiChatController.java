package org.example.springboot.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.client.advisor.SimpleLoggerAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

/**
 * AI 聊天控制器
 * 提供基于通义千问的智能对话功能，支持 SSE 流式输出
 */
@RestController
@RequestMapping("/api/chat/ai")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "AI聊天", description = "智能聊天助手接口，基于通义千问模型")
public class AiChatController {

    private final ChatModel chatModel;
    private final ChatMemory chatMemory;
    
    // 定义常量避免魔法字符串
    private static final String CHAT_MEMORY_CONVERSATION_ID_KEY = "chat_memory_conversation_id";
    
    // 存储每个会话的流式状态标识
    private final ConcurrentHashMap<String, AtomicBoolean> streamingStates = new ConcurrentHashMap<>();

    /**
     * 流式对话接口
     * 使用 Server-Sent Events (SSE) 实现实时流式输出
     *
     * @param message 用户输入的消息
     * @param sessionId 会话ID，用于记忆上下文（可选，默认为用户ID）
     * @param userId 用户ID，用于隔离不同用户的对话
     * @return Flux<String> 流式响应数据
     */
    @GetMapping(value = "/generateStream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    @Operation(summary = "流式对话", description = "使用SSE实现流式输出，支持对话记忆")
    public Flux<String> generateStream(
            @Parameter(description = "用户输入的消息", required = true)
            @RequestParam String message,

            @Parameter(description = "会话ID，用于记忆上下文")
            @RequestParam(required = false) String sessionId,

            @Parameter(description = "用户ID")
            @RequestParam(required = false) String userId) {

        // 构建会话标识：优先使用 sessionId，否则使用 userId，都没有则使用 default
        String chatId = sessionId != null ? sessionId : (userId != null ? userId : "default");

        log.info("收到AI对话请求 [会话ID: {}] [用户ID: {}]: {}", chatId, userId, message);

        // 为当前会话创建流式状态标识
        AtomicBoolean isStreaming = streamingStates.computeIfAbsent(chatId, k -> new AtomicBoolean(true));
        isStreaming.set(true);

        // 构建 ChatClient
        ChatClient chatClient = ChatClient.builder(chatModel)
                .defaultSystem("""
                        你是一个友好且专业的旅游助手，专门为用户提供旅游咨询服务。
                        你的主要职责包括：
                        1. 解答旅游景点相关问题
                        2. 提供旅游攻略和建议
                        3. 推荐合适的住宿和餐饮
                        4. 帮助规划旅游路线
                        5. 回答旅游相关的各类问题
                        
                        请用简洁、友好、专业的语气回答用户问题。
                        """)
                .defaultAdvisors(
                        new SimpleLoggerAdvisor(),  // 日志记录
                        new MessageChatMemoryAdvisor(chatMemory)  // 对话记忆
                )
                .build();

        // 执行流式对话
        return chatClient.prompt()
                .user(message)
                .advisors(advisorSpec -> advisorSpec
                        .param(CHAT_MEMORY_CONVERSATION_ID_KEY, chatId))  // 设置会话ID用于记忆管理
                .stream()
                .content()
                .takeWhile(data -> isStreaming.get())  // 支持动态中断
                .doOnComplete(() -> {
                    log.info("对话流完成 [会话ID: {}]", chatId);
                })
                .doOnCancel(() -> {
                    log.info("对话流已取消 [会话ID: {}]", chatId);
                    streamingStates.remove(chatId);
                })
                .doOnError(error -> {
                    log.error("对话流发生错误 [会话ID: {}]: {}", chatId, error.getMessage(), error);
                    streamingStates.remove(chatId);
                })
                .concatWithValues("[DONE]");  // 添加结束标记
    }

    /**
     * 中断流式输出接口
     * 
     * @param sessionId 会话ID
     * @param userId 用户ID
     */
    @PostMapping("/cancelStream")
    @Operation(summary = "中断流式输出", description = "取消正在进行的流式对话")
    public void cancelStream(
            @Parameter(description = "会话ID")
            @RequestParam(required = false) String sessionId,
            
            @Parameter(description = "用户ID")
            @RequestParam(required = false) String userId) {
        
        String chatId = sessionId != null ? sessionId : (userId != null ? userId : "default");
        AtomicBoolean isStreaming = streamingStates.get(chatId);
        
        if (isStreaming != null) {
            isStreaming.set(false);
            log.info("已触发流式输出中断 [会话ID: {}]", chatId);
        } else {
            log.warn("未找到活跃的流式对话 [会话ID: {}]", chatId);
        }
    }

    /**
     * 清除会话记忆
     * 
     * @param sessionId 会话ID
     * @param userId 用户ID
     */
    @DeleteMapping("/clearMemory")
    @Operation(summary = "清除对话记忆", description = "清除指定会话的对话历史")
    public void clearMemory(
            @Parameter(description = "会话ID")
            @RequestParam(required = false) String sessionId,
            
            @Parameter(description = "用户ID")
            @RequestParam(required = false) String userId) {
        
        String chatId = sessionId != null ? sessionId : (userId != null ? userId : "default");
        chatMemory.clear(chatId);
        streamingStates.remove(chatId);
        log.info("已清除对话记忆 [会话ID: {}]", chatId);
    }

    /**
     * 非流式对话接口（同步返回完整结果）
     * 
     * @param message 用户输入的消息
     * @param sessionId 会话ID
     * @param userId 用户ID
     * @return String 完整的AI回复
     */
    @GetMapping("/generate")
    @Operation(summary = "同步对话", description = "同步方式获取AI回复（非流式）")
    public String generate(
            @Parameter(description = "用户输入的消息", required = true)
            @RequestParam String message,
            
            @Parameter(description = "会话ID")
            @RequestParam(required = false) String sessionId,
            
            @Parameter(description = "用户ID")
            @RequestParam(required = false) String userId) {

        String chatId = sessionId != null ? sessionId : (userId != null ? userId : "default");
        log.info("收到AI同步对话请求 [会话ID: {}]: {}", chatId, message);

        ChatClient chatClient = ChatClient.builder(chatModel)
                .defaultSystem("""
                        你是一个友好且专业的旅游助手，专门为用户提供旅游咨询服务。
                        请用简洁、友好、专业的语气回答用户问题。
                        """)
                .defaultAdvisors(
                        new MessageChatMemoryAdvisor(chatMemory)
                )
                .build();

        String response = chatClient.prompt()
                .user(message)
                .advisors(advisorSpec -> advisorSpec
                        .param(CHAT_MEMORY_CONVERSATION_ID_KEY, chatId))
                .call()
                .content();

        log.info("AI同步对话完成 [会话ID: {}]", chatId);
        return response;
    }
}
