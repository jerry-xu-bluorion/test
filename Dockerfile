FROM centos:7

# 安装基础工具
RUN yum update -y && \
    yum install -y curl git wget tar xz which && \
    yum clean all

# 安装 Node.js 18.20.4
RUN curl -fsSL https://rpm.nodesource.com/setup_18.x | bash - && \
    yum install -y nodejs

# 安装 pnpm
RUN corepack enable && \
    corepack prepare pnpm@latest --activate

# 配置环境
RUN npm config set registry https://registry.npmmirror.com && \
    mkdir -p /root/.pnpm-store

ENV PNPM_HOME=/root/.pnpm-store
ENV PATH=$PATH:$PNPM_HOME

# 验证
RUN node -v && \
    npm -v && \
    pnpm -v

# 设置工作目录
WORKDIR /app

CMD ["bash"]