FROM node:18.20.4
RUN npm install -g pnpm@9.7.1 && pnpm set registry https://npm.meeboss.me/

WORKDIR /app
