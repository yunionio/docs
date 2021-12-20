---
title: "DNAT管理"
date: 2021-12-13T16:01:09+08:00
weight: 30
description: >
    管理NAT网关下的DNAT规则
---

基于已有NAT网关的情况下，通过创建DNAT条目使VPC内的虚拟机可以向外提供互联网访问服务。一个虚拟机绑定一条DNAT条目，如有多个虚拟机需要为互联网提供服务，则需要创建多条DNAT条目。