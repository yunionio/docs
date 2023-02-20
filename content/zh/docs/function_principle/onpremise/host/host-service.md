---
title: "Host服务启动失败或有warning如何处理"
weight: 3
description: >
---


## 禁用 dhcp 服务

如果你看到了这样的提示：`dhcp: dhcp client is enabled before host agent start, please disable it.`

说明你的机器之前启用过dhcp client.

如何禁用 dhcp client：
```bash
# 一般 centos7 的 dhcp client 都是由 NetworkManager 启动的
$ systemctl disable NetworkManager --now

# 我们会检查 /var/run/dhclient-<nic>.pid 下是否有dhclient的pid文件来决定是否要输出 warning
# 所以同时你需要清除 /var/run 下的 dhclient-<nic>.pid 文件, nic 需要替换成自己的网卡名，如 eth0
$ rm -f /var/run/dhclient-<nic>.pid
```

## 内核模块不匹配

使用我们的平台的 host 服务需要用我们的内核，如果你看到了这样的提示：

`openvswitch: kernel module openvswitch paramters version not found, is kernel version correct ??`

或者 `uname -r` 输出结果中字段不包含 yn. 正确的：`3.10.0-514.26.2.el7.yn20180608.x86_64`

说明你的机器使用的不是我们的内核，需要安装我们的内核然后重启，安装内核步骤如下。

### 环境

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

### 使用 ocboot 添加对应节点

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

```bash
# 本地安装 ansible
$ yum install -y python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible paramiko

# 下载 ocboot 工具到本地
$ git clone -b {{<release_branch>}} https://github.com/yunionio/ocboot && cd ./ocboot

# 使用 ocboot 添加节点
$ ./ocboot.py add-node 10.168.26.216 10.168.222.140
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

