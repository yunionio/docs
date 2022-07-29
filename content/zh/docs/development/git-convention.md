---
title: "Git 提交内容规范"
weight: 3
description:
  说明提交代码时，书写 git commit message 的内容规范
---

为了方便代码提交记录的查看，以及以后的统计，我们制定了以下使用 Git 书写提交内容的规范，提交代码的时候请大家遵循以下的格式。

## Git 提交记录书写规范

格式如下:

```bash
<type>(<scope>): <subject>

<body>

<footer>
```

通过 `git commit` 命令填写的提交内容应该类似如上的结构，大致分为３个部分（每个部分使用空行分割）：

- 标题行：必填，描述主要修改类型和概要内容
- 主题内容：选填，描述为什么修改，做了什么样的修改，以及开发的思路，使用方法等等
- 页脚备注：选填，一些备注

每个部分的占位符说明如下:

- type(PR 的类型):
    - feat: 新功能
    - fix: 修复
    - refactor: 代码重构
    - test: 测试用例相关修改
    - chore: 其它修改，比如Makefile,Dockerfile等

- scope(影响范围，相关组件): 比如 region, scheduler, cloudcommon，如果是多个组件，用英文 ',' 分割，比如: (region,scheduler,monitor)

- subject(commit 的概述): 建议不超过 50 个字符

- body(commit 具体修改内容): 可以分为多行，建议每行不超过 72 个字符

- footer(一些备注，选填): 一些备注，通常是相关参考连接、BREAKING CHANGE 或修复 bug 的连接

## Commit 举例

----

```bash
fix(region): compute NextSyncTime for snapshotpolicydisk

1. 如果计算出来的 NextSyncTime 和 base 相等，可以将 base 加1一个小时递归处理。
2. 对于 retentionday 有效的快照策略，比如某一个 snaphsotpolicy
是每周一生效，并且打的快照自动保留 3 天，那么，就应该在每周一（打快照）
和每周四（释放快照）进行快照的同步。
```
----

```bash
feat(scheduler): add cpu filter

Added new cpu filter to scheduler:

- filter host by cpu model
- set host capability by request cpu count
```
----

```bash
fix(apigateway,monitor,influxdb): disable influxdb service query proxy
```
----

```bash
feat(climc): support disable wrap line

Usage:
export OS_TRY_TERM_WIDTH=false
climc server-list

Closes #6710
```
----

## 辅助工具

也有相应的工具帮忙生成符合要求的 Commit message，使用 [commitizen-go](https://github.com/lintingzhen/commitizen-go) 可以协助生成 Commit message，用法如下:

```bash
# osx 安装 commitizen-go
$ brew tap lintingzhen/tap
$ brew install commitizen-go
# 如果是 linux 环境，可以 clone 源码编译，这个工具是 golang 写的，编译也简单
$ git clone https://github.com/lintingzhen/commitizen-go && cd commitizen-go
$ make && ./commitizen-go install

# 这一部会生成 git cz 命令的配置
$ sudo commitizen-go install

# 测试提交
$ git add .
# 使用 git cz 命令，就会以交互式的方式帮忙输入 commit
$ git cz
```

相关配置参考：https://github.com/lintingzhen/commitizen-go/blob/master/README.MD#configure

当然工具并不是说强制使用，只是说有工具的帮助，生成的 commit 内容会更统一一点　;)

当然也有 nodejs 版本的工具，可能更符合前端的使用: https://github.com/commitizen/cz-cli ，前端的同学也可以使用这个工具。


## cherry pick

用于帮助用户合并代码至指定release版本。

1、下载安装hub

  hub地址：https://github.com/github/hub
```bash
# Mac环境下安装
$ brew install hub
```
2、配置hub环境变量

1.编辑hub文件
```bash
$ vim /User/username/.config
user: <github_username>
oauth_token: <github_token>
protocol: https
```
2.生成github_token

github->个人中心->settings->developer settings ->personal access tokens->generate new token

<img src="../images/github_token_location.png" width="800">


note:该token用于何处

expiration:token有效期，建议设置no expiration永久保留

repo:all

将生成的token放入/User/username/.config中的oauth_token中

3、执行

```bash
$ ./scripts/cherry_pick_pull.sh upstream/<分支>  <PR number>
```

4、tips: 

scripts/cherry_pick_pull可重复执行，覆盖上一次结果，出现already时结果已覆盖。


## 参考

- https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.fpepsvr2gqby

- http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html

- https://blog.csdn.net/noaman_wgs/article/details/103429171
