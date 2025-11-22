<!-- eslint-disable -->
<template>
  <div class="scenic-frontend-container">
    <!-- Hero顶部区域 -->
    <div class="hero-section">
      <div class="hero-background">
        <div class="hero-gradient"></div>
      </div>
      <div class="hero-content">
        <div class="hero-glass-card">
          <h1 class="hero-title">
            <svg class="hero-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
              <circle cx="12" cy="10" r="3"></circle>
            </svg>
            探索精彩景点
          </h1>
          <p class="hero-subtitle">发现世界各地的美丽风景和文化遗产</p>
        </div>
      </div>
    </div>

    <!-- 搜索和筛选区域 -->
    <div class="search-filter-section">
      <div class="section-container">
        <!-- 搜索卡片 -->
        <div class="search-card glass-card">
          <div class="search-header">
            <h3 class="search-title">
              <svg class="title-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="8"></circle>
                <path d="m21 21-4.35-4.35"></path>
              </svg>
              智能搜索
            </h3>
          </div>
          <div class="search-form">
            <div class="search-inputs">
              <div class="search-input-group">
                <el-input v-model="searchForm.name" placeholder="搜索景点名称、地区或描述..." clearable size="large"
                  class="main-search-input" @keyup.enter="handleSearch">
                  <template #prefix>
                    <el-icon>
                      <Search />
                    </el-icon>
                  </template>
                </el-input>
              </div>
              <div class="search-input-group">
                <el-input v-model="searchForm.location" placeholder="地区筛选" clearable size="large"
                  @keyup.enter="handleSearch">
                  <template #prefix>
                    <el-icon>
                      <Location />
                    </el-icon>
                  </template>
                </el-input>
              </div>
              <div class="search-actions">
                <el-button type="primary" @click="handleSearch" class="search-btn" size="large">
                  <el-icon>
                    <Search />
                  </el-icon>
                  搜索
                </el-button>
                <el-button @click="resetSearch" class="reset-btn" size="large">
                  <el-icon>
                    <Refresh />
                  </el-icon>
                  重置
                </el-button>
              </div>
            </div>

            <!-- 搜索结果提示 -->
            <div v-if="searchForm.name || searchForm.location || searchForm.categoryId" class="search-tags">
              <el-tag v-if="searchForm.name" closable @close="clearSearchName" class="search-tag tag-keyword">
                关键词: {{ searchForm.name }}
              </el-tag>
              <el-tag v-if="searchForm.location" closable @close="clearSearchLocation" class="search-tag tag-location">
                地区: {{ searchForm.location }}
              </el-tag>
              <el-tag v-if="searchForm.categoryId && getCurrentCategoryName()" closable @close="clearSearchCategory"
                class="search-tag tag-category">
                分类: {{ getCurrentCategoryName() }}
              </el-tag>
            </div>
          </div>

          <!-- 分类筛选 -->
          <div class="category-filter">
            <h3 class="filter-title">
              <svg class="title-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="3" width="7" height="7"></rect>
                <rect x="14" y="3" width="7" height="7"></rect>
                <rect x="14" y="14" width="7" height="7"></rect>
                <rect x="3" y="14" width="7" height="7"></rect>
              </svg>
              景点分类
            </h3>
            <div class="category-chips">
              <div v-for="category in categoryList" :key="category.id" class="category-chip"
                :class="{ 'active': searchForm.categoryId === category.id }" @click="handleCategoryChange(category.id)">
                <span class="chip-text">{{ category.name }}</span>
                <span class="chip-count" v-if="category.count">({{ category.count }})</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 景点列表区域 -->
    <div class="scenic-list-section">
      <div class="section-container">
        <div class="scenic-grid" v-if="tableData && tableData.length > 0">
          <div v-for="(item, index) in tableData" :key="item.id" class="scenic-card glass-card-scenic"
            :class="`delay-${(index % 6 + 1) * 100}`" @click="goDetail(item.id)">
            <div class="card-image-wrapper">
              <img :src="getImageUrl(item.imageUrl)" :alt="item.name" />
              <div class="image-gradient-overlay"></div>
              <div class="card-badges">
                <span v-if="item.categoryInfo" class="badge badge-category">{{ item.categoryInfo.name }}</span>
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
              <p class="scenic-desc">{{ truncateText(item.description, 80) }}</p>
              <div class="card-footer">
                <div class="card-meta">
                  <span class="review-count">{{ formatReviewCount(item.reviewCount) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="empty-state">
          <svg class="empty-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <path d="m21 21-4.35-4.35"></path>
          </svg>
          <h3 class="empty-title">暂无景点信息</h3>
          <p class="empty-desc">试试调整搜索条件或浏览其他分类</p>
          <el-button type="primary" @click="resetSearch" class="empty-action">
            重新搜索
          </el-button>
        </div>

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="total > 0">
          <el-pagination background layout="total, prev, pager, next, jumper" :current-page="currentPage"
            :page-size="pageSize" :total="total" @current-change="handleCurrentChange" class="modern-pagination" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import request from '@/utils/request'
import { useUserStore } from '@/store/user'
import { Search, Location, Refresh, Star, Grid } from '@element-plus/icons-vue'

const baseAPI = process.env.VUE_APP_BASE_API || '/api'
const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const tableData = ref([])
const categoryList = ref([])
const currentPage = ref(1)
const pageSize = ref(8)
const total = ref(0)
const searchForm = reactive({
  name: '',
  location: '',
  categoryId: null
})
const collectionStatus = ref({}) // 收藏状态映射

// 检查是否登录
const isLoggedIn = computed(() => userStore.isLoggedIn)

const fetchCategories = async () => {
  try {
    await request.get('/scenic-category/tree', {}, {
      onSuccess: (res) => {
        categoryList.value = res || [];
      }
    });
  } catch (error) {
    console.error('获取分类列表失败:', error);
    categoryList.value = [];
  }
}

const fetchScenicSpots = async () => {
  try {
    await request.get('/scenic/page', {
      name: searchForm.name,
      location: searchForm.location,
      categoryId: searchForm.categoryId,
      currentPage: currentPage.value,
      size: pageSize.value
    }, {
      onSuccess: (res) => {
        tableData.value = res.records || []
        total.value = res.total || 0

        // 如果用户已登录，检查收藏状态
        if (isLoggedIn.value && tableData.value.length > 0) {
          checkCollectionStatus()
        }

        // 获取评论统计信息
        if (tableData.value.length > 0) {
          fetchBatchCommentStats()
        }
      }
    })
  } catch (error) {
    console.error('获取景点列表失败:', error)
    tableData.value = []
    total.value = 0
  }
}

// 检查景点收藏状态
const checkCollectionStatus = async () => {
  // 提取景点ID列表
  const scenicIds = tableData.value.map(item => item.id)
  if (scenicIds.length === 0) return

  try {
    await request.post('/scenic-collection/batch-is-collected', scenicIds, {
      showDefaultMsg: false,
      onSuccess: (res) => {
        collectionStatus.value = res || {}
      }
    })
  } catch (error) {
    console.error('获取收藏状态失败:', error)
  }
}

// 处理URL搜索参数
const handleUrlParams = () => {
  const searchParam = route.query.search
  const categoryParam = route.params.categoryId

  if (searchParam) {
    // 如果有搜索参数，设置到搜索表单中
    searchForm.name = decodeURIComponent(searchParam)
  }

  if (categoryParam) {
    // 如果有分类参数，设置分类ID
    searchForm.categoryId = parseInt(categoryParam)
  }
}

// 监听路由变化
watch(() => route.query, (newQuery) => {
  if (newQuery.search !== undefined) {
    searchForm.name = newQuery.search ? decodeURIComponent(newQuery.search) : ''
    currentPage.value = 1
    fetchScenicSpots()
  }
}, { immediate: false })

watch(() => route.params.categoryId, (newCategoryId) => {
  if (newCategoryId !== undefined) {
    searchForm.categoryId = newCategoryId ? parseInt(newCategoryId) : null
    currentPage.value = 1
    fetchScenicSpots()
  }
}, { immediate: false })

onMounted(() => {
  fetchCategories();
  handleUrlParams();
  fetchScenicSpots();
})

const handleSearch = () => {
  currentPage.value = 1
  fetchScenicSpots()
}

const resetSearch = () => {
  searchForm.name = ''
  searchForm.location = ''
  searchForm.categoryId = null // 重置分类ID
  currentPage.value = 1
  fetchScenicSpots()
}

const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchScenicSpots()
}

const handleCategoryChange = (categoryId) => {
  // 如果点击当前已选中的分类，则取消选择
  if (searchForm.categoryId === categoryId) {
    searchForm.categoryId = null
  } else {
    searchForm.categoryId = categoryId
  }
  currentPage.value = 1
  fetchScenicSpots()
}

const goDetail = (id) => {
  router.push(`/scenic/${id}`)
}

// 清除搜索条件的方法
const clearSearchName = () => {
  searchForm.name = ''
  handleSearch()
}

const clearSearchLocation = () => {
  searchForm.location = ''
  handleSearch()
}

const clearSearchCategory = () => {
  searchForm.categoryId = null
  handleSearch()
}

// 获取当前选中分类的名称
const getCurrentCategoryName = () => {
  if (!searchForm.categoryId) return ''
  const category = categoryList.value.find(cat => cat.id === searchForm.categoryId)
  return category ? category.name : ''
}

// 获取图片完整URL
const getImageUrl = (url) => {
  if (!url) return '/default-scenic.jpg'
  return url.startsWith('http') ? url : baseAPI + url
}

// 截取文本
const truncateText = (text, length) => {
  if (!text) return ''
  return text.length > length ? text.substring(0, length) + '...' : text
}

// 格式化评价数量
const formatReviewCount = (count) => {
  if (!count || count === 0) return '暂无评价'
  if (count === 1) return '1条评价'
  return `${count}条评价`
}

// 获取评分显示
const getDisplayRating = (rating) => {
  if (!rating) return '4.5'
  return parseFloat(rating).toFixed(1)
}

// 批量获取评论统计信息
const fetchBatchCommentStats = async () => {
  // 为每个景点获取评论统计
  for (const item of tableData.value) {
    try {
      await request.get('/comment/page', {
        scenicId: item.id,
        currentPage: 1,
        size: 1  // 只需要获取总数
      }, {
        showDefaultMsg: false,
        onSuccess: (res) => {
          // 更新景点的评论数量
          item.reviewCount = res.total || 0
        }
      })
    } catch (error) {
      console.error(`获取景点${item.id}评论统计失败:`, error)
      item.reviewCount = 0
    }
  }
}
</script>

<style lang="scss" scoped>
.scenic-frontend-container {
  min-height: 100vh;
  font-family: "PingFang SC", "Helvetica Neue", Helvetica, Arial, "Microsoft YaHei", sans-serif;
  color: #1a202c;
}

// Hero区域样式
.hero-section {
  position: relative;
  height: 150px;
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
}

.hero-content {
  position: relative;
  z-index: 10;
  width: 100%;
  max-width: 800px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.hero-glass-card {
  border-radius: 30px;
  padding: 0px 60px;
  border: 1px solid rgba(255, 255, 255, 0.4);
  text-align: center;
  width: 100%;
  transition: all 0.4s ease;
  animation: fadeInUp 0.8s ease;
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

.hero-title {
  font-size: 48px;
  font-weight: 800;
  margin: 0 0 16px;
  color: #1a202c;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
  letter-spacing: 1px;
}

.hero-icon {
  width: 48px;
  height: 48px;
  color: #67b6f5;
  flex-shrink: 0;
}

.hero-subtitle {
  font-size: 18px;
  margin: 0;
  color: #5a6c7d;
  font-weight: 400;
  letter-spacing: 0.5px;
}

// 通用容器样式
.section-container {
  max-width: 1300px;
  margin: 0 auto;
  padding: 20px 20px;
}

.search-card {
  padding: 32px;
  margin-bottom: 30px;
}

.glass-card {
  background: rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

.glass-card-scenic {
  background: #fff;
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

.search-header {
  margin-bottom: 24px;
}

.search-title,
.filter-title {
  font-size: 20px;
  font-weight: 700;
  color: #1a202c;
  margin: 0;
  display: flex;
  align-items: center;
  gap: 10px;
}

.title-icon {
  width: 24px;
  height: 24px;
  color: #67b6f5;
  flex-shrink: 0;
}

.search-form {
  .search-inputs {
    display: grid;
    grid-template-columns: 2fr 1fr auto;
    gap: 16px;
    align-items: end;
    margin-bottom: 20px;
  }

  .search-input-group {
    display: flex;
    flex-direction: column;
  }

  .main-search-input {
    :deep(.el-input__wrapper) {
      border-radius: 16px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
      border: 2px solid rgba(103, 182, 245, 0.2);
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      transition: all 0.3s ease;

      &:hover {
        border-color: #67b6f5;
        box-shadow: 0 6px 16px rgba(103, 182, 245, 0.15);
      }

      &.is-focus {
        border-color: #67b6f5;
        box-shadow: 0 6px 20px rgba(103, 182, 245, 0.25);
      }
    }
  }

  :deep(.el-input__wrapper) {
    border-radius: 16px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    border: 2px solid rgba(103, 182, 245, 0.2);
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    transition: all 0.3s ease;

    &:hover {
      border-color: #67b6f5;
    }

    &.is-focus {
      border-color: #67b6f5;
      box-shadow: 0 6px 20px rgba(103, 182, 245, 0.25);
    }
  }

  .search-actions {
    display: flex;
    gap: 12px;
  }

  .search-btn {
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    border: none;
    border-radius: 16px;
    font-weight: 600;
    box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);
    transition: all 0.3s ease;
    color: white;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(103, 182, 245, 0.4);
      background: linear-gradient(135deg, #5aa9e6 0%, #4a99d6 100%);
    }
  }

  .reset-btn {
    border-radius: 16px;
    border: 2px solid rgba(103, 182, 245, 0.3);
    color: #67b6f5;
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    font-weight: 600;

    &:hover {
      border-color: #67b6f5;
      background: rgba(103, 182, 245, 0.1);
      transform: translateY(-2px);
    }
  }
}

.search-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 16px;

  .search-tag {
    border-radius: 20px;
    font-weight: 600;
    padding: 8px 16px;
    border: none;
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);

    &.tag-keyword {
      background: linear-gradient(135deg, #ffa7c4 0%, #ff9ab5 100%);
      color: white;
    }

    &.tag-location {
      background: linear-gradient(135deg, #ffd89b 0%, #ffc17c 100%);
      color: white;
    }

    &.tag-category {
      background: linear-gradient(135deg, #a8edea 0%, #93e4df 100%);
      color: white;
    }
  }
}

// 分类筛选
.category-filter {
  margin-top: 32px;
  padding-top: 32px;
  border-top: 1px solid rgba(103, 182, 245, 0.2);
}

.category-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  margin-top: 16px;
}

.category-chip {
  padding: 10px 20px;
  border-radius: 24px;
  border: 2px solid rgba(103, 182, 245, 0.3);
  background: #fff;
  cursor: pointer;
  transition: all 0.3s ease;
  font-size: 14px;
  font-weight: 600;
  color: #5a6c7d;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);

  &:hover {
    border-color: #67b6f5;
    color: #67b6f5;
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(103, 182, 245, 0.2);
  }

  &.active {
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    border-color: transparent;
    color: white;
    box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);
  }

  .chip-count {
    margin-left: 6px;
    opacity: 0.8;
  }
}

// 景点列表区域
.scenic-list-section {
  padding: 20px 0 60px;
}

// 景点网格布局
.scenic-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
  margin-bottom: 40px;
}

.scenic-card {
  border-radius: 20px;
  overflow: hidden;
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  opacity: 1;
  transform: translateY(0);
  animation: fadeInUp 0.6s ease both;

  @for $i from 1 through 12 {
    &.delay-#{$i * 100} {
      animation-delay: #{$i * 0.1}s;
    }
  }

  &:hover {
    transform: translateY(-12px);
    box-shadow: 0 20px 50px rgba(103, 182, 245, 0.25);

    .card-image-wrapper img {
      transform: scale(1.15);
    }

    .image-gradient-overlay {
      opacity: 0.6;
    }
  }
}

.card-image-wrapper {
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

  &.badge-category {
    background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
    color: #1a202c;
  }

  &.badge-free {
    background: linear-gradient(135deg, #52c787, #4ecdc4);
    color: white;
  }

  &.badge-price {
    background: linear-gradient(135deg, #ffd89b, #ffa7c4);
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
  margin-bottom: 16px;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.card-meta {
  font-size: 13px;
  color: #94a3b8;
  font-weight: 500;

  .review-count {
    color: #718096;
  }
}

// 空状态
.empty-state {
  text-align: center;
  padding: 80px 20px;

  .empty-icon {
    width: 80px;
    height: 80px;
    margin: 0 auto 24px;
    color: #cbd5e0;
  }

  .empty-title {
    font-size: 24px;
    font-weight: 600;
    color: #2d3748;
    margin: 0 0 12px;
  }

  .empty-desc {
    font-size: 16px;
    color: #718096;
    margin: 0 0 32px;
  }

  .empty-action {
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    border: none;
    border-radius: 24px;
    padding: 12px 32px;
    font-weight: 600;
    box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(103, 182, 245, 0.4);
    }
  }
}

// 分页样式
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 40px;
}

.modern-pagination {
  :deep(.el-pagination) {
    .el-pager li {
      border-radius: 12px;
      margin: 0 6px;
      transition: all 0.3s ease;
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      border: 2px solid transparent;

      &:hover {
        background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
        color: white;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(103, 182, 245, 0.3);
      }

      &.is-active {
        background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
        color: white;
        border-color: transparent;
        box-shadow: 0 4px 12px rgba(103, 182, 245, 0.3);
      }
    }

    .btn-prev,
    .btn-next {
      border-radius: 12px;
      transition: all 0.3s ease;
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);

      &:hover {
        background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
        color: white;
        transform: translateY(-2px);
      }
    }
  }
}

// 响应式样式
@media (max-width: 992px) {
  .scenic-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  }

  .section-container {
    padding: 20px 16px;
  }
}

@media (max-width: 768px) {
  .hero-section {
    height: 320px;
  }

  .hero-glass-card {
    padding: 40px 30px;
  }

  .hero-title {
    font-size: 32px;
  }

  .hero-subtitle {
    font-size: 16px;
  }

  .search-form .search-inputs {
    grid-template-columns: 1fr;
    gap: 12px;
  }

  .category-grid {
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 16px;
  }

  .scenic-grid {
    grid-template-columns: 1fr;
  }
}
</style>