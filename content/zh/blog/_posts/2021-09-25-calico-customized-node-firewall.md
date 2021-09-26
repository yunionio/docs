---
title: "用Calico网络策略设置主机node防火墙规则"
date: 2021-09-25
slug: calico-customized-node-firewall
---

**作者:** 小助手

Cloudpods的服务运行在一个Kubernetes集群之上，该Kubernets集群的网络方案采用了[Calico](https://docs.projectcalico.org/)。因此运行Cloudpods服务的节点的iptables规则被Calico接管。这就导致我们在Cloudpods服务节点上配置的防火墙规则会被Calico配置的iptables规则覆盖，导致防火墙规则不生效。本文介绍如何使用Calico的HostEndpoint和GlobalNetworkPolicy来设置主机节点的防火墙规则。

## 1、准备calicoctl工具

下载二进制

```bash
curl -O -L https://github.com/projectcalico/calicoctl/releases/download/v3.12.1/calicoctl
chmod +x calicoctl
```

设置环境变量

```bash
export DATASTORE_TYPE=kubernetes
export KUBECONFIG=/etc/kubernetes/admin.conf
```

## 2、配置HostEndpoint规则

对每一台主机的每个需要控制防火墙规则接口，定义对应的HostEndpoint规则

```yaml
- apiVersion: projectcalico.org/v3
  kind: HostEndpoint
  metadata:
    name: <node_name>-<interface_name>
    labels:
      role: master
      env: production
  spec:
    interfaceName: <interface_name>
    node: <node_name>
    expectedIPs: ["<interface_ip>"]
- apiVersion: projectcalico.org/v3
  kind: HostEndpoint
  metadata:
    name: <node_name>-<interface_name>
    labels:
      role: master
      env: production
  spec:
    interfaceName: <interface_name>
    node: <node_name>
    expectedIPs: ["<interface_ip>"]
```

应用该规则：

```bash
./calicoctl apply -f hep.yaml
```

## 3、定义网络规则

定义好HostEndpoint之后，采用Calico的GlobalNetworkPolicy定义防火墙规则。


```yaml
- apiVersion: projectcalico.org/v3
  kind: GlobalNetworkPolicy
  metadata:
    name: <whitelist_gnp_name>
  spec:
    order: 10
    preDNAT: true
    applyOnForward: true
    ingress:
      - action: Allow
        protocol: TCP
        source:
          nets: [<src_net_block1>, <src_net_block2>]
        destination:
          ports: [<dst_port1>, <dst_port2>]
    selector: "role==\"master\""
- apiVersion: projectcalico.org/v3
  kind: GlobalNetworkPolicy
  metadata:
    name: drop-other-ingress
  spec:
    order: 20
    preDNAT: true
    applyOnForward: true
    ingress:
      - action: Deny
    selector: "role==\"master\""
```

应用规则

```bash
./calicoctl apply -f gnp.yaml
```

## 4. failSafe机制

为防止用户错误配置导致node无法网络访问的风险，calico设计了failSafe机制，即在用户编写规则有误的情况下，部分端口也不会被封禁，导致节点功能失效。这里是FailSafe端口的信息：https://docs.projectcalico.org/reference/host-endpoints/failsafe


## 5. 配置举例

举例：master节点的外网端口只允许80和443端口，其他都禁止：

### HostEndpoint定义：

```yaml
- apiVersion: projectcalico.org/v3
  kind: HostEndpoint
  metadata:
    name: master1-em4
    labels:
      role: master
      type: external
  spec:
    interfaceName: em4
    node: master1
    expectedIPs: ["120.133.60.219"]
- apiVersion: projectcalico.org/v3
  kind: HostEndpoint
  metadata:
    name: master2-em4
    labels:
      role: master
      type: external
  spec:
    interfaceName: em4
    node: master2
    expectedIPs: ["120.133.60.220"]
- apiVersion: projectcalico.org/v3
  kind: HostEndpoint
  metadata:
    name: master3-em4
    labels:
      role: master
      type: external
  spec:
    interfaceName: em4
    node: master3
    expectedIPs: ["120.133.60.221"]
```

### GlobalNetworkPolicy定义

```yaml
- apiVersion: projectcalico.org/v3
  kind: GlobalNetworkPolicy
  metadata:
    name: allow-http-https-traffic-only
  spec:
    order: 10
    preDNAT: true
    applyOnForward: true
    ingress:
      - action: Allow
        protocol: TCP
        destination:
          ports: [80,443]
    selector: "role==\"master\" && type==\"external\""
- apiVersion: projectcalico.org/v3
  kind: GlobalNetworkPolicy
  metadata:
    name: drop-other-ingress
  spec:
    order: 20
    preDNAT: true
    applyOnForward: true
    ingress:
      - action: Deny
```
