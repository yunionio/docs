---
title: "更换节点IP"
linkTitle: "更换节点IP"
weight: 400
description: >
  介绍更换控制节点和计算节点的IP的方法步骤
---

本文介绍更换集群控制节点和计算节点IP的方法步骤.

由于Kubernetes的节点IP无法动态更换，更换后必须重新部署Kubelet服务，因此更换节点IP后，需要将节点上Kubelet实例重置，并重新部署节点。

下面分几种情况讨论：

### AllInOne节点更换IP

1. 清理Kubelet

```bash
ocadm reset -f
kubeadm reset -f
```

2. 修改config.yml

在/opt/yunion/upgrade保存有部署时使用的config.yml。备份该yaml文件，并修改文件，将旧的IP地址替换为新的IP地址。

3. 重新部署

使用ocboot重新部署AllInOne节点

```
ocboot install config.yml
```

4. 开启operator sync-user模式

重新部署会重新生成各个服务在mysql的账号的密码，以及各个服务账号的密码。这些信息都存储在数据库中。重新部署之后，新的Kubernetes中configmaps中留下的密码和旧的配置不一致，会导致服务无法正常启动。解决的办法是：修改onecloud-opeartor服务的启动参数，添加-sync-user参数，这样operator会自动更新数据库中保存的密码，确保和Kubernetes的configmaps中的密码一致。

```bash
kubectl -n onecloud edit deployment onecloud-operator
```

### 高可用集群的控制节点更换IP

TODO

### 私有云计算节点更换IP

计算节点更换IP的流程同AllInOne，但是需要在控制节点删除清理该节点信息，包括k8s的node信息和云平台的宿主机信息。删除干净后，再运行上述命令，重置计算节点的Kubenetes.
