import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import { VitePWA } from 'vite-plugin-pwa';

// https://astro.build/config
export default defineConfig({
  output: 'static',
  integrations: [
    react({
      include: ['**/react/*'],
    }),
    VitePWA({
      registerType: 'autoUpdate',
      injectRegister: 'auto',
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg,webp,woff,woff2,json}'],
        // Maximize cache size limits for comprehensive offline image availability
        maximumFileSizeToCacheInBytes: 15 * 1024 * 1024, // 15MB
        runtimeCaching: [
          {
            urlPattern: /^https:\/\/backend-nookipedia\.2\.godsize\.info\/assets\/.*/i,
            handler: 'CacheFirst',
            options: {
              cacheName: 'nookipedia-directus-images',
              expiration: {
                maxEntries: 500,
                maxAgeSeconds: 30 * 24 * 60 * 60, // 30 days
              },
              cacheableResponse: {
                statuses: [0, 200],
              },
            },
          },
        ],
      },
      manifest: {
        name: 'Nookipedia Next-Level',
        short_name: 'Nookipedia',
        description: 'Das ultimative, superschnelle Animal Crossing Wiki für die Hosentasche',
        theme_color: '#1a5c3e',
        background_color: '#121212',
        display: 'standalone',
        orientation: 'portrait',
        start_url: '/',
        icons: [
          {
            src: '/assets/img/icon-192x192.png',
            sizes: '192x192',
            type: 'image/png'
          },
          {
            src: '/assets/img/icon-512x512.png',
            sizes: '512x512',
            type: 'image/png'
          },
          {
            src: '/assets/img/icon-512x512.png',
            sizes: '512x512',
            type: 'image/png',
            purpose: 'any maskable'
          }
        ]
      }
    })
  ]
});
