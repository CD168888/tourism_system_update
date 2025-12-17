<template>
  <div class="accommodation-frontend-container">
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
              <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
              <polyline points="9 22 9 12 15 12 15 22"></polyline>
            </svg>
            精选住宿推荐
          </h1>
          <p class="hero-subtitle">发现舒适便捷的住宿选择，让您的旅程更加完美</p>
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
                <el-input v-model="searchForm.name" placeholder="搜索住宿名称或地址..." clearable size="large"
                  class="main-search-input" @keyup.enter="handleSearch">
                  <template #prefix>
                    <el-icon>
                      <Search />
                    </el-icon>
                  </template>
                </el-input>
              </div>
              <div class="search-input-group">
                <el-select v-model="filters.scenicId" placeholder="选择景点" clearable size="large" style="width: 100%">
                  <el-option v-for="item in scenicOptions" :key="item.id" :label="item.name" :value="item.id" />
                </el-select>
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

            <!-- 高级筛选 -->
            <div class="advanced-filters">
              <h3 class="filter-title">
                <svg class="title-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                  stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                  <polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"></polygon>
                </svg>
                高级筛选
              </h3>
              <div class="filter-row">
                <div class="filter-group">
                  <label class="filter-label">住宿类型</label>
                  <el-select v-model="filters.type" placeholder="选择类型" clearable>
                    <el-option v-for="item in typeOptions" :key="item" :label="item" :value="item" />
                  </el-select>
                </div>
                <div class="filter-group">
                  <label class="filter-label">价格区间</label>
                  <div class="price-range">
                    <el-input v-model="filters.minPrice" placeholder="最低价" />
                    <span class="price-separator">-</span>
                    <el-input v-model="filters.maxPrice" placeholder="最高价" />
                  </div>
                </div>
                <div class="filter-group">
                  <label class="filter-label">最低评分</label>
                  <el-rate v-model="filters.minRating" :max="5" :colors="colors" show-score />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 住宿列表区域 -->
    <div class="accommodation-list-section">
      <div class="section-container">
        <div v-if="loading" class="loading-state">
          <el-skeleton :rows="8" animated />
        </div>

        <div v-else-if="accommodationList && accommodationList.length > 0" class="accommodation-grid">
          <div v-for="(item, index) in accommodationList" :key="item.id"
            class="accommodation-card glass-card-accommodation" :class="`delay-${(index % 6 + 1) * 100}`"
            @click="goToDetail(item.id)">
            <div class="card-image-wrapper">
              <img :src="getImageUrl(item.imageUrl)" :alt="item.name" />
              <div class="image-gradient-overlay"></div>
              <div class="card-badges">
                <span v-if="item.type" class="badge badge-type">{{ item.type }}</span>
                <span v-if="item.priceRange" class="badge badge-price">{{ item.priceRange }}</span>
              </div>
              <div class="rating-badge">
                <el-icon>
                  <Star />
                </el-icon>
                <span>{{ item.starLevel || '4.5' }}</span>
              </div>
            </div>
            <div class="card-content">
              <h3 class="accommodation-name">{{ item.name }}</h3>
              <div class="accommodation-location">
                <el-icon>
                  <Location />
                </el-icon>
                {{ item.address || '地址待更新' }}
              </div>
              <div v-if="item.scenicName" class="accommodation-scenic">
                <el-icon>
                  <MapLocation />
                </el-icon>
                靠近 {{ item.scenicName }}
                <span v-if="item.distance" class="distance">{{ item.distance }}</span>
              </div>
              <p class="accommodation-desc">{{ truncateText(item.features || '舒适便捷的住宿环境，为您提供优质的服务体验', 80) }}</p>
              <div class="card-footer">
                <div class="card-meta">
                  <div class="meta-stats">
                    <span class="rating-info">
                      <el-icon>
                        <Star />
                      </el-icon>
                      {{ getDisplayRating(item.starLevel) }}
                    </span>
                    <span class="price-info">{{ item.priceRange || '价格面议' }}</span>
                  </div>
                </div>
                <el-button type="primary" size="small" class="detail-btn" @click.stop="goToDetail(item.id)">
                  查看详情
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <div v-else class="empty-state">
          <svg class="empty-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
            <polyline points="9 22 9 12 15 12 15 22"></polyline>
          </svg>
          <h3 class="empty-title">暂无住宿信息</h3>
          <p class="empty-desc">试试调整搜索条件或浏览其他选项</p>
          <el-button type="primary" @click="resetSearch" class="empty-action">
            重新搜索
          </el-button>
        </div>

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="total > 0">
          <el-pagination background layout="total, prev, pager, next, jumper" :current-page="currentPage"
            :page-size="pageSize" :total="total" @current-change="handleCurrentChange" @size-change="handleSizeChange"
            class="modern-pagination" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'
import { Location, Star, Search, Refresh, MapLocation } from '@element-plus/icons-vue'

const router = useRouter()
const baseAPI = process.env.VUE_APP_BASE_API || '/api'

// 数据状态
const loading = ref(false)
const accommodationList = ref([])
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)
const scenicOptions = ref([])
const typeOptions = ref([])

// 搜索表单
const searchForm = reactive({
  name: ''
})

// 筛选条件
const filters = reactive({
  scenicId: '',
  type: '',
  minPrice: '',
  maxPrice: '',
  minRating: 0
})

// 评分颜色
const colors = ['#99A9BF', '#F7BA2A', '#FF9900']

// 获取住宿列表
const fetchAccommodations = async () => {
  loading.value = true
  try {
    // 构建查询参数
    const params = {
      currentPage: currentPage.value,
      size: pageSize.value
    }

    // 添加搜索条件
    if (searchForm.name) params.name = searchForm.name

    // 添加筛选条件
    if (filters.scenicId) params.scenicId = filters.scenicId
    if (filters.type) params.type = filters.type
    if (filters.minPrice) params.minPrice = filters.minPrice
    if (filters.maxPrice) params.maxPrice = filters.maxPrice
    if (filters.minRating > 0) params.minRating = filters.minRating

    // 发送请求
    await request.get('/accommodation/page', params, {
      onSuccess: (res) => {
        accommodationList.value = res.records || []
        total.value = res.total || 0
      }
    })
  } catch (error) {
    console.error('获取住宿列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取景点列表（用于筛选）
const fetchScenicOptions = async () => {
  try {
    await request.get('/scenic/all', {}, {
      onSuccess: (res) => {
        scenicOptions.value = res || []
      }
    })
  } catch (error) {
    console.error('获取景点列表失败:', error)
  }
}

// 获取住宿类型列表（用于筛选）
const fetchAccommodationTypes = async () => {
  try {
    await request.get('/accommodation/types', {}, {
      onSuccess: (res) => {
        typeOptions.value = res || []
      }
    })
  } catch (error) {
    console.error('获取住宿类型列表失败:', error)
  }
}

// 处理图片URL
const getImageUrl = (url) => {
  if (!url) return require('@/assets/images/no-image.png')
  if (url.startsWith('http')) return url
  return baseAPI + url
}

// 搜索处理
const handleSearch = () => {
  currentPage.value = 1
  fetchAccommodations()
}

// 重置搜索和筛选条件
const resetSearch = () => {
  searchForm.name = ''
  filters.scenicId = ''
  filters.type = ''
  filters.minPrice = ''
  filters.maxPrice = ''
  filters.minRating = 0
  currentPage.value = 1
  fetchAccommodations()
}

// 分页处理
const handleSizeChange = (size) => {
  pageSize.value = size
  fetchAccommodations()
}

const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchAccommodations()
}

// 跳转到详情页
const goToDetail = (id) => {
  router.push(`/accommodation/${id}`)
}

// 截取文本
const truncateText = (text, length) => {
  if (!text) return ''
  return text.length > length ? text.substring(0, length) + '...' : text
}

// 获取评分显示
const getDisplayRating = (rating) => {
  if (!rating) return '4.5'
  return parseFloat(rating).toFixed(1)
}

// 初始加载
onMounted(() => {
  fetchScenicOptions()
  fetchAccommodationTypes()
  fetchAccommodations()
})
</script>

<style lang="scss" scoped>
.accommodation-frontend-container {
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

.glass-card-accommodation {
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
    grid-template-columns: 1fr 200px auto;
    gap: 16px;
    align-items: end;
    margin-bottom: 24px;
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

// 高级筛选
.advanced-filters {
  margin-top: 32px;
  padding-top: 32px;
  border-top: 1px solid rgba(103, 182, 245, 0.2);
}

.filter-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 20px;
}

.filter-group {
  .filter-label {
    display: block;
    font-size: 14px;
    font-weight: 600;
    color: #374151;
    margin-bottom: 8px;
  }

  .price-range {
    display: flex;
    align-items: center;
    gap: 8px;

    .price-separator {
      color: #9ca3af;
      font-weight: 500;
    }
  }
}

// 住宿列表区域
.accommodation-list-section {
  padding: 20px 0 60px;
}

.loading-state {
  background: white;
  border-radius: 16px;
  padding: 40px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
}

// 住宿网格
.accommodation-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
  margin-bottom: 40px;
}

.accommodation-card {
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
  height: 200px;
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

  &.badge-type {
    background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
    color: #1a202c;
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
  padding: 20px;
}

.accommodation-name {
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

.accommodation-location {
  display: flex;
  align-items: center;
  font-size: 14px;
  color: #5a6c7d;
  margin-bottom: 8px;
  font-weight: 500;

  .el-icon {
    margin-right: 6px;
    color: #67b6f5;
  }
}

.accommodation-scenic {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #5a6c7d;
  margin-bottom: 8px;
  font-weight: 500;

  .el-icon {
    color: #67b6f5;
    font-size: 16px;
  }

  .distance {
    color: #10b981;
    font-weight: 600;
  }
}

.accommodation-desc {
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
  margin-top: 16px;
  padding-top: 16px;
  border-top: 1px solid #f1f5f9;
}

.card-meta {
  flex: 1;
  font-size: 13px;
  color: #94a3b8;
  font-weight: 500;

  .review-count {
    color: #718096;
  }
}

.meta-stats {
  display: flex;
  align-items: center;
  gap: 12px;
}

.rating-info {
  display: flex;
  align-items: center;
  gap: 4px;
  font-size: 14px;
  font-weight: 600;
  color: #1a202c;

  .el-icon {
    color: #ffd700;
    font-size: 16px;
  }
}

.price-info {
  font-size: 14px;
  font-weight: 600;
  color: #ef4444;
}

.detail-btn {
  border-radius: 20px;
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.3s ease;
  border: none;
  background: #f1f5f9;
  color: #67b6f5;

  &:hover {
    color: white;
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    transform: translateY(-2px);
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

// 分页
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

// 响应式设计
@media (max-width: 992px) {
  .accommodation-grid {
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

  .accommodation-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 480px) {
  .section-container {
    padding: 20px 12px;
  }

  .hero-title {
    font-size: 24px;
  }

  .search-card {
    padding: 20px 16px;
  }

  .card-image-wrapper {
    height: 160px;
  }

  .card-content {
    padding: 12px;
  }

  .card-footer {
    flex-direction: column;
    align-items: stretch;
    gap: 12px;

    .detail-btn {
      width: 100%;
      justify-content: center;
    }
  }
}
</style>