<<<<<<< HEAD
const { defineConfig } = require('@vue/cli-service');
module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: '/',
  outputDir: 'dist',
  assetsDir: 'static',
=======
const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
>>>>>>> d8bcea05440b3cc1e83e15c8380c711dc7411ddd
  devServer: {
    proxy: {
      '/api': {
        target: 'http://localhost:1236',
        changeOrigin: true,
        // pathRewrite: {
        //   '^/api': ''
        // }
<<<<<<< HEAD
      },
    },
    client: {
      overlay: false,
    },
  },
});
=======
      }
    },
    client: {
      overlay:false
    }
  }
})
>>>>>>> d8bcea05440b3cc1e83e15c8380c711dc7411ddd
