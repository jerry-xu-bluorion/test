# 文件: Dockerfile
# 作者: 许军杰
# 功能: 基于 aws-cli 镜像安装 Python3 和 requests（兼容 OpenSSL 1.0.2）
# 基础镜像: dev.meeboss.me/aws-cli

FROM dev.meeboss.me/aws-cli

LABEL maintainer="许军杰"
LABEL description="AWS CLI with Python3 and requests library (OpenSSL 1.0.2 compatible)"
LABEL version="latest"

# 设置环境变量
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# 安装 Python3、pip 和必要工具
RUN set -ex && \
    # 检测包管理器并安装 Python3
    if command -v yum >/dev/null 2>&1; then \
        # RHEL/CentOS/Amazon Linux
        yum install -y python3 python3-pip unzip  openssh-clients && \
        yum clean all && \
        rm -rf /var/cache/yum; \
    elif command -v apt-get >/dev/null 2>&1; then \
        # Debian/Ubuntu
        apt-get update && \
        apt-get install -y --no-install-recommends \
            python3 \
            python3-pip \
            python3-setuptools \
            openssh-clients \
            unzip && \
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*; \
    elif command -v apk >/dev/null 2>&1; then \
        # Alpine
        apk add --no-cache python3 py3-pip; \
    else \
        echo "错误: 未识别的包管理器" && exit 1; \
    fi

# 升级 pip 并安装兼容版本的 requests 和 urllib3
# urllib3 < 2.0 兼容 OpenSSL 1.0.2
RUN python3 -m pip install --upgrade "pip<24.0" "setuptools<65.0" && \
    python3 -m pip install \
        "urllib3<2.0" \
        "requests>=2.25.0,<3.0.0" \
        "certifi>=2021.5.30" \
        "charset-normalizer>=2.0.0,<4.0.0" \
        "idna>=2.5,<4.0"

# 验证安装
RUN set -ex && \
    echo "=== 验证安装 ===" && \
    python3 --version && \
    pip3 --version && \
    python3 -c "import sys; print(f'Python: {sys.version}')" && \
    python3 -c "import ssl; print(f'OpenSSL: {ssl.OPENSSL_VERSION}')" && \
    python3 -c "import urllib3; print(f'urllib3: {urllib3.__version__}')" && \
    python3 -c "import requests; print(f'requests: {requests.__version__}')" && \
    aws --version && \
    echo "✓ 所有依赖安装成功"

# 设置工作目录
WORKDIR /workspace

# 默认命令
CMD ["/bin/bash"]
