const { defineConfig } = require('@vue/cli-service');
module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: '/',
  outputDir: 'dist',
  assetsDir: 'static',
  devServer: {
    proxy: {
      '/api': {
        target: 'http://localhost:1236',
        changeOrigin: true,
        // pathRewrite: {
        //   '^/api': ''
        // }
      },
    },
    client: {
      overlay: false,
    },
  },
});
