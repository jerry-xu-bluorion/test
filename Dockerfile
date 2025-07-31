FROM node:18.20.4
RUN npm install -g pnpm && pnpm set registry https://npm.meeboss.me/

WORKDIR /app