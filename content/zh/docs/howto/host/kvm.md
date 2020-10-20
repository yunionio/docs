---
title: "KVM 宿主机"
weight: 1
date: 2019-07-19T20:00:14+08:00
---

云联壹云 原生提供基于 kvm 的私有云虚拟机管理功能，运行 kvm 虚拟机的机器叫做宿主机，这种宿主机也叫作 "计算节点"，上面会运行管理虚拟机、网络和存储的一系列服务，如何部署并上线宿主机请参考: [安装部署/计算节点](/setup/host/)。

## 宿主机操作

### 查询

通过 `host-list` 查询宿主机列表，`host-show` 查询宿主机详情。

```bash
# 查询 kvm 这种类型的宿主机
$ climc host-list --hypervisor kvm

# 查询被禁用的 kvm 宿主机
$ climc host-list --hypervisor kvm --disabled

# 查询启用的 kvm 宿主机
$ climc host-list --hypervisor kvm --enabled
```

### 启用

kvm 宿主机上线后，默认是禁用的状态，需要启用才能创建虚拟机。

```bash
# 找到禁用的宿主机
$ climc host-list --disabled

# 启用
$ climc host-enable <host_id>
```

### 禁用

如果完全不想让宿主机创建虚拟机，可以禁用它。

```bash
$ climc host-disable <host_id>
```
