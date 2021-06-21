---
title: "如何手动更改安装了操作系统的裸金属服务器RAID配置"
date: 2021-06-09T22:25:05+08:00
weight: 1
---

## 手动更改安装了操作系统的裸金属服务器的RAID配置

Cloudpods裸金属管理可以实现在安装操作系统的过程中，自动化地配置RAID配置，支持MegaRaid，HPSmart Array等RAID卡。但是安装完操作系统后，在不重装系统的情况下，无法重新自动配置RAID，例如，给RAID增加磁盘或者更改RAID级别等。这时候就必须通过手动方式进行。本文介绍如何手动更改安装了操作系统的裸金属服务器的RAID配置。

1. 将该裸金属服务器重启进入维护模式

```bash
climc host-maintenance <host_id>
```

该命令将重启物理机，并启动进入网络PXE引导的内存操作系统

2. 等引导启动进入内存操作系统后，ssh登入该系统

```bash
climc host-ssh <host_id>
```

3. 更改RAID配置

RAID的工具软件位于内存操作系统的/opt目录下，包含MegaRaid, HPSA, SAS, Marvel等RAID的控制工具软件

4. 更改RAID配置完成后，重启恢复已安装的操作系统

```bash
climc host-unmaintenance <host_id>
```
