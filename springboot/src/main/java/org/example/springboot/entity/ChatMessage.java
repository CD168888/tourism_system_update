package org.example.springboot.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * AI聊天消息实体类
 */
@Data
@TableName("chat_message")
@Schema(description = "AI聊天消息实体类")
public class ChatMessage {
    
    @TableId(type = IdType.AUTO)
    @Schema(description = "消息ID")
    private Long id;
    
    @Schema(description = "会话ID")
    private Long sessionId;
    
    @Schema(description = "用户ID")
    private Long userId;
    
    @Schema(description = "消息类型(0:AI消息, 1:用户消息)")
    private Integer messageType;
    
    @Schema(description = "消息内容")
    private String content;
    
    @Schema(description = "创建时间")
    private LocalDateTime createTime;
}
