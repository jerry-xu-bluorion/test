FROM openjdk:17-jdk-slim

LABEL maintainer="许军杰"

# 安装必要工具
RUN apt-get update && \
    apt-get install -y wget unzip git curl zip lsof python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

# 设置 Android SDK 环境变量
ENV ANDROID_SDK_ROOT /opt/android-sdk
ENV ANDROID_HOME /opt/android-sdk
ENV PATH $PATH:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/emulator

# 下载并安装 Android Commandline Tools
RUN mkdir -p /opt/android-sdk/cmdline-tools && \
    cd /opt/android-sdk/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip -O tools.zip && \
    unzip tools.zip && rm tools.zip && \
    mkdir latest && \
    mv cmdline-tools/* latest/ && \
    rmdir cmdline-tools

# 安装 Android SDK 组件
RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses && \
    sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "platform-tools" "platforms;android-33" "build-tools;33.0.0" "build-tools;30.0.3" "ndk;26.1.10909125" "cmake;3.18.1"

# 安装 Gradle 8.4
RUN wget https://services.gradle.org/distributions/gradle-8.4-bin.zip -P /tmp && \
    unzip /tmp/gradle-8.4-bin.zip -d /opt && \
    ln -s /opt/gradle-8.4/bin/gradle /usr/bin/gradle && \
    rm /tmp/gradle-8.4-bin.zip

ENV PATH $PATH:/opt/gradle-8.4/bin

WORKDIR /home

CMD ["/bin/bash"]
