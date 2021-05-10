# 使用官方 Golang 镜像作为构建环境
FROM golang:1.15-buster as builder-golang
WORKDIR /app
#下载项目
RUN git clone https://github.com/Xhofe/alist.git .
COPY conf.yml.example entrypoint.sh ./server/
# 安装依赖
RUN go mod download
# 构建二进制文件
RUN go build -mod=readonly -v -o server/alist
# 使用官方 Node 镜像作为构建环境
FROM node:12.22.1-buster as builder-vue
WORKDIR /app
# 下载项目
RUN git clone https://github.com/Xhofe/alist-web.git .
# 构建静态文件
RUN yarn install \
  && yarn build --dest server/dist
# 将构建好的go二进制拷贝到镜像目录
COPY --from=builder-golang /app/server/ ./server/
# 使用裁剪后的官方 Debian 镜像作为基础镜像
# https://hub.docker.com/_/debian
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM debian:buster-slim
EXPOSE 5244
WORKDIR /app
RUN set -x \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates \
  && rm -rf /var/lib/apt/lists/*
# 将构建好的二进制文件拷贝进镜像
COPY --from=builder-vue /app/server/ /app/
# 挂载点
VOLUME ["/config"]
# 启动 Web 服务
ENTRYPOINT ["sh", "-c", "./entrypoint.sh"] 
