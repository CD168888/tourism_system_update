package org.example.springboot.controller;

import com.auth0.jwt.JWT;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.example.springboot.common.Result;
import org.example.springboot.entity.ChatMessage;
import org.example.springboot.entity.ChatSession;
import org.example.springboot.service.ChatMessageService;
import org.example.springboot.service.ChatSessionService;
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
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicBoolean;

@RestController
@RequestMapping("/ai")
@Slf4j
public class AiChatController {

    private final ChatClient dashScopeChatClient;
    
    @Resource
    private ChatSessionService chatSessionService;
    
    @Resource
    private ChatMessageService chatMessageService;

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
     * 从Token中提取用户ID
     */
    private Long getUserIdFromToken(String token) {
        try {
            String userId = JWT.decode(token).getAudience().get(0);
            return Long.valueOf(userId);
        } catch (Exception e) {
            log.error("解析Token失败", e);
            throw new RuntimeException("未登录或登录已过期");
        }
    }

    /**
     * 流式对话接口（2.0版本 - 需要登录，支持消息持久化）
     * @param message 用户输入的消息
     * @param sessionId 会话ID
     * @param token 用户Token
     * @return Flux<ServerSentEvent<String>> 流式响应数据
     */
    @GetMapping(value = "/chatStream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public Flux<ServerSentEvent<String>> generate(
            @RequestParam(value = "message", required = true) String message,
            @RequestParam(value = "sessionId", required = true) Long sessionId,
            @RequestParam(value = "token", required = true) String token,
            HttpServletResponse response) {

        // 验证用户登录
        Long userId;
        try {
            userId = getUserIdFromToken(token);
        } catch (Exception e) {
            return Flux.just(ServerSentEvent.<String>builder()
                    .event("error")
                    .data("未登录或登录已过期，请重新登录")
                    .build());
        }
        
        log.info("接收到 AI 对话请求 - 用户ID: {}, 会话ID: {}, 消息: {}", userId, sessionId, message);

        // 验证会话归属
        ChatSession session = chatSessionService.getById(sessionId);
        if (session == null || !session.getUserId().equals(userId)) {
            return Flux.just(ServerSentEvent.<String>builder()
                    .event("error")
                    .data("会话不存在或无权访问")
                    .build());
        }

        // 保存用户消息
        chatMessageService.saveMessage(sessionId, userId, 1, message);
        
        // 更新会话时间
        chatSessionService.updateSessionTime(sessionId);

        // 设置响应头
        response.setHeader("Cache-Control", "no-cache, no-transform");
        response.setHeader("X-Accel-Buffering", "no");

        // 创建会话标识
        String chatId = String.valueOf(sessionId);

        // 为当前会话创建流式状态标识
        AtomicBoolean isStreaming = streamingStates.computeIfAbsent(chatId, k -> new AtomicBoolean(true));
        isStreaming.set(true);
        
        // 用于累积AI回复内容
        StringBuilder aiResponse = new StringBuilder();

        // 生成流式对话
        return dashScopeChatClient.prompt()
                .user(message)
                .advisors(a -> a.param(ChatMemory.CONVERSATION_ID, sessionId))
                .stream()
                .content()
                .takeWhile(data -> isStreaming.get())
                .map(content -> {
                    aiResponse.append(content);
                    return ServerSentEvent.<String>builder()
                            .data(content)
                            .build();
                })
                .concatWith(Flux.just(ServerSentEvent.<String>builder()
                        .data("\u0003")
                        .build()))
                .doOnComplete(() -> {
                    // 保存AI回复消息
                    if (aiResponse.length() > 0) {
                        chatMessageService.saveMessage(sessionId, userId, 0, aiResponse.toString());
                    }
                    streamingStates.remove(chatId);
                    log.info("流式对话完成 [用户ID: {}, 会话ID: {}]", userId, sessionId);
                })
                .doOnCancel(() -> {
                    // 即使取消也保存部分回复
                    if (aiResponse.length() > 0) {
                        chatMessageService.saveMessage(sessionId, userId, 0, aiResponse.toString());
                    }
                    streamingStates.remove(chatId);
                    log.info("流式对话被取消 [用户ID: {}, 会话ID: {}]", userId, sessionId);
                })
                .doOnError(error -> {
                    streamingStates.remove(chatId);
                    log.error("流式对话出错 [用户ID: {}, 会话ID: {}]", userId, sessionId, error);
                })
                .onErrorResume(error -> {
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
     * @param sessionId 会话ID
     */
    @PostMapping("/cancelStream")
    public void cancelStream(@RequestParam(value = "sessionId", required = true) Long sessionId) {
        String chatId = String.valueOf(sessionId);
        AtomicBoolean isStreaming = streamingStates.get(chatId);

        if (isStreaming != null) {
            isStreaming.set(false);
            log.info("已触发流式输出中断 [会话ID: {}]", sessionId);
        } else {
            log.warn("未找到活跃的流式对话 [会话ID: {}]", sessionId);
        }
    }
    
    /**
     * 创建新会话
     */
    @PostMapping("/createSession")
    public Result<ChatSession> createSession(
            @RequestHeader("token") String token,
            @RequestParam(value = "sessionName", required = true) String sessionName) {
        try {
            Long userId = getUserIdFromToken(token);
            ChatSession session = chatSessionService.createSession(userId, sessionName);
            return Result.success(session);
        } catch (Exception e) {
            log.error("创建会话失败", e);
            return Result.error("创建会话失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取用户的所有会话列表
     */
    @GetMapping("/sessions")
    public Result<List<ChatSession>> getSessions(@RequestHeader("token") String token) {
        try {
            Long userId = getUserIdFromToken(token);
            List<ChatSession> sessions = chatSessionService.getUserSessions(userId);
            return Result.success(sessions);
        } catch (Exception e) {
            log.error("获取会话列表失败", e);
            return Result.error("获取会话列表失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取会话的历史消息（优先从Redis获取，不存在则从数据库加载）
     */
    @GetMapping("/messages/{sessionId}")
    public Result<List<ChatMessage>> getMessages(
            @RequestHeader("token") String token,
            @PathVariable Long sessionId) {
        try {
            Long userId = getUserIdFromToken(token);
            
            // 验证会话归属
            ChatSession session = chatSessionService.getById(sessionId);
            if (session == null || !session.getUserId().equals(userId)) {
                return Result.error("会话不存在或无权访问");
            }
            
            List<ChatMessage> messages = chatMessageService.getSessionMessages(sessionId);
            return Result.success(messages);
        } catch (Exception e) {
            log.error("获取历史消息失败", e);
            return Result.error("获取历史消息失败: " + e.getMessage());
        }
    }
    
    /**
     * 删除会话
     */
    @DeleteMapping("/session/{sessionId}")
    public Result<String> deleteSession(
            @RequestHeader("token") String token,
            @PathVariable Long sessionId) {
        try {
            Long userId = getUserIdFromToken(token);
            
            // 删除会话的所有消息
            chatMessageService.deleteSessionMessages(sessionId, userId);
            
            // 删除会话
            boolean success = chatSessionService.deleteSession(sessionId, userId);
            if (success) {
                return Result.success("删除成功");
            } else {
                return Result.error("删除失败");
            }
        } catch (Exception e) {
            log.error("删除会话失败", e);
            return Result.error("删除会话失败: " + e.getMessage());
        }
    }
}
