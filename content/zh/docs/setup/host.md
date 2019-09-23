---
title: "计算节点"
weight: 10
description: >
  如果要运行 onecloud 私有云虚拟机，需要添加对应的计算节点，本节介绍如何部署相应组件
---

如果需要构建内部私有云，就需要部署计算节点(宿主机)。计算节点主要负责虚拟机、网络和存储的管理，需要安装的组件如下:

|     组件    |           用途           | 安装方式 | 运行方式 |
|:-----------:|:------------------------:|:--------:|:--------:|
|     host    |   管理 kvm 虚拟机和存储  |    rpm   |  systemd |
|   sdnagent  |  管理虚拟机网络和安全组  |    rpm   |  systemd |
| openvswitch | 虚拟机网络端口和流表配置 |    rpm   |  systemd |
|     qemu    |        运行虚拟机        |    rpm   |  process |
|    kernel   |    onecloud 提供的内核   |    rpm   |     -    |

## 环境

- 操作系统: Centos 7.x
- 硬件要求:
	- Virtualization: CPU 要支持虚拟化，用于虚拟机 KVM 加速
	- 打开 iommu，VT-d: 用于 GPU 透传
- 网络:
	- 当前可用的网段: 虚拟机可以直接使用和计算节点所在的扁平网段，需要预先划分保留对应端给云平台虚拟机使用，防止被其它设备占用，最后 IP 冲突

- 备注:
	- 如果是以测试为目的，可以拿一台虚拟机部署计算节点的服务，但可能无法使用 KVM 加速和 GPU 透传

## 安装依赖

计算节点所有的服务都以 rpm 的方式安装，因为虚拟机会用到内核 vfio 和 nbd 等特性，所以没有容器化部署。

```bash
# 添加 yum 源
$ cat <<EOF >/etc/yum.repos.d/yunion.repo
[yunion]
name=Packages for Yunion Multi-Cloud Platform
baseurl=https://iso.yunion.cn/yumrepo-2.10
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
  epel-release chntpw dosfstools ethtool fetchclient fuse fuse-devel fuse-libs gdisk \
  libaio jq libusb lvm2 lxcfs nc ntfs-3g_ntfsprogs zerofree \
  oniguruma parted pciutils spice spice-protocol sshpass sysstat \
  tcpdump telegraf usbredir vmware-vddk xfsprogs \
  yunion-qemu-2.12.1 yunion-host yunion-host-deployer yunion-host-image yunion-sdnagent \
  kernel-3.10.0-862.14.4.el7.yn20190712 \
  kernel-devel-3.10.0-862.14.4.el7.yn20190712 \
  kernel-headers-3.10.0-862.14.4.el7.yn20190712 \
  kmod-openvswitch-2.9.5-1.el7 \
  openvswitch-2.9.5-1

# 安装完成后需要重启进入我们的内核
$ reboot

# 重启完成后，查看当前节点内核信息，确保为 yn 内核
$ uname -r
3.10.0-862.14.4.el7.yn20190712.x86_64
```

## 控制节点操作

以下操作在控制节点进行。

### 创建 host 服务的认证用户

```bash
$ ocadm cluster rcadmin
# 这个是云平台 keystone 的认证地址，后面配置会用到
export OS_AUTH_URL=https://10.168.222.218:5000/v3
...
# 这个 region0 也会在配置中用到
export OS_REGION_NAME=region0

$ source <(ocadm cluster rcadmin)

# 这里记住自己的用户密码，后面配置会用到
$ climc user-create --enabled --password hostadminpasswd hostadmin
$ climc project-add-user system hostadmin admin
```

### 创建计算节点所在的网段

我的环境**计算节点**的 ip 为 10.168.222.140，就创建一个对应的 **计算节点(host)网段**。

{{% alert title="提示" %}}
需要根据自己的计算节点环境创建对应的网段，如果不创建该网段，计算节点就没发注册进来。
{{% /alert %}}

```bash
# 查看当前环境的 zone
$ climc zone-list
+--------------------------------------+-------+--------+----------------+
| ID | Name | Status | Cloudregion_ID |
+--------------------------------------+-------+--------+----------------+
| f73a2120-1206-45fa-8d43-de374ab0f494 | zone0 | enable | default        |
+--------------------------------------+-------+--------+----------------+

# 在 zone0 里面创建一个 wire bcast0，该资源抽象计算节点所在的二层广播域信息
$ climc wire-create zone0 bcast0 1000

# 在 wire bcast0 之上创建一个计算节点的网络，计算节点的 host 服务注册会用到，如果 host 注册时没有在云平台找到对应的网络，将会注册失败
$ climc network-create --gateway 10.168.222.1 --server-type baremetal bcast0 inf0 10.168.222.140 10.168.222.140 24
```

## 计算节点(host)操作

以下操作在计算节点进行，计算节点也叫 host，私有云计算节点上面会运行 host 服务来管理 kvm 虚拟机。

### 配置 host 服务

```bash
# 获取计算节点 IP
$ host_addr=$(ip route get 1 | awk '{print $NF;exit}')
$ echo $host_addr
10.168.222.140

$ mkdir -p /etc/yunion

 # 记得把这些认证信息参考控制节点的 rc_amdin 配置对应过来
$ cat <<EOF >/etc/yunion/host.conf
region = 'region0'
address =  '$host_addr' # 计算节点服务监听的地址
port = 8885
auth_uri = 'https://10.168.222.218:5000/v3' # 控制节点 keystone 服务的认证地址
admin_user = 'hostadmin'  # 计算节点认证用户
admin_password = 'hostadminpasswd' # 计算节点认证用户密码
admin_tenant_name = 'system' # 计算节点用户所在的项目
networks = ['eth0/br0/$host_addr']  # 计算节点网桥配置
hostname = '$(hostname -s)'

bridge_driver = 'openvswitch'

servers_path = '/opt/cloud/workspace/servers'
snapshot_path = '/opt/cloud/workspace/disks/snapshots'

local_image_path = ['/opt/cloud/workspace/disks']
image_cache_path = '/opt/cloud/workspace/disks/image_cache'
agent_temp_path = '/opt/cloud/workspace/disks/agent_tmp'

rack  = 'rack0'
slots = 'slot0'

linux_default_root_user = True
allow_inter_tenant_broadcast = True
allow_inter_tenant_multicast = True
allow_inter_tenant_unicast = True

block_io_scheduler = 'cfq'

enable_template_backing = True

default_qemu_version = '2.12.1'
EOF
```

### 启动 host

配置完成后就可以使用 systemctl 启动 host 服务了，命令如下:

```bash
# 启动
$ systemctl enable yunion-host yunion-host-deployer --now

# 观察启动日志
$ journalctl -u yunion-host -f
...
Jul 09 18:23:34 lzx-ocadm-test2 host[4216]: [I 190709 18:23:34 metadata.StartService(metadatahandler.go:268)] Host Metadata Start listen on http://10.168.222.140:9885
# 出现上述信息表示 host 已经成功注册到了控制节点
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
