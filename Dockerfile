FROM maven:3.8.8-eclipse-temurin-17
# 安装 git 和 maven
RUN apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

RUN java -version && mvn -version

# 验证安装
RUN git --version && mvn -version && java -version

# 设置工作目录
WORKDIR /workspace

CMD ["/bin/bash"]