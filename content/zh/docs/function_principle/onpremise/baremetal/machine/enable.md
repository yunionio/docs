---
title: "启用/禁用"
date: 2022-02-07T19:11:22+08:00
weight: 30
description: >
    启用或禁用物理机，启用状态的物理机用于创建裸金属服务器
---

### 启用

```bash
# 启用物理机
$ climc host-enable --baremetal true <id>
```

### 禁用

该功能用于禁用”启用“状态的物理机，禁用状态的物理机不能创建裸金属服务器。

<big>**Climc命令行**</big>

```bash
# 禁用物理机
climc host-disable --baremetal true <id>
```
