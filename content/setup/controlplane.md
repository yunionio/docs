---
title: "控制节点"
date: 2019-04-13T13:01:57+08:00
weight: 2
description: "Showcase: Lessons learned from taking letsencrypt.org to Hugo."
---

## 环境准备

OneCloud 相关的组件运行在 kubernetes 之上，环境以及相关的软件依赖如下:

- 操作系统: Centos 7.x
- 数据库: mariadb (CentOS 7自带的版本：Ver 15.1 Distrib 5.5.56-MariaDB）
- docker: ce-18.09.1
- kubernetes: v1.14.3

### 安装配置 mariadb

mariadb 作为服务数据持久化的数据库，可以部署在其它节点或者使用单独维护的。下面假设还没有部署 mariadb，在控制节点上安装设置 mariadb。

为了方便运行维护，mariadb推荐打开两个参数设施：

* skip_name_resolve：取消域名解析
* expire_logs_days=30：设置binlog的超时时间为30天，超过30天的binglog自动删除

```bash
$ MYSQL_PASSWD='your-sql-passwd'
# 安装 mariadb
$ yum install -y epel-release mariadb-server
$ systemctl enable --now mariadb
$ mysqladmin -u root password "$MYSQL_PASSWD"
$ cat <<EOF >/etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mariadb according to the
# instructions in http://fedoraproject.org/wiki/Systemd
# skip domain name resolve
skip_name_resolve
# auto delete binlog older than 30 days
expire_logs_days=30

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d
EOF

$ mysql -uroot -p$MYSQL_PASSWD \
  -e "GRANT ALL ON *.* to 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWD' with grant option; FLUSH PRIVILEGES;"
```

### 安装配置 docker

```bash
$ yum install -y yum-utils
$ yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
$ yum install -y docker-ce-18.09.1 docker-ce-cli-18.09.1 containerd.io

$ mkdir /etc/docker
$ cat <<EOF >/etc/docker/daemon.json
{
  "bridge": "none",
  "iptables": false,
  "exec-opts":
    [
      "native.cgroupdriver=cgroupfs"
    ],
  "data-root": "/opt/docker",
  "live-restore": true,
  "log-driver": "json-file",
  "log-opts":
    {
      "max-size": "100m"
    },
  "registry-mirrors":
    [
      "https://lje6zxpk.mirror.aliyuncs.com",
      "https://lms7sxqp.mirror.aliyuncs.com",
      "https://registry.docker-cn.com"
    ],
  "storage-driver": "overlay2"
}
EOF
$ systemctl enable --now docker
```

### 安装配置 kubelet

```bash
$ cat <<EOF >/etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
$ yum install --assumeyes bridge-utils conntrack-tools jq kubelet-1.14.3-0 kubectl-1.14.3-0 kubeadm-1.14.3-0
$ systemctl enable kubelet

# 做一些 sysctl 的配置, kubernetes 要求
$ cat <<EOF > /etc/sysctl.d/bridge.conf
net.bridge.bridge-nf-call-iptables=1
net.bridge.bridge-nf-call-ip6tables=1
EOF

$ sudo modprobe br_netfilter

$ cat <<EOF > /etc/sysctl.d/ip_forward.conf
net.ipv4.ip_forward=1
EOF

$ sysctl -p
```

## 部署控制节点

先安装部署工具 ocadm 和云平台的命令行工具 climc:

```bash
# 安装 climc 云平台命令行工具
$ yum-config-manager --add-repo https://iso.yunion.cn/yumrepo-2.10/yunion.repo
$ yum install -y yunion-climc
# climc 在 /opt/yunion/bin 目录下，根据自己的需要加到 bash 或者 zsh 配置文件里面
$ echo 'export PATH=$PATH:/opt/yunion/bin' >> ~/.bashrc && source ~/.bashrc

# 安装 ocadm
$ wget https://github.com/Zexi/ocadm/releases/download/v0.1.0/ocadm -P /opt/yunion/bin
$ chmod a+x /opt/yunion/bin/ocadm
```

接下来会现在当前节点启动 v1.14.3 的 kubernetes 服务，然后将 keystone, region, scheduler 作为控制节点必须的服务启动起来。

```bash
# 假设 mariadb 部署在本地，如果是使用已有的数据库，请改变对应的 ip
$ MYSQL_HOST=$(ip route get 1 | awk '{print $NF;exit}')

# 拉取必要的 docker 镜像
$ ocadm config images pull

# 开始部署 kubernetes 以及 onecloud 必要的控制服务，稍等 3 分钟左右，kubernetes 和 onecloud 控制服务都会运行起来
$ ocadm init --mysql-host $MYSQL_HOST --mysql-user root --mysql-password $MYSQL_PASSWD
...
Your Kubernetes and Onecloud control-plane has initialized successfully!
...
```

### 环境检查

当控制节点部署完成后，云平台的管理员认证信息会保存在 /etc/yunion/rc_admin , 这些认证信息在使用 climc 控制云平台资源时会用到。

```bash
$ source /etc/yunion/rc_admin
```

用 climc 命令行工具查看添加到云平台的网络，这里会创建一个默认 adm0 的网络，start_ip 和 end_ip 都为当前控制节点的默认ip。

```bash
$ climc network-list
+--------------------------------------+------+----------------+----------------+---------------+--------------------------------------+-----------+--------------+---------------+-------------+-----------+
|                  ID                  | Name | Guest_ip_start |  Guest_ip_end  | Guest_ip_mask |               wire_id                | is_public | public_scope | guest_gateway | server_type |  Status   |
+--------------------------------------+------+----------------+----------------+---------------+--------------------------------------+-----------+--------------+---------------+-------------+-----------+
| 375d75ed-2d96-44e9-85c9-854025ebfcf3 | adm0 | 10.168.222.216 | 10.168.222.216 | 24            | a18aa192-1199-4744-8777-300ded3397e7 | false     | none         | 10.168.222.1  | baremetal   | available |
+--------------------------------------+------+----------------+----------------+---------------+--------------------------------------+-----------+--------------+---------------+-------------+-----------+
```

### 删除环境

如果安装过程中失败，或者想清理环境，可执行以下命令删除 kubernetes 集群和 onecloud 数据库

```bash
$ ocadm reset -f
```

