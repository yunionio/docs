---
title: "Ceph对接"
weight: 11
description: >
  介绍如何对接非标准ceph rbd存储(启明星辰, 杉岩等存储厂商)
---

# 说明
- release/3.8 及之后版本将使用ceph及rbd命令直接操作ceph集群
- 若使用了非开源版ceph，请在计算节点装好存储厂商提供的ceph及rbd命令，并放置在**PATH**路径里面，并重启宿主机 yunion-executor.service 服务
- 若对接了多个存储厂商，且各厂商提供的rbd命令相互不兼容，需要考虑rbd命令和宿主机挂载关系，避免多套不兼容存储挂载到同一个宿主机
