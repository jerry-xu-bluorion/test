FROM node:18.20

# 1. 设置 pnpm 环境
ENV PNPM_HOME=/usr/local/share/pnpm
ENV PATH=$PATH:$PNPM_HOME

# 2. 通过 Corepack 安装（官方推荐）
RUN corepack enable && \
    corepack prepare pnpm@8.15.7 --activate && \
    pnpm config set store-dir /usr/local/share/.pnpm-store

# 3. 安全加固
RUN chmod -R 755 $PNPM_HOME && \
    chown -R node:node $PNPM_HOME

# 4. 使用非 root 用户
USER node
WORKDIR /app