# 构建阶段
FROM openjdk:17-jdk-slim AS builder

ENV ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk

# 安装基础工具
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        unzip \
        curl \
        ca-certificates \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean

# 下载 Android SDK
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    cd /opt/android-sdk/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip -O tools.zip && \
    unzip -q tools.zip && rm tools.zip && \
    mkdir latest && \
    mv cmdline-tools/* latest/ && \
    rmdir cmdline-tools

# 安装 Android SDK 组件
RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses && \
    sdkmanager --sdk_root=${ANDROID_SDK_ROOT} \
        "platform-tools" \
        "platforms;android-33" \
        "build-tools;33.0.0" \
        "build-tools;30.0.3" \
        "ndk;26.1.10909125" \
        "cmake;3.18.1"

# 最终镜像
FROM openjdk:17-jdk-slim

ENV ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk \
    GRADLE_HOME=/opt/gradle-8.4 \
    PATH=$PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/emulator:/opt/gradle-8.4/bin

# 安装运行时依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        unzip \
        git \
        curl \
        zip \
        lsof \
        python3 \
        python3-pip \
        ca-certificates \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get clean

# 从构建阶段复制 Android SDK
COPY --from=builder /opt/android-sdk /opt/android-sdk

# 安装 AWS CLI
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# 安装 Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-8.4-bin.zip -P /tmp && \
    unzip -q /tmp/gradle-8.4-bin.zip -d /opt && \
    ln -s /opt/gradle-8.4/bin/gradle /usr/bin/gradle && \
    rm /tmp/gradle-8.4-bin.zip

# 清理不必要的文件
RUN rm -rf /opt/android-sdk/ndk/26.1.10909125/docs \
    && rm -rf /opt/android-sdk/ndk/26.1.10909125/samples \
    && rm -rf /opt/android-sdk/ndk/26.1.10909125/toolchains/llvm/prebuilt/linux-x86_64/share

WORKDIR /home

CMD ["/bin/bash"]
