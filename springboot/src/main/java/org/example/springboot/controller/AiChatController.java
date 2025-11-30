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

    private static final String SYSTEM_PROMPT = """
        你现在的身份：广东江门市旅游推荐官（本地专家）。
        目标：根据用户提供的条件，生成清晰、可执行的江门旅游推荐（行程、交通、吃住、费用、注意事项等）。
        要求：
        1. 语言：默认使用简体中文。
        2. 首要任务：如果用户提供的关键信息（出行日期、天数、出发地、预算、同行人数、偏好）不完整，先礼貌询问这些信息，再给出完整的行程建议；不要在信息不完整时直接给详尽不可执行的计划。
        3. 输出结构（默认 Markdown）应包含以下部分（按顺序）：
           - 概览：1-3句总结推荐理由与适合人群。
           - 推荐行程：按天列出每日行程，每条包含：时间段、景点、预计停留时长、交通方式、建议活动。
           - 交通建议：如何到达江门（高铁/自驾/飞机换乘）及市内交通建议（公交/打车/租车）。
           - 美食推荐：列出 3-5 个当地必尝美食及推荐餐馆（如有小众店说明理由）。
           - 费用估算：给出粗略总费用区间（按交通+住宿+门票+餐饮估算），并说明估算假设。
           - 注意事项与小贴士：包括气候、穿衣、当地习俗、健康与安全提示等。
        4. 如果用户明确要求「可机读格式」或「用于前端展示」，优先输出 JSON（包含上面同样字段），并注明字段含义。
        5. 输出长度控制：概览 1-3 句；每日行程每项不超过 6 行文字；提供详细版时可扩展为每个景点给出更多建议。
        6. 口径与可信度：不要捏造实时票价、具体营业时间或临时活动；若涉及实时信息（如节庆、演出、当日天气、门票余量），请提示用户是否允许你去查证或建议他们以官方渠道为准。
        7. 风格：友好、专业、简洁、贴地气（可加入简单本地表达），遇到多方案时给出“推荐度”排序与简短理由。
        8. 额外行为：对常见问题模板（如“三日游”“亲子游”“自驾游”“周末短途”）准备好可复用模板；当用户提出预算或限制（例如：老人腿脚不便）时，自动调整景点难度与交通方式。
        9. 若用户请求你扮演“导游”或输出逐小时的串场稿，请确认是否需要加入历史/文化解说、讲稿长度和语言风格。
        10. 一切输出以帮助用户在江门获得高质量出行决策为目标，不提供任何误导性或违法信息。
        """;

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
     * 生成会话标题（异步）
     * 根据用户问题和AI回复，生成一个5-6字的简短标题
     */
    private void generateSessionTitle(Long sessionId, String userMessage, String aiResponse) {
        // 异步执行，不阻塞主流程
        new Thread(() -> {
            try {
                String prompt = String.format(
                    "请根据以下对话内容，生成一个5-6个字的简短标题，直接输出标题，不要其他说明。\n\n用户：%s\n\nAI：%s",
                    userMessage.length() > 100 ? userMessage.substring(0, 100) : userMessage,
                    aiResponse.length() > 200 ? aiResponse.substring(0, 200) : aiResponse
                );
                    
                String title = dashScopeChatClient.prompt()
                    .user(prompt)
                    .call()
                    .content()
                    .trim();
                    
                // 限制长度为5-8字
                title = title.replaceAll("[^\\p{L}\\p{N}]", "");
                if (title.length() > 8) title = title.substring(0, 8);
                    
                // 更新会话标题
                chatSessionService.updateSessionName(sessionId, title);
                log.info("会话标题生成成功 - 会话ID: {}, 标题: {}", sessionId, title);
                    
            } catch (Exception e) {
                log.error("生成会话标题失败 - 会话ID: {}", sessionId, e);
            }
        }).start();
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
                .system(SYSTEM_PROMPT)
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
                    
                    // 如果是会话的第一次对话，生成会话标题（检查消息数量）
                    // 此时已经保存了用户消息(1条)和AI回复(1条)，共2条
                    List<ChatMessage> sessionMessages = chatMessageService.getSessionMessages(sessionId);
                    if (sessionMessages.size() == 2) {
                        generateSessionTitle(sessionId, message, aiResponse.toString());
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
    
    /**
     * 更新会话标题
     */
    @PutMapping("/session/{sessionId}/title")
    public Result<String> updateSessionTitle(
            @RequestHeader("token") String token,
            @PathVariable Long sessionId,
            @RequestParam(value = "title", required = true) String title) {
        try {
            Long userId = getUserIdFromToken(token);
            
            // 验证会话归属
            ChatSession session = chatSessionService.getById(sessionId);
            if (session == null || !session.getUserId().equals(userId)) {
                return Result.error("会话不存在或无权访问");
            }
            
            // 验证标题长度
            if (title == null || title.trim().isEmpty()) {
                return Result.error("标题不能为空");
            }
            if (title.length() > 50) {
                return Result.error("标题长度不能超过50个字符");
            }
            
            // 更新标题
            chatSessionService.updateSessionName(sessionId, title.trim());
            return Result.success("标题更新成功");
        } catch (Exception e) {
            log.error("更新会话标题失败", e);
            return Result.error("更新会话标题失败: " + e.getMessage());
        }
    }
}
