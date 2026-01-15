# -------- Base image --------
FROM node:20-alpine AS base
WORKDIR /app

# -------- Dependencies --------
FROM base AS deps
COPY package*.json ./
RUN npm ci

# -------- Build --------
FROM base AS build
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run build

# -------- Production --------
FROM node:20-alpine AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV HOST=0.0.0.0
ENV PORT=3000

# Nuxt build is standalone - only need .output
COPY --from=build /app/.output ./.output

EXPOSE 3000

CMD ["node", ".output/server/index.mjs"]
