---
title: "高可用安装"
linkTitle: "高可用安装"
edition: ce
weight: 2
description: >
  使用 ocboot 部署工具高可用安装 Cloudpods 服务，更符合生产环境的部署需求
---

## 环境准备

关于环境的准备和不同架构 CPU 操作系统的要求，请参考 [All in One 安装/机器配置要求](../allinone#机器配置要求)。

假设准备好了 3 台 CentOS7 机器，以及 1 台 Mariadb/MySQL 的机器，规划如下：

role          | ip            | interface    |  note
------------  | ------------- | ------------ | ------------------------------
k8s primary   | 10.127.90.101 | eth0         | -                             |
k8s master 1  | 10.127.90.102 | eth0         | -                             |
k8s master 2  | 10.127.90.103 | eth0         | -                             |
k8s VIP       | 10.127.190.10 | -            | -                             |
DB            | 10.127.190.11 | -            | pswd="0neC1oudDB#",  port=3306|

其中 DB 的部署目前是不归 ocboot 部署工具管理的，需要提前手动部署，高可用的数据库部署可以参考文档 [部署 DB HA 环境](../../setup/db-ha) 。

## 开始安装

### 下载 ocboot

参考 [All in One 安装/下载 ocboot](../allinone/#下载-ocboot)。

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
  onecloud_version: "v3.8.11"
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

另外部署完成后，可以给已有集群添加节点，参考文档：[添加计算节点](../../setup/host)。
