<template>
  <div class="category-menu">
    <div class="menu-header">
      <div class="header-icon">
        <svg viewBox="0 0 24 24" width="20" height="20" fill="currentColor">
          <path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z" />
        </svg>
      </div>
      <h3 class="menu-title">景点分类</h3>
    </div>

    <div class="category-list">
      <div class="category-item" :class="{ active: !currentCategoryId }" @click="handleCategoryClick(null)">
        <div class="item-content">
          <span class="item-text">全部分类</span>
          <div class="item-indicator"></div>
        </div>
      </div>

      <div v-for="category in categories" :key="category.id" class="category-item"
        :class="{ active: currentCategoryId === category.id }" @click="handleCategoryClick(category.id)">
        <div class="item-content">
          <span class="item-text">{{ category.name }}</span>
          <div class="item-indicator"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import request from '@/utils/request'

const props = defineProps({
  currentCategoryId: {
    type: Number,
    default: null
  }
})

const emit = defineEmits(['category-change'])

const categories = ref([])
const baseAPI = process.env.VUE_APP_BASE_API || '/api'

// 获取分类列表
const fetchCategories = async () => {
  try {
    await request.get('/scenic-category/tree', {}, {
      showDefaultMsg: false,
      onSuccess: (res) => {
        categories.value = res
      }
    })
  } catch (error) {
    console.error('获取分类列表失败:', error)
  }
}

// 点击分类
const handleCategoryClick = (categoryId) => {
  emit('category-change', categoryId)
}

onMounted(() => {
  fetchCategories()
})
</script>

<style lang="scss" scoped>
.category-menu {
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border-radius: 20px;
  padding: 24px;
  border: 1px solid rgba(255, 255, 255, 0.3);
  box-shadow: 0 8px 32px rgba(31, 38, 135, 0.1),
    0 2px 8px rgba(0, 0, 0, 0.04);
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);

  &:hover {
    box-shadow: 0 12px 48px rgba(31, 38, 135, 0.15),
      0 4px 12px rgba(0, 0, 0, 0.06);
    transform: translateY(-2px);
  }

  .menu-header {
    display: flex;
    align-items: center;
    gap: 12px;
    padding-bottom: 20px;
    margin-bottom: 16px;
    border-bottom: 2px solid transparent;
    background: linear-gradient(90deg, rgba(102, 126, 234, 0.2) 0%, transparent 100%) border-box;
    border-image-slice: 1;

    .header-icon {
      width: 36px;
      height: 36px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      border-radius: 10px;
      color: #ffffff;
      box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
    }

    .menu-title {
      font-size: 18px;
      font-weight: 600;
      margin: 0;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      -webkit-background-clip: text;
      -webkit-text-fill-color: transparent;
      background-clip: text;
      letter-spacing: 0.5px;
    }
  }

  .category-list {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .category-item {
    position: relative;
    cursor: pointer;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

    .item-content {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 14px 16px;
      border-radius: 12px;
      background: rgba(255, 255, 255, 0.4);
      backdrop-filter: blur(8px);
      border: 1px solid rgba(255, 255, 255, 0.5);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);

      .item-text {
        font-size: 15px;
        font-weight: 500;
        color: #475569;
        transition: all 0.3s ease;
        letter-spacing: 0.3px;
      }

      .item-indicator {
        width: 6px;
        height: 6px;
        border-radius: 50%;
        background: #cbd5e1;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        opacity: 0;
      }
    }

    &:hover:not(.active) {
      .item-content {
        background: rgba(102, 126, 234, 0.08);
        backdrop-filter: blur(12px);
        border-color: rgba(102, 126, 234, 0.2);
        transform: translateX(4px);

        .item-text {
          color: #667eea;
        }

        .item-indicator {
          opacity: 0.5;
          background: #667eea;
        }
      }
    }

    &.active {
      .item-content {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border-color: transparent;
        box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3),
          0 2px 8px rgba(102, 126, 234, 0.2);
        transform: translateX(6px);

        .item-text {
          color: #ffffff;
          font-weight: 600;
        }

        .item-indicator {
          opacity: 1;
          background: #ffffff;
          box-shadow: 0 0 8px rgba(255, 255, 255, 0.6);
        }
      }
    }
  }
}
</style>