---
title: "如何更改宿主机网卡接入的二层网络"
weight: 100
description: >
   介绍如何在平台宿主机网卡对接的二层网络。
---

在对{{<oem_name>}}网络概念不太清晰的情况下，新接入宿主机时，经常发生无法判断是否需要新增二层网络，导致宿主机接入错误的二层网络的情况。

本文介绍在宿主机接入二层网络配置错误的情况下，如果通过命令修正，更改宿主机接入的二层网络。

首先需要确认宿主机上没有虚拟机。

查看宿主机的接入参数，执行如下命令：

```bash
climc host-wire-list --host <host_id> --details
```

一般输出参数如下：
```bash

```

## 第一步：把宿主机对接二层网络的记录删除

```bash
climc host-remove-netif localhost '0c:c4:7a:0e:fa:f5'
```

## 第二步：把对应的IP子网删除

此时，宿主机接入的IP子网也配置在了错误的二层网络之上。目前，不支持更改IP子网的二层网络。因此，需要先把对应的IP子网删除，再在新的二层网络上重建该IP子网。

删除旧的宿主机IP子网

```bash
climc network-delete adm4
```

在新的二层网络重新建宿主机IP子网

```bash
climc network-create --gateway 10.2.53.254 --server-type baremetal <name_of_new_wire> adm4 10.2.53.55 10.2.53.55 24
```

## 第三步：重建宿主机的对接网络记录

```bash
climc host-add-netif --ip-addr 192.168.3.201 --bridge br0 --interface bond0 --type admin localhost 73710abe-a0cf-48de-8fcd0-0b7b0492f4ef '0c:c4:7a:0e:fa:f4' 0
```

