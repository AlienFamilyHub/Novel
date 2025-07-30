# =================================================================
# Stage 1: Build
# =================================================================
FROM node:24-alpine3.21 AS builder

RUN npm install -g pnpm

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN pnpm install --frozen-lockfile

RUN pnpm approve-builds

COPY . .

RUN pnpm build

# =================================================================
# Stage 2: Production
# =================================================================
FROM nginx:stable-alpine

COPY --from=builder /app/public /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
