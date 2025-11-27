// 判断是否为OSS链接
export function isOssUrl(url) {
  if (!url) return false;
  return url.startsWith('http://') || url.startsWith('https://');
}

// 获取图片显示路径
export function getImageUrl(path) {
  if (!path) return '';

  // OSS链接直接返回
  if (isOssUrl(path)) {
    return path;
  }

  // 兼容旧数据：本地路径也直接返回（OSS迁移期间）
  return path;
}
