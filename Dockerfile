# Simple Dockerfile adding Maven and GraalVM Native Image compiler to the standard
# https://github.com/orgs/graalvm/packages/container/package/graalvm-ce image
FROM oraclelinux:8 
LABEL Author="The TF2 Engineer Main, Josiah"
ENV HOME=/build
RUN mkdir -p $HOME/jdk
RUN mkdir -p $HOME/src
WORKDIR $HOME

# Install native image compiler dependencies
RUN dnf config-manager --set-enabled ol8_codeready_builder \
    && dnf install -y wget tar gcc glibc-devel zlib-devel libstdc++-static zlib-static

ENV JDK_VERSION=19
ENV GRAAL_VERSION=22.3.0-dev-20221004_1644
# Install GraalVM JDK 16 and add to PATH
RUN cd jdk \
    && wget -c -O - "https://github.com/graalvm/graalvm-ce-dev-builds/releases/download/${GRAAL_VERSION}/graalvm-ce-java${JDK_VERSION}-linux-amd64-dev.tar.gz" | tar -xvz

# RUN curl -L -o musl.tar.gz https://musl.libc.org/releases/musl-1.2.2.tar.gz && \
#     tar -xvzf musl.tar.gz

ENV JAVA_HOME=$HOME/jdk/graalvm-ce-java$JDK_VERSION-22.3.0-dev
ENV PATH=$PATH:$JAVA_HOME/bin