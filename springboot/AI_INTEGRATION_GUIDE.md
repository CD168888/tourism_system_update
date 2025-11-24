# Spring AI Alibaba 集成指南

## 概述

本项目已成功集成 Spring AI Alibaba，使用通义千问模型实现智能对话功能，支持 SSE 流式输出。

## 配置说明

### 1. Maven 依赖

已在 `pom.xml` 中添加：

```xml
<dependency>
    <groupId>com.alibaba.cloud.ai</groupId>
    <artifactId>spring-ai-alibaba-starter-dashscope</artifactId>
    <version>1.1.0.0-M5</version>
</dependency>
```

### 2. 环境变量配置

在 `application.properties` 中配置：

```properties
spring.ai.dashscope.api-key=${AI_DASHSCOPE_API_KEY}
spring.ai.dashscope.chat.options.model=qwen-plus
spring.ai.dashscope.chat.options.temperature=0.7
```

**重要**: 需要设置环境变量 `AI_DASHSCOPE_API_KEY`

#### Windows 设置环境变量：
```bash
# 临时设置（当前命令行窗口有效）
set AI_DASHSCOPE_API_KEY=your-api-key-here

# 或者在系统环境变量中永久设置
# 控制面板 -> 系统 -> 高级系统设置 -> 环境变量
```

#### 或者直接在 application.properties 中配置（不推荐）：
```properties
spring.ai.dashscope.api-key=sk-your-actual-api-key
```

### 3. 获取 DashScope API Key

1. 访问阿里云百炼平台：https://bailian.console.aliyun.com/
2. 登录后进入 API-KEY 管理
3. 创建或复制已有的 API Key

## 核心组件

### 1. AiConfig.java

配置类，提供 ChatMemory Bean，用于存储对话历史。

**位置**: `org.example.springboot.config.AiConfig`

### 2. AiChatController.java

AI 聊天控制器，提供以下接口：

**位置**: `org.example.springboot.controller.AiChatController`

#### 接口说明：

##### (1) 流式对话接口（推荐）

```
GET /api/chat/ai/generateStream
```

**参数**:
- `message` (必填): 用户输入的消息
- `sessionId` (可选): 会话ID，用于记忆上下文
- `userId` (可选): 用户ID

**响应**: SSE 流式输出，Content-Type: `text/event-stream`

**示例**:
```
http://localhost:1236/api/chat/ai/generateStream?message=你好&sessionId=session123&userId=user456
```

##### (2) 同步对话接口

```
GET /api/chat/ai/generate
```

**参数**: 同上

**响应**: 返回完整的 AI 回复文本

##### (3) 取消流式输出

```
POST /api/chat/ai/cancelStream
```

**参数**:
- `sessionId` (可选)
- `userId` (可选)

##### (4) 清除对话记忆

```
DELETE /api/chat/ai/clearMemory
```

**参数**:
- `sessionId` (可选)
- `userId` (可选)

## 前端集成示例

### 完整示例组件

位置: `vue3/src/views/frontend/ai/AiChat.vue`

这是一个完整的 Vue 3 聊天界面，包含：
- SSE 流式接收
- Markdown 渲染
- 消息列表展示
- 取消/清除功能

### 核心代码片段

```javascript
// 创建 SSE 连接
const eventSource = new EventSource(
  `/api/chat/ai/generateStream?message=${encodeURIComponent(message)}&sessionId=${sessionId}&userId=${userId}`
)

// 接收流式数据
eventSource.onmessage = (event) => {
  const data = event.data
  
  if (data === '[DONE]') {
    eventSource.close()
    return
  }
  
  // 累积数据并渲染
  messageOrigin += data
  const renderedMsg = md.render(messageOrigin)
  messages.value[messages.value.length - 1].msg = renderedMsg
}

// 错误处理
eventSource.onerror = (error) => {
  console.error('SSE 错误:', error)
  eventSource.close()
}
```

### 前端依赖

需要安装 markdown-it（如果尚未安装）：

```bash
cd vue3
npm install markdown-it
```

## 使用场景

### 1. 旅游咨询助手

系统已为 AI 配置了旅游助手身份，可以：
- 解答景点相关问题
- 提供旅游攻略建议
- 推荐住宿和餐饮
- 帮助规划旅游路线

### 2. 对话记忆

通过 `sessionId` 实现上下文记忆：
- 同一个 sessionId 的对话会保留历史记录
- AI 可以理解上下文并进行连续对话
- 可以通过 clearMemory 接口清除历史

### 3. 多用户隔离

通过 `userId` 实现用户隔离：
- 不同用户使用不同的 userId
- 每个用户的对话独立存储

## 测试步骤

### 1. 启动后端

```bash
cd springboot
set AI_DASHSCOPE_API_KEY=your-api-key
mvn spring-boot:run
```

### 2. 测试 API

访问 Knife4j 文档：
```
http://localhost:1236/doc.html
```

找到 "AI聊天" 分组，测试各个接口。

### 3. 使用前端界面

将 `AiChat.vue` 组件集成到路由中：

```javascript
// router/index.js
{
  path: '/ai-chat',
  name: 'AiChat',
  component: () => import('@/views/frontend/ai/AiChat.vue')
}
```

访问：
```
http://localhost:8080/ai-chat
```

## 注意事项

### 1. API 配额

- DashScope 有调用次数限制
- 建议在生产环境监控 API 用量

### 2. 安全性

- 不要将 API Key 提交到代码仓库
- 使用环境变量或配置中心管理密钥
- 建议添加用户认证和访问频率限制

### 3. 对话记忆

- 当前使用内存存储 (InMemoryChatMemory)
- 重启应用会丢失历史记录
- 生产环境可考虑使用 Redis 或数据库存储

### 4. 性能优化

- SSE 长连接会占用服务器资源
- 建议设置超时时间
- 可以使用 Redis 做对话缓存

## 扩展建议

### 1. 持久化对话历史

实现自定义 ChatMemory，将对话存储到 MySQL：

```java
public class DatabaseChatMemory implements ChatMemory {
    // 实现将对话存储到数据库
}
```

### 2. 添加认证

在 `AiChatController` 中添加 JWT 验证：

```java
@GetMapping("/generateStream")
public Flux<String> generateStream(
    @RequestHeader("token") String token,
    // ... 其他参数
) {
    // 验证 token
    String userId = JwtUtil.getUserIdFromToken(token);
    // ...
}
```

### 3. 限流保护

使用 Redis + AOP 实现接口限流：

```java
@RateLimit(maxRequests = 10, duration = 60) // 每分钟最多10次
@GetMapping("/generateStream")
public Flux<String> generateStream(...) {
    // ...
}
```

### 4. 对话分析

记录对话数据用于分析：

```java
@Async
public void logConversation(String userId, String message, String response) {
    // 保存到数据库
}
```

## 故障排查

### 问题1: 无法连接到 DashScope

**解决**: 
- 检查 API Key 是否正确
- 确认网络可以访问阿里云服务
- 查看后端日志中的错误信息

### 问题2: SSE 连接中断

**解决**:
- 检查前端是否正确处理 onerror 事件
- 查看浏览器控制台是否有 CORS 错误
- 确认后端没有超时设置过短

### 问题3: 对话没有记忆

**解决**:
- 确保每次请求使用相同的 sessionId
- 检查 ChatMemory Bean 是否正确注入
- 查看日志确认 CHAT_MEMORY_CONVERSATION_ID_KEY 是否设置

## 相关资源

- Spring AI Alibaba 文档: https://sca.aliyun.com/docs/2023/user-guide/ai/overview/
- 通义千问模型文档: https://help.aliyun.com/zh/dashscope/
- SSE 标准: https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events

## 更新日志

- 2024-11-24: 初始集成，支持流式对话和对话记忆功能
