FROM golang:1.15-alpine

LABEL maintainer="Zexi Li <zexi.li@qq.com>"

RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
    rsync \
    build-base \
    libc6-compat \
    make \
    python3 py3-yaml \
    npm

ARG HUGO_VERSION

RUN mkdir -p /usr/local/src && \
    cd /usr/local/src && \
    curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz | tar -xz && \
    mv hugo /usr/local/bin/hugo && \
    addgroup -Sg 1000 hugo && \
    adduser -Sg hugo -u 1000 -h /src hugo

RUN apk add --no-cache bash

RUN npm install -g npm

RUN npm install -g postcss postcss-cli autoprefixer

RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /src

USER hugo:hugo

EXPOSE 1313
