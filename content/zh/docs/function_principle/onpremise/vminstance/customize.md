---
title: "调试QEMU参数"
date: 2019-07-19T18:32:40+08:00
weight: 11
description: >
  介绍如何调试修改QEMU虚拟机的命令行参数。
---

本文介绍如何调试 {{<oem_name>}} KVM虚拟机的配置参数。

## {{<oem_name>}} KVM虚拟机的配置存储位置一般在宿主机的 /opt/cloud/workspace/servers 下，该位置可以修改 /etc/yunion/host.conf 的 servers_path

在 servers 目录下，每个虚拟机ID的目录存储了该虚拟机相关的配置文件，主要的文件有：

```bash
-rw-r--r-- 1 root root 3114 May 17 10:53 desc
-rwx------ 1 root root  344 Jun 22 10:07 if-down-br0-vnet222-252.sh
-rwx------ 1 root root 1074 Jun 22 10:07 if-up-br0-vnet222-252.sh
-rw-r--r-- 1 root root 2810 Jun 22 10:07 startvm
-rw-r--r-- 1 root root  661 Jun 22 10:07 stopvm
```

其中，startvm 为启动虚拟机的脚本文件，包含了该虚拟机启动的所有命令行参数，可以修改该文件的qemu启动参数来实现调试qemu启动参数的目的。

一般步骤为：

1) 停止虚拟机

2) 修改该虚拟机的startvm脚本参数

3) 以root身份启动虚拟机：sh startvm

4) 在前端，对虚拟机执行“同步状态”的操作

5) 同步状态后，前端显示该虚拟机为运行状态，即可查看该虚拟机的vnc终端，以及进行其他控制操作
