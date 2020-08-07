---
title: "创建云主机"
weight: 10
date: 2019-07-19T15:22:33+08:00
---

`climc server-create` 命令提供创建云主机的操作。 OneCloud 可以同时管理多个私有云和公有云，不同供应商有各自的认证方式，在创建云主机之前需要做一些不同的准备工作。


## 环境准备

### OneCloud 虚拟机

OneCloud 提供自研的 kvm 虚拟机私有云管理平台，创建 kvm 虚拟机时需要有相应的宿主机，如果还没有添加 kvm 宿主机，请参考 [安装部署/计算节点](../../../setup/host/) 注册对应的宿主机到云平台。

### VMware ESXI 虚拟机

TODO

### 私有云

私有云和公有云都有自己的认证体系，为了让 OneCloud 能够管理各个云平台，需要把他们的认证信息导入到 OneCloud 平台。

| 平台      | 准备工作 |
|:---------:|:--------:|
| openstack | TODO     |
| zstack    | TODO     |

### 公有云

| 平台   | 准备工作 |
|:-------|---------:|
| 阿里云 | TODO     |
| 腾讯云 | TODO     |
| 华为云 | TODO     |
| AWS    | TODO     |
| Azure  | TODO     |
| UCloud | TODO     |

## 创建机器

创建机器命令为 `server-create`，可以使用 `climc help server-create` 查看创建 server 的所有参数，常用的参数如下：

|     参数名称    |   类型   |                           作用                           |
|:---------------:|:--------:|:--------------------------------------------------------:|
|      --ncpu     |    int   |                      虚拟机 cpu 个数                     |
|      --disk     | []string |   指定创建的系统盘镜像，指定多次表示虚拟机创建多块磁盘   |
|      --net      | []string | 指定虚拟机使用的网络，指定多次将在虚拟机里面添加多个网卡 |
|  --allow-delete |   bool   |                      允许删除虚拟机                      |
|   --auto-start  |   bool   |                      创建完自动启动                      |
|    --password   |  string  |                      设置虚拟机密码                      |
|     --tenant    |  string  |                     创建到指定的项目                     |
| --prefer-region |  string  |                    创建到指定的 region                   |
|  --prefer-zone  |  string  |                     创建到指定的 zone                    |
|  --prefer-host  |  string  |                     创建到指定的 host                    |


**注意以下几点:**

1. 名称、内存或者套餐类型在创建主机时必须使用;
2. 系统盘的镜像通过 `image-list` 或者 `cached-image-list`，公有云的镜像列表通过 `cached-image-list` 接口查询，参考: [查询镜像](../howto/image/query/);

下面以举例的方式创建机器：

### 私有云主机

待创建规格:

| 名称 | 平台     | 套餐    | 内存 | cpu | 系统盘                 | 网络 | 其他                                                                           |
|------|----------|---------|------|-----|------------------------|------|--------------------------------------------------------------------------------|
| vm1  | kvm      | -       | 4g   | 4   | centos7.qcow2 60g      | net1 | 2块数据盘， 一块100g ext4 挂载到 /opt，另外一块 50g xfs 挂载到 /data; 自动启动 |
| vm2  | esxi     | -       | 2g   | 2   | ubuntu18.04.qcow2 100g | net2 | 允许删除                                                                       |
| vm3  | opnstack | t2.nano | -    | -   | centos6.qcow2          | net3 | -                                                                              |

```bash
# 创建 kvm vm1
$ climc server-create --hypervisor kvm --disk centos7.qcow2:60g --disk 100g:ext4:/opt --disk 50g:xfs:/data --ncpu 4 --net net1 --auto-start vm1 4g

# 创建 esxi vm2
$ climc server-create --hypervisor esxi --disk ubuntu18.04.qcow2:100g --net net2 --ncpu 2 --allow-delete vm2 2g

# 创建 openstack vm3
$ climc server-create --hypervisor openstack --disk centos6.qcow2 --net net3 vm3 t2.nano
```

### 公有云主机

创建共有云主机和虚拟机的参数一致，但通常情况下需要通过 `cloud-region-list` 、`zone-list` 和 `vpc-list` 子命令挑选出各个公有云可用的 region, zone 和 network。

然后 server-create 的时候通过 `--prefer-region` 或 `--prefer-zone` 创建到指定的区域，`--net` 创建到指定的 vpc 子网。

```bash
# 查询 aliyun 的可用的 vpc
$ climc vpc-list --provider Aliyun --details
+--------------------------------------+-------------------------------------------+---------+-----------+--------------------------------------+------------+----------------+------------------------+
|                  ID                  |                   Name                    | Enabled |  Status   |            Cloudregion_Id            | Is_default |   Cidr_Block   |         Region         |
+--------------------------------------+-------------------------------------------+---------+-----------+--------------------------------------+------------+----------------+------------------------+
| 6aabd4c5-8a6a-4ffb-83cd-39f924f773b7 | test12                                    | false   | available | 9b0fdc39-701b-44fc-8842-664fe89359f1 | false      | 192.168.0.0/16 | 阿里云 华北2（北京）   |
| 8f4d444f-cce4-4797-8441-e1b58c72ed26 | ali-yunion-bj                             | false   | available | 9b0fdc39-701b-44fc-8842-664fe89359f1 | true       | 172.17.0.0/16  | 阿里云 华北2（北京）   |
| bb8c1ec5-4577-4f84-8117-efab6586b799 | ali-transit-bj                            | false   | available | 9b0fdc39-701b-44fc-8842-664fe89359f1 | false      | 10.0.0.0/8     | 阿里云 华北2（北京）   |
| c4e1a012-5f2a-48fc-80ef-4ac0371006eb | hello                                     | false   | available | dbbfea2f-8bf4-4676-8036-4ad6f6e6b1ea | false      | 10.0.0.0/8     | 阿里云 阿联酋（迪拜）  |
...

# 查询 vpc 6aabd4c5-8a6a-4ffb-83cd-39f924f773b7 下可用的 network
$ climc network-list --vpc 6aabd4c5-8a6a-4ffb-83cd-39f924f773b7
+--------------------------------------+------------+----------------+-----------------+---------------+--------------------------------------+-----------+--------------+-----------------+-------------+-----------+
|                  ID                  |    Name    | Guest_ip_start |  Guest_ip_end   | Guest_ip_mask |               wire_id                | is_public | public_scope |  guest_gateway  | server_type |  Status   |
+--------------------------------------+------------+----------------+-----------------+---------------+--------------------------------------+-----------+--------------+-----------------+-------------+-----------+
| b3dee5e6-0dce-403c-80b2-ad62880b662f | esrdfsfsd  | 192.168.0.1    | 192.168.127.252 | 17            | a421934d-9cb4-4163-85b9-ad0038e9cb89 | true      | system       | 192.168.127.254 | guest       | available |
| d131de82-1be5-4f70-8b22-2303f4f409bb | sdfsdfdsff | 192.168.128.1  | 192.168.255.252 | 17            | 8ccdbe42-0c62-456f-842d-bc279a5c2786 | true      | system       | 192.168.255.254 | guest       | available |
+--------------------------------------+------------+----------------+-----------------+---------------+--------------------------------------+-----------+--------------+-----------------+-------------+-----------+

# 查询 region 9b0fdc39-701b-44fc-8842-664fe89359f1 下可用的 sku
$ climc server-sku-list --region 9b0fdc39-701b-44fc-8842-664fe89359f1 --provider Aliyun

# 创建 ecs.t5-lc2m1.nano aliyun vm4 虚拟机到 region 9b0fdc39-701b-44fc-8842-664fe89359f1 的子网 b3dee5e6-0dce-403c-80b2-ad62880b662f
$ climc server-create --prefer-region 9b0fdc39-701b-44fc-8842-664fe89359f1 vm4 --hypervisor aliyun --net b3dee5e6-0dce-403c-80b2-ad62880b662f vm4 ecs.t5-lc2m1.nano
```
