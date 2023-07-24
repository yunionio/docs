---
title: "All in One 安装"
linkTitle: "All in One 安装"
edition: ce
weight: 1
description: >
  使用 ocboot 部署工具快速以 All in One 的方式部署 Cloudpods 服务
---

## 前提

{{% alert title="注意" color="warning" %}}
本章内容是通过部署工具快速搭建 Cloudpods 服务，如果想在生产环境部署高可用集群请参考: [高可用安装](../../setup/ha-ce/) 。
{{% /alert %}}

## 环境准备

### 机器配置要求

- 操作系统: CentOS 7.6-7.9 Minimal(X86_64和ARM64)、Debian 10-11(X86_64和ARM64)、Kylin V10 sp2(X86_64和ARM64)等主流操作系统安装，下面是操作系统镜像常见下载地址
    - X86_64: [CentOS 7.9 Minimal](http://isoredirect.centos.org/centos/7/isos/x86_64/)
    - ARM64: [CentOS 7.9 Minimal](http://isoredirect.centos.org/altarch/7/isos/aarch64/)，[Debian 10(buster)](https://www.debian.org/releases/stable/arm64/) ，[Debian 11(bullseye)](https://www.debian.org/releases/bullseye/arm64/)
    - 操作系统需要是干净的版本，因为部署工具会重头搭建指定版本的 kubernetes 集群，所以确保系统没有安装 kubernetes, docker 等容器管理工具，否则会出现冲突导致安装异常
- 最低配置要求: CPU 4核, 内存 8GiB, 存储 100GiB
- 虚拟机和服务使用的存储路径都在 **/opt** 目录下，所以理想环境下建议单独给 **/opt** 目录设置挂载点
    - 比如把 /dev/sdb1 单独分区做 ext4 然后通过 /etc/fstab 挂载到 /opt 目录

### 数据库要求

Cloudpods 会默认部署 MariaDB ，也可以用yaml文件使用已有 MariaDB 安装。
注意事项：在公有云上部署环境时，建议部署 MariaDB 数据库，不要使用 MySQL 5.6及以下版本，防止索引长度 bug： Index column size too large. The maximum column size is 767 bytes.

- Centos 7.6-7.9  Minimal(X86_64和ARM64) 默认安装MariaDB 5.5.68
- Debian 10-11(X86_64和ARM64) 默认安装MariaDB 10.3.1
- Kylin V10 sp2(X86_64和ARM64) 默认安装MariaDB 10.3.4


以下为待部署机器的环境:

| IP   | 登录用户 |
|:----:|:--------:|
|10.168.26.216| root |

{{% alert title="提示" %}}
> 10.168.26.216 是本次测试环境的 IP, 请根据自己的环境做相应修改, 若在公有云部署，请使用内网IP地址。
{{% /alert %}}

### 本地环境配置要求

本地环境即用户进行实际操作部署的环境。本次测试的本地环境为 MAC 操作系统的笔记本，也可在待部署机器上进行操作。

- ssh: 开启 ssh 免密登录
- 本地环境安装部署 ansbile（Windows操作系统不支持安装 ansible）

#### 配置 ssh 免密登录

```bash
# 生成本机的 ssh 秘钥 (如果本地已有 ~/.ssh/id_rsa.pub 则跳过此步骤)
$ ssh-keygen

# 将生成的 ~/.ssh/id_rsa.pub 公钥拷贝到待部署机器
$ ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.168.26.216

# 尝试免密登录待部署机器，应该不需要输入登录密码即可拿到部署机器的 hostname
$ ssh root@10.168.26.216 "hostname"
```

#### 安装ansible和git

首先需要安装ansible和git，ansible版本要求最低2.9.27，其中2.11.12测试较多

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

部署的工具是 https://github.com/yunionio/ocboot , 然后根据需要部署机器的配置， 利用 ansbile 远程登录到待部署的机器安装配置 Cloudpods 服务，以下操作都在本地环境上进行操作。操作步骤如下:

```bash
# 下载 ocboot 工具到本地
$ git clone -b {{<release_branch>}} https://github.com/yunionio/ocboot && cd ./ocboot
```

### 快速部署

可以直接执行run.py来快速部署一个AllInOne的Cloudpods实例，其中<host_ip>为部署所在主机的主IP地址。


{{% alert title="注意" color="warning" %}}
如果待部署的主机是一台虚拟机，默认是不会在虚拟机里面部署内置私有云虚拟化相关组件的，如果需要在虚拟机里面使用内置私有云（相当于嵌套虚拟化），请使用[自定义配置部署](#自定义配置部署)。
{{% /alert %}}

{{< tabs name="ocboot_install_region" >}}
{{% tab name="中国大陆" %}}

```bash
# 直接部署，会从 registry.cn-beijing.aliyuncs.com 拉取容器镜像
$ ./run.py <host_ip>
```

{{% /tab %}}

{{% tab name="其他地区" %}}

对于某些网络环境，registry.cn-beijing.aliyuncs.com 访问缓慢或不可达，在版本 `v3.9.5`之后（含），可指定镜像源：[docker.io](http://docker.io) 来安装。命令如下：

```bash
IMAGE_REPOSITORY=docker.io/yunion ./run.py <host_ip>
```

这种方式其实是自动在当前目录生成一个名为config-allinone-current.yaml的配置文件，基于该配置文件的参数来执行部署。

{{% /tab %}}

{{< /tabs >}}

### 自定义配置部署

也可以我们手工编辑一个配置文件，基于该配置文件，采用run.py来实现部署。

```bash
# 编写 config-allinone.yml 文件
$ cat <<EOF >./config-allinone.yml
# mariadb_node 表示需要部署 mariadb 服务的节点
mariadb_node:
  # 待部署节点 ip
  hostname: 10.168.26.216
  # 待部署节点登录用户
  user: root
  # mariadb 的用户
  db_user: root
  # mariadb 用户密码
  db_password: your-sql-password
# primary_master_node 表示运行 k8s 和 Cloudpods 服务的节点
primary_master_node:
  hostname: 10.168.26.216
  user: root
  # 数据库连接地址
  db_host: 10.168.26.216
  # 数据库用户
  db_user: root
  # 数据库密码
  db_password: your-sql-password
  # k8s 控制节点的 ip
  controlplane_host: 10.168.26.216
  # k8s 控制节点的端口
  controlplane_port: "6443"
  # Cloudpods 版本
  onecloud_version: {{<release_version>}}
  # Cloudpods 登录用户
  onecloud_user: admin
  # Cloudpods 登录用户密码
  onecloud_user_password: admin@123
  # 该节点作为 Cloudpods 私有云计算节点
  as_host: true
  # 虚拟机强行作为 Cloudpods 内置私有云计算节点（默认为 false）。开启此项时，请确保as_host: true
  as_host_on_vm: true
  # 设置镜像仓库，如果待部署的机器处于海外，可以用 dockerhub 的镜像仓库：docker.io/yunion
  image_repository: registry.cn-beijing.aliyuncs.com/yunion
EOF
```

当填写完 config-allinone.yml 部署配置文件后，便可以执行 ocboot 里面的 `./run.py ./config-allinone.yml` 部署集群了。

```bash
# 开始部署
$ ./run.py ./config-allinone.yml
```

## 部署完成

```bash
....
# 部署完成后会有如下输出，表示运行成功
# 浏览器打开 https://10.168.26.216
# 使用 admin/admin@123 用户密码登录就能访问前端界面
Initialized successfully!
Web page: https://10.168.26.216
User: admin
Password: admin@123
```

然后用浏览器访问 https://10.168.26.216 ，用户名输入 `admin`，密码输入 `admin@123` 就会进入 Cloudpods 的界面。

![登录页](../images/index.png)

## 开始使用Cloudpods

### 创建第一台虚拟机

通过如下三步创建出第一台虚拟机：

#### 1. 导入镜像

浏览位于 [CentOS 7云主机镜像](https://cloud.centos.org/centos/7/images/) ，选择一个GenericCloud 镜像，拷贝镜像URL。

在 `主机` 菜单，选择 `系统镜像`，选择 `上传`。输入镜像名称，选择 `输入镜像URL`，粘贴上述CentOS 7镜像URL，选择 `确定`。

可以访问 https://docs.openstack.org/image-guide/obtain-images.html 获得更多的虚拟机镜像。

#### 2. 创建网络（VPC和IP子网）

[新建VPC] 在 `网络` 菜单，选择 `VPC` 子菜单，选择 `新建`。输入名称，例如 `vpc0`，选择目标网段，例如 `192.168.0.0/16`。点击 `新建`。

[新建IP子网] VPC创建完成后，选择 `IP子网` 子菜单，选择 `新建`。输入名称，例如 `vnet0`，选择VPC为刚才创建的VPC `vpc0`，选择可用区，输入 `子网网段`，例如 `192.168.100.0/24`。点击 `新建`。

[典型网络配置](../../function_principle/onpremise/network/examples)提供了几种常见的宿主机网络配置，请参考。

#### 3. 创建虚拟机

在 `主机` 菜单，选择 `虚拟机`，选择 `新建`。在此界面输入主机名，选择镜像和IP子网，创建虚拟机。

### 导入公有云或者其它私有云平台资源

Cloudpods自身是一个完整的私有云，同时也可以统一纳管其他云平台的资源。

在 `多云管理` 菜单，选择 `云账号` 并新建，根据自己的需求填写对应云平台的认证信息，配置完云账号后 Cloudpods 服务就会同步相应云平台的资源，同步完成后即可在前端查看。

![多云管理](../images/cloudaccount.png)


## FAQ

### 1. 在 All in One 部署完成后宿主机列表没有宿主机？

如下图所示，若发现环境部署完成后宿主机列表中没有宿主机，可按照以下方式进行排查

  ![](../images/nohost.png)


1. 请确认部署用的yaml文件中是否有`as_host: true`配置项，若没有，则表示该节点只作为控制节点使用，不作为计算节点使用，因此宿主机列表中没有宿主机是正常的；

2. 在控制节点排查 host 问题，请参考：[Host服务问题排障技巧](../../function_principle/onpremise/host/troubleshooting/)


    1. 若日志报错信息中包含“register failed: try create network: find_matched == false”，则表示未成功创建包含宿主机的IP子网，导致宿主机注册失败，请创建包含宿主机网段的IP子网。

    ```
    # 创建包含宿主机网段的IP子网
    $ climc network-create bcast0  adm0 <start_ip> <end_ip> mask
    ```

    ![](../images/iperror.png)

    2. 若日志报错信息中包含“name starts with letter, and contains letter, number and - only”，则表示宿主机的主机名不合规，应改成以字母开头的hostname

    ![](../images/hostnameerror.png)

### 2. 在 All in One 中找不到虚拟机界面？

All in One 部署的节点会部署 Cloudpods host 计算服务，作为宿主机，具有创建和管理私有云虚拟机的能力。没有虚拟机界面应该是 Cloudpods 环境中没有启用宿主机。

请到 `管理后台` 界面，点击 `主机/基础资源/宿主机` 查看宿主机列表，启用相应的宿主机，刷新界面就会出现虚拟机界面。

{{% alert title="注意" color="warning" %}}
如果要使用 Cloudpods 私有云虚拟机，需要宿主机使用 Cloudpods 编译的内核，可使用以下命令查看宿主机是否使用 Cloudpods 内核(包含 yn 关键字)。

```bash
# 查看是否使用 yn 内核
$ uname -a | grep yn
Linux office-controller 3.10.0-1160.6.1.el7.yn20201125.x86_64
# 如果内核不是带有 yn 关键字的版本，可能是第一次使用 ocboot 安装，重启即可进入 yn 内核
$ reboot
```
{{% /alert %}}

![宿主机](../images/host.png)

### 3. 修改节点的 hostname ，有些服务启动失败

k8s 管理节点，依赖于 hostname，请改回去。

### 4. 如何重装

1. 执行 `kubeadm reset -f` 删除 kubernetes 集群

2. 重新运行 ocboot 的脚本

3. 等待运行完毕，使用`kubectl edit deployment onecloud-operator -n onecloud`加入下列参数，然后保存关闭。

![](../images/oo_syncuser.png)

4. 第2步的修改，会影响 onecloud-operator 的性能，所以等所有服务启动，可以将第2步的参数恢复。

### 5. 其它问题？

其它问题欢迎在 Cloudpods github issues 界面提交: https://github.com/yunionio/cloudpods/issues , 我们会尽快回复。
