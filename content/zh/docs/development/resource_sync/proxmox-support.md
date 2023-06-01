---
title: "纳管对接 Proxmox 资源支持"
edition: ce
weight: 400
description:
  Proxmox 的虚拟机、网络和存储资源纳管到 cloudpods 平台的一些开发相关说明
---

# 资源ID 以及 与Proxmox 对应关系

| 名称         | 抽象资源                 | Proxmox对应关系，说明 | ID格式    | 例子
|--------------|------------------------- | ----------------------|------------------------------------------|-------------------------|
| host         | 服务器                   | node                  | node/{node name}                         | node/abc                |
| zone         | 云平台数据中心           | cluster               |                                          |                         |
| storage      | 存储                     | storage               | storage/{node name}/{storage name}       | storage/abc/local       |
| disk         | 云硬盘                   | disk                  | {storage name}:vm-{vm id}-disk-{slot id} | local:vm-100-disk-0     |
| network      | 网络                     | network               | network/abc/{network name}               | network/abc/vmbr1       |
| instance     | 虚拟机                   | qemu(vm)              | vmid                                     | 100                     |

# 功能说明

1. Proxmox的API很多情况都是需要node的名字，因此需要调用API的时候需要先分析该资源的ID，从ID知道所在的node。
2. image 功能目前未实现。 image 显示Proxmox 当中 qemu 模板
3. 目前仅支持单机模式的Proxmox。不支持管理多节点的Proxmox集群，在多节点情况，storage资源模型复杂

cluster : 提供整个Proxmox集群 vm、node、storage资源查找，因为network 和disk 在Proxmox集群中是没有全局ID ， cluter提供帮助查找到 network 或 disk 是在node下哪个vm 或storage。
disk : disk-list 与 disk-show 只会找到与vm相关的disk。
instance : 创建vm 只会创建空的系统磁盘。

# 相关网址
1. Proxmox VE API Documentation https://pve.proxmox.com/pve-docs/api-viewer/index.html
2. Network Configuration - Proxmox VE https://pve.proxmox.com/wiki/Network_Configuration
3. Proxmox VE Documentation Index https://pve.proxmox.com/pve-docs/index.html
4. Storage - Proxmox VE https://pve.proxmox.com/wiki/Storage
