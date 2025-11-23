<!-- eslint-disable -->
<template>
  <div class="my-guide-container">
    <!-- Hero头部区域 -->
    <div class="page-hero">
      <div class="hero-background">
        <div class="hero-gradient"></div>
      </div>
      <div class="hero-content">
        <div class="hero-icon-wrapper">
          <svg class="hero-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path>
            <path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path>
          </svg>
        </div>
        <h1 class="hero-title">我的攻略</h1>
        <p class="hero-subtitle">管理您已发布的旅游攻略内容，分享您的旅行经验</p>
      </div>
    </div>

    <!-- 主内容区域 -->
    <div class="main-content">
      <div class="content-container">
        <!-- 操作栏 -->
        <div class="action-bar glass-card">
          <div class="action-left">
            <h3 class="section-title">
              <svg class="title-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
              </svg>
              攻略管理
            </h3>
          </div>
          <div class="action-right">
            <el-button type="primary" @click="goEdit" :icon="Edit" class="publish-btn" size="large">
              发布新攻略
            </el-button>
          </div>
        </div>
        <!-- 加载状态 -->
        <div v-if="loading" class="loading-state">
          <el-skeleton :rows="8" animated />
        </div>

        <!-- 空状态 -->
        <div v-else-if="tableData.length === 0" class="empty-state">
          <svg class="empty-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
            <line x1="16" y1="13" x2="8" y2="13"></line>
            <line x1="16" y1="17" x2="8" y2="17"></line>
          </svg>
          <h3 class="empty-title">您还没有发布任何攻略</h3>
          <p class="empty-desc">分享您的旅行经验，帮助更多人发现美好</p>
          <el-button type="primary" @click="goEdit" class="empty-action">
            <el-icon>
              <Edit />
            </el-icon>
            立即发布
          </el-button>
        </div>

        <!-- 攻略网格 -->
        <div v-else class="guide-grid">
          <div v-for="(guide, index) in tableData" :key="guide.id" class="guide-card"
            :class="`delay-${(index % 6 + 1) * 100}`" @click="viewGuide(guide)">
            <div class="card-image">
              <img :src="getImageUrl(guide.coverImage)" :alt="guide.title" />
              <div class="image-overlay">
                <div class="overlay-content">
                  <div class="guide-views">
                    <el-icon>
                      <View />
                    </el-icon>
                    {{ guide.views || 0 }}
                  </div>
                </div>
              </div>
              <div class="card-badges">
                <span v-if="isNew(guide.createTime)" class="badge new">最新</span>
              </div>
            </div>

            <div class="card-content">
              <h3 class="guide-title">{{ guide.title }}</h3>

              <div class="guide-meta">
                <div class="meta-item">
                  <el-icon>
                    <View />
                  </el-icon>
                  <span>{{ guide.views || 0 }} 浏览</span>
                </div>
                <div class="meta-item">
                  <el-icon>
                    <Calendar />
                  </el-icon>
                  <span>{{ formatDate(guide.createTime) }}</span>
                </div>
              </div>

              <div class="card-footer">
                <div class="card-actions">
                  <el-button type="primary" round @click.stop="viewGuide(guide)" class="action-btn view-btn">
                    <el-icon>
                      <View />
                    </el-icon>
                  </el-button>
                  <el-button round @click.stop="goEdit(guide)" class="action-btn edit-btn">
                    <el-icon>
                      <Edit />
                    </el-icon>
                  </el-button>
                  <el-button type="danger" round @click.stop="deleteGuide(guide)" class="action-btn delete-btn">
                    <el-icon>
                      <Delete />
                    </el-icon>
                  </el-button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 现代化分页 -->
        <div class="pagination-wrapper" v-if="total > 0">
          <el-pagination background layout="total, prev, pager, next" :total="total" :page-size="pageSize"
            :current-page="currentPage" @current-change="handleCurrentChange" class="modern-pagination" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessageBox } from 'element-plus'
import request from '@/utils/request'
import { formatDate } from '@/utils/dateUtils'
import { useUserStore } from '@/store/user'
import { Edit, View, Calendar, Delete, EditPen } from '@element-plus/icons-vue'

const baseAPI = process.env.VUE_APP_BASE_API || '/api'
const router = useRouter()
const userStore = useUserStore()
const tableData = ref([])
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)

// 计算总浏览量
const totalViews = computed(() => {
  return tableData.value.reduce((sum, guide) => sum + (guide.views || 0), 0)
})

// 计算本月新增攻略数量
const newGuideCount = computed(() => {
  const now = new Date()
  const currentMonth = now.getMonth()
  const currentYear = now.getFullYear()

  return tableData.value.filter(guide => {
    if (!guide.createTime) return false
    const createDate = new Date(guide.createTime)
    return createDate.getMonth() === currentMonth && createDate.getFullYear() === currentYear
  }).length
})

// 获取图片完整URL
const getImageUrl = (url) => {
  if (!url) return '/default-guide-cover.jpg'
  return url.startsWith('http') ? url : baseAPI + url
}

// 判断是否是新发布的攻略（7天内）
const isNew = (dateString) => {
  if (!dateString) return false
  const publishDate = new Date(dateString)
  const now = new Date()
  const diffTime = now - publishDate
  const diffDays = diffTime / (1000 * 60 * 60 * 24)
  return diffDays < 7
}

const fetchGuides = async () => {
  loading.value = true
  try {
    await request.get('/guide/page', {
      userId: userStore.userInfo?.id,
      currentPage: currentPage.value,
      size: pageSize.value
    }, {
      showDefaultMsg: false,
      onSuccess: (res) => {
        tableData.value = res.records || []
        total.value = res.total || 0
      }
    })
  } catch (error) {
    console.error('获取我的攻略列表失败', error)
  } finally {
    loading.value = false
  }
}

onMounted(fetchGuides)

const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchGuides()
}

const handleSizeChange = (size) => {
  pageSize.value = size
  currentPage.value = 1
  fetchGuides()
}

const handleRowClick = (row) => {
  viewGuide(row)
}

const viewGuide = (row) => {
  router.push(`/guide/detail/${row.id}`)
}

const goEdit = (row) => {
  if (row) {
    router.push({ name: 'GuideEdit', query: { id: row.id } })
  } else {
    router.push({ name: 'GuideEdit' })
  }
}

const deleteGuide = (row) => {
  ElMessageBox.confirm('确定要删除该攻略吗？删除后无法恢复！', '删除确认', {
    confirmButtonText: '确定删除',
    cancelButtonText: '取消',
    type: 'warning',
    closeOnClickModal: false
  }).then(async () => {
    try {
      await request.delete(`/guide/delete/${row.id}`, {
        successMsg: '删除成功',
        onSuccess: () => fetchGuides()
      })
    } catch (error) {
      console.error('删除攻略失败', error)
    }
  }).catch(() => { })
}
</script>

<style lang="scss" scoped>
.my-guide-container {
  min-height: 100vh;
  font-family: "PingFang SC", "Helvetica Neue", Helvetica, Arial, "Microsoft YaHei", sans-serif;
  color: #1a202c;
}

// Hero头部区域
.page-hero {
  position: relative;
  height: 240px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: -80px;
}

.hero-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
}

.hero-gradient {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.hero-content {
  position: relative;
  z-index: 10;
  text-align: center;
  padding: 0 20px;
}

.hero-icon-wrapper {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
}

.hero-icon {
  width: 72px;
  height: 72px;
  color: #67b6f5;
  filter: drop-shadow(0 4px 12px rgba(103, 182, 245, 0.3));
}

.hero-title {
  font-size: 42px;
  font-weight: 800;
  margin: 0 0 16px;
  color: #1a202c;
  letter-spacing: 2px;
}

.hero-subtitle {
  font-size: 18px;
  margin: 0;
  color: #5a6c7d;
  font-weight: 400;
}

// 主内容区域
.main-content {
  position: relative;
  z-index: 10;
  padding: 60px 0 80px;
}

.content-container {
  max-width: 1300px;
  margin: 0 auto;
  padding: 0 20px;
}

// 玻璃态卡片
.glass-card {
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  position: relative;
  z-index: 10;

  &:hover {
    box-shadow: 0 12px 40px rgba(103, 182, 245, 0.15);
  }
}

// 操作栏
.action-bar {
  padding: 32px;
  margin-top: 20px;
  margin-bottom: 40px;
  display: flex;
  justify-content: space-between;
  align-items: center;

  .action-left {
    .section-title {
      font-size: 24px;
      font-weight: 700;
      color: #1a202c;
      margin: 0;
      display: flex;
      align-items: center;
      gap: 12px;

      .title-icon {
        width: 28px;
        height: 28px;
        color: #67b6f5;
      }
    }
  }

  .publish-btn {
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    border: none;
    border-radius: 25px;
    font-weight: 600;
    padding: 12px 32px;
    box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);
    transition: all 0.3s ease;
    cursor: pointer;
    position: relative;
    z-index: 100;

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(103, 182, 245, 0.4);
      background: linear-gradient(135deg, #5aa9e6 0%, #4a99d6 100%);
    }

    &:active {
      transform: translateY(0);
    }
  }
}

// 加载状态
.loading-state {
  padding: 60px 20px;
}

// 空状态
.empty-state {
  text-align: center;
  padding: 100px 20px;

  .empty-icon {
    width: 96px;
    height: 96px;
    color: #67b6f5;
    margin: 0 auto 24px;
    filter: drop-shadow(0 4px 12px rgba(103, 182, 245, 0.2));
  }

  .empty-title {
    font-size: 28px;
    font-weight: 700;
    color: #1a202c;
    margin: 0 0 12px;
  }

  .empty-desc {
    font-size: 16px;
    color: #5a6c7d;
    margin: 0 0 32px;
  }

  .empty-action {
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    border: none;
    border-radius: 25px;
    padding: 14px 32px;
    font-weight: 600;
    font-size: 16px;
    box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(103, 182, 245, 0.4);
    }
  }
}

// 攻略网格布局
.guide-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 24px;
  margin-bottom: 40px;
}

.guide-card {
  border-radius: 20px;
  overflow: hidden;
  background: #fff;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  position: relative;
  height: 100%;
  display: flex;
  flex-direction: column;
  animation: fadeInUp 0.6s ease-out forwards;
  opacity: 0;

  @for $i from 1 through 6 {
    &.delay-#{$i * 100} {
      animation-delay: #{$i * 0.1}s;
    }
  }

  &:hover {
    transform: translateY(-12px);
    box-shadow: 0 16px 48px rgba(103, 182, 245, 0.2);

    .card-image img {
      transform: scale(1.15);
    }

    .image-overlay {
      opacity: 1;
    }
  }
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }

  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.card-image {
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

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: linear-gradient(to bottom,
      rgba(103, 182, 245, 0.1) 0%,
      rgba(103, 182, 245, 0.8) 100%);
  opacity: 0;
  transition: opacity 0.3s ease;
  display: flex;
  align-items: flex-end;
  padding: 24px;
}

.overlay-content {
  color: white;

  .guide-views {
    display: flex;
    align-items: center;
    font-size: 15px;
    font-weight: 600;
    gap: 6px;
    background: rgba(255, 255, 255, 0.2);
    padding: 8px 16px;
    border-radius: 20px;
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);

    .el-icon {
      color: #ffc17c;
    }
  }
}

.card-badges {
  position: absolute;
  top: 16px;
  right: 16px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  z-index: 10;
}

.badge {
  padding: 6px 12px;
  border-radius: 16px;
  font-size: 12px;
  font-weight: 700;
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);

  &.new {
    background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
    color: white;
  }

  &.guide {
    background: linear-gradient(135deg, #ffc17c 0%, #f59e0b 100%);
    color: white;
  }
}

.card-content {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: column;
}

.guide-title {
  margin: 0 0 16px;
  font-size: 20px;
  font-weight: 700;
  color: #1a202c;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  line-height: 1.4;
  transition: color 0.3s ease;

  &:hover {
    color: #67b6f5;
  }
}

.guide-meta {
  display: flex;
  justify-content: space-between;
  margin-bottom: 16px;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(103, 182, 245, 0.1);

  .meta-item {
    display: flex;
    align-items: center;
    font-size: 13px;
    color: #5a6c7d;
    gap: 6px;

    .el-icon {
      color: #67b6f5;
      font-size: 16px;
    }
  }
}

.card-footer {
  margin-top: auto;

  .card-actions {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 8px;

    .action-btn {
      flex: 1;
      min-width: 0;
      height: 44px;
      width: 44px;
      padding: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      border: none;
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

      .el-icon {
        font-size: 20px;
      }

      &:hover {
        transform: translateY(-4px) scale(1.05);
      }

      &:active {
        transform: translateY(-2px) scale(1.02);
      }
    }

    .view-btn {
      background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
      box-shadow: 0 4px 12px rgba(103, 182, 245, 0.3);

      &:hover {
        box-shadow: 0 8px 20px rgba(103, 182, 245, 0.4);
        background: linear-gradient(135deg, #5aa9e6 0%, #4a99d6 100%);
      }
    }

    .edit-btn {
      background: linear-gradient(135deg, #ffc17c 0%, #f59e0b 100%);
      box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);

      &:hover {
        background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        box-shadow: 0 8px 20px rgba(245, 158, 11, 0.4);
      }
    }

    .delete-btn {
      background: linear-gradient(135deg, #f56565 0%, #e53e3e 100%);
      box-shadow: 0 4px 12px rgba(245, 101, 101, 0.3);

      &:hover {
        background: linear-gradient(135deg, #e53e3e 0%, #c53030 100%);
        box-shadow: 0 8px 20px rgba(245, 101, 101, 0.4);
      }
    }
  }
}

// 分页样式
.pagination-wrapper {
  display: flex;
  justify-content: center;
  margin-top: 60px;
  padding-top: 40px;
  border-top: 2px solid rgba(103, 182, 245, 0.1);
}

.modern-pagination {
  :deep(.el-pagination) {
    .el-pager li {
      border-radius: 12px;
      margin: 0 6px;
      transition: all 0.3s ease;
      font-weight: 600;
      border: 2px solid transparent;

      &:hover {
        background: linear-gradient(135deg, rgba(103, 182, 245, 0.1) 0%, rgba(90, 169, 230, 0.1) 100%);
        border-color: #67b6f5;
        color: #67b6f5;
        transform: translateY(-2px);
      }

      &.is-active {
        background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
        color: white;
        box-shadow: 0 4px 12px rgba(103, 182, 245, 0.3);
        border-color: transparent;
      }
    }

    .btn-prev,
    .btn-next {
      border-radius: 12px;
      transition: all 0.3s ease;
      font-weight: 600;
      border: 2px solid rgba(103, 182, 245, 0.2);

      &:hover {
        background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
        color: white;
        border-color: transparent;
        transform: translateY(-2px);
      }
    }
  }
}

// 响应式设计
@media (max-width: 1200px) {
  .guide-grid {
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  }
}

@media (max-width: 768px) {
  .page-hero {
    height: 180px;
    margin-bottom: -60px;
  }

  .hero-icon {
    width: 56px;
    height: 56px;
  }

  .hero-title {
    font-size: 32px;
  }

  .hero-subtitle {
    font-size: 16px;
  }

  .main-content {
    padding: 40px 0 60px;
  }

  .action-bar {
    flex-direction: column;
    gap: 20px;
    padding: 24px;

    .action-left,
    .action-right {
      width: 100%;
    }

    .publish-btn {
      width: 100%;
    }
  }

  .guide-grid {
    grid-template-columns: 1fr;
    gap: 20px;
  }

  .card-image {
    height: 200px;
  }
}

@media (max-width: 480px) {
  .hero-title {
    font-size: 28px;
  }

  .action-bar .section-title {
    font-size: 20px;
  }

  .card-content {
    padding: 20px;
  }

  .guide-title {
    font-size: 18px;
  }
}
</style>