FROM centos:centos7.9.2009

# 安装常用工具
RUN yum install -y epel-release && \
    yum update -y && \
    yum install -y net-tools vim htop dstat zip unzip git wget

# 安装 OpenJDK 17（官方归档）
ENV JAVA_VERSION=17.0.2
ENV JAVA_HOME=/usr/local/java
RUN wget https://download.oracle.com/java/17/archive/jdk-${JAVA_VERSION}_linux-x64_bin.tar.gz -O /tmp/jdk.tar.gz && \
    mkdir -p $JAVA_HOME && \
    tar -zxf /tmp/jdk.tar.gz -C $JAVA_HOME --strip-components=1 && \
    rm -f /tmp/jdk.tar.gz

# 安装 Maven（官方归档）
ENV MAVEN_VERSION=3.8.8
ENV MAVEN_HOME=/opt/maven
RUN wget https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -O /tmp/maven.tar.gz && \
    mkdir -p $MAVEN_HOME && \
    tar -zxf /tmp/maven.tar.gz -C $MAVEN_HOME --strip-components=1 && \
    ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn && \
    rm -f /tmp/maven.tar.gz

# 设置环境变量
ENV PATH=$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH
ENV TZ=Asia/Shanghai
ENV LANG=en_US.utf8

# 可选：验证
RUN java -version && mvn -version && git --version && unzip -v

WORKDIR /root

CMD ["/bin/bash"]