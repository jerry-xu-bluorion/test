FROM node:18.20.4
RUN npm install -g pnpm && pnpm set registry https://npm.meeboss.me/

# 4. 使用非 root 用户
USER node
WORKDIR /app