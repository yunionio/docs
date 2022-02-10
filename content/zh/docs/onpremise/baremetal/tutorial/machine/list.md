---
title: "查看物理机列表"
date: 2022-02-08T10:17:18+08:00
weight: 10
description: >
    查看物理机列表信息
---

### 列表

该功能用于查看物理机列表的信息。

1. 在左侧导航栏，选择 **_"主机/基础资源/物理机"_** 菜单项，进入物理机页面。
2. 查看以下参数： 
   - 启用：表示物理机是否能用于创建裸金属，只有启用状态的物理机可以创建裸金属。
   - 状态：物理机的运行状态。
   - IP：包括物理机的管理IP和带外IP，带外IP即IPMI的IP地址。
   - SN：序列号等。
   - 分配：显示物理机是否已分配创建了裸金属，此处显示具体的物理机创建的裸金属名称。
   - 初始账号：获取连接物理机的用户名和密码。
   - IPMI：包括IPMI用户名、IPMI密码和IPMI IP。
   - 维护模式：查看物理机是否进入维护模式，进入维护模式的物理机即进入了YunionOS小系统。

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