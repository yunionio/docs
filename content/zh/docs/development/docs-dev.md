---
title: "贡献文档"
weight: 103
oem_ignore: true
edition: ce
description:
  介绍搭建 Cloudpods 文档编写开发环境，以及如何贡献文档
---

Cloudpods 文档使用 markdown 编写，所有内容都放到 [https://github.com/yunionio/docs.git](https://github.com/yunionio/docs.git) 这个仓库里面管理，然后使用 [hugo](https://gohugo.io/) 这个工具把文档转换成 HTML 静态网站，最后发布到 [https://www.cloudpods.org](https://www.cloudpods.org)。

本文介绍如何搭建文档编写环境，以及如何贡献文档等注意事项。

## 在网页编辑已有文档

编辑已有文档的最简单方式是在 [https://cloudpods.org](https://cloudpods.org) 相关文档界面，点击“编辑此页”，就会跳转到文档的 github 仓库界面进行在线编辑。

![](../images/web_edit_doc.png)

这是最简单快捷修改已有文档的方式，适合对已有文档进行小的改动。如果要新增加文档，或者全面掌握文档编写以及打包发布机制，请阅读下面的内容。

## 配置文档开发环境

### 1. Fork 主仓库

文档放到 [https://github.com/yunionio/docs.git](https://github.com/yunionio/docs.git) 仓库进行管理，所以在编写文档之前，需要先把主仓库 fork 一份到自己的 github 账号下。

访问 https://github.com/yunionio/docs ，将仓库 fork 到自己的 github 账号下。

### 2. clone 文档仓库

Fork 完成后，将自己 github 账号的 docs 文档仓库使用 `git clone` 下来。


```bash
# 注意这里把 <your_name> 改成自己的 github 账号
$ git clone https://github.com/<your_name>/docs --recursive
$ cd docs
```

### 3. 安装 hugo

[hugo](https://gohugo.io/) 这个工具的作用是把 markdown 编辑的文档转换成静态网站，我们编写完文档后需要靠这个工具来预览最终文档的效果。

安装 hugo 请参考文档：[https://gohugo.io/installation/](https://gohugo.io/installation/)

下一步是安装 npm 相关的依赖，因为主题用到了 css 相关的插件。

```bash
# 安装 npm 相关的包
$ npm install -g postcss-cli
```

如果没有安装过 Node.js 和 npm 请先参考文档 [https://docs.npmjs.com/downloading-and-installing-node-js-and-npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm) 安装配置 Node.js 和 npm ，然后再执行上面的命令安装 `postcss-cli` 包。

## markdown 简单说明

在编写文档之前，需要掌握 markdown 的基本语法，可参考：[https://www.markdownguide.org/basic-syntax/](https://www.markdownguide.org/basic-syntax/)。

另外在使用 markdown 编写文档时，建议多使用语义化的标签，比如注意标题层级，使用 list item 和 codeblock 这些标签。下面是一个例子：

```markdown
## 2级标题

编写文档的时候请使用 '##' 2级标题开始，如果使用 '#' 1级标题，是不会出现在当前文档对应的目录(TOC)的。

### 3级子标题

3级标题会作为2级标题的子标题，以缩进的方式出现在文档对应的目录里面。

### 使用 list item

- Todo1
    - SubTodo1
    - SubTodo2
- Todo2
    - SubTodo1
    - SubTodo2
        - SubSubTodo1

### 使用 codeblock

当编写的文档设计到代码或者命令行操作时，应该尽量使用 codeblock 代码块语法。

    ```bash
    # 更新 centos 系统
    $ sudo yum update -y
    ```

    ```yaml
    # yaml 注释
    key1: val1
    key2:
      sub_key1: sub_val1
    ```
```

<p>

## 2级标题

编写文档的时候请使用 '##' 2级标题开始，如果使用 '#' 1级标题，是不会出现在当前文档对应的目录(TOC)的。

### 3级子标题

3级标题会作为2级标题的子标题，以缩进的方式出现在文档对应的目录里面。

### 使用 list item

- Todo1
    - SubTodo1
    - SubTodo2
- Todo2
    - SubTodo1
    - SubTodo2
        - SubSubTodo1

### 使用 codeblock

当编写的文档设计到代码或者命令行操作时，应该尽量使用 codeblock 代码块语法。

```bash
# 更新 centos 系统
$ sudo yum update -y
```

```yaml
# yaml 注释
key1: val1
key2:
  sub_key1: sub_val1
```

## 编写文档

文档在 content/{en,zh} 目录下，选择需要的部分进行编辑或者添加，内容组织请参考：https://gohugo.io/content-management/organization/。

### 目录结构说明

以 content/zh 目录的结构来说明各个目录包含的内容。

```bash
$ tree -L 2 content/zh/
content/zh/
├── _index.html # 文档首页，一般不需要变更
├── blog # 对应博客的内容
│   ├── _index.md
│   └── _posts # 包含 markdown 编写的博客
├── docs # 对应文档目录
│   ├── contact # 联系相关的文档
│   ├── development # 开发相关的文档
│   ├── faq # 常见问题相关的文档
│   ├── function_principle # 功能原理相关文档
│   ├── introduce # 平台介绍相关文档
│   ├── ops # 运维相关文档
│   ├── quickstart # 快速开始相关文档
│   ├── quickuse # 快速上手相关文档
│   ├── release # release note 相关文档，记录每一次的发布日志
│   ├── setup # 安装部署相关文档
│   ├── swagger # swagger api 文档
│   └── web_ui # 前端 UI 使用相关的文档
```

### 文档头部 meta 元信息

每篇使用 markdown 编写的文档，在开头都有 '---' 包起来，并用 yaml 格式配置的 meta 源信息，下面对相关配置进行说明。

```
# 表示该文档的主标题
title: "your document title"

# 控制同级文档之间的顺序，值越大，文档越靠后
weight: 80

# 文档创建的时间
date: 2022-12-16T07:10:02+08:00

# 表示文档是草稿，最终不会发布，一般不需要配置这个选项
# 只有在使用 `hugo new` 命令新建的文档才会出现这个配置
draft: true

# 文档简要描述
description: "document description"

# edition 标记文档包含在ce(开源版)或者ee(企业版)，如果不设置则表示两个版本都会包含
edition: ce
```

### 预览文档

编辑文档的过程中，我们想要一个实时预览的效果，可以执行 `hugo serve` 命令。改命令会在本地启动一个 http 服务，默认监听 '1313' 端口。访问该服务就可以预览整个文档页面。

```bash
# 执行 hugo serve
# '-D' 表示把草稿文档也展示出来
$ hugo serve -D
Start building sites …
hugo v0.84.0 darwin/arm64 BuildDate=unknown

                   | EN  | ZH
-------------------+-----+------
  Pages            | 119 | 775
  Paginator pages  |   0 |   1
  Non-page files   |  25 | 954
  Static files     |  92 |  92
  Processed images |   0 |   0
  Aliases          |   1 |   1
  Sitemaps         |   2 |   1
  Cleaned          |   0 |   0

Built in 5337 ms
Watching for changes in /Users/lzx/code/go/src/yunion.io/x/docs/{assets,content,layouts,package.json,static,themes}
Watching for config changes in /Users/lzx/code/go/src/yunion.io/x/docs/config.toml, /Users/lzx/code/go/src/yunion.io/x/docs/themes/docsy/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
# 注意这里显示的 http web 服务访问地址
Web Server is available at //localhost:1313/ (bind address 127.0.0.1)
Press Ctrl+C to stop

# 如果是本地 1313 端口被占用，可以通过'--port'参数指定其他端口
# 下面命令监听到 8088 端口
$ hugo serve --port 8088 -D
```

启动 hugo web 服务后，通过浏览器访问相关页面，然后对文档进行编辑。每次内容的修改，就会触发 hugo 对文档的编译，然后浏览器里面对应的文档界面就会实时刷新。

### 新建文档

可以通过以下 2 种方式新建文档：

1. 使用 `hugo new` 命令

    ```bash
    $ hugo new content/zh/docs/quickstart/test-new.md
    content/zh/docs/quickstart/test-new.md created
    ```

    然后使用自己喜欢的编辑器编写对应的 markdown 文档即可。

2. 直接新建文档编辑

    另外一种方式是直接在相应目录新建文档，然后配置 meta 元信息编辑。

    下面是一个命令行下新建文档的例子：

    ```bash
    # 新建文档
    $ touch new content/zh/docs/quickstart/test-new-by-cmd.md

    # 编辑文档
    $ vim content/zh/docs/quickstart/test-new-by-cmd.md

    # 添加 meta 元信息后的内容
    $ cat content/zh/docs/quickstart/test-new-by-cmd.md
    ---
    title: "Test New By Commandline"
    weight: 100
    ---
    ```

## 提交文档

文档编辑完成后请参考 git 配置提交代码，相关文档参考：[提交贡献代码](../contrib/#提交代码流程)。

如果只是编写和贡献文档，看到这里就已经可以了。接下来是文档编译打包以及转换成 docx 相关的内容。

## 编译打包文档

编译打包文档是指通过 hugo 这个工具，把文档转换成最终的 HTML 站点，最后发布到线上。

编译打包后的文档，有下面这4种输出结果，其中 ce 是 'Community Edition'，ee 是 'Enterprise Edition' 简写。

- 在线文档：发布到线上
    - 开源版本(ce)：在线开源版文档，发布到 [https://www.cloudpods.org](https://www.cloudpods.org)
    - 企业版本(ee)：在线商业版文档，发布到 [https://docs.yunion.cn](https://docs.yunion.cn)

### 在线文档

#### ce 开源版本

```bash
# 本地启用 http server 查看 ce 开源版本文档
$ make local-serve

# 将 ce 文档编译成 HTML 站点
$ make ce-build
```

在线开源文档会在每次合并到 release 分支的时候，使用 github workflow 自动更新线上站点。

对应的配置在 [https://github.com/yunionio/docs/blob/master/.github/workflows/release.yml](https://github.com/yunionio/docs/blob/master/.github/workflows/release.yml)。

#### ee 商业版本

```bash
# 本地启用 http server 查看 ee 文档
$ make ee-local-serve

# 将 ee 文档编译成 HTML 站点
$ make ee-build
```
