---
title: "Github Issues 使用指南"
weight: 4
edition: ce
description: >
  介绍 cloudpods issues 处理逻辑和使用方法
---

Cloudpods 所有相关的 issues 都在 [https://github.com/yunionio/cloudpods/issues](https://github.com/yunionio/cloudpods/issues) 管理维护。

## 处理逻辑

目前 issue 的处理逻辑如下：

### issue 生命周期相关

- 用户创建 issue 时：
    - 打上 'state/awaiting processing' 的标签，表示这个问题待处理
- 如果 issue 超过 30 天没有更新：
    - 打上 stale 标签，表示已经长期没有进展了
    - 如果 issue 有 announcement 标签，就算超过 30 天没有更新，也不会打上 stale 标签
- 如果 issue 超过 37 天没有更新:
    - 自动关闭 issue
- 如果 issue 被关闭：
    - 在 issue 没有 stale 标签的情况下，会删掉 'state/awaiting user feedback' 和 'state/awaiting processing' 的标签

### issue 评论相关

- issue 发生评论时：
    - 如果是创建 issue 的作者评论:
        - 会打上 'state/awaiting processing' 标签
        - 并且删掉 'state/awaiting user feedback' 标签
    - 如果是其它用户评论:
        - 会打上 'state/awaiting user feedback' 标签
        - 并且删掉 'state/awaiting processing' 标签
        - 如果不想删掉 'state/awaiting processing'，需要在评论的时候加上 '/keep-state' 关键字

## 使用指南

给 issues 打上标签后，就可以基于标签来做过滤了，常用的场景可以用以下的方式过滤：

### 查询目前等待处理的问题

只用查询状态为打开，并且有 'state/awaiting processing' 标签，并且没有 'stale' 标签的 issues 就可以了。

Github 前端可以用以下的表达式过滤:

```
is:open is:issue label:"state/awaiting processing" -label:stale 
```

对应到 Cloudpods issues 页面：

[https://github.com/yunionio/cloudpods/issues?page=1&q=is%3Aopen+is%3Aissue+label%3A%22state%2Fawaiting+processing%22+-label%3Astale](https://github.com/yunionio/cloudpods/issues?page=1&q=is%3Aopen+is%3Aissue+label%3A%22state%2Fawaiting+processing%22+-label%3Astale)

### 查询过期即将关闭的问题

只用查询状态为打开，并且有 'stale' 标签的 issues。

Github 前端可以用以下的表达式过滤:

```
is:open is:issue label:stale
```

对应到 Cloudpods issues 页面：

[https://github.com/yunionio/cloudpods/issues?q=is%3Aopen+is%3Aissue+label%3Astale+](https://github.com/yunionio/cloudpods/issues?q=is%3Aopen+is%3Aissue+label%3Astale+)

### 查询过期但被关闭的问题

这一类问题通常是用户长期没有回复，或者没有及时解决的问题，这类问题是有查询价值的，有时候需要找到这类问题，并且重新打开。

查询状态为关闭，并且有 'stale' 标签的 issues。

Github 前端可以用以下的表达式过滤:

```
is:closed is:issue label:stale
```

对应到 Cloudpods issues 页面：

[https://github.com/yunionio/cloudpods/issues?q=is%3Aclosed+is%3Aissue+label%3Astale](https://github.com/yunionio/cloudpods/issues?q=is%3Aclosed+is%3Aissue+label%3Astale)
