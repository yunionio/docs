---
title: "进入/退出维护模式"
date: 2022-02-07T19:12:28+08:00
weight: 80
description: >
    将物理机进入/退出维护模式，维护模式下可以更改分区、重做RAID、更改密码等
---

### 进入维护模式

该功能用于将已分配裸金属设备的物理机进入离线系统（PXE引导系统），管理员在离线系统可以进行更改分区、重做RAID、更改密码等操作。未分配的物理机默认就处于离线系统。

<big>**climc操作**</big>

```bash
climc host-maintenance <host_id>
```

### 退出维护模式

该功能用于退出维护模式。

<big>**climc操作**</big>

```bash
climc host-unmaintenance <host_id>
```
