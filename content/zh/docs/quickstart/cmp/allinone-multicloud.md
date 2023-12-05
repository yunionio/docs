---
title: "Ocboot 安装"
linkTitle: "Ocboot 安装"
edition: ce
weight: 1
description: >
  使用 ocboot 部署工具快速以 All in One 的方式部署 Cloudpods CMP 多云管理版本
---

## 前提

{{% alert title="注意" color="warning" %}}
本章内容是通过部署工具快速搭建 Cloudpods 服务，如果想在生产环境部署高可用集群请参考: [高可用安装](../../../setup/ha-ce/) 。
{{% /alert %}}

## 环境准备

### 机器配置要求

- 操作系统: 根据 CPU 架构不同，支持的发行版也不一样，目前支持的发行版情况如下：
    - [CentOS 7.6~7.9 Minimal](http://isoredirect.centos.org/centos/7/isos): 支持 x86_64 和 arm64
    - [Debian 10/11](https://www.debian.org/distrib/): 支持 x86_64 和 arm64
    - [Ubuntu 22.04](https://releases.ubuntu.com/jammy/): 仅支持 x86_64
    - [银河麒麟V10 SP2](https://www.kylinos.cn/scheme/server/1.html): 支持 x86_64 和 arm64
    - [统信 UOS kongzi](https://www.chinauos.com/): 支持 x86_64 和 arm64
- 操作系统需要是干净的版本，因为部署工具会重头搭建指定版本的 kubernetes 集群，所以确保系统没有安装 kubernetes, docker 等容器管理工具，否则会出现冲突导致安装异常
- 最低配置要求: CPU 4核, 内存 8GiB, 存储 100GiB
- 虚拟机和服务使用的存储路径都在 **/opt** 目录下，所以理想环境下建议单独给 **/opt** 目录设置挂载点
    - 比如把 /dev/sdb1 单独分区做 ext4 然后通过 /etc/fstab 挂载到 /opt 目录

## 安装ansible和git

首先需要安装ansible和git，ansible版本要求最低2.9.27，其中2.11.12测试较多。

{{< tabs name="ocboot_install" >}}
{{% tab name="CentOS 7" %}}

```bash
# 本地安装 ansible 和 git
$ yum install -y epel-release git python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{% tab name="Kylin V10" %}}
```bash
# 本地安装 ansible 和 git
$ yum install -y git python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{% tab name="Debian 10/11" %}}

如果提示`locale`相关的报错，请先执行：

```bash
if ! grep -q '^en_US.UTF-8' /etc/locale.gen; then
    echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
    locale-gen
    echo 'LANG="en_US.UTF-8"' >> /etc/default/locale
    source /etc/default/locale
fi
```

```bash
# 本地安装 ansible 和 git
$ apt install -y git python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
备注：已知在`debian 11`环境，如果`/proc/cmdline`里找不到启动选项 `systemd.unified_cgroup_hierarchy=0`，ocboot会自动配置相关的`GRUB`选项，重建启动参数，并重启操作系统，以便 `k8s` 能够正常启动。

{{% /tab %}}

{{% tab name="其它操作系统" %}}
```bash
# 本地安装 ansible
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible
```
{{% /tab %}}

{{< /tabs >}}

## 安装Cloudpods

部署的工具在 [https://github.com/yunionio/ocboot](https://github.com/yunionio/ocboot)，需要把该工具使用 `git clone` 下来，然后运行 `run.py` 脚本部署服务。操作步骤如下:

```bash
# 下载 ocboot 工具到本地
$ git clone -b {{<release_branch>}} https://github.com/yunionio/ocboot && cd ./ocboot
```

执行 run.py 部署服务。其中 **<host_ip>** 为部署节点的 IP 地址，该参数为可选项。如果不指定则选择默认路由出去的那张网卡部署服务。如果你的节点有多张网卡，可以通过指定 **<host_ip>** 选择对应网卡监听服务。


{{< tabs name="ocboot_install_region" >}}
{{% tab name="中国大陆" %}}

```bash
# 直接部署，会从 registry.cn-beijing.aliyuncs.com 拉取容器镜像
$ ./run.py cmp <host_ip>

# 如果遇到 pip 安装包下载过慢的问题，可以用 -m 参数指定 pip 源
# 比如下面使用: https://mirrors.aliyun.com/pypi/simple/ 源
$ ./run.py -m https://mirrors.aliyun.com/pypi/simple/ cmp <host_ip> 
```

{{% /tab %}}

{{% tab name="其他地区" %}}

对于某些网络环境，registry.cn-beijing.aliyuncs.com 访问缓慢或不可达，在版本 `v3.9.5`之后（含），可指定镜像源：[docker.io](http://docker.io) 来安装。命令如下：

```bash
IMAGE_REPOSITORY=docker.io/yunion ./run.py cmp <host_ip>
```

这种方式其实是自动在当前目录生成一个名为config-allinone-current.yaml的配置文件，基于该配置文件的参数来执行部署。

{{% /tab %}}

{{< /tabs >}}

## 部署完成

```bash
....
# 部署完成后会有如下输出，表示运行成功
# 浏览器打开 https://10.168.26.216 ，该 ip 为之前设置 <host_ip>
# 使用 admin/admin@123 用户密码登录就能访问前端界面
Initialized successfully!
Web page: https://10.168.26.216
User: admin
Password: admin@123
```

然后用浏览器访问 https://10.168.26.216 ，用户名输入 `admin`，密码输入 `admin@123` 就会进入 Cloudpods 的界面。

![登录页](../../images/index.png)

## 开始使用Cloudpods

### 导入公有云或者其它私有云平台资源

Cloudpods 多云管理平台可以统一纳管其他云平台的资源。

在 `多云管理` 菜单，选择 `云账号` 并新建，根据自己的需求填写对应云平台的认证信息，配置完云账号后 Cloudpods 服务就会同步相应云平台的资源，同步完成后即可在前端查看。

![多云管理](../../images/cloudaccount.png)


## FAQ


### 1. 如何重装

1. 执行 `kubeadm reset -f` 删除 kubernetes 集群

2. 重新运行 ocboot 的脚本

### 2. 其它问题？

其它问题欢迎在 Cloudpods github issues 界面提交: https://github.com/yunionio/cloudpods/issues , 我们会尽快回复。
