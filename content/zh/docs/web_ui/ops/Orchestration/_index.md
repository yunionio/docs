---
title: "编排"
weight: 3
draft: false
description: 通过Helm编排一键部署虚拟机实例和容器实例。  
---

编排使用流程：

- 在[Helm仓库](../orchestration/k8s-repo/)中对接虚拟机类型和容器类型等Helm仓库。
- 在[应用市场](../orchestration/k8s-chart/)中选择虚拟机类型或容器类型的应用部署。
   - 部署容器类型应用前需要在[容器](../../docker)中创建容器集群以及命名空间等。
   - 部署虚拟机类型应用前请确保平台中有“CentOS-7.6.1810-20190430.qcow2”镜像、可用宿主机或公有云/私有云云账号等。