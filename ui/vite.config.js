// vite.config.ts
import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import AutoImport from 'unplugin-auto-import/vite'
import Components from 'unplugin-vue-components/vite'
import { NaiveUiResolver } from 'unplugin-vue-components/resolvers'
import fs from 'node:fs'
import path from 'node:path'
import https from 'node:https'

// https://vitejs.dev/config/
export default defineConfig(({ command }) => {
  return {
    base: './',
    server: {
      proxy: {
        '/session': {
          target: 'http://127.0.0.1:8080',
          ws: true
        },
        '/method': {
          target: 'http://127.0.0.1:8080',
          ws: true
        }
      }
    },
    resolve: {
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url))
      }
    },
    plugins: [
      vue(),
      AutoImport({
        imports: [
          'vue',
          {
            'naive-ui': ['useDialog', 'useMessage', 'useNotification', 'useLoadingBar']
          }
        ]
      }),
      {
        name: 'build-script',
        async buildStart(options) {
          if (command === 'build') {
            const dirPath = path.join(__dirname, 'public')
            const fileBuildRequired = {
              'speedtest_worker.js': path.join('..', 'speedtest', 'speedtest_worker.js')
            }
            const remoteFallback = process.env.SPEEDTEST_WORKER_URL || 'https://raw.githubusercontent.com/librespeed/speedtest/master/speedtest_worker.js'

            const download = (url, destination) => new Promise((resolve, reject) => {
              const file = fs.createWriteStream(destination)
              https.get(url, (response) => {
                if (response.statusCode !== 200) {
                  reject(new Error(`unexpected status ${response.statusCode} while downloading ${url}`))
                  response.resume()
                  return
                }
                response.pipe(file)
                file.on('finish', () => file.close(resolve))
              }).on('error', (err) => {
                reject(err)
              })
            })

            for (const [dest, relativeSource] of Object.entries(fileBuildRequired)) {
              const destPath = path.join(dirPath, dest)
              const sourcePath = path.join(dirPath, relativeSource)

              if (!fs.existsSync(sourcePath)) {
                console.warn(`[build-script] ${sourcePath} missing, fetching ${remoteFallback}`)
                try {
                  await download(remoteFallback, destPath)
                  continue
                } catch (error) {
                  console.warn(`[build-script] failed to download worker: ${error.message}`)
                  continue
                }
              }

              if (fs.existsSync(destPath)) {
                fs.unlinkSync(destPath)
              }
              fs.copyFileSync(sourcePath, destPath)
            }
          }
        },
      },
      Components({
        resolvers: [NaiveUiResolver()]
      })
    ]
  }
})
