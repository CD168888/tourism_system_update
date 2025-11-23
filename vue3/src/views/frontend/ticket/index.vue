<template>
  <div class="ticket-list-container">
    <!-- Hero顶部区域 - 参考景点列表 -->
    <div class="hero-section">
      <div class="hero-background">
        <div class="hero-gradient"></div>
      </div>
      <div class="hero-content">
        <div class="hero-glass-card">
          <h1 class="hero-title">
            <svg class="hero-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
              stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <rect x="2" y="5" width="20" height="14" rx="2"></rect>
              <line x1="2" y1="10" x2="22" y2="10"></line>
            </svg>
            精选门票预订
          </h1>
          <p class="hero-subtitle">探索各地热门景点，预订优惠门票，开启美好旅程</p>
        </div>
      </div>
    </div>

    <!-- 搜索和筛选区域 - 参考景点列表 -->
    <div class="search-filter-section">
      <div class="section-container">
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
                <el-input v-model="searchForm.ticketName" placeholder="搜索门票名称或景点..." clearable size="large"
                  class="main-search-input" @keyup.enter="searchTickets">
                  <template #prefix>
                    <el-icon>
                      <Search />
                    </el-icon>
                  </template>
                </el-input>
              </div>
              <div class="search-actions">
                <el-button type="primary" size="large" @click="searchTickets" class="search-btn">
                  <el-icon>
                    <Search />
                  </el-icon>
                  搜索
                </el-button>
                <el-button size="large" @click="resetSearch" class="reset-btn">
                  <el-icon>
                    <Refresh />
                  </el-icon>
                  重置
                </el-button>
              </div>
            </div>

            <!-- 高级筛选选项 -->
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
                  <label class="filter-label">门票类型</label>
                  <el-select v-model="searchForm.ticketType" placeholder="选择类型" clearable class="filter-select">
                    <el-option label="成人票" value="成人票" />
                    <el-option label="儿童票" value="儿童票" />
                    <el-option label="学生票" value="学生票" />
                    <el-option label="老人票" value="老人票" />
                  </el-select>
                </div>
                <div class="filter-group">
                  <label class="filter-label">选择景点</label>
                  <el-select v-model="searchForm.scenicId" placeholder="选择景点" clearable filterable remote
                    :remote-method="fetchScenicOptions" :loading="scenicLoading" class="filter-select">
                    <el-option v-for="item in scenicOptions" :key="item.id" :label="item.name" :value="item.id" />
                  </el-select>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 门票列表区域 -->
    <div class="ticket-list-section">
      <div class="section-container">
        <!-- 加载状态 -->
        <div v-if="loading" class="loading-state">
          <el-skeleton :rows="8" />
        </div>

        <!-- 空状态 -->
        <div v-else-if="ticketList.length === 0" class="empty-state">
          <svg class="empty-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <rect x="2" y="5" width="20" height="14" rx="2"></rect>
            <line x1="2" y1="10" x2="22" y2="10"></line>
          </svg>
          <h3 class="empty-title">暂无符合条件的门票</h3>
          <p class="empty-desc">试试调整搜索条件或浏览其他门票</p>
          <el-button type="primary" @click="resetSearch" class="empty-action">
            重新搜索
          </el-button>
        </div>

        <!-- 门票网格 -->
        <div v-else class="ticket-grid">
          <div v-for="(ticket, index) in ticketList" :key="ticket.id" class="ticket-card glass-card-ticket"
            :class="`delay-${(index % 6 + 1) * 100}`" @click="goToBooking(ticket.id)">
            <div class="card-header">
              <div class="ticket-type-badge">{{ ticket.ticketType }}</div>
              <div class="card-actions">
                <el-button type="primary" size="small" @click.stop="goToBooking(ticket.id)" class="quick-book-btn">
                  <el-icon>
                    <Ticket />
                  </el-icon>
                </el-button>
              </div>
            </div>

            <div class="card-content">
              <h3 class="ticket-name">{{ ticket.ticketName }}</h3>

              <div class="ticket-price-section">
                <div class="price-info">
                  <template v-if="ticket.discountPrice">
                    <span class="discount-price">¥{{ ticket.discountPrice }}</span>
                    <span class="original-price">¥{{ ticket.price }}</span>
                    <span class="discount-badge">特惠</span>
                  </template>
                  <template v-else>
                    <span class="normal-price">¥{{ ticket.price }}</span>
                  </template>
                </div>
                <div class="valid-period">
                  <el-icon>
                    <Calendar />
                  </el-icon>
                  <span>{{ ticket.validPeriod }}</span>
                </div>
              </div>

              <div class="ticket-description">{{ ticket.description || '暂无描述' }}</div>

              <div class="card-footer">
                <div class="ticket-meta">
                  <div class="stock-info" v-if="ticket.stock">
                    <el-icon>
                      <Goods />
                    </el-icon>
                    <span>余票 {{ ticket.stock }} 张</span>
                  </div>
                </div>
                <el-button type="primary" @click.stop="goToBooking(ticket.id)" class="booking-btn">
                  立即预订
                </el-button>
              </div>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div class="pagination-wrapper" v-if="total > 0">
          <el-pagination background layout="total, prev, pager, next, jumper" :total="total" :page-size="pageSize"
            :current-page="currentPage" @current-change="handleCurrentChange" class="modern-pagination" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import request from '@/utils/request'
import { Search, Refresh, Ticket, Calendar, Goods } from '@element-plus/icons-vue'

const router = useRouter()

// 分页参数
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)

// 门票列表数据
const ticketList = ref([])
const loading = ref(false)

// 搜索表单
const searchForm = reactive({
  ticketName: '',
  ticketType: '',
  scenicId: null
})

// 景点选择器数据
const scenicOptions = ref([])
const scenicLoading = ref(false)

// 获取门票列表
const fetchTickets = async () => {
  loading.value = true
  try {
    await request.get('/ticket/page', {
      ticketName: searchForm.ticketName,
      ticketType: searchForm.ticketType,
      scenicId: searchForm.scenicId,
      currentPage: currentPage.value,
      size: pageSize.value
    }, {
      showDefaultMsg: false,
      onSuccess: (res) => {
        ticketList.value = res.records || []
        total.value = res.total || 0
      }
    })
  } catch (error) {
    console.error('获取门票列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 搜索景点选项
const fetchScenicOptions = async (query) => {
  if (query === '') {
    scenicOptions.value = []
    return
  }

  scenicLoading.value = true
  try {
    await request.get('/scenic/page', {
      name: query,
      currentPage: 1,
      size: 20
    }, {
      showDefaultMsg: false,
      onSuccess: (res) => {
        scenicOptions.value = res.records || []
      }
    })
  } catch (error) {
    console.error('获取景点列表失败:', error)
  } finally {
    scenicLoading.value = false
  }
}

// 搜索按钮点击事件
const searchTickets = () => {
  currentPage.value = 1
  fetchTickets()
}

// 重置搜索条件
const resetSearch = () => {
  searchForm.ticketName = ''
  searchForm.ticketType = ''
  searchForm.scenicId = null
  currentPage.value = 1
  fetchTickets()
}

// 分页变化事件
const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchTickets()
}

// 前往预订页面
const goToBooking = (ticketId) => {
  router.push(`/ticket/booking/${ticketId}`)
}

// 页面加载时获取门票列表
onMounted(() => {
  fetchTickets()
})
</script>

<style lang="scss" scoped>
.ticket-list-container {
  min-height: 100vh;
  font-family: "PingFang SC", "Helvetica Neue", Helvetica, Arial, "Microsoft YaHei", sans-serif;
  color: #1a202c;

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

  // 搜索卡片
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

  .glass-card-ticket {
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
    margin: 0 0 16px;
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
    grid-template-columns: repeat(2, 1fr);
    gap: 20px;
    margin-top: 16px;
    align-items: start;
  }

  .filter-group {
    display: flex;
    flex-direction: column;
  }

  .filter-label {
    font-size: 14px;
    font-weight: 600;
    color: #1a202c;
    margin-bottom: 8px;
  }

  .filter-select {
    width: 100%;

    :deep(.el-input__wrapper) {
      border-radius: 16px;
      border: 2px solid rgba(103, 182, 245, 0.2);
      background: rgba(255, 255, 255, 0.9);
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      transition: all 0.3s ease;

      &:hover {
        border-color: #67b6f5;
        box-shadow: 0 4px 12px rgba(103, 182, 245, 0.15);
      }

      &.is-focus {
        border-color: #67b6f5;
        box-shadow: 0 6px 16px rgba(103, 182, 245, 0.25);
      }
    }
  }

  // 门票列表区域
  .ticket-list-section {
    padding: 20px 0 60px;
  }

  // 加载状态
  .loading-state {
    padding: 40px 20px;
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

  // 门票网格布局
  .ticket-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 30px;
    margin-bottom: 40px;
  }

  .ticket-card {
    border-radius: 20px;
    overflow: hidden;
    transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;
    height: 100%;
    display: flex;
    flex-direction: column;
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
    }
  }

  .card-header {
    position: relative;
    padding: 16px;
    background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .ticket-type-badge {
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 13px;
    font-weight: 700;
    background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%);
    color: #1a202c;
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  }

  .card-actions {
    .quick-book-btn {
      border-radius: 50%;
      width: 36px;
      height: 36px;
      padding: 0;
      background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
      border: none;
      box-shadow: 0 4px 12px rgba(103, 182, 245, 0.3);
      transition: all 0.3s ease;

      &:hover {
        transform: scale(1.1);
        box-shadow: 0 6px 16px rgba(103, 182, 245, 0.4);
      }
    }
  }

  .card-content {
    padding: 20px;
    flex: 1;
    display: flex;
    flex-direction: column;
  }

  .ticket-name {
    margin: 0 0 16px;
    font-size: 20px;
    font-weight: 700;
    color: #1a202c;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    line-height: 1.4;
  }

  .ticket-price-section {
    margin-bottom: 16px;
  }

  .price-info {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 8px;

    .discount-price {
      font-size: 24px;
      font-weight: 700;
      color: #e53e3e;
    }

    .original-price {
      font-size: 16px;
      color: #94a3b8;
      text-decoration: line-through;
    }

    .normal-price {
      font-size: 24px;
      font-weight: 700;
      color: #2d3748;
    }

    .discount-badge {
      padding: 2px 6px;
      border-radius: 8px;
      font-size: 10px;
      font-weight: 600;
      background: linear-gradient(45deg, #f56565, #e53e3e);
      color: white;
    }
  }

  .valid-period {
    display: flex;
    align-items: center;
    font-size: 12px;
    color: #5a6c7d;
    gap: 4px;

    .el-icon {
      color: #67b6f5;
    }
  }

  .ticket-description {
    font-size: 14px;
    color: #718096;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    line-height: 1.6;
    margin-bottom: 16px;
  }

  .card-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: auto;
    padding-top: 16px;
  }

  .ticket-meta {
    .stock-info {
      display: flex;
      align-items: center;
      font-size: 13px;
      color: #5a6c7d;
      gap: 4px;
      font-weight: 500;

      .el-icon {
        color: #67b6f5;
      }
    }
  }

  .booking-btn {
    border-radius: 20px;
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    border: none;
    font-weight: 600;
    padding: 8px 16px;
    transition: all 0.3s ease;

    &:hover {
      transform: translateY(-1px);
      box-shadow: 0 6px 16px rgba(103, 182, 245, 0.3);
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
    .ticket-grid {
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

    .ticket-grid {
      grid-template-columns: 1fr;
    }
  }
}
</style>