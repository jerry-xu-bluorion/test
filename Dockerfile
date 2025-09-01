FROM python:3.9-alpine

# 安装必要的包
RUN apk add --no-cache \
    openssh-client \
    git \
    curl \
    bash \
    && pip install --no-cache-dir \
    ansible \
    boto3 \
    awscli

# 创建工作目录
WORKDIR /ansible

# 创建ansible用户
RUN adduser -D -s /bin/bash ansible

# 切换到ansible用户
USER ansible

# 默认启动bash
CMD ["/bin/bash"]