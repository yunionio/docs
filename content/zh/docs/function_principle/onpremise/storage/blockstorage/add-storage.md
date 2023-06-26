---
title: "如何添加和删除本地存储"
weight: 1
description: >
---

本地存储的虚拟机磁盘存储在本地目录里，跟该目录使用的文件系统无关，可以使ext4或者xfs。虚拟磁盘的文件格式采用qcow2格式。默认的存储位置是宿主机的目录 /opt/cloud/workspace/disks。

存储虚拟磁盘的本地目录需要在宿主机的配置文件里显示声明。host服务的配置项 local_image_path 指定本宿主机用来保存虚拟机磁盘的目录。

## 如何添加本地存储目录？

1. 修改/etc/yunion/host.conf，在 local_image_path 的字符串数组中添加新的本地磁盘：

```yaml
local_image_path:
- /opt/cloud/workspace/disks
- /new_image_path
```

2. 重启host服务

host服务重启后，稍等片刻，查看宿主机的存储列表，就能看到这个新的存储注册上来了。

```bash
climc storage-list --host <host_id>
```

## 如何删除本地存储？

1. 需要确保所有的虚拟磁盘都被删除，特别需要留意被伪删除的磁盘，以及被标记为系统资源的磁盘:

```bash
# 查看所有的磁盘，包括不再执行命令用户所在项目下的所有磁盘，以及被标记为系统资源的磁盘
climc disk-list --storage <storage_id> --scope system --system
# 查看所有的未删除的磁盘
climc disk-list --storage <storage_id> --scope system --system --pending-delete
```

2. 解除存储和宿主机的关联关系：

```bash
climc host-storage-detach <host_id> <storage_id>
```

3. 删除存储

```bash
climc storage-delete <storage_id>
```

4. 到宿主机，修改 /etc/yunion/host.conf，将该存储所在路径从 local_image_path 删除

5. 重启host服务