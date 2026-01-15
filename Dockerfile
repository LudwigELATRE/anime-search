# -------- Base image --------
FROM node:20-alpine AS base
WORKDIR /app

# -------- Dependencies --------
FROM base AS deps
COPY package*.json ./
RUN npm ci

# -------- Build --------
FROM base AS build
ARG SUPABASE_URL
ARG SUPABASE_KEY
ARG OPENAI_API_KEY
ENV SUPABASE_URL=$SUPABASE_URL
ENV SUPABASE_KEY=$SUPABASE_KEY
ENV OPENAI_API_KEY=$OPENAI_API_KEY

COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# -------- Production --------
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

COPY --from=build /app/.output ./.output

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
