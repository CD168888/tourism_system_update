<template>
  <div class="auth-container">
    <div class="auth-box">
      <div class="auth-header" v-if="showHeader">
        <div class="logo"><el-icon>
            <Place />
          </el-icon></div>
        <h1 class="title">旅游信息系统</h1>
        <div class="subtitle">TRAVEL INFORMATION SYSTEM</div>
      </div>

      <el-form :model="formData" :rules="rules" ref="formRef" class="auth-form">
        <slot name="form-items"></slot>

        <el-form-item>
          <el-button type="primary" :loading="loading" @click="handleSubmit" class="auth-button">
            {{ submitText }}
          </el-button>
        </el-form-item>

        <div class="auth-links">
          <slot name="auth-links"></slot>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { Place } from '@element-plus/icons-vue'

const props = defineProps({
  formData: {
    type: Object,
    required: true
  },
  rules: {
    type: Object,
    required: true
  },
  loading: {
    type: Boolean,
    default: false
  },
  submitText: {
    type: String,
    default: '提交'
  },
  showHeader: {
    type: Boolean,
    default: true
  }
})

const formRef = ref(null)

const emit = defineEmits(['submit'])

const handleSubmit = () => {
  formRef.value.validate(valid => {
    if (valid) {
      emit('submit', formRef)
    }
  })
}

defineExpose({
  formRef
})
</script>

<style lang="scss" scoped>
.auth-container {
  height: 100vh;
  width: 100vw;
  display: flex;
  justify-content: center;
  align-items: center;
  background-image: url('@/assets/bg.jpg');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  position: relative;
  overflow: hidden;

  // 添加渐变遮罩层，让背景更柔和
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 1;
  }

  // 粒子装饰
  &::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-image:
      radial-gradient(2px 2px at 20% 30%, rgba(255, 255, 255, 0.3), transparent),
      radial-gradient(2px 2px at 60% 70%, rgba(255, 255, 255, 0.3), transparent),
      radial-gradient(1px 1px at 50% 50%, rgba(255, 255, 255, 0.3), transparent),
      radial-gradient(1px 1px at 80% 10%, rgba(255, 255, 255, 0.3), transparent);
    background-size: 200% 200%, 180% 180%, 150% 150%, 220% 220%;
    background-position: 0% 0%, 100% 0%, 50% 50%, 0% 100%;
    animation: sparkle 15s ease-in-out infinite;
    z-index: 1;
  }
}

.auth-box {
  width: 440px;
  padding: 45px;
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(30px);
  -webkit-backdrop-filter: blur(30px);
  border-radius: 24px;
  box-shadow:
    0 20px 60px rgba(0, 0, 0, 0.3),
    0 0 0 1px rgba(255, 255, 255, 0.3) inset;
  z-index: 2;
  position: relative;
  animation: slideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1);

  // 光晕效果
  &::before {
    content: '';
    position: absolute;
    top: -2px;
    left: -2px;
    right: -2px;
    bottom: -2px;
    background: linear-gradient(135deg,
        rgba(255, 255, 255, 0.4) 0%,
        rgba(255, 255, 255, 0.1) 50%,
        rgba(255, 255, 255, 0.4) 100%);
    border-radius: 24px;
    z-index: -1;
    opacity: 0.6;
  }
}

.auth-header {
  text-align: center;
  margin-bottom: 32px;

  .logo {
    font-size: 56px;
    margin-bottom: 16px;

    .el-icon {
      font-size: 56px;
      background: linear-gradient(135deg, #5aa9e6 0%, #4a99d6 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      filter: drop-shadow(0 4px 8px rgba(102, 126, 234, 0.3));
      animation: pulse 2s ease-in-out infinite;
    }
  }

  .title {
    font-size: 28px;
    font-weight: 800;
    color: white;
    margin: 0 0 8px;
    text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
    letter-spacing: 1px;
  }

  .subtitle {
    font-size: 13px;
    color: rgba(255, 255, 255, 0.85);
    letter-spacing: 2px;
    font-weight: 500;
  }
}

.auth-form {
  .el-form-item {
    margin-bottom: 20px;
  }

  :deep(.el-tabs__header) {
    margin-bottom: 24px;
  }

  :deep(.el-tabs__nav-wrap) {
    &::after {
      background-color: rgba(255, 255, 255, 0.2);
    }
  }

  :deep(.el-tabs__item) {
    color: rgba(255, 255, 255, 0.7);
    font-weight: 600;
    font-size: 15px;
    padding: 0 20px;

    &.is-active {
      color: white;
    }

    &:hover {
      color: white;
    }
  }

  :deep(.el-tabs__active-bar) {
    background-color: white;
    height: 3px;
    border-radius: 3px;
  }

  :deep(.el-input__wrapper) {
    padding: 12px 16px 12px 45px;
    border-radius: 16px;
    background: rgba(255, 255, 255, 0.2);
    backdrop-filter: blur(10px);
    border: 2px solid rgba(255, 255, 255, 0.3);
    box-shadow:
      0 4px 12px rgba(0, 0, 0, 0.1),
      0 0 0 1px rgba(255, 255, 255, 0.1) inset;
    transition: all 0.3s ease;

    &:hover {
      background: rgba(255, 255, 255, 0.25);
      border-color: rgba(255, 255, 255, 0.5);
    }

    &.is-focus {
      background: rgba(255, 255, 255, 0.3);
      border-color: white;
      box-shadow:
        0 6px 20px rgba(102, 126, 234, 0.3),
        0 0 0 1px rgba(255, 255, 255, 0.2) inset;
    }

    .el-input__inner {
      color: white;
      font-weight: 500;

      &::placeholder {
        color: rgba(255, 255, 255, 0.6);
      }
    }
  }

  :deep(.el-input__prefix) {
    left: 16px;
    font-size: 18px;
    color: rgba(255, 255, 255, 0.8);
  }

  :deep(.el-input-group__append) {
    background: rgba(255, 255, 255, 0.2);
    border: none;
    border-radius: 0 16px 16px 0;

    .el-button {
      background: transparent;
      color: white;
      font-weight: 600;
      border: none;

      &:hover:not(:disabled) {
        background: rgba(255, 255, 255, 0.1);
      }

      &:disabled {
        color: rgba(255, 255, 255, 0.5);
      }
    }
  }
}

.auth-button {
  width: 100%;
  height: 48px;
  border-radius: 16px;
  font-size: 16px;
  font-weight: 700;
  background: linear-gradient(135deg, #5aa9e6 0%, #4a99d6 100%);
  border: none;
  box-shadow:
    0 8px 24px rgba(102, 126, 234, 0.4),
    0 0 0 1px rgba(255, 255, 255, 0.3) inset;
  transition: all 0.3s ease;

  &:hover:not(:disabled) {
    transform: translateY(-2px);
    box-shadow:
      0 12px 32px rgba(102, 126, 234, 0.5),
      0 0 0 1px rgba(255, 255, 255, 0.4) inset;
  }

  &:active:not(:disabled) {
    transform: translateY(0);
  }
}

.auth-links {
  margin-top: 24px;
  text-align: center;
  color: rgba(255, 255, 255, 0.9);
  font-size: 14px;

  a {
    color: white;
    text-decoration: none;
    font-weight: 600;
    transition: all 0.3s;
    padding: 2px 8px;
    border-radius: 8px;

    &:hover {
      background: rgba(255, 255, 255, 0.15);
      text-decoration: none;
    }
  }
}

@media (max-width: 576px) {
  .auth-box {
    width: 90%;
    max-width: 360px;
    padding: 32px 24px;
  }
}

// 动画
@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(40px) scale(0.95);
  }

  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

@keyframes sparkle {

  0%,
  100% {
    opacity: 0.3;
    background-position: 0% 0%, 100% 0%, 50% 50%, 0% 100%;
  }

  50% {
    opacity: 0.6;
    background-position: 100% 100%, 0% 100%, 0% 0%, 100% 0%;
  }
}

@keyframes pulse {

  0%,
  100% {
    transform: scale(1);
  }

  50% {
    transform: scale(1.05);
  }
}
</style>