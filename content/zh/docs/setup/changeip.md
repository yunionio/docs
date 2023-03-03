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

## AllInOne节点更换IP

### 1. 清理Kubelet

```bash
$ ocadm reset -f
$ kubeadm reset -f
```

### 2. 修改旧的config.yml

{{% alert title="注意" color="warning" %}}
- 如果第一次部署是直接运行的 `./run.py $ip` 这种方式，生成的配置文件就在 ocboot 目录下的 config-allinone-current.yml 文件
- 如果第一次部署是用的自定义配置文件，请使用相关配置文件
- 如果第一次部署是用的商业版本 iso 部署的，配置文件在 opt/yunion/upgrade/config.yml 路径
{{% /alert %}}


下面假设第一次部署运行的命令为 `./run.py $ip` 这种形式，所以生成的配置文件在运行 ocboot 目录下的 config-allinone-current.yml 文件。

在第一次运行 ocboot 目录下保存有当时部署时使用的 config-allinone-current.yml 配置文件。备份该 yaml 文件，并修改文件，将旧的 IP 地址替换为新的 IP 地址。

```bash
$ cp ./config-allinone-current.yml config.yml
$ vim config.yml
# 修改里面节点的 ip 地址，包括 primary_master_node 下面的 hostname，controlplane_host
# 如果当时部署的 mariadb 也在该节点上，还要修改 mariadb_node 里面的 hostname 以及 primary_master_node 里面的 db_host
```


### 3. 重新部署

使用 ocboot 重新部署 AllInOne 节点

```
$ ./ocboot.py install config.yml
```

### 4. 开启operator sync-user模式

重新部署会重新生成各个服务在mysql的账号的密码，以及各个服务账号的密码。这些信息都存储在数据库中。重新部署之后，新的Kubernetes中configmaps中留下的密码和旧的配置不一致，会导致服务无法正常启动。解决的办法是：修改onecloud-opeartor服务的启动参数，添加-sync-user参数，这样operator会自动更新数据库中保存的密码，确保和Kubernetes的configmaps中的密码一致。

```bash
$ kubectl -n onecloud edit deployment onecloud-operator
# 找到 .spec..containers[0].command 路径，添加 '-sync-user' 参数
```

修改后的结果如下图：

![](../../quickstart/images/oo_syncuser.png)

## 私有云计算节点更换IP

计算节点更换IP的流程同AllInOne，但是需要在控制节点删除清理该节点信息，包括k8s的node信息和云平台的宿主机信息。删除干净后，再运行上述命令，重置计算节点的Kubenetes，流程如下：

### 1. 清理Kubelet

下面命令在计算节点上运行，清理节点上的 kubelet

```bash
$ ocadm reset -f
$ kubeadm reset -f
```

### 2. 删除 node 信息

下面命令在控制节点运行

```bash
# 假设要删除的节点为 node1
$ nodename=node1
$ kubectl delete node $nodename
```

### 3. 使用 ocboot 重新加入节点

```bash
$ ./ocboot.py add-node $primary_master_ip $target_node_ip
```

## FAQ

### 1. 计算节点 host 服务运行异常或者平台对应的宿主机记录状态未知，怎样查看计算节点上 host 服务的日志？

```bash
# 先确定有问题的计算节点在当前 k8s 里面的节点名称
$ kubectl get nodes
NAME                       STATUS   ROLES    AGE    VERSION          INTERNAL-IP       EXTERNAL-IP   
ceph-01                    Ready    <none>   127d   v1.15.12         192.168.222.111   <none>        
ceph-02                    Ready    <none>   127d   v1.15.12         192.168.222.112   <none>        


# 比如现在要查看 ceph-02 上的 host 服务日志，命令如下
$ kubectl logs -n onecloud $(kubectl get pods -n onecloud -o wide | grep host | egrep -v 'image|deployer' | grep ceph-02 | awk '{print $1}') -c host
# 然后查看 host 服务里面相应的报错日志
```

- 若日志报错信息中包含“register failed: try create network: find_matched == false”，则表示未成功创建包含宿主机的IP子网，导致宿主机注册失败，请创建包含宿主机网段的IP子网。
- 若日志报错信息中包含“name starts with letter, and contains letter, number and - only”，则表示宿主机的主机名不合规，应改成以字母开头的hostname
