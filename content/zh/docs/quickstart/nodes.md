---
title: "多节点安装"
linkTitle: "多节点安装"
weight: 1
description: >
  使用 ocboot 部署工具在多个节点部署”云联壹云“服务
---

多节点安装和 [All in One 安装](../allinone) 一样，都使用 https://github.com/yunionio/ocboot 这个部署工具，根据配置执行 ansible playbook 部署节点。

## 环境准备

关于环境的准备和不同架构 CPU 操作系统的要求，请参考 [All in One 安装/机器配置要求](../allinone#机器配置要求)。

以下为待部署机器的环境，假设已经准备好了 5 台机器，IP 分别是 10.127.10.156-160 ，各个节点做出以下角色规划：

- mariadb_node: 这个角色表示该节点上部署并运行 mariadb 数据库服务，该角色不一定要写在配置中，如果环境中有准备好的数据库，也可以不部署
    - 节点: 10.127.10.156
- primary_master_node: 这个角色表示该节点是第一个部署并运行 k8s master 组件的节点，该角色必须存在于配置中，该角色运行 onecloud 控制服务
    - 节点: 10.127.10.156
- master_nodes: 这个角色表示这些节点运行控制服务，该角色可选，主要作用是和 primary_master_node 一起组成 Kubernetes 的 etcd 3 节点高可用
    - 节点: 10.127.10.157-158
- worker_nodes: 这个角色表示这些节点运行私有云计算服务，该角色可选，如果需要内置的私有云功能，可以不配置
    - 节点: 10.127.10.159-160

|         IP        | 登录用户 | 角色                               |
|:-----------------:|:--------:|------------------------------------|
|   10.127.10.156   |   root   | mariadb_node & primary_master_node |
| 10.127.10.157-158 |   root   | master_nodes                       |
| 10.127.10.159-160 |   root   | worker_nodes                       |

## 开始部署

### 下载 ocboot

参考 [All in One 安装/下载 ocboot](../allinone/#下载-ocboot)。

### 编写部署配置

```bash
# 编写 config-allinone.yml 文件
$ cat <<EOF >./config-nodes.yml
mariadb_node:
  hostname: 10.127.10.156
  user: root
  db_user: root
  db_password: your-sql-password
primary_master_node:
  onecloud_version: v3.7.0
  hostname: 10.127.10.156
  user: root
  db_host: 10.127.10.156
  db_user: root
  db_password: your-sql-password
  controlplane_host: 10.127.10.156
  controlplane_port: "6443"
master_nodes:
  hosts:
  - hostname: 10.127.10.157
    user: root
  - hostname: 10.127.10.158
    user: root
  controlplane_host: 10.127.10.156
  controlplane_port: "6443"
worker_nodes:
  hosts:
  - hostname: 10.127.10.159
    user: root
  - hostname: 10.127.10.160
    user: root
  controlplane_host: 10.127.10.156
  controlplane_port: "6443"
EOF
```

### 开始部署

当填写完 config-allinone.yml 部署配置文件后，便可以执行 ocboot 里面的 `./run.py ./config-allinone.yml` 部署集群了。

```bash
# 开始部署
$ ./run.py ./config-nodes.yml
```
