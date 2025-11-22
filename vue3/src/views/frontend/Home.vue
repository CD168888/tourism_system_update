<template>
  <div class="home-container">
    <!-- Hero区域 - 轮播图 + 搜索 -->
    <div class="hero-section">
      <div class="hero-background">
        <home-carousel />
        <div class="hero-particles"></div>
      </div>
      <div class="hero-content">
        <div class="hero-glass-card">
          <h1 class="hero-title">探索世界 · 发现美好</h1>
          <p class="hero-subtitle">每一次旅行,都是一场心灵的修行</p>
          <div class="hero-search">
            <smart-search placeholder="搜索目的地、景点、攻略..." @search="handleSearch" />
          </div>
        </div>
      </div>
    </div>
    <!-- 快速导航区域 -->
    <div class="quick-nav-section">
      <div class="section-container">
        <div class="section-header">
          <h2 class="section-title">
            <svg class="title-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="3" y="3" width="7" height="7"></rect>
              <rect x="14" y="3" width="7" height="7"></rect>
              <rect x="14" y="14" width="7" height="7"></rect>
              <rect x="3" y="14" width="7" height="7"></rect>
            </svg>
            <span class="gradient-text">热门分类</span>
          </h2>
        </div>
        <div class="category-grid">
          <div v-for="(category, index) in categories" :key="category.id" class="category-card glass-effect"
            :class="`category-${index + 1}`" @click="goToCategory(category.id)">
            <div class="category-icon-wrapper">
              <el-icon :size="32">
                <component :is="category.icon" />
              </el-icon>
            </div>
            <h3 class="category-name">{{ category.name }}</h3>
            <p class="category-desc">{{ category.description || '探索更多精彩' }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- 精选推荐区域 -->
    <div class="featured-section">
      <div class="section-container">
        <div class="section-header">
          <h2 class="section-title">
            <svg class="title-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
              <circle cx="12" cy="10" r="3"></circle>
            </svg>
            <span class="gradient-text">精选景点</span>
          </h2>
          <router-link to="/scenic" class="view-more-btn glass-btn">
            查看全部 <el-icon>
              <ArrowRight />
            </el-icon>
          </router-link>
        </div>

        <el-skeleton :loading="scenicLoading" animated :count="6" :throttle="500">
          <template #template>
            <div class="scenic-grid">
              <div v-for="i in 6" :key="i" class="skeleton-item">
                <el-skeleton-item variant="image" style="width: 100%; height: 200px" />
                <div style="padding: 16px;">
                  <el-skeleton-item variant="h3" style="width: 80%; margin-bottom: 8px" />
                  <el-skeleton-item variant="text" style="width: 60%; margin-bottom: 8px" />
                  <el-skeleton-item variant="text" style="width: 40%" />
                </div>
              </div>
            </div>
          </template>
          <template #default>
            <div class="scenic-grid">
              <div v-for="item in scenicList" :key="item.id" class="scenic-card glass-card"
                @click="goToScenicDetail(item.id)">
                <div class="card-image-wrapper">
                  <img :src="getImageUrl(item.imageUrl)" :alt="item.name" />
                  <div class="image-gradient-overlay"></div>
                  <div class="card-badges">
                    <span v-if="item.price === 0" class="badge badge-free">免费</span>
                    <span v-else-if="item.price > 0" class="badge badge-price">¥{{ item.price }}</span>
                  </div>
                  <div class="rating-badge">
                    <el-icon>
                      <Star />
                    </el-icon>
                    <span>{{ item.rating || '4.5' }}</span>
                  </div>
                </div>
                <div class="card-content">
                  <h3 class="scenic-name">{{ item.name }}</h3>
                  <div class="scenic-location">
                    <el-icon>
                      <Location />
                    </el-icon>
                    {{ item.location || '未知地区' }}
                  </div>
                  <p class="scenic-desc">{{ truncateText(item.description, 60) }}</p>
                </div>
              </div>
            </div>
          </template>
        </el-skeleton>
      </div>
    </div>

    <!-- 旅游灵感区域 -->
    <div class="inspiration-section">
      <div class="section-container">
        <div class="section-header">
          <h2 class="section-title">
            <svg class="title-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
              <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
            </svg>
            <span class="gradient-text">旅游攻略</span>
          </h2>
          <router-link to="/guide" class="view-more-btn glass-btn">
            更多攻略 <el-icon>
              <ArrowRight />
            </el-icon>
          </router-link>
        </div>

        <div class="guides-section">

          <el-skeleton :loading="guideLoading" animated :count="3" :throttle="500">
            <template #template>
              <div class="guide-grid">
                <div v-for="i in 3" :key="i" class="guide-skeleton">
                  <el-skeleton-item variant="image" style="width: 100%; height: 160px; border-radius: 8px" />
                  <div style="padding: 16px;">
                    <el-skeleton-item variant="h3" style="width: 80%; margin-bottom: 8px" />
                    <el-skeleton-item variant="text" style="width: 60%; margin-bottom: 8px" />
                    <el-skeleton-item variant="text" style="width: 40%" />
                  </div>
                </div>
              </div>
            </template>
            <template #default>
              <div class="guide-grid">
                <div v-for="item in guideList" :key="item.id" class="guide-card glass-card"
                  @click="goToGuideDetail(item.id)">
                  <div class="guide-image-wrapper">
                    <img :src="getImageUrl(item.coverImage)" :alt="item.title" />
                    <div class="image-gradient-overlay"></div>
                    <div class="guide-views-badge">
                      <el-icon>
                        <View />
                      </el-icon>
                      <span>{{ item.views || 0 }}</span>
                    </div>
                  </div>
                  <div class="guide-content">
                    <h4 class="guide-title">{{ item.title }}</h4>
                    <div class="guide-meta">
                      <span class="author">{{ item.userNickname || '旅游达人' }}</span>
                      <span class="date">{{ formatDate(item.createTime) }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </template>
          </el-skeleton>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, nextTick } from 'vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'
import HomeCarousel from '@/components/frontend/HomeCarousel.vue'
import SmartSearch from '@/components/common/SmartSearch.vue'
import {
  ArrowRight,
  Location,
  View,
  Calendar,
  Sunny,
  House,
  TakeawayBox,
  OfficeBuilding,
  Ship,
  Star
} from '@element-plus/icons-vue'

const router = useRouter()
const baseAPI = process.env.VUE_APP_BASE_API || '/api'



// 景点分类
const categories = [
  { id: 1, name: '自然风光', icon: 'Sunny', description: '山川湖海，自然奇观' },
  { id: 2, name: '历史文化', icon: 'House', description: '古迹名胜，文化传承' },
  { id: 3, name: '主题公园', icon: 'TakeawayBox', description: '欢乐体验，亲子时光' },
  { id: 4, name: '城市地标', icon: 'OfficeBuilding', description: '都市风光，现代建筑' },
  { id: 5, name: '乡村民俗', icon: 'Ship', description: '田园风情，民俗体验' }
]

// 景点数据
const scenicList = ref([])
const scenicLoading = ref(true)

// 攻略数据
const guideList = ref([])
const guideLoading = ref(true)

// 获取图片完整URL
const getImageUrl = (url) => {
  if (!url) return ''
  return url.startsWith('http') ? url : baseAPI + url
}

// 截断文本
const truncateText = (text, length) => {
  if (!text) return ''
  return text.length > length ? text.substring(0, length) + '...' : text
}

// 格式化日期
const formatDate = (dateString) => {
  if (!dateString) return ''
  const date = new Date(dateString)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

// 跳转到分类页面
const goToCategory = (categoryId) => {
  router.push(`/scenic/category/${categoryId}`)
}

// 跳转到景点详情
const goToScenicDetail = (scenicId) => {
  router.push(`/scenic/${scenicId}`)
}

// 跳转到攻略详情
const goToGuideDetail = (guideId) => {
  router.push(`/guide/detail/${guideId}`)
}

// 搜索功能
const handleSearch = (keyword) => {
  if (keyword && keyword.trim()) {
    router.push(`/scenic?search=${encodeURIComponent(keyword.trim())}`)
  }
}

// 获取热门景点
const fetchHotScenics = async () => {
  scenicLoading.value = true
  try {
    await request.get('/scenic/hot', {
      limit: 4
    }, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        scenicList.value = data || []
      }
    })
  } catch (error) {
    console.error('获取热门景点失败:', error)
  } finally {
    scenicLoading.value = false
  }
}

// 获取精选攻略
const fetchHotGuides = async () => {
  guideLoading.value = true
  try {
    await request.get('/guide/hot', {
      limit: 3
    }, {
      showDefaultMsg: false,
      onSuccess: (data) => {
        guideList.value = data || []
      }
    })
  } catch (error) {
    console.error('获取精选攻略失败:', error)
  } finally {
    guideLoading.value = false
  }
}

// 滚动动画观察器
const observeElements = () => {
  const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('visible')
      }
    })
  }, {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  })

  // 观察需要动画的元素
  nextTick(() => {
    const animateElements = document.querySelectorAll('.glass-card, .category-card')
    animateElements.forEach(el => observer.observe(el))
  })
}

// 添加粒子效果
const createParticles = () => {
  const particlesContainer = document.querySelector('.hero-particles')
  if (!particlesContainer) return

  for (let i = 0; i < 20; i++) {
    const particle = document.createElement('div')
    particle.className = 'particle'
    particle.style.cssText = `
      position: absolute;
      width: ${Math.random() * 4 + 2}px;
      height: ${Math.random() * 4 + 2}px;
      background: rgba(255, 255, 255, ${Math.random() * 0.5 + 0.2});
      border-radius: 50%;
      left: ${Math.random() * 100}%;
      top: ${Math.random() * 100}%;
      animation: particleFloat ${Math.random() * 3 + 4}s ease-in-out infinite;
      animation-delay: ${Math.random() * 2}s;
    `
    particlesContainer.appendChild(particle)
  }
}

onMounted(() => {
  fetchHotScenics()
  fetchHotGuides()

  // 延迟执行动画相关功能，确保DOM已渲染
  nextTick(() => {
    observeElements()
    createParticles()
  })
})
</script>

<style lang="scss" scoped>
// 全局变量
:root {
  --gradient-primary: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
  --gradient-secondary: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
  --gradient-success: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
  --gradient-warm: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
}

.home-container {
  width: 100%;
  font-family: "PingFang SC", "Helvetica Neue", Helvetica, Arial, "Microsoft YaHei", sans-serif;
  color: #1a202c;
  min-height: 100vh;
}

// Hero区域样式
.hero-section {
  position: relative;
  height: 600px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;

  :deep(.home-carousel) {
    height: 100%;
    z-index: 1;

    .el-carousel {
      height: 100%;
      z-index: 1;
    }

    .el-carousel__item {
      height: 100%;
      z-index: 1;
    }
  }
}

.hero-particles {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 2;
  pointer-events: none;
}

@keyframes particleFloat {

  0%,
  100% {
    transform: translateY(0px);
  }

  50% {
    transform: translateY(-10px);
  }
}

.hero-content {
  position: relative;
  z-index: 10;
  width: 100%;
  max-width: 800px;
  padding: 0 20px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.hero-glass-card {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-radius: 30px;
  padding: 60px 50px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
  text-align: center;
  width: 100%;
  transition: all 0.4s ease;
  animation: fadeInUp 0.8s ease;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 25px 70px rgba(0, 0, 0, 0.25);
  }
}

@keyframes fadeInUp {
  0% {
    opacity: 0;
    transform: translateY(30px);
  }

  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

// 为每个卡片添加延迟动画
.scenic-card,
.guide-card {
  @for $i from 1 through 12 {
    &:nth-child(#{$i}) {
      animation-delay: #{$i * 0.1}s;
    }
  }
}

.hero-title {
  font-size: 52px;
  font-weight: 800;
  margin: 0 0 20px;
  color: white;
  text-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
  letter-spacing: 2px;
  line-height: 1.2;
}

.hero-subtitle {
  font-size: 20px;
  margin: 0 0 40px;
  color: rgba(255, 255, 255, 0.95);
  text-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  font-weight: 400;
  letter-spacing: 1px;
}

.hero-search {
  width: 100%;
  display: flex;
  justify-content: center;

  :deep(.smart-search) {
    width: 100%;
    max-width: 100%;
  }
}

// 通用容器样式
.section-container {
  max-width: 1300px;
  margin: 0 auto;
  padding: 20px 20px;
}

// 区域样式
.quick-nav-section,
.featured-section,
.inspiration-section {
  position: relative;


}

// 标题样式
.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 50px;
  flex-wrap: wrap;
  gap: 20px;
}

.section-title {
  font-size: 38px;
  font-weight: 800;
  margin: 0;
  color: #1a202c;
  display: flex;
  align-items: center;
  gap: 12px;
}

.gradient-text {
  background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  position: relative;
  display: inline-block;

  &::after {
    content: '';
    position: absolute;
    bottom: -10px;
    left: 0;
    width: 60px;
    height: 4px;
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    border-radius: 2px;
  }
}

.title-icon {
  width: 32px;
  height: 32px;
  color: #67b6f5;
  flex-shrink: 0;
}

.view-more-btn,
.more-link {
  color: #67b6f5;
  font-size: 15px;
  display: flex;
  align-items: center;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.3s ease;
  padding: 0;

  .el-icon {
    margin-left: 6px;
    transition: transform 0.3s ease;
  }

  &:hover {
    color: #5aa9e6;

    .el-icon {
      transform: translateX(4px);
    }
  }
}

.glass-btn {
  background: rgba(255, 255, 255, 0.8);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  padding: 10px 20px;
  border-radius: 20px;
  border: 1px solid rgba(103, 182, 245, 0.2);
  transition: all 0.3s ease;

  &:hover {
    background: rgba(255, 255, 255, 0.95);
    transform: translateY(-2px);
    box-shadow: 0 8px 16px rgba(103, 182, 245, 0.2);
  }
}

// 快速导航样式
.category-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 24px;
  margin-bottom: 20px;
}

.category-card {
  position: relative;
  border-radius: 24px;
  padding: 40px 30px;
  cursor: pointer;
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  text-align: center;
  overflow: hidden;
  opacity: 1;
  transform: translateY(0);
  animation: fadeInUp 0.6s ease both;

  &.visible {
    opacity: 1;
    transform: translateY(0);
  }

  &:hover {
    transform: translateY(-10px) scale(1.02);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);

    .category-icon-wrapper {
      transform: scale(1.15) rotate(5deg);
    }
  }

  &.category-1 {
    background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
  }

  &.category-2 {
    background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
  }

  &.category-3 {
    background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
  }

  &.category-4 {
    background: linear-gradient(135deg, #a1c4fd 0%, #c2e9fb 100%);
  }

  &.category-5 {
    background: linear-gradient(135deg, #ffecd2 0%, #fcb69f 100%);
  }
}

.glass-effect {
  background: rgba(255, 255, 255, 0.7);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.08);
}

.category-icon-wrapper {
  width: 80px;
  height: 80px;
  border-radius: 20px;
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 20px;
  transition: all 0.4s ease;
  color: #667eea;
  box-shadow: 0 4px 15px rgba(103, 182, 245, 0.2);
}

.category-name {
  font-size: 20px;
  font-weight: 700;
  margin: 0 0 10px;
  color: #1a202c;
}

.category-desc {
  font-size: 14px;
  margin: 0;
  color: #5a6c7d;
  line-height: 1.6;
}

// 景点网格布局
.scenic-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
}

.scenic-card,
.glass-card {
  border-radius: 20px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  opacity: 1;
  transform: translateY(0);
  animation: fadeInUp 0.6s ease both;

  &.visible {
    opacity: 1;
    transform: translateY(0);
  }

  &:hover {
    transform: translateY(-12px);
    box-shadow: 0 20px 50px rgba(103, 182, 245, 0.2);

    .card-image-wrapper img,
    .guide-image-wrapper img {
      transform: scale(1.15);
    }

    .image-gradient-overlay {
      opacity: 0.6;
    }
  }
}

.card-image-wrapper,
.guide-image-wrapper {
  height: 240px;
  overflow: hidden;
  position: relative;

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.6s cubic-bezier(0.4, 0, 0.2, 1);
  }
}

.image-gradient-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(180deg,
      rgba(0, 0, 0, 0) 0%,
      rgba(0, 0, 0, 0.3) 70%,
      rgba(0, 0, 0, 0.6) 100%);
  opacity: 0.4;
  transition: opacity 0.3s ease;
  pointer-events: none;
}

.card-badges {
  position: absolute;
  top: 16px;
  left: 16px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  z-index: 2;
}

.badge {
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 700;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);

  &.badge-free {
    background: linear-gradient(135deg, #52c787, #4ecdc4);
    color: white;
  }

  &.badge-price {
    background: linear-gradient(135deg, #ff9a56, #ff6b6b);
    color: white;
  }
}

.rating-badge {
  position: absolute;
  top: 16px;
  right: 16px;
  background: rgba(255, 255, 255, 0.95);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  padding: 6px 12px;
  border-radius: 20px;
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 14px;
  font-weight: 700;
  color: #ffa94d;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  z-index: 2;

  .el-icon {
    color: #ffd700;
  }

  span {
    color: #1a202c;
  }
}

.card-content {
  padding: 24px;
}

.scenic-name {
  margin: 0 0 12px;
  font-size: 20px;
  font-weight: 700;
  color: #1a202c;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.4;
}

.scenic-location {
  display: flex;
  align-items: center;
  font-size: 14px;
  color: #5a6c7d;
  margin-bottom: 12px;
  font-weight: 500;

  .el-icon {
    margin-right: 6px;
    color: #67b6f5;
  }
}

.scenic-desc {
  font-size: 14px;
  color: #718096;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.6;
}

// 攻略区域
.guides-section {
  margin-top: 0;
}

.guide-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 30px;
}

.guide-image-wrapper {
  height: 200px;
}

.guide-views-badge {
  position: absolute;
  top: 16px;
  right: 16px;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  color: white;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  display: flex;
  align-items: center;
  gap: 6px;
  font-weight: 600;
  z-index: 2;

  .el-icon {
    font-size: 14px;
  }
}

.guide-content {
  padding: 24px;
}

.guide-title {
  margin: 0 0 12px;
  font-size: 18px;
  font-weight: 700;
  color: #1a202c;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.4;
}

.guide-meta {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  color: #718096;

  .author {
    font-weight: 600;
    color: #67b6f5;
  }

  .date {
    color: #a0aec0;
  }
}

// 骨架屏样式
.guide-skeleton,
.skeleton-item {
  background: rgba(255, 255, 255, 0.9);
  border-radius: 20px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

// 响应式样式
@media (max-width: 992px) {
  .scenic-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  }

  .guide-grid {
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  }

  .section-container {
    padding: 60px 20px;
  }
}

@media (max-width: 768px) {
  .hero-section {
    height: 500px;
  }

  .hero-glass-card {
    padding: 40px 30px;
  }

  .hero-title {
    font-size: 36px;
  }

  .hero-subtitle {
    font-size: 16px;
    margin-bottom: 30px;
  }

  .section-title {
    font-size: 28px;
  }

  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 15px;
  }

  .category-grid {
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 16px;
  }

  .category-card {
    padding: 30px 20px;
  }

  .category-icon-wrapper {
    width: 60px;
    height: 60px;
  }

  .scenic-grid,
  .guide-grid {
    grid-template-columns: 1fr;
  }

  .section-container {
    padding: 40px 15px;
  }
}

@media (max-width: 480px) {
  .hero-section {
    height: 400px;
  }

  .hero-glass-card {
    padding: 30px 20px;
  }

  .hero-title {
    font-size: 28px;
    letter-spacing: 1px;
  }

  .hero-subtitle {
    font-size: 14px;
    margin-bottom: 25px;
  }

  .section-title {
    font-size: 24px;
  }

  .category-grid {
    grid-template-columns: 1fr;
  }

  .category-card {
    padding: 25px 20px;
  }

  .card-image-wrapper,
  .guide-image-wrapper {
    height: 200px;
  }
}
</style>
