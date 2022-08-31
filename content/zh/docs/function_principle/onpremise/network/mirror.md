---
title: "流量镜像"
weight: 900
description: >
  介绍流量镜像概念和操作
---

本节介绍流量镜像的概念和操作。流量镜像是用来抓取任意虚拟机的网络流量送到指定的虚拟机的虚拟网卡或者物理机的物理网卡，无论该虚拟机在哪台宿主机，在哪个VPC，以及虚拟机的操作系统。可以采用第三方流量抓取软件从该虚拟或物理网卡获取流量，进行流量分析，流量回放测试等。

## 功能组件

流量镜像功能包含两个资源：

* 镜像目的(tap_service)：用于定义收集流量的虚拟网卡。如果镜像目的是一台虚拟机，则平台会为这台虚拟机增加一个虚拟网卡，专门用于采集流量。如果镜像目的是一台物理机，则需要指定采集流量的物理网卡的mac地址，平台将把该物理网卡加入网桥，将采集到的流量输出到该物理网卡。(在镜像目的为物理机的场景，该物理网卡必须为未使用的物理网卡。)

* 镜像源(tap_flow)：用于定义流量的来源。流量的来源可以是指定虚拟机的指定网卡。也可以是指定宿主机的某个虚拟交换机（通过二层网络指定）的全部或部分流量。

## 工作原理

每台宿主机有一个专门用于流量镜像采集的虚拟网桥brtap。

如果虚拟机作为镜像目的，则该虚拟机增加一个虚拟网卡，并且该网卡自动加入所在宿主机的brtap。如果该宿主机作为镜像目的，则该宿主机用于流量采集的网卡自动加入宿主机的网桥brtap。

如果镜像源和镜像目的在同一台宿主机，则会通过patch port，将源虚拟机的流量送到brtap。如果镜像源和镜像目的不在同一台宿主机，则会通过GRE隧道将流量送到镜像目的所在宿主机的brtap。

宿主机上的sdnagent负责配置brtap的流表，将归属于镜像目的镜像源的流量发送到镜像目的网络端口。

## 操作方法

### 创建镜像目的

1、创建虚拟机镜像目的

```bash
climc tap-service-create --type guest --target-id <id_of_guest> <name_of_tap_service>
```

2、创建物理机镜像目的

```bash
climc tap-service-create --type host --target-id <id_of_host> --mac-addr <mac_addr> <name_of_tap_service>
```

### 创建镜像源

1、创建虚拟机网卡镜像源

```bash
climc tap-flow-create --guest-id <guest_id> --mac-addr <mac_addr> --ip-addr <ip_addr> --direction <IN|OUT|BOTH> --tap-id <tap_service_id> --type vnic <name_of_tap_flow>
```

2、创建虚拟交换机镜像源

```bash
climc tap-flow-create --host-id <host_id> --wire-id <wire_id> --vlan-id <vlan_id> --direction <IN|OUT|BOTH> --tap-id <tap_service_id> --type vswitch <name_of_tap_flow>
```

### 启用镜像目的和源

1. 镜像目的创建后默认是禁用状态，需要手动启用

```bash
climc tap-service-enable <tap_service_id>
climc tap-service-disable <tap_service_id>
```

2、镜像源创建后默认启用状态

```bash
climc tap-flow-disable <tap_flow_id>
climc tap-flow-enable <tap_flow_id>
```


