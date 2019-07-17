---
title: "计算节点"
weight: 10
date: 2019-07-09T16:25:11+08:00
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
  libaio jq libusb lvm2 lxcfs lz4 nc ntfs-3g_ntfsprogs zerofree \
  oniguruma parted pciutils spice spice-protocol sshpass sysstat \
  tcpdump telegraf usbredir vmware-vddk xfsprogs \
  yunion-qemu-2.12.1 yunion-host host-image yunion-sdnagent \
  kernel-3.10.0-862.14.4.el7.yn20190116 \
  kernel-devel-3.10.0-862.14.4.el7.yn20190116 \
  kernel-headers-3.10.0-862.14.4.el7.yn20190116 \
  kmod-openvswitch-2.9.3-1.el7 \
  openvswitch-2.9.3-1

# 安装完成后需要重启进入我们的内核
$ reboot

# 重启完成后，查看当前节点内核信息，确保为 yn 内核
$ uname -r
3.10.0-862.14.4.el7.yn20190116.x86_64
```

## 控制节点操作

### 创建 host 服务的认证用户

```bash
$ source /etc/yunion/rc_admin

$ cat /etc/yunion/rc_admin
# 这个是云平台 keystone 的认证地址，后面配置会用到
export OS_AUTH_URL=https://10.168.222.216:5000/v3
...
# 这个 region0 也会在配置中用到
export OS_REGION_NAME=region0

# 这里记住自己的用户密码，后面配置会用到
$ climc user-create --enabled --password hostadminpasswd hostadmin
$ climc project-add-user system hostadmin admin
```

### 创建计算节点所在的网段

我的环境控制节点的 ip 为 10.168.222.218，就创建一个对应的 host 网段。需要根据自己的环境创建对应的网段。

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
$ climc network-create --gateway 10.168.222.1 --server-type baremetal bcast0 inf0 10.168.222.218 10.168.222.218 24
```

## 配置 host 服务

```bash
$ mkdir -p /etc/yunion
$ cat <<EOF >/etc/yunion/host.conf
region = 'region0'   # 记得把这些认证信息参考控制节点的 rc_amdin 配置对应过来
address =  '10.168.222.218'
port = 8885
auth_uri = 'https://10.168.222.216:5000/v3'
admin_user = 'hostadmin'
admin_password = 'hostadminpasswd'
admin_tenant_name = 'system'
networks = ['eth0/br0/10.168.222.218']
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

$ cat <<EOF >/etc/systemd/system/yunion-host.service
[Unit]
Description=Yunion Cloud Host Agent server
Documentation=https://docs.yunion.cn
After=network-online.target
Wants=network-online.target
After=network.target 

[Service]
Type=simple
User=root
Group=root
ExecStart=/opt/yunion/bin/host --config /etc/yunion/host.conf
WorkingDirectory=/opt/yunion/bin
KillMode=process
Restart=always
RestartSec=30
LimitNOFILE=500000
LimitNPROC=500000

[Install]
WantedBy=multi-user.target
EOF

$ cat <<EOF >/etc/systemd/system/yunion-host-sdnagent.service
[Unit]
Description=Yunion Cloud Host SDN Agent server
Documentation=https://docs.yunion.cn
After=network-online.target
Wants=network-online.target
After=network.target 

[Service]
Type=simple
User=root
Group=root
ExecStart=/opt/yunion/bin/sdnagent
WorkingDirectory=/opt/yunion
KillMode=process
Restart=always
RestartSec=30
LimitNOFILE=500000
LimitNPROC=500000

[Install]
WantedBy=multi-user.target
EOF

$ cat <<EOF >/etc/systemd/system/yunion-host-image.service
[Unit]
Description=Yunion Host Image Server
Documentation=https://docs.yunion.cn
After=network-online.target
Wants=network-online.target
After=network.target

[Service]
Type=simple
User=root
Group=root
ExecStart=/opt/yunion/bin/host-image --config /etc/yunion/host.conf
WorkingDirectory=/opt/yunion/bin
KillMode=process
Restart=always
RestartSec=30
LimitNOFILE=500000
LimitNPROC=500000

[Install]
WantedBy=multi-user.target
EOF
```

## 启动 host

配置完成后就可以使用 systemctl 启动 host 服务了，命令如下:

```bash
# 启动
$ systemctl enable yunion-host --now

# 观察启动日志
$ journalctl -u yunion-host -f
...
Jul 09 18:23:34 lzx-ocadm-test2 host[4216]: [I 190709 18:23:34 metadata.StartService(metadatahandler.go:268)] Host Metadata Start listen on http://10.168.222.218:9885
# 出现上述信息表示 host 已经成功注册到了控制节点
```

## 控制节点启动 host

回到控制节点，启用刚才上报的计算节点

```bash
# 使用 climc 查看注册的 host 列表
$ climc host-list
+--------------------------------------+-----------------+-------------------+----------------+----------------------------+---------+---------+-------------+----------+-----------+------------+---------------+--------------+------------+-----------------+--------------+
|                  ID                  |      Name       |    Access_mac     |   Access_ip    |        Manager_URI         | Status  | enabled | host_status | mem_size | cpu_count | node_count |      sn       | storage_type | host_type  |     version     | storage_size |
+--------------------------------------+-----------------+-------------------+----------------+----------------------------+---------+---------+-------------+----------+-----------+------------+---------------+--------------+------------+-----------------+--------------+
| cc053d7c-1456-4c72-8198-adc1f487df9d | lzx-ocadm-test2 | 00:22:1b:c4:a4:81 | 10.168.222.218 | http://10.168.222.218:8885 | running | false   | online      | 4096     | 4         | 4          | Not Specified | rotate       | hypervisor | HEAD(5c8f4b19a) | 29982        |
+--------------------------------------+-----------------+-------------------+----------------+----------------------------+---------+---------+-------------+----------+-----------+------------+---------------+--------------+------------+-----------------+--------------+
***  Total: 1 Pages: 1 Limit: 20 Offset: 0 Page: 1  ***

# 启动 host
$ climc host-enable lzx-ocadm-test2
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
$ climc server-create --disk cirros-0.4.0-x86_64-disk.qcow2:10g --disk 5g:ext4:/opt --net vnet0 --auto-start --allow-delete --ncpu 1 testvm01 512M

# 查看创建的虚拟机，1分钟后应该会变为 running 状态
$ climc server-list --details
+--------------------------------------+----------+--------------+--------------+-------+---------+------------+-----------+----------+-----------------------------+------------+---------+-----------------+--------+-----------+
|                  ID                  |   Name   | Billing_type |     IPs      | Disk  | Status  | vcpu_count | vmem_size | Secgroup |         Created_at          | Hypervisor | os_type |      Host       | Tenant | is_system |
+--------------------------------------+----------+--------------+--------------+-------+---------+------------+-----------+----------+-----------------------------+------------+---------+-----------------+--------+-----------+
| f10c0083-9ee8-4353-86e2-67b9ac16f732 | testvm01 | postpaid     | 10.20.30.253 | 30720 | running | 1          | 512       | Default  | 2019-07-09T13:12:16.000000Z | kvm        | Linux   | lzx-ocadm-test2 | system | false     |
+--------------------------------------+----------+--------------+--------------+-------+---------+------------+-----------+----------+-----------------------------+------------+---------+-----------------+--------+-----------+

# 获取虚拟机登录信息
$ climc server-logininfo testvm01
+----------+-----------------------------+
|  Field   |            Value            |
+----------+-----------------------------+
| password | Bs5Zn6%Ry?9h                |
| updated  | 2019-07-09T13:12:22.785767Z |
| username | root                        |
+----------+-----------------------------+

# 在计算节点联通测试网络(如果你是直接用的二层网络，应该能直接 ping 通虚拟机的 ip 了，不需要做这一步)
$ ip address add 10.20.30.1/24 dev br0
$ ping 10.20.30.253
PING 10.20.30.253 (10.20.30.253) 56(84) bytes of data.
64 bytes from 10.20.30.253: icmp_seq=1 ttl=64 time=0.984 ms

# 用之前 server-logininfo 命令获取的用户名密码，直接登录到虚拟机里面
$ ssh root@10.20.30.253

# 如果网络不通，也可以通过 vnc 的方式打开虚拟机的 tty 登录界面，操作如下
# 打开 vnc 链接，用浏览器打开下面的链接
# 打开 vnc 链接时会出现不安全认证，导致 websocket 无法握手，需要在浏览器信任 webconsole server 对应的 endpoint
$ climc endpoint-list --details | grep webconsole
| 67dcd7e163524526867d2a67c2162389 | region0 | 0c79be9a91f840c38d02930e9aa24dce | webconsole | webconsole | https://10.168.222.216:8899 | internal | true |

# 然后用浏览器访问下 https://10.168.222.216:8899 , 信任该链接即可

# 在通过 webconsole-server 命令获取 vnc web 界面的链接地址
$ climc webconsole-server testvm01
https://console.yunion.cn/web-console?access_token=FI-VXQSAonhzfSnxVTKCCbwHinp7swlRkmi-4p6s-4OfZpg6TG9YhWuwbHEUA1D7XoKu_w%3D%3D&api_server=https%3A%2F%2F10.168.222.216%3A8899&password=65xB2kaE&protocol=vnc

```
