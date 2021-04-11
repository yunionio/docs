---
title: "Git Commit Message Convention"
weight: 3
description: >
  git commit message convention
---

For the purpose of word-processing the code change history, and statistics, we compile the following Git Commit Message Convention to regulate the format of Git Commit Message.

## Git Commit Message Convention

Conform to the following format:

```bash
<type>(<scope>): <subject>

<body>

<footer>
```

The message is composed of three parts (part is separated by an empty line):

- Title: required, describing the type of modification and a concise summary of changes
- Content: optional, describing in details why the modification is need, how to change, the basic outline of codes, how to make the change take effect, etc.
- Notes: optional, some additional notes

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

---

```bash
fix(region): compute NextSyncTime for snapshotpolicydisk

1. 如果计算出来的 NextSyncTime 和 base 相等，可以将 base 加1一个小时递归处理。
2. 对于 retentionday 有效的快照策略，比如某一个 snaphsotpolicy
是每周一生效，并且打的快照自动保留 3 天，那么，就应该在每周一（打快照）
和每周四（释放快照）进行快照的同步。
```
---

```bash
feat(scheduler): add cpu filter

Added new cpu filter to scheduler:

- filter host by cpu model
- set host capability by request cpu count
```
---

```bash
fix(apigateway,monitor,influxdb): disable influxdb service query proxy
```
---

```bash
feat(climc): support disable wrap line

Usage:
export OS_TRY_TERM_WIDTH=false
climc server-list

Closes #6710
```
---

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

## 参考

- https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.fpepsvr2gqby

- http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html

- https://blog.csdn.net/noaman_wgs/article/details/103429171
