// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },
  css: ['~/assets/css/main.css'],

  modules: [
    '@nuxt/eslint',
    '@nuxt/icon',
    '@nuxt/fonts',
    '@nuxt/ui',
    '@nuxtjs/supabase'
  ],

  supabase: {
    redirect: false // Pas de redirection auth
  },

  runtimeConfig: {
    openaiApiKey: process.env.OPENAI_API_KEY
  },

  // ========================================
  // MODE DE RENDU - Décommente UN des modes:
  // ========================================

  // MODE 1: SSR (défaut) - Rendu côté serveur
  // Le HTML est généré sur le serveur, bon pour le SEO
  ssr: true,

  // MODE 2: SPA - Single Page Application
  // Décommente cette ligne et commente ssr: true
  // ssr: false,

  // MODE 3: Hybride - Par route (avancé)
  // routeRules: {
  //   '/': { prerender: true },        // Pré-rendu statique
  //   '/animes': { ssr: true },         // SSR
  //   '/dashboard/**': { ssr: false },  // SPA (client only)
  // }
})