---
title: "升级相关"
linkTitle: "升级相关"
weight: 100
description: >
  介绍如何升级服务版本
---

本文介绍从 v3.4.x 升级到 v3.6.x 的步骤以及注意事项。

版本升级建议从相邻的版本升级，比如从 v3.2.x 升级到 v3.6.x 需要以下的步骤：

1. v3.2.x => v3.3.x
2. v3.3.x => v3.4.x
3. v3.4.x => v3.6.x

直接跨多个版本升级可能会出现问题，建议参考以下的内容选择升级步骤:

- [v3.1.x 升级到 v3.2.x](https://docs.yunion.io/v3.2/docs/setup/upgrade)
- [v3.2.x 升级到 v3.3.x](https://docs.yunion.io/v3.3/docs/setup/upgrade)
- [v3.3.x 升级到 v3.4.x](https://docs.yunion.io/v3.4/docs/setup/upgrade)

总体来说，升级的步骤如下:

使用我们编写的 [ocboot](https://github.com/yunionio/ocboot) 工具进行升级，这个工具主要是调用 ansible 来升级集群里面的所有节点。

1. 使用 git 拉取最新的 [ocboot](https://github.com/yunionio/ocboot) 代码，切换到 release/3.6 分支
2. 使用 [ocboot](https://github.com/yunionio/ocboot) 进行大版本升级

## 查看当前版本

可以使用 kubectl 查看当前集群的版本

```bash
# 使用 kubectl 获得当前集群的版本为 v3.4.5
$ kubectl -n onecloud get onecloudclusters default -o=jsonpath='{.spec.version}'
v3.4.5
```

## 拉取 ocboot 工具

如果本地已经有 ocboot 工具可以跳过此步，只用把代码更新到对应的分支。

```bash
# 本地安装 ansible
$ yum install -y ansible python-paramiko

# 下载 ocboot 工具到本地
$ git clone -b release/3.6 https://github.com/yunionio/ocboot && cd ./ocboot
```

## 更新 ocboot 代码

```bash
$ git checkout release/3.6
$ git pull
```

## 更新 Cloudpods 服务

更新服务的原理是通过本机 ssh 免密码远程登录到集群的第一个控制节点，获取所有节点的信息后，然后通过 ansible 执行 playbook 更新，所以有以下要求：

1. 本机能够 ssh 远程登录 PRIMARY_MASTER_HOST
2. PRIMARY_MASTER_HOST 能够 ssh 免密码登录集群中的其它节点

如果没有设置免密码登录，请使用 *ssh-copy-id -i ~/.ssh/id_rsa.pub root@PRIMARY_MASTER_HOST* 命令把公钥下发到自己环境对应的节点。

升级的版本号可以到 [CHANGELOG release/3.6 页面](../../changelog/release-3.6/) 查询。

```bash
# 使用 ocboot 相关服务到 v3.6.18 版本
# 该步骤会因为拉取 docker 镜像等待较长时间，请耐心等待
# PRIMARY_MASTER_HOST 是指部署集群的第一个节点的 ip 地址
# 需要本机能够使用 ssh 密钥登录上去
$ ./ocboot.py upgrade <PRIMARY_MASTER_HOST> v3.6.18

# 另外可以使用 `./ocboot.py upgrade --help` 查看其它可选参数
# 比如:
# --user 可以指定其它 ssh 用户
# --port 指定 ssh 端口
# --key-file 指定另外的 ssh private key
# --as-bastion 可以让 PRIMARY_MASTER_HOST 作为堡垒机部署在内网的宿主机

# 另外可以在升级的过程中可以登录到 PRIMARY_MASTER_HOST， 使用 kubectl 查看对应 pods 的升级情况
$ kubectl get pods -n onecloud --watch
```
