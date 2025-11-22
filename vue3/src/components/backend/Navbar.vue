<template>
  <div class="navbar">
    <div class="navbar-content">
      <div class="left-section">
        <div class="menu-toggle" @click="toggleSidebar">
          <el-icon :size="22">
            <component :is="appStore.sidebarCollapsed ? Expand : Fold" />
          </el-icon>
        </div>

        <div class="breadcrumb-wrapper">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item :to="{ path: '/dashboard' }">
              <span class="breadcrumb-text">首页</span>
            </el-breadcrumb-item>
            <el-breadcrumb-item v-if="route.meta.title">
              <span class="breadcrumb-text">{{ route.meta.title }}</span>
            </el-breadcrumb-item>
          </el-breadcrumb>
        </div>
      </div>

      <div class="right-section">
        <div class="action-btn fullscreen-btn" @click="toggleFullScreen">
          <el-icon :size="20">
            <component :is="isFullscreen ? Aim : FullScreen" />
          </el-icon>
        </div>

        <el-dropdown trigger="click" class="user-dropdown">
          <div class="user-info">
            <el-avatar :size="36" :src="avatarUrl" class="user-avatar">
              {{ userInfo?.name?.charAt(0)?.toUpperCase() || userInfo?.username?.charAt(0)?.toUpperCase() || 'U' }}
            </el-avatar>
            <span class="username">{{ userInfo?.name || userInfo?.username || '用户' }}</span>
            <el-icon class="dropdown-icon" :size="16">
              <ArrowDown />
            </el-icon>
          </div>
          <template #dropdown>
            <el-dropdown-menu class="modern-dropdown">
              <el-dropdown-item @click="handleLogout">
                <el-icon>
                  <SwitchButton />
                </el-icon>
                <span>退出登录</span>
              </el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, ref, onUnmounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/store/user'
import { useAppStore } from '@/store/app'
import { ElMessageBox } from 'element-plus'
import { Expand, Fold, ArrowDown, User, SwitchButton, FullScreen, Aim } from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const appStore = useAppStore()
const baseAPI = process.env.VUE_APP_BASE_API || '/api'
const userInfo = computed(() => userStore.userInfo)
const isFullscreen = ref(false)

const toggleSidebar = () => {
  appStore.toggleSidebar()
}
const avatarUrl = computed(() => {
  return userInfo.value?.avatar ? baseAPI + userInfo.value.avatar : '';
})
const toggleFullScreen = () => {
  if (!document.fullscreenElement) {
    document.documentElement.requestFullscreen()
    isFullscreen.value = true
  } else {
    if (document.exitFullscreen) {
      document.exitFullscreen()
      isFullscreen.value = false
    }
  }
}

// 监听全屏状态变化
const fullscreenChangeHandler = () => {
  isFullscreen.value = !!document.fullscreenElement
}

document.addEventListener('fullscreenchange', fullscreenChangeHandler)

// 组件卸载时移除事件监听
onUnmounted(() => {
  document.removeEventListener('fullscreenchange', fullscreenChangeHandler)
})



const handleLogout = () => {
  ElMessageBox.confirm('确定要退出登录吗?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning',
  }).then(async () => {
    await userStore.logout()
    router.push('/login')
  }).catch(() => { })
}
</script>

<style lang="scss" scoped>
.navbar {
  height: 70px;
  position: relative;
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.08),
    0 2px 8px rgba(0, 0, 0, 0.04);
  z-index: 100;

  .navbar-content {
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 24px;
    max-width: 100%;
  }

  .left-section {
    display: flex;
    align-items: center;
    gap: 20px;

    .menu-toggle {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 40px;
      height: 40px;
      cursor: pointer;
      border-radius: 12px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: #ffffff;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);

      &:hover {
        transform: translateY(-2px) scale(1.05);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
      }

      &:active {
        transform: translateY(0) scale(0.98);
      }
    }

    .breadcrumb-wrapper {
      :deep(.el-breadcrumb) {
        font-size: 14px;

        .el-breadcrumb__item {
          .breadcrumb-text {
            color: #64748b;
            font-weight: 500;
            transition: all 0.3s ease;
          }

          &:last-child .breadcrumb-text {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            font-weight: 600;
          }
        }

        .el-breadcrumb__inner.is-link:hover .breadcrumb-text {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
          background-clip: text;
        }

        .el-breadcrumb__separator {
          color: #cbd5e1;
        }
      }
    }
  }

  .right-section {
    display: flex;
    align-items: center;
    gap: 12px;

    .action-btn {
      display: flex;
      align-items: center;
      justify-content: center;
      width: 40px;
      height: 40px;
      cursor: pointer;
      border-radius: 12px;
      background: rgba(255, 255, 255, 0.6);
      backdrop-filter: blur(10px);
      border: 1px solid rgba(255, 255, 255, 0.3);
      color: #64748b;
      transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);

      &:hover {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: #ffffff;
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.3);
        border-color: transparent;
      }

      &:active {
        transform: translateY(0);
      }
    }

    .user-dropdown {
      :deep(.user-info) {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 6px 16px 6px 6px;
        height: 48px;
        cursor: pointer;
        border-radius: 24px;
        background: rgba(255, 255, 255, 0.7);
        backdrop-filter: blur(10px);
        border: 1px solid rgba(255, 255, 255, 0.4);
        transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);

        &:hover {
          background: rgba(102, 126, 234, 0.1);
          border-color: rgba(102, 126, 234, 0.3);
          box-shadow: 0 4px 16px rgba(102, 126, 234, 0.2);
          transform: translateY(-1px);
        }

        .user-avatar {
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: #ffffff;
          font-weight: 600;
          font-size: 14px;
          box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
        }

        .username {
          font-size: 14px;
          font-weight: 500;
          color: #334155;
          letter-spacing: 0.3px;
        }

        .dropdown-icon {
          color: #94a3b8;
          transition: transform 0.3s ease;
        }
      }
    }
  }
}

:deep(.modern-dropdown) {
  margin-top: 8px !important;
  border-radius: 12px !important;
  background: rgba(255, 255, 255, 0.95) !important;
  backdrop-filter: blur(20px) !important;
  border: 1px solid rgba(255, 255, 255, 0.2) !important;
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.15) !important;
  padding: 6px !important;

  .el-dropdown-menu__item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 16px !important;
    margin: 2px 0;
    border-radius: 8px !important;
    font-size: 14px;
    font-weight: 500;
    color: #64748b !important;
    transition: all 0.3s ease !important;

    .el-icon {
      font-size: 18px;
    }

    &:hover {
      background: linear-gradient(135deg, rgba(239, 68, 68, 0.1) 0%, rgba(220, 38, 38, 0.1) 100%) !important;
      color: #ef4444 !important;
      transform: translateX(4px);
    }
  }
}
</style>