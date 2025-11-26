package org.example.springboot.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.example.springboot.entity.ChatSession;
import org.example.springboot.mapper.ChatSessionMapper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

/**
 * AI聊天会话服务
 */
@Service
@Slf4j
public class ChatSessionService extends ServiceImpl<ChatSessionMapper, ChatSession> {
    
    /**
     * 创建新会话
     */
    public ChatSession createSession(Long userId, String sessionName) {
        ChatSession session = new ChatSession();
        session.setUserId(userId);
        session.setSessionName(sessionName);
        session.setCreateTime(LocalDateTime.now());
        session.setUpdateTime(LocalDateTime.now());
        
        save(session);
        log.info("创建会话成功 - 用户ID: {}, 会话ID: {}", userId, session.getId());
        return session;
    }
    
    /**
     * 获取用户的所有会话列表
     */
    public List<ChatSession> getUserSessions(Long userId) {
        LambdaQueryWrapper<ChatSession> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ChatSession::getUserId, userId)
                .orderByDesc(ChatSession::getUpdateTime);
        return list(wrapper);
    }
    
    /**
     * 更新会话时间
     */
    public void updateSessionTime(Long sessionId) {
        ChatSession session = getById(sessionId);
        if (session != null) {
            session.setUpdateTime(LocalDateTime.now());
            updateById(session);
        }
    }
    
    /**
     * 删除会话
     */
    public boolean deleteSession(Long sessionId, Long userId) {
        LambdaQueryWrapper<ChatSession> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(ChatSession::getId, sessionId)
                .eq(ChatSession::getUserId, userId);
        return remove(wrapper);
    }
}
