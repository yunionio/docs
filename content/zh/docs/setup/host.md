---
title: "添加计算节点"
weight: 10
description: >
  如果要运行 onecloud 私有云虚拟机，需要添加对应的计算节点，本节介绍如何部署相应组件
---

如果需要构建内部私有云，就需要部署计算节点(宿主机)。计算节点主要负责虚拟机、网络和存储的管理，需要安装的组件如下:

|     组件    |           用途           | 安装方式 | 运行方式 |
|:-----------:|:------------------------:|:--------:|:--------:|
|     host    |   管理 kvm 虚拟机和存储  |    -   |  docker |
| host-deployer    |   虚拟机部署服务  |    -   |  docker |
|   sdnagent  |  管理虚拟机网络和安全组  |    rpm   |  systemd |
| openvswitch | 虚拟机网络端口和流表配置 |    rpm   |  systemd |
|     qemu    |        运行虚拟机        |    rpm   |  process |
|    kernel   |    onecloud 提供的内核   |    rpm   |     -    |

## 环境

- 操作系统: Centos 7.x
- 硬件要求:
	- Virtualization: CPU 要支持虚拟化，用于虚拟机 KVM 加速
	- 打开 iommu，VT-d: 用于 GPU 透传(不用GPU可以不开)
- 网络:
	- 当前可用的网段: 虚拟机可以直接使用和计算节点所在的扁平网段，需要预先划分保留对应端给云平台虚拟机使用，防止被其它设备占用，最后 IP 冲突

- 备注:
	- 如果是以测试为目的，可以拿一台虚拟机部署计算节点的服务，但可能无法使用 KVM 加速和 GPU 透传

## 安装依赖

计算节点所需的依赖以 rpm 的方式安装

```bash
# 添加 yum 源
$ cat <<EOF >/etc/yum.repos.d/yunion.repo
[yunion]
name=Packages for Yunion Multi-Cloud Platform
baseurl=https://iso.yunion.cn/yumrepo-3.0
sslverify=0
failovermethod=priority
enabled=1
gpgcheck=0
EOF

# 禁用防火墙和selinux
$ systemctl disable firewalld
$ sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
```

安装 rpm 包

```bash
$ yum install -y \
  epel-release libaio jq libusb lvm2 nc ntp fetchclient fuse fuse-devel fuse-libs \
  oniguruma pciutils spice spice-protocol sysstat tcpdump telegraf usbredir \
  yunion-qemu-2.12.1 yunion-sdnagent yunion-executor-server \
  kernel-3.10.0-1062.4.3.el7.yn20191203 \
  kernel-devel-3.10.0-1062.4.3.el7.yn20191203 \
  kernel-headers-3.10.0-1062.4.3.el7.yn20191203 \
  kmod-openvswitch-2.9.6-1.el7 \
  openvswitch-2.9.6-1.el7 net-tools

$ systemctl enable --now yunion-host-sdnagent yunion-executor

# 安装完成后需要重启进入我们的内核
$ reboot

# 重启完成后，查看当前节点内核信息，确保为 yn 内核
$ uname -r
3.10.0-862.14.4.el7.yn20190712.x86_64
```

### 安装 docker 和 kubelet

参考 ["部署集群/环境准备"](/docs/setup/controlplane/#安装配置-docker) 的流程，安装好 docker 和 kubelet。

## 控制节点操作

以下操作在控制节点进行。

### 创建计算节点所在的网段

我的环境**计算节点**的 ip 为 10.168.222.140，就创建一个对应的 **计算节点(host)网段**。

{{% alert title="提示" %}}
需要根据自己的计算节点环境创建对应的网段，如果不创建该网段，计算节点就没法注册进来。
{{% /alert %}}

```bash
# 查看当前环境的 zone
$ climc zone-list
+--------------------------------------+-------+--------+----------------+
| ID                                   | Name  | Status | Cloudregion_ID |
+--------------------------------------+-------+--------+----------------+
| f73a2120-1206-45fa-8d43-de374ab0f494 | zone0 | enable | default        |
+--------------------------------------+-------+--------+----------------+

# 在 zone0 里面创建一个 wire bcast0，该资源抽象计算节点所在的二层广播域信息
$ climc wire-create zone0 bcast0 1000

# 在 wire bcast0 之上创建一个计算节点的网络，计算节点的 host 服务注册会用到，如果 host 注册时没有在云平台找到对应的网络，将会注册失败
$ climc network-create --gateway 10.168.222.1 --server-type baremetal bcast0 adm0 10.168.222.140 10.168.222.140 24
```

## 计算节点(host)操作

以下操作在计算节点进行，计算节点也叫 host，私有云计算节点上面会运行 host 服务来管理 kvm 虚拟机。

### 配置 host 服务

参考 ["添加节点/获取加入集群token"](/docs/setup/components/#获取加入集群-token) 的流程获取join所需的信息

```bash
# 使用 ocadm join 来创建一台计算节点
# 可选参数 --host-networks: 配置host服务的网络，比如: 'eth0/br0/10.168.222.140', eth0是物理网卡，br0是网桥名称，10.168.222.140是宿主机的ip
# 获取计算节点 IP
$ host_addr=$(ip route get 1 | awk '{print $NF;exit}')
$ echo $host_addr
10.168.222.140

# 可选参数 --host-local-image-path: 配置host服务磁盘的存储路径，比如: '/opt/cloud/workspace/disks'
# 注意：容器部署的host服务只会挂载/opt/cloud目录
# 如果有其他挂载点需要bind mount到/opt/cloud下，可在fstab中添加一行如'/src /opt/cloud/dst none defaults,bind 0 0'
# 可选参数 --host-hostname: 配置宿主机的hostname, 比如: 'node1'
$ ./ocadm join $api_server_addr \
    --enable-host-agent \
    --token $token \
    --discovery-token-unsafe-skip-ca-verification

# 然后等待宿主机上的host pod和host-deployer pod为running状态
```

## 控制节点启用 host

回到控制节点，启用刚才上报的计算节点，只有启用的宿主机才能运行虚拟机。

```bash
# 使用 climc 查看注册的 host 列表
$ climc host-list
+--------------------------------------+-------------------------+-------------------+----------------+----------------------------+---------+---------+-------------+----------+-----------+------------+---------------+--------------+------------+-------------------------+--------------+
|                  ID                  |          Name           |    Access_mac     |   Access_ip    |        Manager_URI         | Status  | enabled | host_status | mem_size | cpu_count | node_count |      sn       | storage_type | host_type  |         version         | storage_size |
+--------------------------------------+-------------------------+-------------------+----------------+----------------------------+---------+---------+-------------+----------+-----------+------------+---------------+--------------+------------+-------------------------+--------------+
| 3830870e-a499-459d-89df-bb6979b5e1ff | lzx-allinone-standalone | 00:22:39:4c:6c:e9 | 10.168.222.140 | http://10.168.222.140:8885 | running | false   | online      | 8192     | 4         | 1          | Not Specified | rotate       | hypervisor | master(7ab047419092301) | 50141        |
+--------------------------------------+-------------------------+-------------------+----------------+----------------------------+---------+---------+-------------+----------+-----------+------------+---------------+--------------+------------+-------------------------+--------------+
***  Total: 0 Pages: 0 Limit: 20 Offset: 0 Page: 1  ***

# 启动 host
$ climc host-enable lzx-allinone-standalone
```

## 创建虚拟机测试

### 上传 cirrors 测试镜像

```bash
# 下载 cirros 测试镜像
$ wget https://iso.yunion.cn/yumrepo-2.10/images/cirros-0.4.0-x86_64-disk.qcow2

# 将镜像上传到 glance
$ climc image-upload --format qcow2 --os-type Linux --min-disk 10240 cirros-0.4.0-x86_64-disk.qcow2 ./cirros-0.4.0-x86_64-disk.qcow2

# 查看上传的镜像
$ climc image-list
+--------------------------------------+--------------------------------+-------------+----------+-----------+----------+---------+--------+----------------------------------+
|                  ID                  |              Name              | Disk_format |   Size   | Is_public | Min_disk | Min_ram | Status |             Checksum             |
+--------------------------------------+--------------------------------+-------------+----------+-----------+----------+---------+--------+----------------------------------+
| 63f6f2af-4db2-4e30-85f5-0ad3baa27bd9 | cirros-0.4.0-x86_64-disk.qcow2 | qcow2       | 22806528 | false     | 30720    | 0       | active | 76dc07d1a730a92d0db7fb2d3c305ecd |
+--------------------------------------+--------------------------------+-------------+----------+-----------+----------+---------+--------+----------------------------------+

# 如果使用虚拟机作为计算节点，存储可能不大，可以把镜像的默认大小30g调整到10g
$ climc image-update --min-disk 10240 cirros-0.4.0-x86_64-disk.qcow2
```

### 创建测试网络

下面是随机创建了一个主机间不可达的网络用于测试，如果有划分好的扁平二层可用网络，可以直接拿来给虚拟机使用。

```bash
$ climc network-create --gateway 10.20.30.1 --server-type guest bcast0 vnet0 10.20.30.2 10.20.30.254 24
$ climc network-public vnet0
```

### 创建虚拟机

```bash
# 创建虚拟机 testvm01，512M内存, 1个CPU, 系统盘 10g, 第二块磁盘 5g 格式化为 ext4 并挂载到 /opt 的虚拟机
$ climc server-create  --auto-start --allow-delete \
		--disk cirros-0.4.0-x86_64-disk.qcow2:10g --disk 5g:ext4:/opt \
		--net vnet0 --ncpu 1 --mem-spec 512M testvm01

# 查看创建的虚拟机，1分钟后应该会变为 running 状态
$ climc server-list --details
+--------------------------------------+----------+--------------+--------------+-------+---------+------------+-----------+----------+-----------------------------+------------+---------+-------------------------+--------+-----------+
|                  ID                  |   Name   | Billing_type |     IPs      | Disk  | Status  | vcpu_count | vmem_size | Secgroup |         Created_at          | Hypervisor | os_type |          Host           | Tenant | is_system |
+--------------------------------------+----------+--------------+--------------+-------+---------+------------+-----------+----------+-----------------------------+------------+---------+-------------------------+--------+-----------+
| bcda7d18-decc-4b5f-8654-2d201a84d1fb | testvm01 | postpaid     | 10.20.30.254 | 35840 | running | 1          | 512       | Default  | 2019-09-23T05:08:49.000000Z | kvm        | Linux   | lzx-allinone-standalone | system | false     |
+--------------------------------------+----------+--------------+--------------+-------+---------+------------+-----------+----------+-----------------------------+------------+---------+-------------------------+--------+-----------+
***  Total: 0 Pages: 0 Limit: 20 Offset: 0 Page: 1  ***

# 获取虚拟机登录信息
$ climc server-logininfo testvm01
+-----------+------------------------------------------+
|   Field   |                  Value                   |
+-----------+------------------------------------------+
| login_key | 49wqh5OWGW3jSr1A8RfrMoH69iRRECzaMZITBA== |
| password  | zS27FwwUFr96                             |
| updated   | 2019-09-23T05:11:29.306403Z              |
| username  | root                                     |
+-----------+------------------------------------------+

# 在计算节点联通测试网络(如果你是直接用的二层网络，应该能直接 ping 通虚拟机的 ip 了，不需要做这一步)
$ ip address add 10.20.30.1/24 dev br0

# 用之前 server-logininfo 命令获取的用户名密码，直接登录到虚拟机里面
$ ssh root@10.20.30.254
PING 10.20.30.254 (10.20.30.254) 56(84) bytes of data.
64 bytes from 10.20.30.254: icmp_seq=1 ttl=64 time=1.31 ms

# 如果网络不通，也可以通过 vnc 的方式打开虚拟机的 tty 登录界面，操作如下
# 打开 vnc 链接，用浏览器打开下面的链接
# 打开 vnc 链接时会出现不安全认证，导致 websocket 无法握手，需要在浏览器信任 webconsole server 对应的 endpoint
$ climc endpoint-list --details | grep webconsole | grep public
| 3da1e476aa7b4ff68e206754aed72d8f | region0   | 16120e8f3eec46dc86c59b3e426b0502 | webconsole      | webconsole      | https://10.168.222.218:8899         | public    | true    |
# 然后用浏览器访问下 https://10.168.222.218:8899 , 信任该链接即可

# 在通过 webconsole-server 命令获取 vnc web 界面的链接地址，然后用浏览器打开该地址
$ climc webconsole-server testvm01
https://console.yunion.cn/web-console?access_token=FI-VXQSAonhzfSnxVTKCCbwHinp7swlRkmi-4p6s-4OfZpg6TG9YhWuwbHEUA1D7XoKu_w%3D%3D&api_server=https%3A%2F%2F10.168.222.216%3A8899&password=65xB2kaE&protocol=vnc
```
