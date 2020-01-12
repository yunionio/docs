---
title: "物理机节点"
weight: 11
description: >
  如果要运行 onecloud 私有云物理机，需要添加对应的物理机管理节点，本节介绍如何部署相应组件
draft: true
---

#### 启用baremetal-agent(可选)

如果要使用物理机管理服务, 则需要在集群准备完毕后指定node来部署baremetal-agent服务。

baremetal-agent只会处理来自dhcp relay服务器的请求, 所以你需要事先在交换机配置dhcp relay或者使用host服务的dhcp relay功能。

```bash
# 启用host服务的dhcp relay:
# 登录到已经部署好计算节点的服务器上修改 /etc/yunion/host.conf，添加dhcp_relay配置项：
dhcp_relay:
- 10.168.222.198 # baremetal agent dhcp服务监听地址
- 67             # baremetal agent dhcp服务监听端口
# 然后重启host服务
```

然后选择node启用baremetal-agent。
```bash
# $listen_interface指的是baremetal-agent监听的网卡名称
ocadm baremetal enable --node $node_name --listen-interface $listen_interface
```

也可以在启用baremetal-agent的节点中选择节点禁止baremetal-agent调度到该节点。
```bash
ocadm baremetal disable --node $node_name
```


