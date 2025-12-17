<template>
  <div class="backend-layout">
    <!-- 侧边栏 -->
    <Sidebar />

    <!-- 主要内容区域 -->
    <div class="main-content">
      <!-- 顶部导航栏 -->
      <Navbar @logout="handleLogout" />

      <!-- 页面内容 -->
      <div class="content-container">
        <router-view v-slot="{ Component }">
          <transition name="fade" mode="out-in">
            <component :is="Component" />
          </transition>
        </router-view>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useUserStore } from '@/store/user'
import { useRouter } from 'vue-router'
import Sidebar from '@/components/backend/Sidebar.vue'
import Navbar from '@/components/backend/Navbar.vue'
const userStore = useUserStore()
const router = useRouter()


const handleLogout = () => {
  userStore.clearUserInfo()
  router.push('/login')
}
</script>

<style lang="scss" scoped>
.backend-layout {
  display: flex;
  height: 100vh;
  min-height: 100vh;
  background: linear-gradient(135deg, #e8f5e9 0%, #f1f8e9 50%, #fff9c4 100%);
  background-attachment: fixed;
  overflow: hidden;
  position: relative;

  &::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-image:
      radial-gradient(circle at 15% 20%, rgba(129, 199, 132, 0.1) 0%, transparent 50%),
      radial-gradient(circle at 85% 80%, rgba(255, 238, 88, 0.08) 0%, transparent 50%);
    pointer-events: none;
    z-index: 0;
  }
}

.sidebar {
  width: 200px;
  background-color: #333;
  color: white;
  padding: 1rem;
}

.sidebar nav {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.sidebar a {
  color: white;
  text-decoration: none;
}

.main-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  height: 100%;
}

.content-container {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  position: relative;
  z-index: 1;

  &::-webkit-scrollbar {
    width: 6px;
  }

  &::-webkit-scrollbar-thumb {
    background: linear-gradient(180deg, #66bb6a 0%, #43a047 100%);
    border-radius: 3px;
  }

  &::-webkit-scrollbar-track {
    background-color: rgba(255, 255, 255, 0.3);
    border-radius: 3px;
  }
}
</style>