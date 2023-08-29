---
title: "Docker Compose 安装"
linkTitle: "Docker Compose 安装"
weight: 5
edition: ce
description: >
  使用 [Docker Compose](https://docs.docker.com/compose/) 快速部署 Cloudpods CMP 多云管理版本
---

## 前提

{{% alert title="注意" color="warning" %}}
该方案通过 Docker Compose 部署 Cloudpods 多云管理版本，该方式部署的是 All in One 环境，即所有的多云管理服务都使用容器运行在一个节点。

该部署方法仅适用于多云管理功能的使用，比如管理公有云(aws, 阿里云, 腾讯云等)或者其它私有云(zstack, openstack 等)，无法使用内置私有云相关功能(因为内置私有云需要节点上面安装配置 qemu, openvswitch 等各种虚拟化软件)

如果需要使用内置私有云，请使用 [All in One 私有云安装](../../quickstart/allinone-private) 的方式部署。
{{% /alert %}}

## 环境准备

### 机器配置要求

- 最低配置要求: CPU 4核, 内存 8GiB, 存储 100GiB
- docker 版本: ce-23.0.2
    - docker 建议安装最新的 ce 版本，新版本已经包含 docker-compose 插件
    - docker 需要开启容器网络以及 iptables

### 安装配置 docker 

{{% alert title="注意" color="warning" %}}
如果您的环境已经安装了新版本的 docker ，可以跳过改步骤。
{{% /alert %}}

下面以 CentOS 7 安装 docker 举例，如果是其他发行版请自行参考官方文档安装：[Install Docker Engine](https://docs.docker.com/engine/install/) 。

国内用户安装 docker-ce 可以使用 aliyun 的仓库，步骤如下：

```bash
# 安装必要的一些系统工具
$ sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# 添加软件源信息
$ sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 更新并安装 docker-ce 以及 compose 插件
$ sudo yum makecache fast
$ sudo yum -y install docker-ce docker-ce-cli docker-compose-plugin

# 开启 docker 服务
$ sudo systemctl enable --now docker
```

## 运行 Cloudpods CMP

Docker Compose 环境准备好后，就可以使用 https://github.com/yunionio/ocboot 里面的 docker-compose.yml 配置文件启动服务了，步骤如下：

```bash
# 下载 ocboot 工具到本地
$ git clone -b release/3.10 https://github.com/yunionio/ocboot && cd ./ocboot

# 进入 compose 目录
$ cd compose
$ ls -alh docker-compose.yml

# 运行服务
$ docker compose up
```

等服务启动完成后，就可以登陆 *https://<本机ip>* 访问前端服务，默认登陆用户密码为：admin 和 admin@123 。

## 操作说明

### 1. 服务放到后台运行

可以使用 '-d/--detach' 参数把所有服务放到后台运行，命令如下：

```bash
# 所有服务放到后台运行
$ docker compose up -d

# 服务放到后台后，可以通过 logs 自命令查看输出日志
$ docker compose logs -f
```

### 2. 登陆 climc 命令行容器

如果要使用命令行工具对平台做操作，可以使用下面的方法进入容器：

```bash
$ docker exec -ti compose-climc-1 bash
Welcome to Cloud Shell :-) You may execute climc and other command tools in this shell.
Please exec 'climc' to get started

# source 认证信息
bash-5.1# source /etc/yunion/rcadmin
bash-5.1# climc user-list
```

### 3. 查看服务配置和持久化数据

所有服务的持久化数据都是存储在 *ocboot/compose/data* 目录下面的，所有配置都是自动生成的，一般不需要手动修改，下面对各个目录做说明：

```bash
$ tree data
data
├── etc
│   ├── nginx
│   │   └── conf.d
│   │       └── default.conf    # 前端 nginx 配置
│   └── yunion
│       ├── *.conf  # cloudpods 各个服务配置
│       ├── pki     # 证书目录
│       ├── rcadmin     # 命令行认证信息
├── opt
│   └── cloud
│       └── workspace
│           └── data
│               └── glance # 镜像服务存储的镜像目录
└── var
    └── lib
        ├── influxdb    # influxdb 持久化数据目录
        └── mysql       # mysql 数据库持久化数据目录
```

### 4. 删除所有容器

所有服务的持久化数据都是存储在 *ocboot/compose/data* 目录下面的，删除容器不会丢失数据，下次直接用 *docker compose up* 重启即可，操作如下：

```bash
# 删除服务
$ docker compose down
```

## 常见问题

### 1. docker 服务没有打开 iptables 和 bridge 导致容器网路无法创建

默认情况下，启动 docker 服务是默认打开 iptables 的，如果在 */etc/docker/daemon.json* 里面设置了 "bridge: none" 和 "iptables: false" 则无法使用 docker compose 功能。

在运行 docker compose 之前请确保打开了 bridge 和 iptables 功能。


### 2. docker-compose.yml 包含了很多服务，是怎么生成的？

Cloudpods CMP 多云管理版本包含了很多服务，如果一个一个手写 compose 的配置会非常复杂，所以在 ocboot 里面有个 *generate-compose.py* 的脚本，负责生成 docker-compose.yml 文件，可以使用下面命令生成 compose 配置文件：

```bash
$ python3 generate-compose.py > compose/docker-compose.yml
```

### 3. 如何升级服务?

通过 docker compose 升级很方便，只用更新 docker-compose.yml 配置文件。

比如 *ocboot/compose/docker-compose.yml* 更新了，就可以通过 git pull 最新的代码，然后重新启动就可以了，步骤如下：

```bash
# 使用 git pull 更新
$ cd ocboot
$ git pull

# 重启 compose 服务
$ cd compose
$ docker compose down
$ docker compose up -d
```

