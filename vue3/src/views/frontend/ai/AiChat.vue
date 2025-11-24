<template>
  <div class="ai-chat-container">
    <div class="chat-header">
      <h2>智能旅游助手</h2>
      <el-button size="small" @click="clearMemory">清除记忆</el-button>
    </div>

    <div class="chat-messages" ref="messagesContainer">
      <div
        v-for="(msg, index) in messages"
        :key="index"
        :class="['message-item', msg.role === 'user' ? 'user-message' : 'ai-message']"
      >
        <div class="message-content" v-html="msg.msg"></div>
      </div>
    </div>

    <div class="chat-input">
      <el-input
        v-model="userInput"
        placeholder="请输入您的问题..."
        @keyup.enter="sendMessage"
        :disabled="isStreaming"
      >
        <template #append>
          <el-button 
            v-if="!isStreaming" 
            type="primary" 
            @click="sendMessage"
            :disabled="!userInput.trim()"
          >
            发送
          </el-button>
          <el-button 
            v-else 
            type="danger" 
            @click="cancelStream"
          >
            停止
          </el-button>
        </template>
      </el-input>
    </div>
  </div>
</template>

<script setup>
import { ref, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import MarkdownIt from 'markdown-it'

// 初始化 Markdown 解析器
const md = new MarkdownIt({
  html: true,
  linkify: true,
  typographer: true
})

// 响应式数据
const messages = ref([])
const userInput = ref('')
const isStreaming = ref(false)
const messagesContainer = ref(null)
const currentEventSource = ref(null)

// 用户ID和会话ID（可以从 store 或 props 获取）
const userId = ref('user_' + Date.now())
const sessionId = ref('session_' + Date.now())

/**
 * 发送消息
 */
const sendMessage = () => {
  if (!userInput.value.trim()) {
    return
  }

  // 添加用户消息到聊天记录
  messages.value.push({
    role: 'user',
    msg: userInput.value
  })

  // 调用 SSE 流式接口
  streamChat(userInput.value)
  
  // 清空输入框
  userInput.value = ''
  
  // 滚动到底部
  scrollToBottom()
}

/**
 * SSE 流式对话
 */
const streamChat = (message) => {
  isStreaming.value = true
  
  // 添加 AI 消息占位符
  messages.value.push({
    role: 'assistant',
    msg: ''
  })

  // 用于累积接收到的文本
  let messageOrigin = ''

  // 构建请求 URL
  const url = `/api/chat/ai/generateStream?message=${encodeURIComponent(message)}&sessionId=${sessionId.value}&userId=${userId.value}`

  // 创建 EventSource 连接
  const eventSource = new EventSource(url)
  currentEventSource.value = eventSource

  // 监听消息事件
  eventSource.onmessage = (event) => {
    const data = event.data

    // 检查是否为结束标记
    if (data === '[DONE]') {
      eventSource.close()
      isStreaming.value = false
      
      // 处理 <think> 标签（如果模型返回了思考过程）
      const formattedMsg = messageOrigin.replace(/<think>/g, "<div class='think'>")
      messages.value[messages.value.length - 1].msg = formattedMsg
      
      scrollToBottom()
      return
    }

    // 累积接收到的数据
    messageOrigin += data

    // 将 Markdown 渲染为 HTML
    const renderedMsg = md.render(messageOrigin)
    
    // 更新最后一条消息
    messages.value[messages.value.length - 1].msg = renderedMsg
    
    // 滚动到底部
    scrollToBottom()
  }

  // 监听错误事件
  eventSource.onerror = (error) => {
    console.error('SSE 错误:', error)
    eventSource.close()
    isStreaming.value = false
    ElMessage.error('连接出错，请重试')
  }

  // 监听连接关闭
  eventSource.addEventListener('close', () => {
    console.log('SSE 连接已关闭')
    isStreaming.value = false
  })
}

/**
 * 取消流式输出
 */
const cancelStream = () => {
  if (currentEventSource.value) {
    currentEventSource.value.close()
    currentEventSource.value = null
  }
  
  // 调用后端取消接口
  fetch(`/api/chat/ai/cancelStream?sessionId=${sessionId.value}&userId=${userId.value}`, {
    method: 'POST'
  })
  
  isStreaming.value = false
  ElMessage.info('已停止生成')
}

/**
 * 清除对话记忆
 */
const clearMemory = () => {
  fetch(`/api/chat/ai/clearMemory?sessionId=${sessionId.value}&userId=${userId.value}`, {
    method: 'DELETE'
  }).then(() => {
    messages.value = []
    ElMessage.success('已清除对话记忆')
  })
}

/**
 * 滚动到底部
 */
const scrollToBottom = () => {
  nextTick(() => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
    }
  })
}
</script>

<style scoped>
.ai-chat-container {
  display: flex;
  flex-direction: column;
  height: 100%;
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
}

.chat-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 2px solid #e0e0e0;
}

.chat-header h2 {
  margin: 0;
  color: #409eff;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background-color: #f5f5f5;
  border-radius: 8px;
  margin-bottom: 20px;
}

.message-item {
  margin-bottom: 15px;
  display: flex;
}

.user-message {
  justify-content: flex-end;
}

.user-message .message-content {
  background-color: #409eff;
  color: white;
  padding: 10px 15px;
  border-radius: 8px;
  max-width: 70%;
}

.ai-message .message-content {
  background-color: white;
  color: #333;
  padding: 10px 15px;
  border-radius: 8px;
  max-width: 70%;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.chat-input {
  padding-top: 10px;
}

/* Markdown 样式 */
.message-content :deep(p) {
  margin: 5px 0;
}

.message-content :deep(code) {
  background-color: #f4f4f4;
  padding: 2px 6px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
}

.message-content :deep(pre) {
  background-color: #f4f4f4;
  padding: 10px;
  border-radius: 4px;
  overflow-x: auto;
}

.message-content :deep(.think) {
  color: #888;
  font-style: italic;
  padding: 5px 10px;
  background-color: #f9f9f9;
  border-left: 3px solid #409eff;
  margin: 10px 0;
}
</style>
