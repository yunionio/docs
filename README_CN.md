# Cloudpods文档

[English](./README.md) | [简体中文](./README_CN.md)

本仓库包含 [Cloudpods](https://github.com/yunionio/cloudpods) 相关的文档。

## 安装依赖

- hugo v0.83.0:
    - Linux: https://github.com/gohugoio/hugo/releases/download/v0.83.1/hugo_extended_0.83.1_Linux-64bit.tar.gz
    - MacOS:
        - x86_64: https://github.com/gohugoio/hugo/releases/download/v0.83.1/hugo_extended_0.83.1_macOS-64bit.tar.gz
        - arm64: https://github.com/gohugoio/hugo/releases/download/v0.83.1/hugo_extended_0.83.1_macOS-ARM64.tar.gz
- docker: 安装 docker 请参考文档 [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

## 查看文档网站

```bash
$ git clone https://github.com/yunionio/docs --recursive
$ cd docs

# 安装 npm 依赖
$ npm install -i

# 使用 hugo serve 查看 CE(community edition) 文档
$ make ce-local-serve

# 使用 hugo serve 查看 EE(enterprise edition) 文档
$ make ee-local-serve

# 然后访问 http://localhost:1313 查看文档
```

## 编辑文档

文档在 content/{en,zh} 目录下，选择需要的部分进行编辑或者添加，内容组织请参考：https://gohugo.io/content-management/organization/。

### 文档头部 meta 元信息

```
# edition 标记文档包含在ce(开源版)或者ee(企业版)，如果不设置则表示两个版本都会包含
edition: ce

# docscope 表示文档所属的作用域，这个在离线编译模式会用到，默认为 system ，可以设置为 domain 和 project
docscope: project

# oem_ignore 表示该文档会在 oem 模式下编译被忽略
oem_ignore: true
```

## 编译文档

### CE 多版本文档

开发阶段的文档是没有多版本的，如果要查看多版本文档的效果，可以运行以下命令。

```bash
# 编译多版本的文档
# 生成的文档网站会在 ./public 目录下
$ make ce-build
$ cd public && python3 -m http.server 1313
```

### EE 离线文档

```bash
# 生成的文档网站会在 ./public 目录下
$ make ee-build-offline
$ cd public && python3 -m http.server 1313
```

## 更新 Submodule

```bash
$ git submodule update --recursive
$ git pull --recurse-submodules
```

## 制作 EE image

```
$ REGISTRY=registry.cn-beijing.aliyuncs.com/yunionio TAG=your-tag ARCH=all make ee-image
```

## 贡献文档

欢迎贡献任何方面的文档内容，具体的流程请参考[贡献文档](https://www.cloudpods.org/zh/docs/development/docs-dev/)。
