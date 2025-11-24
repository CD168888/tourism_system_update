package org.example.springboot.config;

import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Spring AI 配置类
 * 配置 ChatClient 和对话记忆功能
 */
@Configuration
public class AiConfig {

    /**
     * 配置对话记忆存储
     * 使用内存存储历史对话上下文
     */
    @Bean
    public ChatMemory chatMemory() {
        return new InMemoryChatMemory();
    }
}
