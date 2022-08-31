---
title: "查看物理机列表"
date: 2022-02-08T10:17:18+08:00
weight: 10
description: >
    查看物理机列表信息
---

### 列表

### 查询物理机

```bash
# list baremetal 记录
climc host-list --baremetal true

# list 已经安装系统的物理机
climc host-list --baremetal true --occupied

# list 未安装系统的物理机
climc host-list --baremetal true --empty

# 查询物理机详情，包括硬件信息，机房信息
climc host-show <host_id>
```

### 获取物理机登录信息

```bash
climc host-logininfo <host_id>
```
