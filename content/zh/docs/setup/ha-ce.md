---
title: "高可用安装"
linkTitle: "高可用安装"
edition: ce
weight: 3
description: >
  使用 ocboot 部署工具高可用安装 Cloudpods 服务，更符合生产环境的部署需求
---

## 环境准备

关于环境的准备和不同架构 CPU 操作系统的要求，请参考 [All in One 安装/机器配置要求](../../quickstart/allinone#机器配置要求)。

假设准备好了 3 台 CentOS7 机器，以及 1 台 Mariadb/MySQL 的机器，规划如下：

| role         | ip            | interface    | note
| ------------ | ------------- | ------------ | ------------------------------
| k8s primary  | 10.127.90.101 | eth0         | 第1个控制节点                                               |
| k8s master 1 | 10.127.90.102 | eth0         | 第2个控制节点                                               |
| k8s master 2 | 10.127.90.103 | eth0         | 第3个控制节点                                               |
| k8s VIP      | 10.127.190.10 | -            | keepalived 使用的 vip ，会优先绑定在 3 个控制节点中的第一个 |
| DB           | 10.127.190.11 | -            | 数据库独立节点 pswd="0neC1oudDB#",  port=3306               |

其中 DB 的部署目前是不归 ocboot 部署工具管理的，需要提前手动部署，高可用的数据库部署可以参考文档 [部署 DB HA 环境](../db-ha) 。

## 开始安装

### 下载 ocboot

参考 [All in One 安装/下载 ocboot](../../quickstart/allinone/#下载-ocboot)。

### 编写部署配置

```bash
# 填充变量，生成配置
DB_IP="10.127.190.11"
DB_PORT=3306
DB_PSWD="0neC1oudDB#"
DB_USER=root

K8S_VIP=10.127.190.10
PRIMARY_INTERFACE="eth0"
PRIMARY_IP=10.127.90.101

MASTER_1_INTERFACE="eth0"
MASTER_1_IP=10.127.90.102
MASTER_2_INTERFACE="eth0"
MASTER_2_IP=10.127.90.103

cat > config-k8s-ha.yml <<EOF
primary_master_node:
  hostname: $PRIMARY_IP
  use_local: false
  user: root
  onecloud_version: "{{<release_version>}}"
  db_host: $DB_IP
  db_user: "$DB_USER"
  db_password: "$DB_PSWD"
  db_port: "$DB_PORT"
  skip_docker_config: true
  image_repository: registry.cn-beijing.aliyuncs.com/yunionio
  ha_using_local_registry: false
  node_ip: "$PRIMARY_IP"
  ip_autodetection_method: "can-reach=$PRIMARY_IP"
  controlplane_host: $K8S_VIP
  controlplane_port: "6443"
  as_host: true
  high_availability: true
  use_ee: false
  enable_minio: true
  registry_mirrors:
  - https://lje6zxpk.mirror.aliyuncs.com
  insecure_registries:
  - $PRIMARY_IP:5000
  host_networks: "$PRIMARY_INTERFACE/br0/$PRIMARY_IP"

master_nodes:
  controlplane_host: $K8S_VIP
  controlplane_port: "6443"
  as_controller: true
  as_host: true
  ntpd_server: "$PRIMARY_IP"
  registry_mirrors:
  - https://lje6zxpk.mirror.aliyuncs.com
  high_availability: true
  hosts:
  - user: root
    hostname: "$MASTER_1_IP"
    host_networks: "$MASTER_1_INTERFACE/br0/$MASTER_1_IP"
  - user: root
    hostname: "$MASTER_2_IP"
    host_networks: "$MASTER_2_INTERFACE/br0/$MASTER_2_IP"
EOF
```

### 开始部署

```bash
$ ./ocboot.py install ./config-k8s-ha.yml
```

等待部署完成后，就可以使用浏览器访问 https://10.127.190.10 (VIP), 输入用户名 `admin` 和密码 `admin@123`，进入前端。

另外部署完成后，可以给已有集群添加节点，参考文档：[添加计算节点](../host)，注意这里添加节点的控制节点 ip 不要用 vip ，只能用第1个控制节点的实际 ip ，因为 vip 有可能漂移到其他节点上，但通常只有第1个节点配置了 ssh 免密登陆登陆其他节点的权限，用其他控制节点会导致 ssh 登陆不上。

## 常见问题

### 1. 如何手动重新添加控制控制节点？

3个控制节点都会运行 kube-apiserver, etcd 这些关键服务，如果遇到某一个节点遇到 etcd 数据不一致，可以将该节点 reset 后重新加入集群，步骤如下：

```bash
# 到其他正常的控制节点创建 join token
$ export KUBECONFIG=/etc/kubernetes/admin.conf
$ ocadm token create --description "ocadm-playbook-node-joining-token" --ttl 90m
2fmpbx.7zikd8sp5uhaxrjr

# 获取控制节点认证
$ /opt/yunion/bin/ocadm init phase upload-certs | grep -v upload-certs
6150f8da2dcdf3a8a730f407ddce9f1cb9f24b15ffa4e4b3680e16ed40201cf0

##########  注意下面的命令需要登陆到需要重新加入的节点执行  ###########
# 如果该节点曾经作为计算节点加入过云平台
# 需要备份当前宿主机 /etc/yunion/host.conf 配置
[your-reset-node] $ cp /etc/yunion/host.conf /etc/yunion/host.conf.manual.bk

# 登陆到需要重新 reset 加入的节点，reset 当前的 kubernetes 环境
[your-reset-node] $ kubeadm reset -f

# 假设当前的网卡为 bond0(如果不做 bond ，物理网卡一般为 eth0 之类的名称)，ip 为 172.16.84.40，需要加入集群 172.16.84.101:6443 集群
[your-reset-node] $ ocadm join \
        --control-plane 172.16.84.101:6443 \ # 加入的目标集群
        --token 2fmpbx.7zikd8sp5uhaxrjr --certificate-key 6150f8da2dcdf3a8a730f407ddce9f1cb9f24b15ffa4e4b3680e16ed40201cf0 --discovery-token-unsafe-skip-ca-verification \ # 加入认证信息
        --apiserver-advertise-address 172.16.84.40 --node-ip 172.16.84.40 \ # 该节点 ip
        --as-onecloud-controller \ # 作为 cloudpods 控制节点
        --enable-host-agent \ # 作为 cloudpods 计算节点
        --host-networks 'bond0/br0/172.16.84.40' \ # 计算节点的桥接网络，意思创建 br0 网桥，并把 bond0 加入进来，给 br0 网桥配置 ip 172.16.84.40
        --high-availability-vip 172.16.84.101 --keepalived-version-tag v2.0.25 # keepalived 的 vip ，保证 kube-apiserver 的高可用性

# 等待加入完成后，还原 /etc/yunion/host.conf.manual.bk 配置
[your-reset-node] $ cp /etc/yunion/host.conf.manual.bk /etc/yunion/host.conf

# 重启 host 服务
$ kubectl get pods -n onecloud -o wide | grep host | grep $your-reset-node
$ kubectl delete pods -n onecloud default-host-xxxx
```

以上手动的步骤参考了 ocboot join master-node 的逻辑，可参考 [https://github.com/yunionio/ocboot/blob/master/onecloud/roles/master-node/tasks/main.yml](https://github.com/yunionio/ocboot/blob/master/onecloud/roles/master-node/tasks/main.yml) 。
