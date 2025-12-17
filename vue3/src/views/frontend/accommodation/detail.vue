<template>
  <div class="accommodation-detail-container">
    <!-- 英雄区域 - 参考景点详情页面设计 -->
    <div class="detail-hero-section" v-if="accommodation">
      <div class="hero-image-container">
        <div class="image-wrapper">
          <img :src="getImageUrl(accommodation.imageUrl)" :alt="accommodation.name" class="hero-image" />
          <div class="image-overlay">
            <div class="overlay-gradient"></div>
            <div class="hero-content">
              <div class="breadcrumb">
                <el-breadcrumb separator="/">
                  <el-breadcrumb-item @click="$router.push('/')">首页</el-breadcrumb-item>
                  <el-breadcrumb-item @click="$router.push('/accommodation')">住宿推荐</el-breadcrumb-item>
                  <el-breadcrumb-item>{{ accommodation.name }}</el-breadcrumb-item>
                </el-breadcrumb>
              </div>
              <h1 class="accommodation-title">{{ accommodation.name }}</h1>
              <div class="accommodation-meta">
                <div class="meta-item">
                  <el-icon>
                    <Location />
                  </el-icon>
                  <span>{{ accommodation.address }}</span>
                </div>
                <div class="meta-item" v-if="accommodation.type">
                  <el-icon>
                    <House />
                  </el-icon>
                  <span>{{ accommodation.type }}</span>
                </div>
                <div class="meta-item rating">
                  <el-icon>
                    <Star />
                  </el-icon>
                  <span>{{ getDisplayRating(accommodation.starLevel) }}</span>
                  <span class="rating-text">({{ formatReviewCount(reviewTotal) }})</span>
                </div>
              </div>
              <div class="action-buttons">
                <el-button type="primary" size="large" @click="showReviewDialog = true" class="review-btn">
                  <el-icon>
                    <EditPen />
                  </el-icon>
                  发表评价
                </el-button>
                <el-button size="large" class="share-btn" @click="handleShare">
                  <el-icon>
                    <Share />
                  </el-icon>
                  分享
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 加载状态 -->
    <div v-if="loading" class="loading-section">
      <div class="section-container">
        <el-skeleton :rows="20" animated />
      </div>
    </div>
    <!-- 详细信息区域 - 参考景点详情页面设计 -->
    <div class="detail-content" v-else-if="accommodation">
      <div class="section-container">
        <div class="content-grid">
          <!-- 左侧主要内容 -->
          <div class="main-content">
            <!-- 住宿描述 -->
            <div class="info-card description-card">
              <h3 class="card-title">
                <el-icon>
                  <Document />
                </el-icon>
                住宿介绍
              </h3>
              <div class="description-content">{{ accommodation.description || '暂无详细描述' }}</div>
            </div>

            <!-- 特色服务 -->
            <div class="info-card features-card">
              <h3 class="card-title">
                <el-icon>
                  <Star />
                </el-icon>
                特色服务
              </h3>
              <div class="features-content">{{ accommodation.features || '暂无特色服务介绍' }}</div>
            </div>

            <!-- 评价列表 -->
            <div class="info-card reviews-card">
              <div class="reviews-header">
                <h3 class="card-title">
                  <el-icon>
                    <ChatDotRound />
                  </el-icon>
                  住客评价 ({{ reviewTotal || 0 }})
                </h3>
              </div>

              <div v-if="loadingReviews" class="review-loading">
                <el-skeleton :rows="3" animated />
              </div>

              <div v-else-if="reviewList.length === 0" class="empty-reviews">
                <div class="empty-icon">💬</div>
                <h4 class="empty-title">暂无评价</h4>
                <p class="empty-desc">成为第一个评价这家住宿的客人</p>
              </div>

              <div v-else class="review-list">
                <div v-for="(review, index) in reviewList" :key="index" class="review-item">
                  <div class="review-header">
                    <div class="review-user">
                      <el-avatar :size="40" :src="getImageUrl(review.avatar)">{{ review.nickname?.charAt(0)
                      }}</el-avatar>
                      <div class="user-info">
                        <span class="username">{{ review.nickname || '匿名用户' }}</span>
                        <span class="review-date">{{ formatDate(review.createTime) }}</span>
                      </div>
                    </div>
                    <div class="review-rating">
                      <el-rate v-model="review.rating" disabled size="small" />
                      <span class="rating-score">{{ review.rating }}分</span>
                    </div>
                  </div>

                  <div class="review-content">
                    <div class="review-text">{{ review.content }}</div>
                  </div>

                  <div v-if="canDelete(review)" class="review-actions">
                    <el-button type="danger" size="small" link @click="handleDeleteReview(review.id)">
                      <el-icon>
                        <Delete />
                      </el-icon> 删除
                    </el-button>
                  </div>
                </div>

                <!-- 评价分页 -->
                <div class="review-pagination" v-if="reviewTotal > 10">
                  <el-pagination background layout="prev, pager, next" :current-page="reviewPage"
                    :page-size="reviewPageSize" :total="reviewTotal" @current-change="handleReviewPageChange"
                    class="modern-pagination" />
                </div>
              </div>
            </div>
          </div>

          <!-- 右侧信息栏 -->
          <div class="sidebar-content">
            <!-- 基本信息卡片 -->
            <div class="info-card basic-info-card">
              <h3 class="card-title">
                <el-icon>
                  <InfoFilled />
                </el-icon>
                基本信息
              </h3>
              <div class="info-list">
                <div class="info-item">
                  <div class="info-label">
                    <el-icon>
                      <Money />
                    </el-icon>
                    价格区间
                  </div>
                  <div class="info-value price-value">{{ accommodation.priceRange }}</div>
                </div>
                <div class="info-item">
                  <div class="info-label">
                    <el-icon>
                      <Phone />
                    </el-icon>
                    联系电话
                  </div>
                  <div class="info-value">{{ accommodation.contactPhone || '暂无' }}</div>
                </div>
                <div class="info-item" v-if="accommodation.scenicName">
                  <div class="info-label">
                    <el-icon>
                      <Location />
                    </el-icon>
                    附近景点
                  </div>
                  <div class="info-value scenic-link" @click="goToScenic(accommodation.scenicId)">
                    {{ accommodation.scenicName }}
                    <span v-if="accommodation.distance" class="distance">（{{ accommodation.distance }}）</span>
                  </div>
                </div>
              </div>
            </div>
            <!-- 周边景点推荐 -->
            <div class="info-card nearby-scenics-card" v-if="nearbyScenics.length > 0">
              <h3 class="card-title">
                <el-icon>
                  <MapLocation />
                </el-icon>
                周边景点
              </h3>

              <div v-if="loadingScenics" class="loading-recommendations">
                <el-skeleton :rows="3" animated />
              </div>

              <div v-else class="scenic-list">
                <div v-for="scenic in nearbyScenics" :key="scenic.id" class="scenic-item"
                  @click="goToScenic(scenic.id)">
                  <div class="scenic-image">
                    <img :src="getImageUrl(scenic.imageUrl)" :alt="scenic.name" />
                  </div>
                  <div class="scenic-info">
                    <div class="scenic-name">{{ scenic.name }}</div>
                    <div class="scenic-price">{{ scenic.price ? `¥${scenic.price}` : '免费' }}</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 更多住宿推荐 -->
            <div class="info-card similar-accommodations-card" v-if="similarAccommodations.length > 0">
              <h3 class="card-title">
                <el-icon>
                  <House />
                </el-icon>
                更多住宿
              </h3>

              <div v-if="loadingSimilar" class="loading-recommendations">
                <el-skeleton :rows="3" animated />
              </div>

              <div v-else class="accommodation-list">
                <div v-for="item in similarAccommodations" :key="item.id" class="accommodation-item"
                  @click="goToAccommodation(item.id)">
                  <div class="accommodation-image">
                    <img :src="getImageUrl(item.imageUrl)" :alt="item.name" />
                  </div>
                  <div class="accommodation-info">
                    <div class="item-name">{{ item.name }}</div>
                    <div class="item-rating">
                      <el-rate v-model="item.starLevel" disabled :max="5" size="small" />
                    </div>
                    <div class="item-price">{{ item.priceRange }}</div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <div v-else class="empty-state">
      <div class="section-container">
        <div class="empty-content">
          <div class="empty-icon">🏨</div>
          <h3 class="empty-title">住宿信息不存在</h3>
          <p class="empty-desc">该住宿可能已下线或不存在</p>
          <el-button type="primary" @click="$router.push('/accommodation')">
            返回住宿列表
          </el-button>
        </div>
      </div>
    </div>

    <!-- 评价对话框 -->
    <el-dialog v-model="showReviewDialog" title="发表评价" width="540px" :close-on-click-modal="false"
      class="review-dialog">
      <el-form ref="reviewFormRef" :model="reviewForm" :rules="reviewRules" label-position="top" class="review-form">
        <el-form-item label="评分" prop="rating" class="rating-item">
          <div class="rating-wrapper">
            <el-rate v-model="reviewForm.rating" :colors="colors" show-score size="large" />
            <p class="rating-hint">请为您的住宿体验打分</p>
          </div>
        </el-form-item>

        <el-form-item label="评价内容" prop="content" class="content-item">
          <el-input v-model="reviewForm.content" type="textarea" :rows="6" placeholder="请分享您的住宿体验...\n例如：环境、服务、设施等方面的感受"
            class="review-textarea" />
          <div class="char-count">{{ reviewForm.content.length }}/500</div>
        </el-form-item>
      </el-form>

      <template #footer>
        <div class="dialog-footer">
          <el-button @click="showReviewDialog = false" class="cancel-btn" size="large">取消</el-button>
          <el-button type="primary" :loading="submittingReview" @click="submitReview" class="submit-btn" size="large">
            <el-icon v-if="!submittingReview">
              <EditPen />
            </el-icon>
            {{ submittingReview ? '提交中...' : '提交评价' }}
          </el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '@/utils/request'
import { useUserStore } from '@/store/user'
import {
  Location, Star, Phone, Delete, House, MapLocation,
  Document, InfoFilled, Money, ChatDotRound, EditPen, Share
} from '@element-plus/icons-vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const baseAPI = process.env.VUE_APP_BASE_API || '/api'

// 数据状态
const accommodation = ref(null)
const loading = ref(false)
const reviewList = ref([])
const reviewTotal = ref(0)
const reviewPage = ref(1)
const reviewPageSize = ref(10)
const loadingReviews = ref(false)
const nearbyScenics = ref([])
const loadingScenics = ref(false)
const similarAccommodations = ref([])
const loadingSimilar = ref(false)

// 评分颜色
const colors = ['#99A9BF', '#F7BA2A', '#FF9900']

// 评价表单
const showReviewDialog = ref(false)
const submittingReview = ref(false)
const reviewForm = reactive({
  accommodationId: parseInt(route.params.id),
  rating: 5,
  content: ''
})

const reviewRules = {
  rating: [
    { required: true, message: '请选择评分', trigger: 'change' }
  ],
  content: [
    { required: true, message: '请输入评价内容', trigger: 'blur' },
    { min: 5, max: 500, message: '评价内容长度在5到500个字符之间', trigger: 'blur' }
  ]
}

// 检查是否为当前用户评价或管理员
const canDelete = (review) => {
  if (!userStore.userInfo) return false
  return userStore.userInfo.id === review.userId || userStore.userInfo.roleCode === 'ADMIN'
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

// 获取住宿详情
const fetchAccommodationDetail = async () => {
  loading.value = true
  try {
    await request.get(`/accommodation/${route.params.id}`, {}, {
      onSuccess: (res) => {
        accommodation.value = res
      }
    })
  } catch (error) {
    console.error('获取住宿详情失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取住宿评价列表
const fetchAccommodationReviews = async () => {
  loadingReviews.value = true
  try {
    await request.get('/accommodation/review/page', {
      accommodationId: route.params.id,
      currentPage: reviewPage.value,
      size: reviewPageSize.value
    }, {
      onSuccess: (res) => {
        reviewList.value = res.records || []
        reviewTotal.value = res.total || 0
      }
    })
  } catch (error) {
    console.error('获取住宿评价失败:', error)
  } finally {
    loadingReviews.value = false
  }
}

// 获取周边景点
const fetchNearbyScenics = async () => {
  if (!accommodation.value?.scenicId) return

  loadingScenics.value = true
  try {
    await request.get('/scenic/page', {
      size: 5,
      currentPage: 1
    }, {
      onSuccess: (res) => {
        // 过滤掉当前关联的景点，只显示其他景点
        nearbyScenics.value = res.records.filter(s => s.id !== accommodation.value?.scenicId).slice(0, 3)
      }
    })
  } catch (error) {
    console.error('获取周边景点失败:', error)
  } finally {
    loadingScenics.value = false
  }
}

// 获取相似住宿
const fetchSimilarAccommodations = async () => {
  if (!accommodation.value) return

  loadingSimilar.value = true
  try {
    await request.get('/accommodation/page', {
      type: accommodation.value.type,
      currentPage: 1,
      size: 3
    }, {
      onSuccess: (res) => {
        // 过滤掉当前住宿，只显示其他住宿
        similarAccommodations.value = res.records.filter(a => a.id !== parseInt(route.params.id)).slice(0, 3)
      }
    })
  } catch (error) {
    console.error('获取相似住宿失败:', error)
  } finally {
    loadingSimilar.value = false
  }
}

// 处理图片URL
const getImageUrl = (url) => {
  if (!url) return require('@/assets/images/no-image.png')
  if (url.startsWith('http')) return url
  return baseAPI + url
}

// 处理评价分页
const handleReviewPageChange = (page) => {
  reviewPage.value = page
  fetchAccommodationReviews()
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

// 提交评价
const submitReview = async () => {
  // 检查是否登录
  if (!userStore.isLoggedIn) {
    ElMessage.warning('请先登录再发表评价')
    router.push('/login')
    return
  }

  submittingReview.value = true
  try {
    await request.post('/accommodation/review', reviewForm, {
      successMsg: '评价提交成功',
      onSuccess: () => {
        showReviewDialog.value = false
        reviewForm.rating = 5
        reviewForm.content = ''
        // 刷新评价列表
        reviewPage.value = 1
        fetchAccommodationReviews()
        // 刷新住宿详情以更新评分
        fetchAccommodationDetail()
      }
    })
  } catch (error) {
    console.error('提交评价失败:', error)
  } finally {
    submittingReview.value = false
  }
}

// 删除评价
const handleDeleteReview = (id) => {
  ElMessageBox.confirm('确认删除该评价?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    try {
      await request.delete(`/accommodation/review/${id}`, {
        successMsg: '评价已删除',
        onSuccess: () => {
          // 刷新评价列表
          fetchAccommodationReviews()
          // 刷新住宿详情以更新评分
          fetchAccommodationDetail()
        }
      })
    } catch (error) {
      console.error('删除评价失败:', error)
    }
  }).catch(() => { })
}

// 跳转到景点详情
const goToScenic = (id) => {
  router.push(`/scenic/${id}`)
}

// 跳转到住宿详情
const goToAccommodation = (id) => {
  router.push(`/accommodation/${id}`)
  // 如果是同一页面不同ID的情况，需要刷新数据
  if (parseInt(route.params.id) !== id) {
    // 延迟执行以确保路由已经完成
    setTimeout(() => {
      fetchAccommodationDetail()
      fetchAccommodationReviews()
      window.scrollTo(0, 0)
    }, 100)
  }
}

// 分享功能
const handleShare = () => {
  // 复制链接到剪贴板
  const url = window.location.href
  navigator.clipboard.writeText(url).then(() => {
    ElMessage.success('链接已复制，快去分享吧！')
  }).catch(() => {
    ElMessage.error('复制失败，请手动复制地址栏链接')
  })
}

// 初始加载
onMounted(() => {
  fetchAccommodationDetail()
  fetchAccommodationReviews()
})

// 监听住宿数据加载完成，加载相关推荐
watch(() => accommodation.value, (newVal) => {
  if (newVal) {
    fetchNearbyScenics()
    fetchSimilarAccommodations()
  }
}, { immediate: false })
</script>

<style lang="scss" scoped>
.accommodation-detail-container {
  min-height: 100vh;
  font-family: "PingFang SC", "Helvetica Neue", Helvetica, Arial, "Microsoft YaHei", sans-serif;
  color: #1a202c;

  // 通用容器样式
  .section-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 20px;
  }

  // 英雄区域样式
  .detail-hero-section {
    position: relative;
    height: 65vh;
    min-height: 550px;
    overflow: hidden;
    border-radius: 32px;
  }

  .hero-image-container {
    position: relative;
    width: 100%;
    height: 100%;
  }

  .image-wrapper {
    position: relative;
    width: 100%;
    height: 100%;
  }

  .hero-image {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.8s ease;
  }

  .image-overlay {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .overlay-gradient {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(to bottom,
        rgba(0, 0, 0, 0.3) 0%,
        rgba(0, 0, 0, 0.2) 50%,
        rgba(0, 0, 0, 0.5) 100%);
  }

  .hero-content {
    position: relative;
    z-index: 10;
    color: white;
    text-align: center;
    max-width: 1200px;
    width: 100%;
    padding: 0 40px;
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

  .breadcrumb {
    margin-bottom: 24px;
    text-align: left;

    :deep(.el-breadcrumb) {
      .el-breadcrumb__item {
        .el-breadcrumb__inner {
          color: rgba(255, 255, 255, 0.9);
          font-weight: 600;
          cursor: pointer;
          transition: all 0.3s ease;

          &:hover {
            color: white;
            text-shadow: 0 2px 8px rgba(255, 255, 255, 0.3);
          }
        }

        &:last-child .el-breadcrumb__inner {
          color: white;
        }
      }

      .el-breadcrumb__separator {
        color: rgba(255, 255, 255, 0.7);
      }
    }
  }

  .accommodation-title {
    font-size: 52px;
    font-weight: 800;
    margin: 0 0 24px;
    text-shadow: 0 6px 20px rgba(0, 0, 0, 0.4);
    line-height: 1.2;
    letter-spacing: 1px;
  }

  .accommodation-meta {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 32px;
    margin-bottom: 32px;
    flex-wrap: wrap;
    padding: 20px;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-radius: 20px;
    border: 1px solid rgba(255, 255, 255, 0.2);
  }

  .meta-item {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 17px;
    font-weight: 600;
    text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);

    .el-icon {
      font-size: 20px;
      filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.2));
    }

    &.rating {
      .rating-text {
        opacity: 0.95;
        margin-left: 6px;
        font-weight: 500;
      }
    }
  }

  .action-buttons {
    display: flex;
    justify-content: center;
    gap: 20px;
    flex-wrap: wrap;
  }

  .review-btn,
  .share-btn {
    border-radius: 25px;
    padding: 14px 32px;
    font-weight: 700;
    font-size: 16px;
    transition: all 0.3s ease;
    border: 2px solid rgba(255, 255, 255, 0.3);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.2);

    &:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 32px rgba(0, 0, 0, 0.3);
    }

    &:active {
      transform: translateY(-2px);
    }
  }

  .review-btn {
    background: linear-gradient(135deg, rgba(255, 255, 255, 0.95) 0%, rgba(255, 255, 255, 0.85) 100%);
    color: #67b6f5;

    &:hover {
      background: linear-gradient(135deg, white 0%, rgba(255, 255, 255, 0.95) 100%);
      color: #5aa9e6;
      border-color: rgba(255, 255, 255, 0.5);
    }
  }

  .share-btn {
    background: rgba(255, 255, 255, 0.15);
    color: white;

    &:hover {
      background: rgba(255, 255, 255, 0.25);
      border-color: rgba(255, 255, 255, 0.6);
    }
  }

  // 加载状态
  .loading-section {
    padding: 60px 0;
  }

  // 详细信息区域
  .detail-content {
    padding: 60px 0;
    position: relative;
  }

  .content-grid {
    display: grid;
    grid-template-columns: 1fr 320px;
    gap: 40px;
    align-items: start;
  }

  .main-content {
    .info-card {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border-radius: 24px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.5);
      margin-bottom: 30px;
      overflow: hidden;
      transition: all 0.3s ease;

      &:hover {
        box-shadow: 0 12px 40px rgba(103, 182, 245, 0.15);
        transform: translateY(-4px);
      }
    }

    .card-title {
      font-size: 22px;
      font-weight: 800;
      color: #1a202c;
      margin: 0 0 20px;
      padding: 28px 28px 0;
      display: flex;
      align-items: center;
      gap: 12px;

      .el-icon {
        color: #67b6f5;
        font-size: 24px;
        filter: drop-shadow(0 2px 4px rgba(103, 182, 245, 0.3));
      }
    }

    .description-content,
    .features-content {
      padding: 0 28px 28px;
      font-size: 16px;
      line-height: 1.9;
      color: #4a5568;
      background: linear-gradient(135deg, rgba(103, 182, 245, 0.02) 0%, rgba(255, 193, 124, 0.02) 100%);
      border-radius: 0 0 24px 24px;
    }

    // 评价区域样式
    .reviews-card {
      .reviews-header {
        padding: 28px 28px 0;
        margin-bottom: 20px;
        background: linear-gradient(135deg, rgba(103, 182, 245, 0.03) 0%, rgba(255, 193, 124, 0.03) 100%);
      }

      .review-loading {
        padding: 20px 24px;
      }

      .empty-reviews {
        text-align: center;
        padding: 60px 28px;
        background: linear-gradient(135deg, rgba(103, 182, 245, 0.03) 0%, rgba(255, 193, 124, 0.03) 100%);
        border-radius: 16px;

        .empty-icon {
          font-size: 64px;
          margin-bottom: 20px;
          filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.1));
        }

        .empty-title {
          font-size: 20px;
          font-weight: 700;
          color: #1a202c;
          margin: 0 0 12px;
        }

        .empty-desc {
          color: #5a6c7d;
          margin: 0;
          font-size: 15px;
        }
      }

      .review-list {
        padding: 0 28px 28px;
      }

      .review-item {
        padding: 24px;
        margin-bottom: 16px;
        background: linear-gradient(135deg, rgba(103, 182, 245, 0.02) 0%, rgba(255, 193, 124, 0.02) 100%);
        border-radius: 16px;
        border: 1px solid rgba(103, 182, 245, 0.1);
        transition: all 0.3s ease;

        &:hover {
          background: linear-gradient(135deg, rgba(103, 182, 245, 0.05) 0%, rgba(255, 193, 124, 0.05) 100%);
          border-color: rgba(103, 182, 245, 0.2);
          transform: translateX(4px);
        }

        &:last-child {
          margin-bottom: 0;
        }
      }

      .review-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 12px;
      }

      .review-user {
        display: flex;
        align-items: center;
        gap: 12px;
      }

      .user-info {
        .username {
          font-size: 15px;
          font-weight: 700;
          color: #1a202c;
          margin: 0 0 4px;
        }

        .review-date {
          font-size: 13px;
          color: #5a6c7d;
          font-weight: 500;
        }
      }

      .review-rating {
        display: flex;
        align-items: center;
        gap: 8px;

        .rating-score {
          font-size: 14px;
          color: #64748b;
          font-weight: 500;
        }
      }

      .review-content {
        .review-text {
          font-size: 15px;
          line-height: 1.8;
          color: #4a5568;
          padding: 12px;
          background: rgba(255, 255, 255, 0.5);
          border-radius: 12px;
        }
      }

      .review-actions {
        margin-top: 12px;
        text-align: right;
      }

      .review-pagination {
        padding: 20px 24px 0;
        text-align: center;

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
      }
    }
  }

  .sidebar-content {
    .info-card {
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border-radius: 24px;
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.5);
      margin-bottom: 30px;
      overflow: hidden;
      transition: all 0.3s ease;

      &:hover {
        box-shadow: 0 12px 40px rgba(103, 182, 245, 0.15);
        transform: translateY(-4px);
      }
    }

    .card-title {
      font-size: 20px;
      font-weight: 800;
      color: #1a202c;
      margin: 0 0 20px;
      padding: 24px 24px 0;
      display: flex;
      align-items: center;
      gap: 10px;

      .el-icon {
        color: #67b6f5;
        font-size: 22px;
        filter: drop-shadow(0 2px 4px rgba(103, 182, 245, 0.3));
      }
    }

    .info-list {
      padding: 0 24px 24px;
    }

    .info-item {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 16px;
      margin-bottom: 12px;
      background: linear-gradient(135deg, rgba(103, 182, 245, 0.03) 0%, rgba(255, 193, 124, 0.03) 100%);
      border-radius: 12px;
      border: 1px solid rgba(103, 182, 245, 0.1);
      transition: all 0.3s ease;

      &:hover {
        background: linear-gradient(135deg, rgba(103, 182, 245, 0.08) 0%, rgba(255, 193, 124, 0.08) 100%);
        border-color: rgba(103, 182, 245, 0.2);
        transform: translateX(4px);
      }

      &:last-child {
        margin-bottom: 0;
      }
    }

    .info-label {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 15px;
      color: #5a6c7d;
      font-weight: 600;

      .el-icon {
        color: #67b6f5;
        font-size: 18px;
        filter: drop-shadow(0 1px 2px rgba(103, 182, 245, 0.3));
      }
    }

    .info-value {
      font-size: 15px;
      color: #1a202c;
      font-weight: 700;

      &.price-value {
        color: #ef4444;
        font-size: 18px;
        text-shadow: 0 2px 4px rgba(239, 68, 68, 0.2);
      }

      &.scenic-link {
        color: #67b6f5;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: underline;
        text-decoration-style: dotted;

        &:hover {
          color: #5aa9e6;
          text-shadow: 0 2px 4px rgba(103, 182, 245, 0.3);
        }

        .distance {
          color: #10b981;
          font-weight: 600;
        }
      }
    }

    // 推荐区域样式
    .nearby-scenics-card,
    .similar-accommodations-card {
      .loading-recommendations {
        padding: 20px;
      }

      .scenic-list,
      .accommodation-list {
        padding: 0 24px 24px;
        display: flex;
        flex-direction: column;
        gap: 16px;
      }

      .scenic-item,
      .accommodation-item {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 14px;
        border-radius: 16px;
        background: linear-gradient(135deg, rgba(103, 182, 245, 0.03) 0%, rgba(255, 193, 124, 0.03) 100%);
        border: 1px solid rgba(103, 182, 245, 0.1);
        cursor: pointer;
        transition: all 0.3s ease;

        &:hover {
          background: linear-gradient(135deg, rgba(103, 182, 245, 0.08) 0%, rgba(255, 193, 124, 0.08) 100%);
          border-color: #67b6f5;
          box-shadow: 0 8px 24px rgba(103, 182, 245, 0.2);
          transform: translateY(-4px) translateX(4px);
        }
      }

      .scenic-image,
      .accommodation-image {
        width: 70px;
        height: 70px;
        border-radius: 12px;
        overflow: hidden;
        flex-shrink: 0;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.3s ease;
        }

        &:hover img {
          transform: scale(1.1);
        }
      }

      .scenic-info,
      .accommodation-info {
        flex: 1;
        min-width: 0;
      }

      .scenic-name,
      .item-name {
        font-size: 15px;
        font-weight: 700;
        color: #1a202c;
        margin: 0 0 6px;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }

      .scenic-price,
      .item-price {
        font-size: 14px;
        color: #ef4444;
        font-weight: 700;
        text-shadow: 0 1px 2px rgba(239, 68, 68, 0.2);
      }

      .item-rating {
        margin: 4px 0;
      }
    }
  }

  // 空状态
  .empty-state {
    padding: 120px 0;

    .empty-content {
      text-align: center;
      max-width: 500px;
      margin: 0 auto;
      padding: 60px 40px;
      background: rgba(255, 255, 255, 0.95);
      backdrop-filter: blur(20px);
      -webkit-backdrop-filter: blur(20px);
      border-radius: 32px;
      box-shadow: 0 12px 48px rgba(0, 0, 0, 0.1);
      border: 1px solid rgba(255, 255, 255, 0.5);

      .empty-icon {
        font-size: 80px;
        margin-bottom: 24px;
        filter: drop-shadow(0 4px 12px rgba(0, 0, 0, 0.1));
      }

      .empty-title {
        font-size: 28px;
        font-weight: 800;
        color: #1a202c;
        margin: 0 0 16px;
        letter-spacing: 0.5px;
      }

      .empty-desc {
        font-size: 17px;
        color: #5a6c7d;
        margin: 0 0 32px;
        line-height: 1.6;
      }

      .el-button {
        border-radius: 25px;
        padding: 14px 32px;
        font-weight: 700;
        font-size: 16px;
        background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
        border: none;
        box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);
        transition: all 0.3s ease;

        &:hover {
          transform: translateY(-4px);
          box-shadow: 0 8px 25px rgba(103, 182, 245, 0.4);
        }
      }
    }
  }

  // 响应式设计
  @media (max-width: 1024px) {
    .content-grid {
      grid-template-columns: 1fr;
      gap: 30px;
    }

    .sidebar-content {
      order: -1;
    }
  }

  @media (max-width: 768px) {
    .detail-hero-section {
      height: 50vh;
      min-height: 400px;
    }

    .hero-content {
      padding: 0 20px;
    }

    .accommodation-title {
      font-size: 32px;
    }

    .accommodation-meta {
      flex-direction: column;
      gap: 16px;
    }

    .action-buttons {
      flex-direction: column;
      align-items: center;

      .review-btn,
      .share-btn {
        width: 200px;
      }
    }

    .section-container {
      padding: 0 16px;
    }

    .detail-content {
      padding: 40px 0;
    }

    .content-grid {
      gap: 20px;
    }

    .main-content .card-title {
      font-size: 18px;
      padding: 20px 20px 0;
    }

    .main-content .description-content,
    .main-content .features-content {
      padding: 0 20px 20px;
      font-size: 14px;
    }
  }

  @media (max-width: 480px) {
    .accommodation-title {
      font-size: 24px;
    }

    .meta-item {
      font-size: 14px;
    }

    .review-btn,
    .share-btn {
      padding: 10px 20px;
      font-size: 14px;
    }

    .main-content .card-title {
      font-size: 16px;
    }

    .sidebar-content .card-title {
      font-size: 16px;
    }
  }
}

// 评价对话框样式
:deep(.review-dialog) {
  .el-dialog {
    border-radius: 24px;
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
    border: 1px solid rgba(255, 255, 255, 0.5);
    overflow: hidden;
  }

  .el-dialog__header {
    padding: 28px 32px;
    margin: 0;
    background: linear-gradient(135deg, rgba(103, 182, 245, 0.08) 0%, rgba(255, 193, 124, 0.08) 100%);
    border-bottom: 1px solid rgba(103, 182, 245, 0.15);

    .el-dialog__title {
      font-size: 24px;
      font-weight: 800;
      color: #1a202c;
      background: linear-gradient(135deg, #67b6f5 0%, #ffc17c 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
  }

  .el-dialog__body {
    padding: 32px;
  }

  .el-dialog__footer {
    padding: 0 32px 32px;
  }

  .el-dialog__headerbtn {
    top: 24px;
    right: 24px;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    background: rgba(103, 182, 245, 0.1);
    transition: all 0.3s ease;

    &:hover {
      background: rgba(103, 182, 245, 0.2);
      transform: rotate(90deg);
    }

    .el-dialog__close {
      color: #67b6f5;
      font-weight: bold;
      font-size: 18px;
    }
  }
}

.review-form {
  .rating-item {
    margin-bottom: 32px;

    .el-form-item__label {
      font-size: 16px;
      font-weight: 700;
      color: #1a202c;
      margin-bottom: 12px;
    }

    .rating-wrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 24px;
      background: linear-gradient(135deg, rgba(103, 182, 245, 0.05) 0%, rgba(255, 193, 124, 0.05) 100%);
      border-radius: 16px;
      border: 2px dashed rgba(103, 182, 245, 0.2);
      transition: all 0.3s ease;

      &:hover {
        background: linear-gradient(135deg, rgba(103, 182, 245, 0.08) 0%, rgba(255, 193, 124, 0.08) 100%);
        border-color: rgba(103, 182, 245, 0.3);
        transform: translateY(-2px);
      }

      :deep(.el-rate) {
        height: auto;

        .el-rate__icon {
          font-size: 32px;
          margin-right: 8px;
        }

        .el-rate__text {
          font-size: 24px;
          font-weight: 800;
          color: #67b6f5;
          margin-left: 12px;
          text-shadow: 0 2px 4px rgba(103, 182, 245, 0.2);
        }
      }

      .rating-hint {
        margin: 12px 0 0;
        font-size: 14px;
        color: #5a6c7d;
        font-weight: 500;
      }
    }
  }

  .content-item {
    .el-form-item__label {
      font-size: 16px;
      font-weight: 700;
      color: #1a202c;
      margin-bottom: 12px;
    }

    .review-textarea {
      :deep(.el-textarea__inner) {
        border-radius: 16px;
        border: 2px solid rgba(103, 182, 245, 0.15);
        padding: 16px;
        font-size: 15px;
        line-height: 1.8;
        background: linear-gradient(135deg, rgba(103, 182, 245, 0.02) 0%, rgba(255, 193, 124, 0.02) 100%);
        transition: all 0.3s ease;
        resize: none;

        &:focus {
          border-color: #67b6f5;
          background: linear-gradient(135deg, rgba(103, 182, 245, 0.05) 0%, rgba(255, 193, 124, 0.05) 100%);
          box-shadow: 0 4px 16px rgba(103, 182, 245, 0.15);
        }

        &::placeholder {
          color: #a0aec0;
          font-size: 14px;
        }
      }
    }

    .char-count {
      text-align: right;
      margin-top: 8px;
      font-size: 13px;
      color: #5a6c7d;
      font-weight: 500;
    }
  }
}

.dialog-footer {
  display: flex;
  justify-content: flex-end;
  gap: 16px;

  .cancel-btn,
  .submit-btn {
    min-width: 120px;
    border-radius: 20px;
    padding: 12px 28px;
    font-weight: 700;
    font-size: 15px;
    transition: all 0.3s ease;
  }

  .cancel-btn {
    background: rgba(103, 182, 245, 0.08);
    border: 2px solid rgba(103, 182, 245, 0.2);
    color: #67b6f5;

    &:hover {
      background: rgba(103, 182, 245, 0.15);
      border-color: rgba(103, 182, 245, 0.3);
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(103, 182, 245, 0.2);
    }

    &:active {
      transform: translateY(0);
    }
  }

  .submit-btn {
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    border: none;
    box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);

    &:hover {
      background: linear-gradient(135deg, #5aa9e6 0%, #4d9ad6 100%);
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(103, 182, 245, 0.4);
    }

    &:active {
      transform: translateY(0);
    }

    .el-icon {
      margin-right: 6px;
    }
  }
}
</style>