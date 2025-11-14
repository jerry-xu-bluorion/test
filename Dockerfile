FROM node:20.10.0
RUN npm install -g pnpm@9.7.1 && pnpm set registry https://npm.meeboss.me/

WORKDIR /app
