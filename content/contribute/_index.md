---
title: "开发贡献"
date: 2019-07-11T11:45:03+08:00
weight: 2
draft: true
---

## 安装 Go

Golang 版本要求 1.12 以上

安装go环境参考: [Install doc](https://golang.org/doc/install)

## 编译 onecloud 组件

### Fork 仓库

访问 https://github.com/yunionio/onecloud ，将仓库 fork 到自己的 github 用户下。

### Clone 源码

git clone 前确保 GOPATH 等环境变量已经设置好，clone 你自己 fork 的仓库

```sh
$ git clone  https://github.com/<your_name>/onecloud $GOPATH/src/yunion.io/x/onecloud
$ cd $GOPATH/src/yunion.io/x/onecloud
$ git remote add upstream https://github.com/yunionio/onecloud
```

### 编译

```sh
# 编译所有组件
$ make

# 编译 cmd 目录下面的指定组件:
$ ls cmd
...
ansibleserver    climc      glance      keystone  qcloudcli     ucloudcli
awscli           cloudir    host        lbagent   region        webconsole

# 编译 region 和 host 组件
$ make cmd/region cmd/host

# 查看编译好的二进制
$ ls _output/bin
region host
```

## 开发流程

- 从 master checkout 出 feature 或者 bugfix 分支，然后提 PR 到 upstream

```bash
# checkout 新分支
$ git fetch upstream --tags
$ git checkout -b feature/implement-x upstream/master

# 开发完成后，提 PR 流程
$ git fetch upstream         # 同步远程 upstream master 代码
$ git rebase upstream/master # 有冲突则解决冲突
$ git push origin feature/implement-x # push 分支到自己的 repo

# 去 web 提 PR
```

- 提完 PR 后请求相关开发人员 review

- 如果是 bugfix 或者需要合并到之前 release 分支的 feature PR，需要 cherry-pick 到对应的 release 分支

```bash
# 自行下载安装 github 的 cli 工具：https://github.com/github/hub
# OSX 使用: brew install hub
# Debian: sudo apt install hub
# 二进制安装: https://github.com/github/hub/releases

# 使用脚本自动 cherry-pick PR 到 release 分支
$ export GITHUB_USER=<your_username>
# 比如要把 PR 8 合并到 release/2.8.0
$ ./scripts/cherry_pick_pull.sh upstream/release/2.8.0 8
 
# cherry pick 可能会出现冲突，冲突时开另外一个 terminal，解决好冲突，再输入 'y' 进行提交
$ git add xxx # 解决完冲突后
$ git am --continue
# 回到执行 cherry-pick 脚本的 terminal 输入 'y' 即可
```

然后去 upstream 的 [PR 页面](https://github.com/yunionio/onecloud/pulls), 就能看到自动生成的 cherry-pick PR，重复 PR review 流程合并到 release

## 部署

TODO
