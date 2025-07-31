FROM node:18.20.4

# 安装 bash 和核心工具
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 安装 pnpm (推荐方式)
RUN corepack enable && corepack prepare pnpm@latest --activate

# 设置默认 shell 为 bash
SHELL ["/bin/bash", "-c"]

# 验证安装
RUN bash -c "type source" && \
    pnpm --version