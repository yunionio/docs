---
title: "启用/禁用宿主机"
date: 2022-02-07T18:24:26+08:00
weight: 1
description: >
    控制宿主机的启用状态，启用状态下的宿主机用于创建虚拟机
---

### 启用

<big>**climc操作**</big>

```bash
# 找到禁用的宿主机
$ climc host-list --disabled

# 启用宿主机
$ climc host-enable <host_id>
```

### 禁用

<big>**climc操作**</big>

```bash
# 禁用宿主机
$ climc host-disable <host_id>
```
