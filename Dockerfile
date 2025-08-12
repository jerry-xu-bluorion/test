FROM node:20.10.0
RUN npm install -g pnpm && pnpm set registry https://npm.meeboss.me/

WORKDIR /app