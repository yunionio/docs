---
title: "添加计算节点"
weight: 10
edition: ce
description: >
  如果要运行 var_oem_name 私有云虚拟机，需要添加对应的计算节点，本节介绍如何部署相应组件
---

如果需要构建内部私有云，就需要部署计算节点(宿主机)。计算节点主要负责虚拟机、网络和存储的管理，需要安装的组件如下:

|     组件    |           用途           | 安装方式 | 运行方式 |
|:-----------:|:------------------------:|:--------:|:--------:|
|     host    |   管理 kvm 虚拟机和存储  |    -   |  docker |
| host-deployer    |   虚拟机部署服务  |    -   |  docker |
|   sdnagent  |  管理虚拟机网络和安全组  |    -   |  docker |
| openvswitch | 虚拟机网络端口和流表配置 |    rpm   |  systemd |
|     qemu    |        运行虚拟机        |    rpm   |  process |
|    kernel   |    Cloudpods 提供的内核   |    rpm   |     -    |

## 环境

- 操作系统: CentOS 7.x
- 硬件要求:
	- Virtualization: CPU 要支持虚拟化，用于虚拟机 KVM 加速
	- 打开 iommu，VT-d: 用于 GPU 透传(不用GPU可以不开)
- 网络:
	- 当前可用的网段: 虚拟机可以直接使用和计算节点所在的扁平网段，需要预先划分保留对应端给云平台虚拟机使用，防止被其它设备占用，最后 IP 冲突
- 虚拟机和服务使用的存储路径都在 **/opt** 目录下，所以理想环境下建议单独给 **/opt** 目录设置挂载点
    - 比如把 /dev/sdb1 单独分区做 ext4 然后通过 /etc/fstab 挂载到 /opt 目录

- 备注:
	- 如果是以测试为目的，可以拿一台虚拟机部署计算节点的服务，但可能无法使用 KVM 加速和 GPU 透传

## 使用 ocboot 添加对应节点

以下操作在控制节点进行，在控制节点使用 `ocboot add-node` 命令把对应计算节点添加进来。

假设要给控制节点 10.168.26.216 添加计算节点 10.168.222.140 首先需要 ssh root 免密码登录对应的计算节点以及控制节点自身。

```bash
# 将控制节点自己设置成免密登录
$ ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.168.26.216

# 尝试免密登录控制节点是否成功
$ ssh root@10.168.26.216 "hostname"

# 将生成的 ~/.ssh/id_rsa.pub 公钥拷贝到待部署的计算机器
$ ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.168.222.140

# 尝试免密登录待部署机器，应该不需要输入登录密码即可拿到部署机器的 hostname
$ ssh root@10.168.222.140 "hostname"
```

### 拉取 ocboot 代码

如果本地已经有 ocboot 工具可以跳过此步，只用把代码更新到对应的分支。

```bash
# 本地安装 ansible
$ yum install -y python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible paramiko

# 下载 ocboot 工具到本地
$ git clone -b {{<release_branch>}} https://github.com/yunionio/ocboot && cd ./ocboot
```

### 更新 ocboot 代码

```bash
$ git fetch
$ git checkout {{<release_version>}}
```

### 添加节点

```bash
# 使用 ocboot 添加节点
$ ./ocboot.py add-node 10.168.26.216 10.168.222.140

# 默认情况是不允许虚拟机作为计算节点的，如果需要目标虚拟机作为计算节点，需要设置 --enable-host-on-vm 参数
$ ./ocboot.py add-node --enable-host-on-vm 10.168.26.216 10.168.222.140

# 其他选项，使用 '--help' 参考帮助
$ ./ocboot.py add-node --help
usage: ocboot.py add-node [-h] [--user SSH_USER] [--key-file SSH_PRIVATE_FILE] [--port SSH_PORT] [--node-port SSH_NODE_PORT]
                          [--enable-host-on-vm]
                          FIRST_MASTER_HOST TARGET_NODE_HOSTS [TARGET_NODE_HOSTS ...]

positional arguments:
  FIRST_MASTER_HOST     onecloud cluster primary master host, e.g., 10.1.2.56
  TARGET_NODE_HOSTS     target nodes ip added into cluster

optional arguments:
  -h, --help            show this help message and exit
  --user SSH_USER, -u SSH_USER
                        primary master host ssh user (default: root)
  --key-file SSH_PRIVATE_FILE, -k SSH_PRIVATE_FILE
                        primary master ssh private key file (default: /home/lzx/.ssh/id_rsa)
  --port SSH_PORT, -p SSH_PORT
                        primary master host ssh port (default: 22)
  --node-port SSH_NODE_PORT, -n SSH_NODE_PORT
                        worker node host ssh port (default: 22)
  --enable-host-on-vm
```

该命令会使用 ansible-playbook 把对应的计算节点加入进来。


### 启用计算节点(宿主机)

等计算节点添加完成后，需要启用刚才上报的计算节点，只有启用的宿主机才能运行虚拟机。

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

## 常见问题
### 存储介质识别不准，例如机械盘识别成固态
例如用户使用SSD 做lvmcache 等情况，可能造成宿主机本地存储介质识别不准，可自行前往对应宿主机->存储->对应存储介质 修改属性，选择介质类型修改即可。
