FROM centos:8
# 替换为阿里云 yum 源
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://mirrors.aliyun.com|g' /etc/yum.repos.d/CentOS-Base.repo && \
    sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-*.repo && \
    sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://mirrors.aliyun.com|g' /etc/yum.repos.d/CentOS-*.repo
# 安装基础工具
RUN yum install -y curl xz tar && \
    yum clean all

# 下载并安装 Node.js 二进制包
RUN curl -fsSL https://nodejs.org/dist/v18.20.4/node-v18.20.4-linux-x64.tar.xz | \
    tar -xJf - -C /usr/local --strip-components=1

# 安装 pnpm
RUN corepack enable && \
    corepack prepare pnpm@latest --activate

# 验证
RUN node -v && pnpm -v