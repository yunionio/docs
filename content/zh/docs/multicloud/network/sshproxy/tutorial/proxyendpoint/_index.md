---
title: "SSH代理节点"
date: 2021-12-16T15:50:52+08:00
weight: 10
description: >
    SSH代理节点用于建立平台与VPC网络之间的通信隧道
---

SSH代理节点用于建立平台与VPC网络之间的通信隧道，实现平台对VPC中资源的管理，安装监控Agent，收集监控数据等。

通过在VPC中选择一台能与外网联通的虚拟机作为SSH代理节点，后续平台可以通过该SSH代理节点的local forward为VPC内网络互通的虚拟机安装Agent，监控Agent收集到监控信息也将通过SSH代理节点的remote forward上报到平台。