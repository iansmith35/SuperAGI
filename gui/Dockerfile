FROM node:18-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci

# Rebuild the source code only when needed
FROM node:18-alpine AS builder

WORKDIR /app

# copy node modules from deps stage
COPY --from=deps /app/node_modules ./node_modules

# copy source files and build
COPY . .
ARG NEXT_PUBLIC_API_BASE_URL=/api
ENV NEXT_PUBLIC_API_BASE_URL=$NEXT_PUBLIC_API_BASE_URL
ARG NEXT_PUBLIC_MIXPANEL_AUTH_ID
ENV NEXT_PUBLIC_MIXPANEL_AUTH_ID=$NEXT_PUBLIC_MIXPANEL_AUTH_ID

RUN npm run build

# Production runner stage: smaller image that only serves the built app
FROM node:18-alpine AS runner
WORKDIR /app
RUN apk add --no-cache libc6-compat

# copy build artifacts and node_modules
COPY --from=deps /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/package.json ./package.json

ENV NODE_ENV=production
EXPOSE 3000
CMD ["npm", "start"]