# 文件: Dockerfile.optimized
# 作者: 许军杰
# 功能: 基于 aws-cli 镜像安装 Python3 和 requests（优化版）

FROM dev.meeboss.me/aws-cli

LABEL maintainer="许军杰"
LABEL description="AWS CLI with Python3 and requests library (optimized)"
LABEL version="latest"

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# 一次性安装所有依赖并清理
RUN set -ex && \
    if command -v yum >/dev/null 2>&1; then \
        yum install -y python3 python3-pip && \
        yum clean all && \
        rm -rf /var/cache/yum; \
    elif command -v apt-get >/dev/null 2>&1; then \
        apt-get update && \
        apt-get install -y --no-install-recommends python3 python3-pip && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*; \
    elif command -v apk >/dev/null 2>&1; then \
        apk add --no-cache python3 py3-pip; \
    fi && \
    python3 -m pip install --no-cache-dir --upgrade pip setuptools && \
    python3 -m pip install --no-cache-dir requests && \
    # 验证
    python3 --version && \
    python3 -c "import requests; print(f'requests {requests.__version__}')" && \
    aws --version && \
    echo "✓ 安装完成"

WORKDIR /workspace
CMD ["/bin/bash"]
