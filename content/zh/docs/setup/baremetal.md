---
title: "物理机管理服务"
weight: 11
description: >
  如果要使用 Cloudpods 私有云物理机管理功能，需要启用物理机管理服务(baremetal-agent)，本节介绍如何部署相应组件
---

启用 baremetal-agent 之前需要部署 Cloudpods 集群，详见 ["安装部署/部署集群"](../../setup/controlplane) 。

待集群准备完毕后需要指定集群中的一个 node 来部署 baremetal-agent 服务。

{{% alert title="注意" color="warning" %}}
目前只能指定一个 node 来部署运行 baremetal-agent 服务，因为 baremetal-agent 服务是有状态的，不能多副本夸节点运行。
{{% /alert %}}

## 启用 baremetal-agent

在通过 pxe 引导流程中，baremetal-agent 只会处理来自 dhcp relay 服务器的请求, 所以你需要事先在交换机配置 dhcp relay 或者使用 Cloudpods host 服务的 dhcp relay 功能。

### 如何配置 host 服务 启用 dhcp relay

{{% alert title="注意" color="warning" %}}
如果在交换机上配置了 dhcp relay，则不需要在这里配置计算节点的 dhcp_relay 了，可以跳过这一步。
{{% /alert %}}

```bash
# 登录到已经部署好计算节点的服务器上修改 /etc/yunion/host.conf，添加 dhcp_relay 配置项：
dhcp_relay:
- 10.168.222.198 # baremetal agent dhcp服务监听地址
- 67             # baremetal agent dhcp服务监听端口
# 然后重启host服务
$ kubectl get pods -n onecloud -o wide | grep host
default-host-p6d8h                       2/2     Running   0          78m    10.168.222.189   k8s-dev1   <none>           <none>
default-host-xdc7x                       2/2     Running   0          78m    10.168.222.150   k8s-dev2   <none>           <none>
# 找到对应的 pod 删除等待 host 服务自动重启
$ kubectl delete pods -n onecloud default-host-xdc7x
```

### 启用 baremetal-agent

然后选择 node 启用 baremetal-agent。
```bash
# $listen_interface 指的是 baremetal-agent 监听的网卡名称
$ ocadm baremetal enable --node $node_name --listen-interface $listen_interface
# 观察 baremetal agent pod 状态查看是否启动成功
$ watch "kubectl get pods -n onecloud | grep baremetal"
default-baremetal-agent-7c84996c9b-hhllw   1/1     Running   0          3m10s
# 启动成功确认 baremetal-agent 注册到控制节点
$ climc agent-list
+--------------------------------------+--------------------------+----------------+-----------------------------+---------+------------+------------------------------------------+--------------------------------------+
|                  ID                  |           Name           |   Access_ip    |         Manager_URI         | Status  | agent_type |                 version                  |               zone_id                |
+--------------------------------------+--------------------------+----------------+-----------------------------+---------+------------+------------------------------------------+--------------------------------------+
| f3c2c671-c41d-4f30-8d04-e022b49bb9b5 | baremetal-10.168.222.150 | 10.168.222.150 | https://10.168.222.150:8879 | enabled | baremetal  | remotes/origin/master(5e415506120011509) | 6230b485-2e54-480e-8284-33360b8202a8 |
+--------------------------------------+--------------------------+----------------+-----------------------------+---------+------------+------------------------------------------+--------------------------------------+
```

部署完成后可以参考 ["操作管理/物理机"](../../howto/baremetal) 来进行对物理机的注册管理。


## 禁用 baremetal-agent

可以在启用 baremetal-agent 的节点中选择节点禁止 baremetal-agent 调度到该节点。

```bash
ocadm baremetal disable --node $node_name
```
