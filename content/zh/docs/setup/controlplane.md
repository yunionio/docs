---
title: "部署集群"
date: 2019-04-13T13:01:57+08:00
weight: 2
description: >
  部署 kubernetes 和 onecloud 服务，创建第一个控制节点
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

## 部署集群

### 安装部署工具

先安装部署工具 ocadm 和云平台的命令行工具 climc:

```bash
# 安装 climc 云平台命令行工具
$ yum-config-manager --add-repo https://iso.yunion.cn/yumrepo-2.10/yunion.repo
$ yum install -y yunion-climc
# climc 在 /opt/yunion/bin 目录下，根据自己的需要加到 bash 或者 zsh 配置文件里面
$ echo 'export PATH=$PATH:/opt/yunion/bin' >> ~/.bashrc && source ~/.bashrc

# 安装 ocadm
$ wget https://github.com/Zexi/ocadm/releases/download/v0.0.1/ocadm -P /opt/yunion/bin
$ chmod a+x /opt/yunion/bin/ocadm
```

### 部署 kubernetes 集群

接下来会现在当前节点启动 v1.14.3 的 kubernetes 服务，然后部署 OneCloud 控制节点相关的服务到 kubernetes 集群。

```bash
# 假设 mariadb 部署在本地，如果是使用已有的数据库，请改变对应的 ip
$ MYSQL_HOST=$(ip route get 1 | awk '{print $NF;exit}')

# 拉取必要的 docker 镜像
$ ocadm config images pull

# 开始部署 kubernetes 以及 onecloud 必要的控制服务，稍等 3 分钟左右，kubernetes 集群会部署完成
$ ocadm init --mysql-host $MYSQL_HOST --mysql-user root --mysql-password $MYSQL_PASSWD
...
Your Kubernetes and Onecloud control-plane has initialized successfully!
...
```

kubernetes 集群部署完成后，通过以下命令来确保相关的 pod (容器) 都已经启动, 变成 running 的状态。

```bash
$ export KUBECONFIG=/etc/kubernetes/admin.conf
$ kubectl get pods --all-namespaces
NAMESPACE            NAME                                       READY   STATUS    RESTARTS   AGE
kube-system          calico-kube-controllers-648bb4447c-57gjb   1/1     Running   0          5h1m
kube-system          calico-node-j89jg                          1/1     Running   0          5h1m
kube-system          coredns-69845f69f6-f6wnv                   1/1     Running   0          5h1m
kube-system          coredns-69845f69f6-sct6n                   1/1     Running   0          5h1m
kube-system          etcd-lzx-ocadm-test2                       1/1     Running   0          5h
kube-system          kube-apiserver-lzx-ocadm-test2             1/1     Running   0          5h
kube-system          kube-controller-manager-lzx-ocadm-test2    1/1     Running   0          5h
kube-system          kube-proxy-2fwgf                           1/1     Running   0          5h1m
kube-system          kube-scheduler-lzx-ocadm-test2             1/1     Running   0          5h
kube-system          traefik-ingress-controller-qwkfb           1/1     Running   0          5h1m
local-path-storage   local-path-provisioner-5978cff7b7-7h8df    1/1     Running   0          5h1m
onecloud             onecloud-operator-6d4bddb8c4-tkjkh         1/1     Running   0          3h37m
```

### 创建 onecloud 集群

当 kubernetes 集群部署完成后，就可以通过 `ocadm cluster create` 创建 onecloud 集群，该集群由 onecloud namespace 里面 **onecloud-operator** deployment 自动部署和维护。

```bash
# 创建集群
$ ocadm cluster create
```

执行完 `ocadm cluster create` 命令后，**onecloud-operator** 会自动创建各个服务组件对应的 pod，等待一段时间后，确保 onecloud namespace 里面的 keystone, region 和 glance 等 pod 都处于 running 状态。

```bash
$ kubectl get pods --namespace onecloud
NAME                                  READY   STATUS    RESTARTS   AGE
default-climc-6c4888fb55-9729z        1/1     Running   0          132m
default-glance-59449b8c8d-bhwgf       1/1     Running   0          132m
default-influxdb-5cd895746c-5w5s9     1/1     Running   0          132m
default-keystone-5d59bf668f-8j9wv     1/1     Running   0          133m
default-logger-69cfb8dc85-qwmhs       1/1     Running   0          132m
default-region-69dbbbb487-s9knd       1/1     Running   0          132m
default-scheduler-6fd8c979bd-wqd6v    1/1     Running   0          132m
default-webconsole-6ff98d4f8b-p7h8v   1/1     Running   0          132m
onecloud-operator-6d4bddb8c4-tkjkh    1/1     Running   0          3h43m
```

### 环境检查

当控制节点部署完成后，云平台的管理员认证信息由 `ocadm cluster rcadmin` 命令可以得到 , 这些认证信息在使用 climc 控制云平台资源时会用到。

```bash
# 获取连接 onecloud 集群的环境变量
$ ocadm cluster rcadmin
export OS_AUTH_URL=https://10.168.222.218:35357/v3
export OS_USERNAME=sysadmin
export OS_PASSWORD=3hV3qAhvxck84srk
export OS_PROJECT_NAME=system
export YUNION_INSECURE=true
export OS_REGION_NAME=region0
export OS_ENDPOINT_TYPE=publicURL

# 测试链接
$ source <(ocadm cluster rcadmin)
$ climc endpoint-list
+----------------------------------+-----------+----------------------------------+----------------------------------+-----------+---------+
|                ID                | Region_ID |            Service_ID            |               URL                | Interface | Enabled |
+----------------------------------+-----------+----------------------------------+----------------------------------+-----------+---------+
| aa266549bbd743f4882fa1b1e98e409a | region0   | 106f7cf2410b4187879d4a44a737df0b | https://default-influxdb:8086    | internal  | true    |
| ba59f23951e6452984b9d2036d303ade | region0   | 106f7cf2410b4187879d4a44a737df0b | https://10.168.222.218:8086      | public    | true    |
| 5b2981d751624c6b86a757e30676c528 | region0   | ee302d70e261452282ca66c86f85f2f7 | https://default-webconsole:8899  | internal  | true    |
| 81c79509449f4f4581140adc030e5e57 | region0   | ee302d70e261452282ca66c86f85f2f7 | https://10.168.222.218:8899      | public    | true    |
| 9623a61a904e4ea78347b05afa08f239 | region0   | 7716623b738d4a3282fc076e46f96627 | https://default-glance:9292/v1   | internal  | true    |
| a7ee01e0f4a94f908fc68e2de5990065 | region0   | 7716623b738d4a3282fc076e46f96627 | https://10.168.222.218:9292/v1   | public    | true    |
| 28f7a82402d847308dd7b09dbc4faead | region0   | 8c0c3b14e9904d7485b986836334fbbb | https://10.168.222.218:8897      | public    | true    |
| 83405b6973354e4287e9b61c1f2af668 | region0   | 8c0c3b14e9904d7485b986836334fbbb | https://default-scheduler:8897   | internal  | true    |
| 6a08a98f8071492287976ac788e2f424 | region0   | acc01b6df2ed442280e9f8f716bd006f | https://10.168.222.218:8889      | public    | true    |
...
```

### 删除环境

如果安装过程中失败，或者想清理环境，可执行以下命令删除 kubernetes 集群。

```bash
$ ocadm reset --force
```

