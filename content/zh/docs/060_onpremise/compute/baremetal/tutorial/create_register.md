---
title: "纳管机器"
weight: 10
draft: true
description: >
  介绍如何把物理服务器纳管到云平台的物理机资源池。
---

物理机管理的第一步就是把机器的信息注册到云平台，包括硬件信息（存储、内存大小和 CPU 型号等等），网卡 IP 配置等等。
把物理服务器纳管到云平台的物理机资源池后，就可以对该物理机进行安装操作系统、开关机等操作。

纳管物理机的原理是先引导启动进入云平台定制的 [YunionOS](https://github.com/yunionio/yunionos) 系统，然后这个系统会探测物理机的硬件信息，开启 SSH 服务，然后由平台管理。

## 物理机纳管相关概念介绍

- YunionOS 是通过带外控制将物理机引导启动进入一个临时操作系统，这是一个通过 buildroot 定制的精简 Linux 系统，内置物理机管理需要的工具软件。Baremetal 管理服务通过 SSH 进入这个系统，实现一些更复杂的管理操作，例如配置 RAID，部署操作系统镜像等。
- Redfish 是一种基于 HTTPS 服务的管理标准，利用 RESTful 接口实现设备管理。通过 Redfish API 管理物理服务器。目前最新的主流服务器（如Dell iDRAC 9, HPE iLO 9等）都已支持 Redfish。
- BMC 是 Baseboard Management Controller 的缩写，是物理服务器内一个独立嵌入系统，不依赖服务器的 CPU，操作系统和 BIOS，提供物理服务器的带外管理控制功能，例如获取物理服务器的参数指标，对物理服务器执行开关机等简单操作。

## 前提条件

### 启用 Baremetal 管理服务

参考文档：[物理机管理服务](/zh/docs/setup/baremetal) 启用 Baremetal 物理机管理服务。

### 创建网络

接下来根据场景介绍如何把现有的服务器纳管到云平台。

## 环境准备

## 引导注册

引导注册分为 **ISO 引导注册** 和 **PXE 引导注册**，这两种注册方式都要求物理机已经配置好 BMC IPMI 信息。ISO 引导注册是使用 Redfish API 挂载 yunionos ISO 系统进行启动，PXE 引导则是让物理机 PXE 启动，然后通过 DHCP 和 TFTP 服务加载 yunionos 系统进行启动。

这两种方式的区别如下表所示：

|                   | ISO 引导注册         | PXE 引导注册                           |
|-------------------|----------------------|----------------------------------------|
| BMC 要求          | 支持 Redfish API     | 支持 IPMI                              |
| yunionos 启动方式 | Redfish 挂载 ISO     | IPMI PXE 启动                          |
| 网络要求          | 管理服务和物理机能通 | 需要配置 DHCP Relay 指向云平台管理服务 |

### ISO 引导注册

假设要引导注册的物理机已经配置好 BMC ，并且支持 Redfish API。

IPMI 的连接信息为 10.0.2.3，用户 root，密码 test@ipmiPWD。

对应前端截图如下：


