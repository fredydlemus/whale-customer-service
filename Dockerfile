#Build stage
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

#Prod stage
FROM node:18-alpine as runner

WORKDIR /app

ENV NODE_ENV=production

COPY package*.json ./

RUN npm ci --only=production

COPY --from=builder /app/dist ./dist

EXPOSE 3001

CMD ["node", "dist/main.js"]