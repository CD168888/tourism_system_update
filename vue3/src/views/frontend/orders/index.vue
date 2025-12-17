<template>
  <div class="orders-container">
    <!-- Hero顶部区域 -->
    <div class="page-hero">
      <div class="hero-background">
        <div class="hero-gradient"></div>
      </div>
      <div class="hero-content">
        <div class="breadcrumb">
          <el-breadcrumb separator="/">
            <el-breadcrumb-item @click="$router.push('/')">首页</el-breadcrumb-item>
            <el-breadcrumb-item>我的订单</el-breadcrumb-item>
          </el-breadcrumb>
        </div>
        <h1 class="page-title">
          <svg class="title-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
            <line x1="16" y1="13" x2="8" y2="13"></line>
            <line x1="16" y1="17" x2="8" y2="17"></line>
            <polyline points="10 9 9 9 8 9"></polyline>
          </svg>
          我的订单
        </h1>
        <p class="page-subtitle">
          查看和管理您的门票订单
        </p>
      </div>
    </div>

    <!-- 现代化标签页区域 -->
    <div class="orders-section">
      <div class="section-container">
        <div class="orders-tabs glass-card">
          <el-tabs v-model="activeTab" @tab-click="handleTabClick" class="modern-tabs">
            <el-tab-pane label="全部" name="all">
              <template #label>
                <div class="tab-label">
                  <el-icon>
                    <List />
                  </el-icon>
                  <span>全部</span>
                  <span class="tab-count">{{ orderStats.total || 0 }}</span>
                </div>
              </template>
            </el-tab-pane>
            <el-tab-pane label="待支付" name="0">
              <template #label>
                <div class="tab-label">
                  <el-icon>
                    <Clock />
                  </el-icon>
                  <span>待支付</span>
                  <span class="tab-count">{{ orderStats.pending || 0 }}</span>
                </div>
              </template>
            </el-tab-pane>
            <el-tab-pane label="已支付" name="1">
              <template #label>
                <div class="tab-label">
                  <el-icon>
                    <Check />
                  </el-icon>
                  <span>已支付</span>
                  <span class="tab-count">{{ orderStats.paid || 0 }}</span>
                </div>
              </template>
            </el-tab-pane>
            <el-tab-pane label="已取消" name="2">
              <template #label>
                <div class="tab-label">
                  <el-icon>
                    <Close />
                  </el-icon>
                  <span>已取消</span>
                  <span class="tab-count">{{ orderStats.cancelled || 0 }}</span>
                </div>
              </template>
            </el-tab-pane>
            <el-tab-pane label="已退款" name="3">
              <template #label>
                <div class="tab-label">
                  <el-icon>
                    <RefreshLeft />
                  </el-icon>
                  <span>已退款</span>
                  <span class="tab-count">{{ orderStats.refunded || 0 }}</span>
                </div>
              </template>
            </el-tab-pane>
            <el-tab-pane label="已完成" name="4">
              <template #label>
                <div class="tab-label">
                  <el-icon>
                    <CircleCheck />
                  </el-icon>
                  <span>已完成</span>
                  <span class="tab-count">{{ orderStats.completed || 0 }}</span>
                </div>
              </template>
            </el-tab-pane>
          </el-tabs>

          <!-- 加载状态 -->
          <div v-if="loading" class="loading-state">
            <el-skeleton :rows="6" animated />
          </div>

          <!-- 空状态 -->
          <div v-else-if="orderList.length === 0" class="empty-state">
            <div class="empty-icon">📋</div>
            <h3 class="empty-title">暂无订单</h3>
            <p class="empty-desc">您还没有任何订单，快去预订门票吧</p>
            <el-button type="primary" @click="goToTicketList" class="empty-action">
              <el-icon>
                <Ticket />
              </el-icon>
              浏览门票
            </el-button>
          </div>

          <!-- 订单列表 -->
          <div v-else class="orders-list">
            <div v-for="(order, index) in orderList" :key="order.id" class="order-card glass-card-inner"
              :class="`delay-${(index % 4 + 1) * 100}`">
              <div class="order-header">
                <div class="order-info">
                  <div class="order-no">
                    <el-icon>
                      <Document />
                    </el-icon>
                    <span>{{ order.orderNo }}</span>
                  </div>
                  <div class="order-time">{{ formatTime(order.createTime) }}</div>
                </div>
                <div class="order-status-badge" :class="getStatusClass(order.status)">
                  {{ getOrderStatusText(order.status) }}
                </div>
              </div>

              <div class="order-content">
                <div class="ticket-section">
                  <div class="ticket-main">
                    <h3 class="ticket-name">{{ order.ticketName }}</h3>
                    <div class="scenic-info">
                      <el-icon>
                        <MapLocation />
                      </el-icon>
                      <span>{{ order.scenicName }}</span>
                    </div>
                  </div>

                  <div class="order-details">
                    <div class="detail-row">
                      <div class="detail-item">
                        <el-icon>
                          <Calendar />
                        </el-icon>
                        <span>游玩日期</span>
                        <strong>{{ formatDate(order.visitDate) }}</strong>
                      </div>
                      <div class="detail-item">
                        <el-icon>
                          <User />
                        </el-icon>
                        <span>数量</span>
                        <strong>{{ order.quantity }} 张</strong>
                      </div>
                    </div>

                    <div class="detail-row">
                      <div class="detail-item">
                        <el-icon>
                          <UserFilled />
                        </el-icon>
                        <span>游客</span>
                        <strong>{{ order.visitorName }}</strong>
                      </div>
                      <div class="detail-item">
                        <el-icon>
                          <Phone />
                        </el-icon>
                        <span>联系电话</span>
                        <strong>{{ order.visitorPhone }}</strong>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="price-section">
                  <div class="price-label">订单总额</div>
                  <div class="price-amount">¥{{ order.totalAmount }}</div>
                </div>
              </div>

              <div class="order-footer">
                <div class="payment-info" v-if="order.paymentTime">
                  <el-icon>
                    <CreditCard />
                  </el-icon>
                  <span>支付时间: {{ formatTime(order.paymentTime) }}</span>
                </div>
                <div class="order-actions">
                  <el-button v-if="order.status === 0" type="primary" @click="payOrder(order)"
                    class="action-btn pay-btn">
                    <el-icon>
                      <CreditCard />
                    </el-icon>
                    去支付
                  </el-button>
                  <el-button v-if="order.status === 0" type="danger" @click="cancelOrder(order.id)"
                    class="action-btn cancel-btn">
                    <el-icon>
                      <Close />
                    </el-icon>
                    取消订单
                  </el-button>
                  <el-button @click="viewOrderDetail(order.id)" class="action-btn detail-btn">
                    <el-icon>
                      <View />
                    </el-icon>
                    查看详情
                  </el-button>
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
    </div>

    <!-- 支付对话框 -->
    <el-dialog title="订单支付" v-model="payDialogVisible" width="500px" :close-on-click-modal="false">
      <div class="pay-dialog-content" v-if="currentOrder">
        <div class="order-info">
          <p><strong>订单号:</strong> {{ currentOrder.orderNo }}</p>
          <p><strong>门票名称:</strong> {{ currentOrder.ticketName }}</p>
          <p><strong>游玩日期:</strong> {{ formatDate(currentOrder.visitDate) }}</p>
          <p><strong>数量:</strong> {{ currentOrder.quantity }}</p>
          <p><strong>总金额:</strong> <span class="amount">¥{{ currentOrder.totalAmount }}</span></p>
        </div>
        <div class="payment-methods">
          <h4>请选择支付方式</h4>
          <el-radio-group v-model="paymentMethod">
            <el-radio label="WECHAT">微信支付</el-radio>
            <el-radio label="ALIPAY">支付宝</el-radio>
            <el-radio label="BANK_CARD">银行卡</el-radio>
          </el-radio-group>
        </div>

      </div>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="payDialogVisible = false">取消</el-button>
          <template v-if="paymentMethod === 'ALIPAY'">
            <el-button type="primary" @click="goToAlipay">去支付</el-button>
          </template>
          <template v-else>
            <el-button type="primary" @click="confirmPayment">确认已支付</el-button>
          </template>
        </span>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog title="订单详情" v-model="detailDialogVisible" width="600px">
      <div class="order-detail" v-if="currentOrder">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="订单号">{{ currentOrder.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="门票名称">{{ currentOrder.ticketName }}</el-descriptions-item>
          <el-descriptions-item label="景点名称">{{ currentOrder.scenicName }}</el-descriptions-item>
          <el-descriptions-item label="游玩日期">{{ formatDate(currentOrder.visitDate) }}</el-descriptions-item>
          <el-descriptions-item label="购买数量">{{ currentOrder.quantity }}</el-descriptions-item>
          <el-descriptions-item label="订单金额">¥{{ currentOrder.totalAmount }}</el-descriptions-item>
          <el-descriptions-item label="游客姓名">{{ currentOrder.visitorName }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ currentOrder.visitorPhone }}</el-descriptions-item>
          <el-descriptions-item label="身份证号">
            {{ currentOrder.idCard || '未提供' }}
          </el-descriptions-item>
          <el-descriptions-item label="订单状态">
            {{ getOrderStatusText(currentOrder.status) }}
          </el-descriptions-item>
          <el-descriptions-item label="下单时间">
            {{ formatTime(currentOrder.createTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="支付时间" v-if="currentOrder.paymentTime">
            {{ formatTime(currentOrder.paymentTime) }}
          </el-descriptions-item>
          <el-descriptions-item label="支付方式" v-if="currentOrder.paymentMethod">
            {{ getPaymentMethodText(currentOrder.paymentMethod) }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import request from '@/utils/request'


const router = useRouter()

// 分页参数
const currentPage = ref(1)
const pageSize = ref(12)
const total = ref(0)

// 订单列表数据
const orderList = ref([])
const loading = ref(false)
const activeTab = ref('all')

// 对话框控制
const payDialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentOrder = ref(null)
const paymentMethod = ref('')

// 订单统计数据 - 改为从后端获取
const orderStats = ref({
  total: 0,
  pending: 0,
  paid: 0,
  cancelled: 0,
  refunded: 0,
  completed: 0
})

// 获取用户订单统计信息
const fetchOrderStats = async () => {
  try {
    await request.get('/order/my/stats', {}, {
      showDefaultMsg: false,
      onSuccess: (res) => {
        orderStats.value = res || {
          total: 0,
          pending: 0,
          paid: 0,
          cancelled: 0,
          refunded: 0,
          completed: 0
        }
      }
    })
  } catch (error) {
    console.error('获取订单统计失败:', error)
  }
}

// 获取状态样式类
const getStatusClass = (status) => {
  const statusMap = {
    0: 'pending',
    1: 'paid',
    2: 'cancelled',
    3: 'refunded',
    4: 'completed'
  }
  return statusMap[status] || 'default'
}

// 跳转到门票列表
const goToTicketList = () => {
  router.push('/ticket')
}

// 获取订单列表
const fetchOrders = async () => {
  loading.value = true
  try {
    const status = activeTab.value === 'all' ? '' : activeTab.value

    await request.get('/order/my', {
      status,
      currentPage: currentPage.value,
      size: pageSize.value
    }, {
      showDefaultMsg: false,
      onSuccess: (res) => {
        orderList.value = res?.records || []
        total.value = res?.total || 0
      }
    })
  } catch (error) {
    console.error('获取订单列表失败:', error)
    orderList.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

// 分页变化事件
const handleCurrentChange = (page) => {
  currentPage.value = page
  fetchOrders()
}

// 标签页切换事件
const handleTabClick = () => {
  currentPage.value = 1
  fetchOrders()
}

// 获取订单状态文本
const getOrderStatusText = (status) => {
  const statusMap = {
    0: '待支付',
    1: '已支付',
    2: '已取消',
    3: '已退款',
    4: '已完成'
  }
  return statusMap[status] || '未知状态'
}

// 获取支付方式文本
const getPaymentMethodText = (method) => {
  const methodMap = {
    'WECHAT': '微信支付',
    'ALIPAY': '支付宝',
    'BANK_CARD': '银行卡'
  }
  return methodMap[method] || '未知方式'
}

// 格式化日期
const formatDate = (dateStr) => {
  if (!dateStr) return ''
  const date = new Date(dateStr)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

// 格式化时间
const formatTime = (timeStr) => {
  if (!timeStr) return ''
  const date = new Date(timeStr)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')} ${String(date.getHours()).padStart(2, '0')}:${String(date.getMinutes()).padStart(2, '0')}:${String(date.getSeconds()).padStart(2, '0')}`
}

// 支付订单
const payOrder = (order) => {
  if (!order || !order.id) {
    ElMessage.error('订单数据无效')
    return
  }
  currentOrder.value = order
  paymentMethod.value = '' // 重置支付方式选择
  payDialogVisible.value = true
}

// 确认支付
const confirmPayment = async () => {
  if (!paymentMethod.value) {
    ElMessage.warning('请选择支付方式')
    return
  }

  if (!currentOrder.value || !currentOrder.value.id) {
    ElMessage.error('订单数据无效')
    payDialogVisible.value = false
    return
  }

  loading.value = true
  try {
    await request.post(`/order/${currentOrder.value.id}/pay`, null, {
      params: {
        paymentMethod: paymentMethod.value
      },
      successMsg: '支付成功',
      onSuccess: () => {
        payDialogVisible.value = false
        fetchOrders()  // 重新加载订单列表
      }
    })
  } catch (error) {
    console.error('支付订单失败:', error)
  } finally {
    loading.value = false
  }
}

// 跳转到支付宝支付页面
const goToAlipay = () => {
  if (currentOrder.value && currentOrder.value.id) {
    payDialogVisible.value = false;
    router.push(`/payment/alipay/${currentOrder.value.id}`)
  } else {
    ElMessage.error('订单信息错误')
  }
}

// 取消订单
const cancelOrder = async (orderId) => {
  ElMessageBox.confirm('确定要取消该订单吗？', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    loading.value = true
    try {
      await request.post(`/order/${orderId}/cancel`, {}, {
        successMsg: '订单已取消',
        onSuccess: () => {
          fetchOrders()  // 重新加载订单列表
        }
      })
    } catch (error) {
      console.error('取消订单失败:', error)
    } finally {
      loading.value = false
    }
  }).catch(() => { })
}

// 查看订单详情
const viewOrderDetail = async (orderId) => {
  loading.value = true
  try {
    await request.get(`/order/${orderId}`, {}, {
      showDefaultMsg: false,
      onSuccess: (res) => {
        if (res) {
          currentOrder.value = res
          detailDialogVisible.value = true
        } else {
          ElMessage.error('获取订单详情失败')
        }
      }
    })
  } catch (error) {
    console.error('获取订单详情失败:', error)
    ElMessage.error('获取订单详情失败')
  } finally {
    loading.value = false
  }
}

// 页面加载时获取订单列表
onMounted(() => {
  // 页面加载时获取统计数据和订单列表
  fetchOrderStats()
  fetchOrders()
})
</script>

<style lang="scss" scoped>
.orders-container {
  min-height: 100vh;
  font-family: "PingFang SC", "Helvetica Neue", Helvetica, Arial, "Microsoft YaHei", sans-serif;
  color: #1a202c;

  // Hero顶部区域
  .page-hero {
    position: relative;
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    padding: 40px 0 30px;
    overflow: hidden;
    border-radius: 24px;

    &::before {
      content: '';
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.15)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.15)"/><circle cx="50" cy="10" r="0.8" fill="rgba(255,255,255,0.1)"/><circle cx="20" cy="60" r="0.8" fill="rgba(255,255,255,0.1)"/><circle cx="80" cy="40" r="0.8" fill="rgba(255,255,255,0.1)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
      opacity: 0.3;
    }
  }

  .hero-content {
    position: relative;
    z-index: 1;
    max-width: 1300px;
    margin: 0 auto;
    padding: 0 20px;
    color: white;
  }

  .breadcrumb {
    margin-bottom: 20px;

    :deep(.el-breadcrumb__item) {
      .el-breadcrumb__inner {
        color: rgba(255, 255, 255, 0.8);
        cursor: pointer;

        &:hover {
          color: white;
        }
      }

      &:last-child .el-breadcrumb__inner {
        color: white;
      }
    }

    :deep(.el-breadcrumb__separator) {
      color: rgba(255, 255, 255, 0.6);
    }
  }

  .page-title {
    font-size: 36px;
    font-weight: 800;
    margin: 0 0 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 12px;
    text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  }

  .title-icon {
    width: 36px;
    height: 36px;
    flex-shrink: 0;
  }

  .page-subtitle {
    font-size: 16px;
    opacity: 0.9;
    margin: 0;
    text-align: center;
  }

  // 通用容器样式
  .section-container {
    max-width: 1300px;
    margin: 0 auto;
    padding: 40px 20px;
  }




  // 订单区域
  .orders-section {
    padding: 20px 0 60px;
  }

  .glass-card {
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-radius: 24px;
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
    overflow: hidden;
  }

  .glass-card-inner {
    background: rgba(255, 255, 255, 0.15);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
    border-radius: 24px;
    border: 1px solid rgba(255, 255, 255, 0.5);
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
  }

  // 现代化标签页样式
  .modern-tabs {
    :deep(.el-tabs__header) {
      margin: 0;
      background: linear-gradient(135deg, rgba(103, 182, 245, 0.05) 0%, rgba(90, 169, 230, 0.05) 100%);
      border-bottom: 1px solid rgba(103, 182, 245, 0.2);
    }

    :deep(.el-tabs__nav-wrap) {
      padding: 0 24px;
    }

    :deep(.el-tabs__item) {
      padding: 20px 0;
      font-size: 16px;
      font-weight: 600;
      color: #5a6c7d;
      border: none;
      margin-right: 40px;

      &.is-active {
        color: #67b6f5;
      }

      &:hover {
        color: #67b6f5;
      }
    }

    :deep(.el-tabs__active-bar) {
      background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
      height: 3px;
      border-radius: 3px;
    }

    :deep(.el-tabs__content) {
      padding: 40px 24px;
    }

    .tab-label {
      display: flex;
      align-items: center;
      gap: 8px;

      .tab-count {
        background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
        color: white;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 12px;
        font-weight: 600;
      }
    }
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
      font-size: 64px;
      margin-bottom: 20px;
    }

    .empty-title {
      font-size: 24px;
      font-weight: 600;
      color: #2d3748;
      margin: 0 0 8px;
    }

    .empty-desc {
      font-size: 16px;
      color: #64748b;
      margin: 0 0 24px;
    }

    .empty-action {
      background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
      border: none;
      border-radius: 12px;
      padding: 12px 32px;
      font-weight: 600;
      box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);
      transition: all 0.3s ease;

      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 25px rgba(103, 182, 245, 0.4);
      }
    }
  }

  // 订单列表
  .orders-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
  }

  .order-card {
    overflow: hidden;
    transition: all 0.3s ease;

    &:hover {
      transform: translateY(-4px);
      box-shadow: 0 12px 40px rgba(103, 182, 245, 0.2);
    }
  }

  .order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 24px;
    background: linear-gradient(135deg, rgba(103, 182, 245, 0.08) 0%, rgba(90, 169, 230, 0.08) 100%);
    border-bottom: 1px solid rgba(103, 182, 245, 0.2);

    .order-info {
      .order-no {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 16px;
        font-weight: 600;
        color: #1a202c;
        margin-bottom: 4px;

        .el-icon {
          color: #67b6f5;
        }
      }

      .order-time {
        font-size: 12px;
        color: #5a6c7d;
      }
    }

    .order-status-badge {
      padding: 6px 16px;
      border-radius: 20px;
      font-size: 13px;
      font-weight: 600;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);

      &.pending {
        background: linear-gradient(135deg, #f59e0b, #d97706);
        color: white;
      }

      &.paid {
        background: linear-gradient(135deg, #10b981, #059669);
        color: white;
      }

      &.cancelled {
        background: linear-gradient(135deg, #ef4444, #dc2626);
        color: white;
      }

      &.refunded {
        background: linear-gradient(135deg, #8b5cf6, #7c3aed);
        color: white;
      }

      &.completed {
        background: linear-gradient(135deg, #06b6d4, #0891b2);
        color: white;
      }
    }
  }

  .order-content {
    padding: 24px;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    gap: 24px;
  }

  .ticket-section {
    flex: 1;

    .ticket-main {
      margin-bottom: 16px;

      .ticket-name {
        font-size: 20px;
        font-weight: 700;
        color: #1a202c;
        margin: 0 0 8px;
        line-height: 1.3;
      }

      .scenic-info {
        display: flex;
        align-items: center;
        gap: 6px;
        font-size: 14px;
        color: #5a6c7d;

        .el-icon {
          color: #67b6f5;
        }
      }
    }

    .order-details {
      .detail-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px;
        margin-bottom: 12px;

        &:last-child {
          margin-bottom: 0;
        }
      }

      .detail-item {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        color: #5a6c7d;

        .el-icon {
          color: #67b6f5;
          flex-shrink: 0;
        }

        strong {
          color: #1a202c;
          font-weight: 600;
          margin-left: auto;
        }
      }
    }
  }

  .price-section {
    text-align: right;
    flex-shrink: 0;

    .price-label {
      font-size: 14px;
      color: #5a6c7d;
      margin-bottom: 4px;
    }

    .price-amount {
      font-size: 28px;
      font-weight: 700;
      background: linear-gradient(135deg, #f56565, #e53e3e);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
    }
  }

  .order-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px 24px;
    background: linear-gradient(135deg, rgba(103, 182, 245, 0.05) 0%, rgba(90, 169, 230, 0.05) 100%);
    border-top: 1px solid rgba(103, 182, 245, 0.2);

    .payment-info {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 12px;
      color: #5a6c7d;

      .el-icon {
        color: #67b6f5;
      }
    }

    .order-actions {
      display: flex;
      gap: 8px;

      .action-btn {
        border-radius: 12px;
        font-weight: 600;
        transition: all 0.3s ease;

        &.pay-btn {
          background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
          border: none;
          color: white;
          box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);

          &:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(103, 182, 245, 0.4);
          }
        }

        &.cancel-btn {
          background: linear-gradient(135deg, #f56565, #e53e3e);
          border: none;
          color: white;
          box-shadow: 0 6px 20px rgba(245, 101, 101, 0.3);

          &:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(245, 101, 101, 0.4);
          }
        }

        &.detail-btn {
          background: rgba(255, 255, 255, 0.6);
          backdrop-filter: blur(10px);
          border: 2px solid rgba(103, 182, 245, 0.2);
          color: #5a6c7d;

          &:hover {
            border-color: #67b6f5;
            color: #67b6f5;
            background: rgba(255, 255, 255, 0.8);
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
        margin: 0 4px;
        transition: all 0.3s ease;

        &:hover {
          background: #67b6f5;
          color: white;
        }

        &.is-active {
          background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
          color: white;
          box-shadow: 0 4px 12px rgba(103, 182, 245, 0.3);
        }
      }

      .btn-prev,
      .btn-next {
        border-radius: 12px;
        transition: all 0.3s ease;

        &:hover {
          background: #67b6f5;
          color: white;
        }
      }
    }
  }


  .hover-lift {
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }

  // 延迟动画类
  .delay-100 {
    animation-delay: 0.1s;
  }

  .delay-200 {
    animation-delay: 0.2s;
  }

  .delay-300 {
    animation-delay: 0.3s;
  }

  .delay-400 {
    animation-delay: 0.4s;
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



}
</style>