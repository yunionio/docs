---
title: "KVM 宿主机"
weight: 1
date: 2019-07-19T20:00:14+08:00
---

Cloudpods 原生提供基于 kvm 的私有云虚拟机管理功能，运行 kvm 虚拟机的机器叫做宿主机，这种宿主机也叫作 "计算节点"，上面会运行管理虚拟机、网络和存储的一系列服务，如何部署并上线宿主机请参考: [安装部署/计算节点](/zh/docs/setup/host/)。

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

### host 服务启动失败或者页面有 warning 如何处理
#### 禁用 dhcp 服务

如果你看到了这样的提示：`dhcp: dhcp client is enabled before host agent start, please disable it.`

说明你的机器之前启用过dhcp client.

如何禁用 dhcp client：
```bash
# 一般 centos7 的 dhcp client 都是由 NetworkManager 启动的
$ systemctl disable NetworkManager --now

# 我们会检查 /var/run/dhclient-<nic>.pid 下是否有dhclient的pid文件来决定是否要输出 warning
# 所以同时你需要清除 /var/run 下的 dhclient-<nic>.pid 文件, nic 需要替换成自己的网卡名，如 eth0
$ rm -f /var/run/dhclient-<nic>.pid
```

#### 内核模块不匹配

使用我们的平台的 host 服务需要用我们的内核，如果你看到了这样的提示：

`openvswitch: kernel module openvswitch paramters version not found, is kernel version correct ??`

或者 `uname -r` 输出结果中字段不包含 yn. 正确的：`3.10.0-514.26.2.el7.yn20180608.x86_64`

说明你的机器使用的不是我们的内核， 需要安装我们的内核然后重启。

如何安装我们的内核可以参考[安装部署流程](/zh/docs/setup/host/#安装依赖)
