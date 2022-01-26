---
title: "下线计算节点"
weight: 11
description: >
  本节介绍如何下线私有云计算节点
---

如果需要将一个计算节点（宿主机）从私有云下线，需要执行以下步骤确保一个计算节点干净下线。

1. 将该宿主机上的虚拟机全部迁移走。确保该宿主机上没有虚拟机，该宿主机上的本地存储没有磁盘

2. 删除宿主机记录，可以在Web前端操作，或者在控制节点执行 climc 命令

```bash
climc host-delete <host_id>
```

注意：如果删除宿主机记录失败，可能的原因是宿主机上还有未清理的虚拟机，或者宿主机的本地存储有未清理的磁盘。发生这个情况时，可以通过 climc 容器的 clean_host.sh 脚本自动清理该宿主机上残留的虚拟机和本地磁盘，并且删除宿主机的数据库记录

```bash
kubectl -n onecloud exec -it default-climc-xxxxxxxx /bin/bash # 进入climc容器执行如下命令
cd /opt/yunion/scripts/tools/
clean_host.sh <host_id>
```

3. 删除该节点在ovn中的chassis记录

首先，停止该宿主机上的openvswitch服务，清理 /etc/openvswitch 目录：

```bash
systemctl stop openvswitch
rm -fr /etc/openvswitch/*
```

其次，在控制节点执行：

```bash
$ kubectl -n onecloude exec -it default-ovn-north-xxxxx /bin/sh # 进入ovn-northd容器执行以下命令
/ # ovn-sbctl show # 找到该宿主机对应的chassis id，通过hostname和ip确认
...
Chassis "e6268b2e-4311-4f6d-a6e2-ddd09f49beef"
    hostname: taishan
    Encap geneve
        ip: "192.168.222.60"
        options: {csum="true"}
...
/ # ovn-sbctl chassis-del <chassis_id>
```

4. 在该宿主机上清理kubelet环境，在该宿主机上执行：

```bash
kubeadm reset -f
```

5. 删除该宿主机对应的k8s节点信息，在控制节点执行：

```bash
kubectl get nodes # 查找该节点的k8s node名称
kubectl delete node <node_name>
```
