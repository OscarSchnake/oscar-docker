FROM jenkins/jenkins:lts-alpine

MAINTAINER Oscar Schnake "oschnake@optimisa.cl"

ENV NODE_VERSION 8.11.1

# Switch to root user
USER root

RUN apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        g++ \
        gcc \
        libgcc \
        linux-headers \
        make \
        python \
    && cd /tmp \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && apk del .build-deps \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz"


ENV YARN_VERSION 1.5.1

RUN curl -fSL -o /usr/local/bin/yarn "https://github.com/yarnpkg/yarn/releases/download/v$YARN_VERSION/yarn-$YARN_VERSION.js" \
    && chmod +x /usr/local/bin/yarn


ADD package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p opt/app && cp -a ./tmp/node_modules /opt/app

# Switch to jenkins user
USER jenkins
