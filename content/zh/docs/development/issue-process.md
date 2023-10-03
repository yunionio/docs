---
title: "Github Issues 处理逻辑"
weight: 4
edition: ce
description: >
  介绍 cloudpods issues 处理逻辑
---

Cloudpods 所有相关的 issues 都在 [https://github.com/yunionio/cloudpods/issues](https://github.com/yunionio/cloudpods/issues) 管理维护。

目前 issue 的处理逻辑如下：

## issue 生命周期相关

- 用户创建 issue 时：
    - 打上 'state/awaiting processing' 的标签，表示这个问题待处理
- 如果 issue 超过 30 天没有更新：
    - 打上 stale 标签，表示已经长期没有进展了
    - 如果 issue 有 announcement 标签，就算超过 30 天没有更新，也不会打上 stale 标签
- 如果 issue 超过 37 天没有更新:
    - 自动关闭 issue
- 如果 issue 被关闭：
    - 在 issue 没有 stale 标签的情况下，会删掉 'state/awaiting user feedback' 和 'stale/awaiting processing' 的标签

## issue 评论相关

- issue 发生评论时：
    - 如果是创建 issue 的作者评论:
        - 会打上 'state/awaiting processing' 标签
        - 并且删掉 'state/awaiting user feedback' 标签
    - 如果是其它用户评论:
        - 会打上 'state/awaiting user feedback' 标签
        - 并且删掉 'state/awaiting processing' 标签
        - 如果不想删掉 'state/awaiting processing'，需要在评论的时候加上 '/keep-state' 关键字
