# Dockerfile for KHMs PlayCanvas node.js deployment
# Based on work by Viral Ganatra (https://github.com/viralganatra/docker-nodejs-best-practices ) under the MIT license

# Base stage
# ---------------------------------------
FROM node:23.3-alpine3.20 AS base
WORKDIR /app
COPY app/package*.json ./
COPY app/tsconfig.json ./
COPY app/rollup.config.mjs ./
COPY app/.env ./

# Development stage
# ---------------------------------------
FROM base AS development
WORKDIR /app
RUN npm install
EXPOSE 3000

# Source stage
# ---------------------------------------
FROM base AS source
WORKDIR /app
COPY ./app/src ./src
COPY ./app/lib ./lib
COPY ./app/plugins  ./plugins
COPY ./app/static ./static
RUN npm ci && npm run build

# Test stage
# ---------------------------------------
#FROM source AS test

# COPY --from=development /app/node_modules /app/node_modules
# RUN npm run test && npm run lint

# Production stage
# ---------------------------------------
FROM nginx:stable-alpine3.20-slim AS production

COPY --from=source /app/dist /usr/share/nginx/html

# Copy in Nginx configuration that redirects to index.html
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
