---
title: "排查Pod网络问题"
date: 2022-12-02T16:02:27+08:00
weight: 50
description: >
    排查Pod内DNS解析失败原因
---

经常遇到Pod内服务报DNSError的错误，例如：

```json
{"error":{"class": "DNSError", "code": 499, "details": "Post \"https://default-kevstone:30357/v3/auth/tokens\": dial tcp: lookup default-kevstone: i/o timeout"}}
```

这类错误一般意味着Pod之间的网络通信有问题。因为Pod之间通信一般最先要进行对端的DNS解析，由于到达coredns的Pod网络不通，导致DNS解析错误，因此最先暴露出来的是DNSError的错误。

## 基本原理

Pod内通过集群的coredns进行域名解析。CoreDNS配置了10.96.0.10的service IP。访问coredns时，首先由kubeproxy实现service IP到Pod IP的NAT转换，如果Pod在本节点，则直接访问Pod。否则通过tunl0以IP-in-IP或VXLAN隧道发送到对端Pod所在节点，进而解封装投递到目标Pod。

{{<oem_name>}} 在每个节点采用IPVS作为Service IP到Pod IP的NAT转换。需确保节点的IPVS规则表有对应10.96.0.10的NAT规则。

{{<oem_name>}} 采用calico作为容器网络的插件，采用IP-in-IP或VXLAN隧道作为Pod之间报文的封装协议。

如果采用IP-in-IP隧道，则在每个节点上都有一个 tunl0 的三层虚拟网络接口，该接口作为该节点IP-in-IP隧道的端点。

如果采用VXLAN隧道，则在每个节点上都有一个 vxlan.calico 的二层虚拟网络接口，该接口作为该节点 VXLAN 隧道的端点。

Pod的IP从10.40.0.0/16 (该网络前缀可以在ocboot初始化时配置) 随机分配。每个节点上都会为集群中其他节点的Pod所在的/26网段（含64个IP地址）配置通过tunl0且下一跳为该Pod所在节点IP的静态路由。如果缺少对应Pod的路由，则也会出现Pod之间网络不通。

### Calico隧道协议的切换

{{<oem_name>}}默认采用IP-in-IP隧道协议，可以在Kubernetes控制节点执行以下命令将Calico隧道协议切换为 VXLAN。常见切换原因为底层网络不支持IP-in-IP协议。

```bash
export DATASTORE_TYPE=kubernetes
calicoctl patch felixconfig default -p '{"spec":{"vxlanEnabled":true}}'
calicoctl patch ippool default-ipv4-ippool -p '{"spec":{"ipipMode":"Never", "vxlanMode":"Always"}}'   ## wait for the vxlan.calico interface to be created and traffic to be routed through it
calicoctl patch felixconfig default -p '{"spec":{"ipipEnabled":false}}'
```

如果需要调整MTU，请用如下命令：
```bash
calicoctl patch felixconfig default -p '{"spec":{"ipipMtu":1430}}'
calicoctl patch felixconfig default -p '{"spec":{"vxlanMtu":1430}}'
```


## 原因排查

### Service IP NAT问题

在无法DNS解析Pod所在节点执行如下命令，确认IPVS的转发表内有相应的表项：

```bash
ipvsadm -Ln | grep -A 3 10.96.0.10
```

正常应该有三个表项：
```bash
TCP  10.96.0.10:53 rr
  -> 10.40.52.149:53              Masq    1      0          0
  -> 10.40.52.171:53              Masq    1      0          0
TCP  10.96.0.10:9153 rr
  -> 10.40.52.149:9153            Masq    1      0          0
  -> 10.40.52.171:9153            Masq    1      0          0
UDP  10.96.0.10:53 rr
  -> 10.40.52.149:53              Masq    1      0          6930
  -> 10.40.52.171:53              Masq    1      0          6859
```

### 路由问题

如果上一步确认无误，在无法DNS解析Pod所在节点查看到达coredns的Pod IP的路由是否存在，假设coredns的节点IP为上述10.40.52.149和10.40.52.171，则执行如下命令确认相应路由是否存在：

```bash
ip route | grep 10.40.52
```

正确输出如下：

```bash
10.40.52.128/26 via 10.41.1.21 dev tunl0 proto bird onlink
```

这里 10.41.1.21 应该是coredns Pod所在节点的IP

### 端口问题

如上一步确认无误，则Pod的报文能够正确通过tunl0经过ip-in-ip隧道发出，则需要确认calico使用哪个端口发送ip-in-ip报文。

执行如下命令，查看calico-node的配置

```bash
kubectl -n kube-system edit daemonset calico-node
```

注意 IP_AUTODETECTION_METHOD，如果为can-reach=<ip>，则calico选用可以访问该ip的端口来发送ip-in-ip报文，请确认该接口是正确的接口。并且calico从对端接口报文的接口和发送接口是一致的。

```yaml
    spec:
      containers:
      - env:
        - name: IP_AUTODETECTION_METHOD
          value: can-reach=10.61.1.254
```

默认集群配置的 IP_AUTODETECTION_METHOD 为 can-reach=<primary_master_ip> ，比如上面例子中的 10.61.1.254 应该就是第一个 K8s 控制节点的 IP 。

IP_AUTODETECTION_METHOD 还可以配置为其他的值，可以参考 calico 官方文档：[Configuring calico/node/Manifest](https://projectcalico.docs.tigera.io/reference/node/configuration#ip-autodetection-methods)。

其中常用的配置可以设置成：`IP_AUTODETECTION_METHOD=kubernetes-internal-ip`，这个就会使用 K8s 节点的 Status.Addresses 作为ip-in-ip 发送的端口。


### 链路问题

如上一步确认无误，则需要确认calico的报文能够正常发送到对端节点，可通过tcpdump在源和目的节点抓包确认。

如果采用IP-in-IP隧道协议，则采用如下命令抓包：
```bash
# 格式为
# tcpdump -i <if_of_calico_node> -nnn "ip proto 4" and host <ip_of_dst_node>

# 比如要在控制节点的 br0 上抓来自于计算节点(IP: 10.130.0.13) 的 ip-in-ip 包，命令如下：
$ tcpdump -i br0 -nnn "ip proto 4" and host 10.130.0.13
```

如果采用VXLAN隧道协议，则采用如下命令抓包：
```bash
# 格式为
# tcpdump -i <if_of_calico_node> -nnn udp and port 4789 and host <ip_of_dst_node>

# 比如要在控制节点的 br0 上抓来自于计算节点(IP: 10.130.0.13) 的 VXLAN 包，命令如下：
$ tcpdump -i br0 -nnn udp and port 4789 and host 10.130.0.13
```


## 常见故障原因

### 节点路由问题

由于节点路由配置不一致，导致节点发送和接收ip-in-ip报文的端口IP不一致，导致双方无法通信

### 内核问题

特定内核在开启GSO之后会导致ip-in-ip报文丢弃，可尝试通过下面的命令关闭网卡相关特性，看是否解决问题：

```bash
# 假设 k8s 节点之间通过 eth0 网卡通信
$ ethtool --offload eth0 rx off tx off 
$ ethtool -K eth0 gso off
```
