---
title: "高可用维护"
date: 2022-11-08T18:38:00+08:00
weight: 101
description: >
    介绍维护高可用集群
---

## 高可用VIP的主动切换

高可用集群通过Keepalived来维护主从节点的切换，平时VIP在主节点，由主节点提供服务。在主节点宕机情况下，会自动切换到备节点，由备节点提供服务。

在平时运维工作中，存在需要主动切换主从节点的情况，例如要对主节点执行关机维护任务。

可以通过修改调低主节点的keepalived的优先级并重启keepalived实例的方式主动实现主从切换。

控制服务的VIP切换的keepavlied配置文件位于 /etc/kubernetes/manifests/keepalived.yaml

数据库服务的VIP切换的keepalived配置文件位于 /etc/keepalived/keepalived.conf

EIP网关的VIP切换的keepalvied配置文件位于 /etc/keepalived/eipgw.conf

## 高可用节点下线维护步骤

1. 如果有VIP，将VIP主动切换到备节点
2. 如果有虚拟机，迁移虚拟机到其他宿主机
3. 将容器从该节点驱逐

```bash
kubectl cordon <node>
```

4. 将kubelet，docker等服务设置为不自动启动

```bash
systemctl disable kubelet docker keepalived maraidb
```

5. 停止容器

```bash
docker stop
```

6. 停止所有服务

```bash
systemctl stop kubelet docker keepalived maraidb
```

7. 维护节点

## 高可用节点恢复上线步骤

1. 如果有数据库，先启动数据库

```bash
systemctl start mariadb
```

2. 检查数据库主从同步状态

```bash
show slave status\G
```

如果有问题，则需优先解决数据库主从同步问题。

3. 启动docker

```bash
systemctl start docker
```

4. 启动kubelet

```bash
systemctl start kubelet
```

5. 如果修改了keepavlied的优先级，恢复keepalived的优先级。启动keepalived

```bash
systemctl start keepalived
```

6. 恢复Kubenetes调度

```bash
kubectl uncordon <node>
```

7. 恢复以上服务的开机自动启动

```bash
systemctl enable kubelet docker keepalived maraidb
```