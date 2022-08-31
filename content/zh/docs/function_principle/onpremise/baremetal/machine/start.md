---
title: "开/关机"
date: 2022-02-07T19:12:10+08:00
weight: 70
description: >
    将物理机开关机
---

### 开机

该功能用于将关机状态的物理机开机。

<big>**climc操作**</big>

```bash
climc host-start <host_id>
```

### 关机

该功能用于将运行状态的物理机关机，当物理机已分配给裸金属使用时，不支持关机操作。

<big>**climc操作**</big>

```bash
climc host-stop <host_id>
```
