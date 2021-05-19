# YunionCloud 文档

本仓库包含 YunionCloud 相关的文档

[English](./README.md) | [简体中文](./README_CN.md)

## 安装依赖

文档的编译开发使用 [docker](https://docs.docker.com/get-started/overview/) 运行 [hugo](https://gohugo.io/) 容器来进行，这样的好处是不需要在本地安装配置 hugo ，保证开发环境的统一。

- docker: 安装 docker 请参考文档 [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

## 查看文档网站

```bash
$ git clone https://github.com/yunionio/docs --recursive
$ cd docs

# 使用 docker 运行 hugo serve 容器
$ make container-serve
# 然后访问 http://localhost:1313 查看文档
```

## 编辑文档

文档在 content/{en,zh} 目录下，选择需要的部分进行编辑或者添加，内容组织请参考：https://gohugo.io/content-management/organization/。

## 编译文档

开发阶段的文档是没有多版本的，如果要查看多版本文档的效果，可以运行以下命令。

```
# 使用 docker 编译多版本的文档
# 生成的文档网站会在 ./public 目录下
$ make container-build
$ cd public && python3 -m http.server 1313
```

## 更新 Submodule

```bash
$ git submodule update --recursive
$ git pull --recurse-submodules
```
