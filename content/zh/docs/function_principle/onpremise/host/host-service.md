---
title: "Host服务启动失败或有warning如何处理"
weight: 3
description: >
---


## 禁用 dhcp 服务

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

## 内核模块不匹配

使用我们的平台的 host 服务需要用我们的内核，如果你看到了这样的提示：

`openvswitch: kernel module openvswitch paramters version not found, is kernel version correct ??`

或者 `uname -r` 输出结果中字段不包含 yn. 正确的：`3.10.0-514.26.2.el7.yn20180608.x86_64`

说明你的机器使用的不是我们的内核， 需要安装我们的内核然后重启。

如何安装我们的内核可以参考[安装部署流程](/zh/docs/setup/host/#安装依赖)
