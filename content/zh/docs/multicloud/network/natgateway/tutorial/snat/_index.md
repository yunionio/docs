---
title: "SNAT管理"
date: 2021-12-13T16:00:44+08:00
weight: 20
description: >
    管理NAT网关上的SNAT规则
---

基于已有NAT网关的情况下，通过创建SNAT条目使VPC中IP子网的虚拟机可以通过NAT网关绑定的弹性公网IP访问公网。一条IP子网对应一条SNAT条目，如有多个IP子网需要访问公网，需要创建多个SNAT条目。