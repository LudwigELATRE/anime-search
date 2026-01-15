# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Anime Search Scan is a Nuxt 4 application that helps users find which manga chapter to start reading after finishing an anime. It features AI-powered search using GPT-4o-mini for anime data discovery.

## Commands

```bash
npm install          # Install dependencies (runs nuxt prepare as postinstall)
npm run dev          # Development server at http://localhost:3000
npm run build        # Production build
npm run preview      # Preview production build
```

## Architecture

### Frontend (app/)
- `app/app.vue` - Root layout with AppHeader and NuxtPage
- `app/pages/index.vue` - Home page with search and anime cards grid
- `app/pages/animes/[id].vue` - Anime detail page showing chapter info
- `app/components/AppHeader.vue` - Fixed header with logo
- `app/assets/css/main.css` - Design system (Japanese minimalist aesthetic)

### Backend (server/)
- `server/api/anime/search.post.ts` - Main search endpoint: queries Supabase first, falls back to GPT-4o-mini, saves new results to DB
- `server/api/anime/[id].get.ts` - Get single anime by ID
- `server/api/anime/seed.post.ts` - Bulk insert initial anime data

### Data Flow
1. User searches → `POST /api/anime/search`
2. Check Supabase `animes` table (ilike search on title)
3. If not found → GPT-4o-mini generates anime info (title, episodes, start_chapter, etc.)
4. Save to Supabase and return
5. Future searches find it in database

### Database Schema (Supabase)
```sql
CREATE TABLE animes (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL UNIQUE,
  description TEXT,
  total_episodes INTEGER NOT NULL,
  start_chapter INTEGER NOT NULL,
  total_chapters INTEGER,
  ongoing BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## Environment Variables

Copy `.env.example` to `.env`:
- `SUPABASE_URL` - Supabase project URL
- `SUPABASE_KEY` - Supabase anon key
- `OPENAI_API_KEY` - OpenAI API key (accessed via `useRuntimeConfig().openaiApiKey` server-side)

## Key Patterns

- **Server API**: Use `serverSupabaseClient(event)` from `#supabase/server` for DB access
- **Client Supabase**: Use `useSupabaseClient()` composable
- **CSS Variables**: Design tokens in `main.css` (colors: ink, paper, stone, vermillion; fonts: Syne display, Cormorant Garamond serif)
- **Responsive Breakpoints**: 768px (tablet), 480px (mobile)
- **Animations**: `.animate-fade-in` with `.animate-delay-{1-5}` classes

## Modules

- `@nuxtjs/supabase` - Database and auth
- `@nuxt/ui` - UI components (includes Tailwind)
- `@nuxt/fonts` - Font optimization
- `@nuxt/icon` - Icon components
- `@nuxt/eslint` - Linting
