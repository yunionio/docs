---
title: "VPC原理"
weight: 200
description: >
  介绍如何VPC网络的实现原理
---

{{<oem_name>}}VPC网络的功能基于开源项目 [OVN](https://ovn.org) 实现。

从3.10开始，采用ovn版本为 2.12.4。

如下图为{{<oem_name>}}和ovn的相关组件架构图。

<img src="../vpc-ovn.png" width="500">

各个组件的功能说明如下：

| 组件            | 部署位置 | 作用                                               |
|----------------|---------|---------------------------------------------------|
| region         | 控制节点 | 云控制器，管理VPC，IP子网，EIP等资源的数据，提供API接口   |
| vpcagent       | 控制节点 | 负责将云平台的网络拓扑信息同步转换存储到ovn northdb      |
| ovn-northd     | 控制节点 | 包含ovn-northdb, ovn-northd和ovn-sourthdb等三个组件，ovn-northd存储虚拟网络面向云平台的北向数据库，ovn-sourthd存储虚拟网络面向底层设备的南向数据库，ovn-northd负责数据格式的翻译和转换 |
| ovn-controller | 计算节点 | 从ovn-southdb获取本计算节点（chassis）的网络配置信息，并翻译为流表，注入本地的openvswitch |
| host           | 计算节点 | 云平台的宿主机管理代理程序，跟云控制器通信，负责本机虚拟机的管理，包括信息的同步，配置的管理等  |
| sdnagent       | 计算节点 | 负责将虚拟机的配置同步到ovs，实现物理网络和虚拟网络的对接    |
| ovs            | 计算节点 | 负责管理计算节点的虚拟交换机配置，将流表同步到内核datapath  |
| ovsdb          | 计算节点 | 负责维护计算节点的虚拟交换机配置信息                      |

工作流程简要说明如下：

1. region为云控制器，实现云资源的信息管理，维护VPC，IP子网，虚拟机，EIP等资源的基础信息，以及资源之间的关联关系
2. vpcagent定期从region同步信息，并将云平台的信息转换为ovn-northd的信息，例如，将IP子网转换为ovn的虚拟机交换机，将VPC转换为ovn的虚拟路由器，
3. ovn-northd中的ovn-northdb接收vpcagent的数据更新，ovn-southd接收ovn-controller上报的物理网络信息，将ovn-northd的逻辑网络拓扑信息根据物理网络拓扑，转换为物理网络拓扑信息，保存在ovn-southd。
4. ovn-controller从ovn-southd获取本机的网络配置信息，转换为流表，注入ovs
5. host从region获取本计机运行的虚拟机的配置信息，包括虚拟机的网络接口配置，安全组，带宽限速等，并保存本地。host负责虚拟机的启动停止等。
6. sdnagent从host保存的信息获取每台虚拟机的配置信息，负责经典网络虚拟机的网络网卡配置，安全组实现和网络限速实现，负责VPC网络虚拟机的虚拟网卡设置。


