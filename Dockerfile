# 使用官方 Golang 镜像作为构建环境
FROM golang:1.16.4-alpine3.13 as builder-golang

# 主程序版本号
ARG ALIST_VERSION=1.0.5

# 设置工作目录
WORKDIR /src

# 设置环境变量
ENV CGO_ENABLED=1 GOOS=linux

# 将构建好的二进制文件拷贝进镜像
COPY conf.yml.example entrypoint.sh /src/output/

# 编译go二进制文件
RUN set -x && \
  apk update && \
  apk --no-cache add make wget gcc libtool musl-dev ca-certificates dumb-init && \
  wget --no-check-certificate https://github.com/Xhofe/alist/archive/refs/tags/v${ALIST_VERSION}.tar.gz -O - | tar -zxvf - --strip-components 1 -C . && \
  go mod download && \
  go build -mod=readonly -v -o /src/output/alist


# 使用官方 Node 镜像作为构建环境
FROM node:12.22.1-buster as builder-vue

# 静态文件版本号
ARG ALIST_WEB_VERSION=1.0.5

# 设置工作目录
WORKDIR /src

# 将构建好的二进制文件拷贝进镜像
COPY --from=builder-golang /src/output/ /src/output/

# 编译vue静态文件
RUN set -x && \
  wget --no-check-certificate https://github.com/Xhofe/alist-web/archive/refs/tags/v${ALIST_WEB_VERSION}.tar.gz -O - | tar -zxvf - --strip-components 1 -C . && \
  yarn install && \
  yarn build --dest /src/output/dist


# 使用裁剪后的官方 Debian 镜像作为基础镜像
# https://hub.docker.com/_/debian
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM alpine:3.13.5

# 暴露端口
EXPOSE 5244

# 设置工作目录
WORKDIR /app

# 将构建好的二进制文件拷贝进镜像
COPY --from=builder-vue /src/output/ /app/

# 初始化环境
RUN apk update && \
  apk add --no-cache bash ca-certificates && \
  update-ca-certificates && \
  rm -rf /var/cache/apk/* && \
  chmod +x entrypoint.sh alist

# 挂载点
VOLUME ["/config"]

# 启动 Web 服务
ENTRYPOINT ["sh", "-c", "./entrypoint.sh"]
