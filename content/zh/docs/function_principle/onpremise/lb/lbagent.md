---
title: "Lbagent部署"
date: 2023-02-20T15:47:12+08:00
weight: 10
description: >
    介绍负载均衡Lbagent部署方法
---

Lbagent是负责负载均衡数据转发的节点，可以部署在经典网络的虚拟机，或者物理机上。

Lbagent内部署了如下软件，实现高可用的4层和7层负载均衡功能：

* haproxy：负责TCP四层负载均衡和http/https七层负责均衡
* gobetween: 负责UDP四层负载均衡转发
* keepalived: 负责主备节点的切换

一个LB集群一般由两个lbagent组成主备切换的高可用集群，其中通过keepalived实现主备自动切换。

在使用负载均衡功能前，需要有实现负载均衡转发功能的由Lbagent组成的负载均衡集群。
本文介绍如何部署Lbagent以组成负载均衡集群。

## 3.9（含）之前版本部署Lbagent

3.9（含）之前版本负载均衡仅支持经典网络，采用前端界面部署Lbagent，部署流程如下：

1. 创建负载均衡集群（lbcluster）
2. 为lbcluster创建一对lbagent
3. 在前端界面的lbagent列表上，点击lbagent的“部署”，输入lbagent所需keystone账号，repo地址等信息，通过后端的ansible脚本自动化实现lbagent的部署。

## 3.10（含）之后版本部署Lbagent

自3.10(含）版本之后，负载均衡开始支持VPC内虚拟机的负载均衡，并可以挂载EIP。同时，部署流程更新为：

1、采用ocboot将已有虚拟机或物理机部署为lbagent节点
2、创建lbcluster
3、将一对lbagent节点和一个lbcluster关联，实现lbagent的自动化配置

### lbagent节点的部署

采用ocboot，采用如下命令将地址为<ip_of_lbagent_node>的经典网络虚拟机或物理机部署为一台lbagent：

```bash
./ocboot add-lbagent <ip_of_master_node> <ip_of_lbagent_node>
```

部署成功的lbagent节点是k8s集群的一个节点，并且带有如下label：

```
onecloud.yunion.io/lbagent=enable
```

## 将3.9（含）之前版本lbagent升级为3.10

对于已经部署了3.9（含）之前版本的lbagent节点，可以通过如下步骤升级为3.10的lbagent：

* 安装3.10的yum repo
```bash
cat > /etc/yum.repos.d/yunion.repo << EOF
[yunion]
name=Packages for Yunion- $basearch
baseurl=https://iso.yunion.cn/centos/7/3.10/x86_64
failovermethod=priority
enabled=1
gpgcheck=0
sslverify=1
EOF
```

* 更新节点的内核为最新的计算节点的内核，重启节点使得新内核生效

```bash
yum install -y kernel-5.4.130 linux-firmware
```

* 安装ovs和ovn软件包

```bash
yum install -y openvswitch openvswitch-ovn-common openvswitch-ovn-host kmod-openvswitch
```

* 设置ovs开机自动启动

```bash
systemctl enable --now openvswitch
```

* 初始化ovn-controller: 

```bash
# 配置ovn
ovn_encap_ip=xx							# 隧道外层IP地址，EIP网关用它与其它计算节点通信
ovn_north_addr=yy:32242					# ovn北向数据库的地址，yy一般选择某台宿主机ip地址；端口默认为32242，对应k8s default-ovn-north service中的端口号
ovs-vsctl set Open_vSwitch . \
	external_ids:ovn-bridge=brvpc \
	external_ids:ovn-encap-type=geneve \
	external_ids:ovn-encap-ip=$ovn_encap_ip \
	external_ids:ovn-remote="tcp:$ovn_north_addr"
# 启动ovn-controller
systemctl enable --now ovn-controller
```

* 安装最新的yunion-lbgent，并重启

```bash
yum install -y yunion-lbagent
systemctl restart yunion-lbagent
```
