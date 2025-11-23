<!-- eslint-disable -->
<template>
  <div class="guide-edit-container">
    <!-- Hero头部区域 -->
    <div class="page-hero">
      <div class="hero-background">
        <div class="hero-gradient"></div>
      </div>
      <div class="hero-content">
        <div class="hero-icon-wrapper">
          <svg class="hero-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
            stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
            <polyline points="14 2 14 8 20 8"></polyline>
            <line x1="16" y1="13" x2="8" y2="13"></line>
            <line x1="16" y1="17" x2="8" y2="17"></line>
            <polyline points="10 9 9 9 8 9"></polyline>
          </svg>
        </div>
        <h1 class="hero-title">{{ form.id ? '编辑攻略' : '发布新攻略' }}</h1>
        <p class="hero-subtitle">分享您的旅行经历，帮助更多人探索世界的美好</p>
      </div>
    </div>

    <!-- 编辑表单区域 -->
    <div class="edit-content">
      <div class="content-container">
        <div class="edit-form-card glass-card">
          <el-form :model="form" label-width="100px" ref="formRef" class="edit-form">
            <el-form-item label="攻略标题" prop="title" required>
              <el-input v-model="form.title" placeholder="请输入攻略标题（建议30字以内）" maxlength="50" show-word-limit size="large"
                class="modern-input">
                <template #prefix>
                  <svg class="input-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="4" y1="9" x2="20" y2="9"></line>
                    <line x1="4" y1="15" x2="20" y2="15"></line>
                    <line x1="10" y1="3" x2="8" y2="21"></line>
                    <line x1="16" y1="3" x2="14" y2="21"></line>
                  </svg>
                </template>
              </el-input>
            </el-form-item>

            <el-form-item label="封面图片" prop="coverImage" required>
              <div class="cover-uploader-container">
                <el-upload class="cover-uploader" action="#" :show-file-list="false" :http-request="customUploadCover"
                  :before-upload="beforeCoverUpload">
                  <div v-if="form.coverImage" class="cover-preview-container">
                    <img :src="getImageUrl(form.coverImage)" class="cover-preview" />
                    <div class="cover-hover-mask">
                      <el-icon class="upload-icon">
                        <EditPen />
                      </el-icon>
                      <span>更换封面</span>
                    </div>
                  </div>
                  <div v-else class="upload-placeholder">
                    <el-icon class="upload-icon">
                      <Plus />
                    </el-icon>
                    <span class="upload-text">上传封面图片</span>
                    <div class="upload-tip">推荐尺寸: 900×600px, JPG/PNG格式, 不超过2MB</div>
                  </div>
                </el-upload>
                <div class="form-tips" v-if="!form.coverImage">
                  <svg class="tip-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="16" x2="12" y2="12"></line>
                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                  </svg>
                  添加一张精美的封面图能吸引更多读者
                </div>
              </div>
            </el-form-item>

            <el-form-item label="攻略内容" prop="content" required>
              <div class="editor-container">
                <WangEditor v-model="form.content" />
                <div class="form-tips">
                  <svg class="tip-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none"
                    stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="16" x2="12" y2="12"></line>
                    <line x1="12" y1="8" x2="12.01" y2="8"></line>
                  </svg>
                  支持Markdown格式、富文本编辑，可插入图片、视频等多媒体内容
                </div>
              </div>
            </el-form-item>

            <el-form-item>
              <div class="form-actions">
                <el-button size="large" @click="goBack" class="cancel-btn">
                  <el-icon>
                    <Close />
                  </el-icon>
                  取消
                </el-button>
                <el-button size="large" type="primary" @click="submit" :loading="submitting" class="submit-btn">
                  <el-icon v-if="!submitting">
                    <Check />
                  </el-icon>
                  {{ form.id ? '保存修改' : '发布攻略' }}
                </el-button>
              </div>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import WangEditor from '@/components/WangEditor.vue'
import request from '@/utils/request'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/store/user'
import { Plus, EditPen, Check, Close } from '@element-plus/icons-vue'


const baseAPI = process.env.VUE_APP_BASE_API || '/api'
const form = reactive({
  title: '',
  coverImage: '',
  content: '',
  id: ''
})
const formRef = ref(null)
const route = useRoute()
const router = useRouter()
const submitting = ref(false)
const userStore = useUserStore()

// 获取图片完整URL
const getImageUrl = (url) => {
  if (!url) return ''
  return url.startsWith('http') ? url : baseAPI + url
}

onMounted(async () => {
  if (route.query.id) {
    try {
      await request.get(`/guide/${route.query.id}`, {}, {
        showDefaultMsg: false,
        onSuccess: (res) => {
          form.title = res.title
          form.coverImage = res.coverImage
          form.content = res.content
          form.id = res.id
        }
      })
    } catch (error) {
      ElMessage.error('获取攻略信息失败')
      console.error('获取攻略信息失败', error)
    }
  }
})

const beforeCoverUpload = (file) => {
  const isJPG = file.type === 'image/jpeg'
  const isPNG = file.type === 'image/png'
  const isLt2M = file.size / 1024 / 1024 < 2
  if (!isJPG && !isPNG) {
    ElMessage.error('封面只能是 JPG 或 PNG 格式!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('封面大小不能超过 2MB!')
    return false
  }
  return true
}

const customUploadCover = async (options) => {
  try {
    const { file } = options
    const formData = new FormData()
    formData.append('file', file)
    await request.post('/file/upload/img', formData, {
      headers: { token: localStorage.getItem('token') || '' },
      transformRequest: [(data) => data],
      successMsg: '封面上传成功',
      errorMsg: '封面上传失败',
      onSuccess: (data) => {
        form.coverImage = data
        options.onSuccess({ data })
      },
      onError: (error) => {
        options.onError(new Error(error.message || '上传失败'))
      }
    })
  } catch (error) {
    options.onError(error)
  }
}

const submit = async () => {
  if (!form.title.trim()) {
    return ElMessage.warning('请输入攻略标题')
  }

  if (!form.coverImage) {
    return ElMessage.warning('请上传攻略封面图片')
  }

  if (!form.content || form.content === '<p><br></p>') {
    return ElMessage.warning('请填写攻略内容')
  }

  submitting.value = true
  form.userId = userStore.userInfo.id
  try {
    if (form.id) {
      await request.put('/guide/update', form, {
        successMsg: '修改成功',
        onSuccess: () => {
          router.push({ name: 'MyGuideList' })
        }
      })
    } else {
      await request.post('/guide/add', form, {
        successMsg: '发布成功',
        onSuccess: () => {
          form.title = ''
          form.coverImage = ''
          form.content = ''
          router.push({ name: 'MyGuideList' })
        }
      })
    }
  } catch (error) {
    console.error('提交失败', error)
  } finally {
    submitting.value = false
  }
}

const goBack = () => {
  router.back()
}
</script>

<style lang="scss" scoped>
.guide-edit-container {
  min-height: 100vh;
  font-family: "PingFang SC", "Helvetica Neue", Helvetica, Arial, "Microsoft YaHei", sans-serif;
  color: #1a202c;
}

// Hero头部区域
.page-hero {
  position: relative;
  height: 200px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: -60px;
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
  margin-bottom: 16px;
}

.hero-icon {
  width: 64px;
  height: 64px;
  color: #67b6f5;
  filter: drop-shadow(0 4px 8px rgba(103, 182, 245, 0.3));
}

.hero-title {
  font-size: 36px;
  font-weight: 800;
  margin: 0 0 12px;
  color: #1a202c;
  letter-spacing: 1px;
}

.hero-subtitle {
  font-size: 16px;
  margin: 0;
  color: #5a6c7d;
  font-weight: 400;
}

// 编辑内容区域
.edit-content {
  position: relative;
  z-index: 2;
  padding: 40px 0 80px;
}

.content-container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 0 20px;
}

.edit-form-card {
  padding: 40px;
  padding-right: 75px;
}

.glass-card {
  margin: 25px 0px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(20px) saturate(180%);
  -webkit-backdrop-filter: blur(20px) saturate(180%);
  border-radius: 24px;
  border: 1px solid rgba(255, 255, 255, 0.5);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;

  &:hover {
    box-shadow: 0 12px 40px rgba(103, 182, 245, 0.15);
  }
}

.cover-uploader-container {
  width: 100%;
}

.cover-uploader {
  :deep(.el-upload) {
    cursor: pointer;
    position: relative;
    overflow: hidden;
    transition: all 0.3s;
    width: 100%;
  }

  .cover-preview-container {
    position: relative;
    width: 100%;
    max-width: 500px;
    height: 280px;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    transition: all 0.3s ease;

    &:hover {
      box-shadow: 0 12px 40px rgba(103, 182, 245, 0.25);
      transform: translateY(-4px);

      .cover-hover-mask {
        opacity: 1;
      }
    }

    .cover-preview {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .cover-hover-mask {
      position: absolute;
      top: 0;
      left: 0;
      right: 0;
      bottom: 0;
      background: linear-gradient(135deg, rgba(103, 182, 245, 0.9) 0%, rgba(90, 169, 230, 0.9) 100%);
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      opacity: 0;
      transition: opacity 0.3s;
      color: #fff;

      .upload-icon {
        font-size: 32px;
        margin-bottom: 12px;
      }

      span {
        font-size: 16px;
        font-weight: 600;
      }
    }
  }

  .upload-placeholder {
    width: 100%;
    max-width: 500px;
    height: 280px;
    border: 2px dashed rgba(103, 182, 245, 0.3);
    border-radius: 20px;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    color: #5a6c7d;
    transition: all 0.3s;
    background: linear-gradient(135deg, rgba(103, 182, 245, 0.03) 0%, rgba(255, 193, 124, 0.03) 100%);

    &:hover {
      border-color: #67b6f5;
      background: linear-gradient(135deg, rgba(103, 182, 245, 0.08) 0%, rgba(255, 193, 124, 0.08) 100%);
      box-shadow: 0 8px 24px rgba(103, 182, 245, 0.15);
      transform: translateY(-4px);

      .upload-icon {
        color: #67b6f5;
        transform: scale(1.1);
      }

      .upload-text {
        color: #67b6f5;
      }
    }

    .upload-icon {
      font-size: 48px;
      margin-bottom: 16px;
      color: #67b6f5;
      transition: all 0.3s ease;
    }

    .upload-text {
      font-size: 16px;
      font-weight: 600;
      margin-bottom: 8px;
      transition: color 0.3s ease;
    }

    .upload-tip {
      font-size: 13px;
      margin-top: 8px;
      color: #94a3b8;
      text-align: center;
      line-height: 1.5;
    }
  }
}

.form-tips {
  font-size: 14px;
  color: #5a6c7d;
  margin-top: 12px;
  line-height: 1.6;
  display: flex;
  align-items: flex-start;
  gap: 8px;
  padding: 12px 16px;
  background: linear-gradient(135deg, rgba(103, 182, 245, 0.05) 0%, rgba(255, 193, 124, 0.05) 100%);
  border-radius: 12px;
  border-left: 3px solid #67b6f5;

  .tip-icon {
    width: 16px;
    height: 16px;
    color: #67b6f5;
    flex-shrink: 0;
    margin-top: 2px;
  }
}

.editor-container {
  :deep(.w-e-text-container) {
    transition: all 0.3s ease;
  }

  :deep(.w-e-toolbar) {
    border-radius: 16px 16px 0 0;
    border-bottom: 2px solid rgba(103, 182, 245, 0.1);
    background: linear-gradient(135deg, rgba(103, 182, 245, 0.03) 0%, rgba(255, 193, 124, 0.03) 100%);
  }

  // 修复编辑器内容溢出问题
  :deep(.w-e-text-container [data-slate-editor]) {
    word-wrap: break-word;
    word-break: break-all;
    overflow-wrap: break-word;
    white-space: pre-wrap;
  }

  :deep(.w-e-text-container p) {
    word-wrap: break-word;
    word-break: break-all;
    overflow-wrap: break-word;
    white-space: pre-wrap;
  }

  :deep(.w-e-text-container) {
    overflow-x: hidden;
    overflow-y: auto;
  }
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 16px;
  margin-top: 20px;

  .el-button {
    min-width: 140px;
    border-radius: 25px;
    font-weight: 600;
    padding: 12px 32px;
    transition: all 0.3s ease;
  }

  .cancel-btn {
    border: 2px solid rgba(103, 182, 245, 0.3);
    color: #67b6f5;
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(10px);
    -webkit-backdrop-filter: blur(10px);

    &:hover {
      border-color: #67b6f5;
      background: rgba(103, 182, 245, 0.1);
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(103, 182, 245, 0.2);
    }
  }

  .submit-btn {
    background: linear-gradient(135deg, #67b6f5 0%, #5aa9e6 100%);
    border: none;
    box-shadow: 0 6px 20px rgba(103, 182, 245, 0.3);

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

// 响应式设计
@media (max-width: 768px) {
  .page-hero {
    height: 160px;
    margin-bottom: -40px;
  }

  .hero-icon {
    width: 48px;
    height: 48px;
  }

  .hero-title {
    font-size: 28px;
  }

  .hero-subtitle {
    font-size: 14px;
  }

  .edit-content {
    padding: 20px 0 40px;
  }

  .content-container {
    padding: 0 16px;
  }

  .edit-form-card {
    padding: 24px 20px;
  }

  .cover-uploader {

    .cover-preview-container,
    .upload-placeholder {
      max-width: 100%;
      height: 220px;
    }
  }

  .form-actions {
    flex-direction: column-reverse;
    gap: 12px;

    .el-button {
      width: 100%;
      margin: 0;
    }
  }

  .editor-container {
    :deep(.w-e-text-container) {
      min-height: 300px;
    }
  }
}

@media (max-width: 480px) {
  .hero-title {
    font-size: 24px;
  }

  .edit-form {
    :deep(.el-form-item__label) {
      font-size: 14px;
    }
  }

  .cover-uploader {

    .cover-preview-container,
    .upload-placeholder {
      height: 180px;
    }

    .upload-placeholder {
      .upload-icon {
        font-size: 36px;
      }

      .upload-text {
        font-size: 14px;
      }

      .upload-tip {
        font-size: 12px;
      }
    }
  }
}
</style>