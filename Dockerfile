# Simple Dockerfile adding Maven and GraalVM Native Image compiler to the standard
# https://github.com/orgs/graalvm/packages/container/package/graalvm-ce image
FROM oraclelinux:8 AS Native-Image-Compiler

ENV HOME=/build
RUN mkdir -p $HOME/jdk
RUN mkdir -p $HOME/src
WORKDIR $HOME

# Install native image compiler dependencies
RUN dnf config-manager --set-enabled ol8_codeready_builder \
    && dnf install -y wget tar gcc glibc-devel zlib-devel libstdc++-static

# Install GraalVM JDK 16 and add to PATH
RUN cd jdk \
    && wget "https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/21.3.0-dev-20210806_1944/graalvm-ce-java16-linux-amd64-dev.tar.gz" \
    && tar -xzf graalvm-ce-java16-linux-amd64-dev.tar.gz 

# RUN curl -L -o musl.tar.gz https://musl.libc.org/releases/musl-1.2.2.tar.gz && \
#     tar -xvzf musl.tar.gz

ENV JAVA_HOME=$HOME/jdk/graalvm-ce-java16-21.3.0-dev
ENV PATH=$PATH:$HOME/jdk/graalvm-ce-java16-21.3.0-dev/bin:$JAVA_HOME

# Install native image utility
RUN gu install native-image

# check native image version
RUN native-image --version