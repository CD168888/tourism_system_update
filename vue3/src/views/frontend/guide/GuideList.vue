<!-- eslint-disable -->
<template>
  <div class="guide-list-container">
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
              <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
              <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
            </svg>
            探索旅游攻略
          </h1>
          <p class="hero-subtitle">分享精彩旅游体验和实用建议</p>
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
                <el-input v-model="searchForm.title" placeholder="搜索攻略标题或内容..." clearable size="large"
                  class="main-search-input" @keyup.enter="handleSearch">
                  <template #prefix>
                    <el-icon>
                      <Search />
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
                    <RefreshLeft />
                  </el-icon>
                  重置
                </el-button>
                <el-button type="primary" @click="goEdit" class="publish-btn" size="large">
                  <el-icon>
                    <Edit />
                  </el-icon>
                  发布攻略
                </el-button>
              </div>
            </div>

            <!-- 搜索结果提示 -->
            <div v-if="searchForm.title" class="search-tags">
              <el-tag v-if="searchForm.title" closable @close="clearSearchTitle" class="search-tag tag-keyword">
                关键词: {{ searchForm.title }}
              </el-tag>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 攻略列表区域 -->
    <div class="guide-list-section">
      <div class="section-container">
        <div class="guides-container" v-loading="loading">
          <div class="empty-state" v-if="tableData.length === 0 && !loading">
            <svg class="empty-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
              <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
            </svg>
            <h3 class="empty-title">暂无攻略内容</h3>
            <p class="empty-desc">成为第一个分享旅游攻略的人吧！</p>
            <el-button type="primary" @click="goEdit" class="empty-action">
              <el-icon>
                <Edit />
              </el-icon>
              发布攻略
            </el-button>
          </div>

          <div class="guides-grid" v-if="tableData.length > 0">
            <div v-for="(item, index) in tableData" :key="item.id" class="guide-card glass-card-guide"
              :class="`delay-${(index % 6 + 1) * 100}`" @click="goDetail(item.id)">
              <div class="card-image-wrapper">
                <img :src="getImageUrl(item.coverImage)" :alt="item.title" v-if="item.coverImage" />
                <div class="default-cover" v-else>
                  <svg class="cover-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
                    <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
                  </svg>
                  <div class="cover-text">旅游攻略</div>
                </div>
                <div class="image-gradient-overlay"></div>
                <div class="card-badges">
                  <div class="badge badge-views">
                    <el-icon>
                      <View />
                    </el-icon>
                    {{ formatNumber(item.views) }}
                  </div>
                </div>
              </div>

              <div class="card-content">
                <h3 class="guide-title">{{ item.title }}</h3>
                <div class="card-footer">
                  <div class="author-info">
                    <el-avatar :src="getImageUrl(item.userAvatar)" :size="32" class="author-avatar">
                      <el-icon>
                        <User />
                      </el-icon>
                    </el-avatar>
                    <span class="nickname">{{ item.userNickname || '旅行者' + item.userId }}</span>
                  </div>
                  <div class="publish-time">
                    <el-icon>
                      <Calendar />
                    </el-icon>
                    <span>{{ formatDate(item.createTime) }}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>
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
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'
import { formatDate } from '@/utils/dateUtils'
import {
  Search, View, Calendar, Edit, User, Reading, RefreshLeft
} from '@element-plus/icons-vue'

const baseAPI = process.env.VUE_APP_BASE_API || '/api'
const router = useRouter()
const tableData = ref([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(12) // 改为12，每行4个，3行
const total = ref(0)
const totalViews = ref(0)
const searchForm = reactive({
  title: ''
})

// 获取图片完整URL
const getImageUrl = (url) => {
  if (!url) return ''
  return url.startsWith('http') ? url : baseAPI + url
}

// 格式化数字
const formatNumber = (num) => {
  if (!num) return '0'
  if (num >= 10000) {
    return (num / 10000).toFixed(1) + 'w'
  } else if (num >= 1000) {
    return (num / 1000).toFixed(1) + 'k'
  }
  return num.toString()
}

const fetchGuides = async () => {
  loading.value = true
  try {
    await request.get('/guide/page', {
      title: searchForm.title || undefined,
      currentPage: currentPage.value,
      size: pageSize.value
    }, {
      showDefaultMsg: false,
      onSuccess: (res) => {
        tableData.value = res.records || []
        total.value = res.total || 0

        // 计算总阅读量
        totalViews.value = tableData.value.reduce((sum, item) => sum + (item.views || 0), 0)
      }
    })
  } catch (error) {
    console.error('获取攻略列表失败', error)
  } finally {
    loading.value = false
  }
}

// 清除搜索标题
const clearSearchTitle = () => {
  searchForm.title = ''
  handleSearch()
}

onMounted(fetchGuides)

const handleSearch = () => {
  currentPage.value = 1
  fetchGuides()
}

const resetSearch = () => {
  searchForm.title = ''
  currentPage.value = 1
  fetchGuides()
}

const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchGuides()
}

const goDetail = (id) => {
  router.push(`/guide/detail/${id}`)
}

const goEdit = () => {
  router.push('/guide/edit')
}
</script>

<style lang="scss" scoped>
.guide-list-container {
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

.glass-card-guide {
  background: #fff;
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
}

.search-header {
  margin-bottom: 24px;
}

.search-title {
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
    grid-template-columns: 2fr auto;
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

  .publish-btn {
    background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
    border: none;
    border-radius: 16px;
    font-weight: 600;
    box-shadow: 0 6px 20px rgba(72, 187, 120, 0.3);
    transition: all 0.3s ease;
    color: white;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(72, 187, 120, 0.4);
      background: linear-gradient(135deg, #38a169 0%, #2f855a 100%);
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
  }
}

// 攻略列表区域
.guide-list-section {
  padding: 20px 0 60px;
}

.guides-container {
  min-height: 400px;
}

.guides-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
  margin-bottom: 40px;
}

// 空状态样式
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

// 攻略卡片样式
.guide-card {
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

    .default-cover {
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
      color: white;

      .cover-icon {
        width: 60px;
        height: 60px;
        margin-bottom: 12px;
        opacity: 0.9;
      }

      .cover-text {
        font-size: 16px;
        font-weight: 600;
        opacity: 0.9;
      }
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
    right: 16px;
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
    display: flex;
    align-items: center;
    gap: 6px;

    &.badge-views {
      background: rgba(255, 255, 255, 0.95);
      color: #1a202c;

      .el-icon {
        color: #67b6f5;
        font-size: 14px;
      }
    }
  }

  .card-content {
    padding: 24px;

    .guide-title {
      margin: 0 0 16px;
      font-size: 20px;
      font-weight: 700;
      color: #1a202c;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      line-height: 1.4;
      min-height: 56px;
    }

    .card-footer {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .author-info {
        display: flex;
        align-items: center;
        flex: 1;

        .author-avatar {
          border: 2px solid #e2e8f0;
          transition: all 0.3s ease;
          margin-right: 10px;
        }

        .nickname {
          font-size: 14px;
          font-weight: 600;
          color: #4a5568;
          max-width: 100px;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
        }
      }

      .publish-time {
        font-size: 12px;
        color: #64748b;
        display: flex;
        align-items: center;
        gap: 4px;
        font-weight: 500;

        .el-icon {
          font-size: 12px;
        }
      }
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
  .guides-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  }

  .section-container {
    padding: 20px 16px;
  }
}

@media (max-width: 768px) {
  .hero-section {
    height: 120px;
  }

  .hero-glass-card {
    padding: 0px 30px;
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

  .guides-grid {
    grid-template-columns: 1fr;
  }
}
</style>