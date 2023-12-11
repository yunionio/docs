---
title: "本地存储"
weight: 1
description: >
  如何配置和使用本地存储
---

本地存储的虚拟机磁盘存储在本地目录里，跟该目录使用的文件系统无关，可以是ext4或者xfs。虚拟磁盘的文件格式采用qcow2格式。默认的存储位置是宿主机的目录 /opt/cloud/workspace/disks。

存储虚拟磁盘的本地目录需要在宿主机的配置文件里显示声明。host服务的配置项 local_image_path 指定本宿主机用来保存虚拟机磁盘的目录。

## 添加本地存储

{{% alert title="注意" color="warning" %}}
一定要把本地存储挂载到放在 `/opt/cloud/workspace` 目录下面的子目录，因为宿主机服务是运行到容器里面的，没有访问其他目录的权限。
{{% /alert %}}

1. 把磁盘分区挂载到 /opt/cloud/workspace 目录下：

这里假设要把 `/dev/sdb1` 和 `/dev/sdc1` 作为本地存储，首先需要格式化磁盘分区，然后在 `/etc/fstab` 里面添加自动挂载点，其中 UUID 可以通过执行 `blkid` 命令查询：

```
UUID=b411dc99-f0a0-4c87-9e05-184977be8539 /opt/cloud/workspace/disks2 ext4   defaults  0      2
UUID=f9fe0b69-a280-415d-a03a-a32752370dee /opt/cloud/workspace/disks3 ext4   defaults  0      2
```

2. 修改 /etc/yunion/host.conf，在 local_image_path 的字符串数组中添加新的本地磁盘：

```yaml
local_image_path:
- /opt/cloud/workspace/disks
- /opt/cloud/workspace/disks2
- /opt/cloud/workspace/disks3
```

3. 重启host服务

重启host这里假设节点名叫作 ceph-02，下面的命令就会删除 ceph-02 上的 host pod，然后 K8s 就会自动重新创建新的 pod 。

```bash
OP_HOST=ceph-02
kubectl delete pods -n onecloud $(kubectl get pods -n onecloud -o wide | grep host | egrep -v 'image|deployer' | grep $OP_HOST | awk '{print $1}')
```

查看宿主机的存储列表，就能看到新注册上来的存储。

```bash
climc storage-list --host <host_id>
```

## 删除本地存储

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

## FAQ

### 没有看到新加的存储?

如果没有看到新加的存储，应该是 host 服务存储注册失败了，需要通过下面的命令查看启动日志。这里假设查看 ceph-02 节点上的 host pod 日志。

```bash
OP_HOST=ceph-02
kubectl logs -n onecloud $(kubectl get pods -n onecloud -o wide | grep host | egrep -v 'image|deployer' | grep $OP_HOST | awk '{print $1}') -c host
```

然后结合日志的报错再做下一步的处理。
