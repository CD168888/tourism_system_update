<template>
  <div class="frontend-layout">
    <!-- 顶部导航栏 -->
    <header class="header">
      <div class="nav-container">
        <div class="logo-container">
          <el-icon class="logo-icon">
            <Place />
          </el-icon>
          <h1 class="logo-text">旅游信息系统</h1>
        </div>

        <el-menu mode="horizontal" :ellipsis="false" class="main-menu" :router="true">
          <el-menu-item index="/">
            <el-icon>
              <HomeFilled />
            </el-icon>
            <span>首页</span>
          </el-menu-item>

          <el-menu-item index="/scenic">
            <el-icon>
              <Bicycle />
            </el-icon>
            <span>景点</span>
          </el-menu-item>

          <el-menu-item index="/guide">
            <el-icon>
              <Reading />
            </el-icon>
            <span>攻略</span>
          </el-menu-item>

          <el-menu-item index="/accommodation">
            <el-icon>
              <House />
            </el-icon>
            <span>周边住宿</span>
          </el-menu-item>

          <el-menu-item index="/tickets">
            <el-icon>
              <Ticket />
            </el-icon>
            <span>门票预订</span>
          </el-menu-item>

          <el-menu-item index="/ai-chat">
            <el-icon>
              <ChatDotRound />
            </el-icon>
            <span>AI助手</span>
          </el-menu-item>
        </el-menu>

        <div class="user-actions">
          <template v-if="isLoggedIn">
            <el-dropdown trigger="click" @command="handleCommand">
              <div class="user-info">
                <el-avatar :size="32" :src="userAvatar">{{ userInitial }}</el-avatar>
                <span class="user-name">{{ userName || '用户' }}</span>
                <el-icon>
                  <ArrowDown />
                </el-icon>
              </div>

              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="profile" icon="User">个人中心</el-dropdown-item>
                  <el-dropdown-item command="guide" icon="Notebook">我的攻略</el-dropdown-item>
                  <el-dropdown-item command="collection" icon="Star">我的收藏</el-dropdown-item>
                  <el-dropdown-item command="orders" icon="Ticket">我的订单</el-dropdown-item>
                  <el-dropdown-item divided command="logout" icon="SwitchButton">退出登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </template>

          <template v-else>
            <el-button type="primary" @click="goToLogin" class="login-btn">
              <el-icon>
                <Key />
              </el-icon>
              <span>登录 / 注册</span>
            </el-button>
          </template>
        </div>
      </div>
    </header>

    <!-- 主要内容区域 -->
    <el-main class="main-content">
      <router-view />
    </el-main>

    <!-- 页脚 -->
    <footer class="footer">
      <div class="footer-content">
        <p class="copyright">&copy; 2025 旅游信息系统 | 版权所有</p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useUserStore } from '@/store/user'
import { useRouter } from 'vue-router'
import {
  HomeFilled,
  User,
  Bicycle,
  Reading,
  Notebook,
  Star,
  SwitchButton,
  Key,
  Ticket,
  House,
  Place,
  ArrowDown,
  ChatDotRound
} from '@element-plus/icons-vue'
import { getImageUrl } from '@/utils/uploadConfig'

const userStore = useUserStore()
const router = useRouter()

const isLoggedIn = computed(() => !!userStore.token)
const userName = computed(() => userStore.userInfo?.name || userStore.userInfo?.username || '')
const userInitial = computed(() => {
  const name = userName.value
  return name ? name.charAt(0).toUpperCase() : '游'
})

const userAvatar = computed(() => {
  return getImageUrl(userStore.userInfo?.avatar)
})

const handleCommand = (command) => {
  switch (command) {
    case 'profile':
      router.push('/profile')
      break
    case 'guide':
      router.push('/my-guide')
      break
    case 'collection':
      router.push('/collection')
      break
    case 'orders':
      router.push('/orders')
      break
    case 'logout':
      handleLogout()
      break
  }
}

const goToLogin = () => {
  router.push('/login')
}

const handleLogout = () => {
  userStore.clearUserInfo()
  router.push('/login')
}
</script>

<style lang="scss" scoped>
.frontend-layout {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background:
    linear-gradient(to bottom, transparent 0%, transparent 5%, #fff 20%),
    linear-gradient(135deg, #e8f5e9 0%, #b3e5fc 30%, #fff9c4 60%, #ffccbc 100%);
  background-attachment: fixed;
  position: relative;

  &::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-image:
      radial-gradient(circle at 20% 30%, rgba(129, 199, 132, 0.15) 0%, transparent 50%),
      radial-gradient(circle at 80% 70%, rgba(100, 181, 246, 0.15) 0%, transparent 50%),
      radial-gradient(circle at 50% 50%, rgba(255, 238, 88, 0.1) 0%, transparent 50%);
    pointer-events: none;
    z-index: 0;
  }
}

// 导航栏样式
.header {
  background: rgba(255, 255, 255, 0.75);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
  border-bottom: 1px solid rgba(255, 255, 255, 0.3);
  position: sticky;
  top: 0;
  z-index: 1000;
}

.nav-container {
  max-width: 1400px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  padding: 0 20px;
  height: 64px;
}

.logo-container {
  display: flex;
  align-items: center;
  margin-right: 30px;

  .logo-icon {
    font-size: 24px;
    background: linear-gradient(135deg, #66bb6a 0%, #42a5f5 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin-right: 10px;
  }

  .logo-text {
    font-size: 20px;
    font-weight: 600;
    background: linear-gradient(135deg, #66bb6a 0%, #42a5f5 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
    margin: 0;
  }
}

.main-menu {
  flex: 1;
  border-bottom: none;
  background-color: transparent;

  :deep(.el-menu-item) {
    color: #5d6d7e;
    font-size: 16px;
    font-weight: 500;
    transition: all 0.3s ease;

    &:hover,
    &.is-active {
      color: #43a047;
      background: rgba(129, 199, 132, 0.1);
      border-radius: 8px;
    }

    .el-icon {
      color: #7e8e9f;
      margin-right: 5px;
      transition: all 0.3s ease;
    }

    &.is-active .el-icon,
    &:hover .el-icon {
      color: #43a047;
    }
  }
}

.user-actions {
  margin-left: auto;
  display: flex;
  align-items: center;

  .user-info {
    display: flex;
    align-items: center;
    cursor: pointer;
    padding: 8px 14px;
    border-radius: 20px;
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.4);
    transition: all 0.3s ease;

    &:hover {
      background: rgba(129, 199, 132, 0.15);
      border-color: rgba(129, 199, 132, 0.3);
      box-shadow: 0 4px 12px rgba(129, 199, 132, 0.2);
    }

    .user-name {
      margin: 0 8px;
      color: #5d6d7e;
      font-size: 14px;
      font-weight: 500;
    }

    .el-icon {
      font-size: 12px;
      color: #909399;
    }
  }

  .login-btn {
    border-radius: 20px;
    background: linear-gradient(135deg, #66bb6a 0%, #43a047 100%);
    border: none;
    color: #fff;
    padding: 10px 20px;
    font-weight: 500;
    box-shadow: 0 4px 12px rgba(102, 187, 106, 0.3);
    transition: all 0.3s ease;

    &:hover {
      background: linear-gradient(135deg, #43a047 0%, #2e7d32 100%);
      box-shadow: 0 6px 16px rgba(102, 187, 106, 0.4);
      transform: translateY(-2px);
    }

    .el-icon {
      margin-right: 5px;
    }
  }
}

// 主内容区域
.main-content {
  flex: 1;
  padding: 20px;
  max-width: 1400px;
  margin: 0 auto;
  width: 100%;
  position: relative;
  z-index: 1;
}

// 页脚样式
.footer {
  background: #f8fafc;
  color: #606266;
  border-top: 1px solid #eaecef;
  padding: 20px 0;
}

.footer-content {
  max-width: 1400px;
  margin: 0 auto;
  text-align: center;
}

.copyright {
  margin: 0;
  font-size: 14px;
  color: #909399;
}

// 响应式样式
@media (max-width: 768px) {
  .nav-container {
    flex-wrap: wrap;
    height: auto;
    padding: 10px;
  }

  .logo-container {
    margin-bottom: 10px;
    width: 100%;
    justify-content: center;
  }

  .main-menu {
    order: 3;
    width: 100%;
    justify-content: center;
  }

  .user-actions {
    order: 2;
    margin: 0 0 10px 0;
    width: 100%;
    justify-content: center;
  }

  .footer-content {
    flex-direction: column;
  }

  .footer-section {
    margin-bottom: 30px;
  }
}
</style>