# 云联壹云 文档

本仓库包含 云联壹云 相关的文档

## 安装 hugo

文档使用 [hugo](https://github.com/gohugoio/hugo) 生成，安装 hugo 参考链接: https://gohugo.io/getting-started/installing/
> hugo使用v0.55.5版，git使用最新版

## 查看文档

```bash
$ git clone https://github.com/yunionio/docs --recursive
$ cd docs
# 安装 npm 相关的包
$ npm install
# 使用 hugo 生成文档的 web 界面
$ hugo serve -D
# 访问 http://localhost:1313 查看文档
```

## 编辑文档

文档都在 content 目录下，选择需要的部分进行编辑，内容组织参考：https://gohugo.io/content-management/organization/

```bash
# 添加新文档
$ hugo new chapter0/section0.md

# 生成的文档会在 content/chapter0/section0.md
$ ls content/chapter0/section0.md

# 用编辑器编辑 content/chapter0/section0.md 文档即可
```

## 更新 submodule

```bash
$ git submodule update --recursive
$ git pull --recurse-submodules
```
