---
title: "原理介绍"
weight: 1
date: 2019-07-19T20:28:13+08:00
description: >
  介绍物理机服务的原理。
---

## 术语解释

- Baremetal: 指尚未安装操作系统的服务器， 也叫作物理机
- [PXE (Preboot eXecution Environment)](https://zh.wikipedia.org/wiki/%E9%A2%84%E5%90%AF%E5%8A%A8%E6%89%A7%E8%A1%8C%E7%8E%AF%E5%A2%83): 使用网络接口启动计算机的机制。这种机制不依赖本地数据存储设备（如硬盘）或本地已安装的操作系统，使用 DHCP 协议查找引导服务器并获取 IP，再通过 TFTP 协议下载初始引导程序和附加文件启动
- [DHCP (Dynamic Host Configuration Protocol)](https://zh.wikipedia.org/wiki/%E5%8A%A8%E6%80%81%E4%B8%BB%E6%9C%BA%E8%AE%BE%E7%BD%AE%E5%8D%8F%E8%AE%AE): 动态主机设置协议是一个局域网的网络协议，使用UDP协议工作，为机器分配 IP
- [TFTP (Trivial File Transfer Protocol)](https://zh.wikipedia.org/wiki/%E5%B0%8F%E5%9E%8B%E6%96%87%E4%BB%B6%E4%BC%A0%E8%BE%93%E5%8D%8F%E8%AE%AE): 小型文件传输协议，使用UDP协议传输文件
- DHCP Relay: 在不同子网和物理网段之间处理和转发dhcp信息的功能
- [IPMI (Intelligent Platform Management Interface)](https://zh.wikipedia.org/wiki/IPMI)：管理服务器硬件的标准，特性是独立于操作系统外自行运行，即使在缺少操作系统或系统管理软件、或受监控的系统关机但有接电源的情况下仍能远程管理系统，也能在操作系统引导后运行
- [BMC (Baseboard management controller)](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface#Baseboard_management_controller): 基板管理控制器，支持行业标准的 IPMI 规范
- [SSH (Secure Shell)](https://zh.wikipedia.org/wiki/Secure_Shell): 用于远程登录控制服务器
- [RAID (Redundant Array of Independent Disks)](https://zh.wikipedia.org/wiki/RAID): 磁盘阵列，把多个硬盘组合成为一个逻辑扇区，操作系统只会把它当作一个硬盘

- Region Service: 云平台控制服务，提供 baremetal 相关 API
- Baremetal Agent: 云平台管理 baremetal 的服务
- Glance Service: 云平台镜像服务，提供物理机装机的 Image 镜像
- 裸金属服务器: baremetal 物理机安装操作系统后，在云平台创建的 server 的记录
- 宿主机: 可以运行云平台虚拟机的节点