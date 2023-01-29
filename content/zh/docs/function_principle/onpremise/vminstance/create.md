---
title: "新建本地IDC虚拟机"
weight: 1
date: 2019-07-19T15:22:33+08:00
description: >
  介绍如何在本地IDC环境中新建虚拟机。
---

### 前提条件

- 如需创建内置私有云虚拟机，请确保环境中存在启用状态的宿主机。
- 如需创建VMware平台虚拟机，请确保环境中已添加了VMware账号。

### climc操作

`climc server-create` 命令提供创建云主机的操作。 {{<oem_name>}} 可以同时管理多个私有云和公有云，不同供应商有各自的认证方式，在创建云主机之前需要做一些不同的准备工作。


创建机器命令为 `server-create`，可以使用 `climc server-create --help` 查看创建 server 的所有参数，常用的参数如下：

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


{{% alert title="注意" color="warning" %}}
1. 名称、内存或者套餐类型在创建主机时必须使用;
2. 系统盘的镜像通过 `image-list` 或者 `cached-image-list`，公有云的镜像列表通过 `cached-image-list` 接口查询，参考: [查询镜像](../../../../function_principle/onpremise/glance/sysimage/show/#查询镜像);
{{% /alert %}}



下面以举例的方式创建机器：

待创建规格:

| 名称 | 平台     | 套餐    | 内存 | cpu | 系统盘                 | 网络 | 其他                                                                           |
|------|----------|---------|------|-----|------------------------|------|--------------------------------------------------------------------------------|
| vm1  | kvm      | -       | 4g   | 4   | centos7.qcow2 60g      | net1 | 2块数据盘， 一块100g ext4 挂载到 /opt，另外一块 50g xfs 挂载到 /data; 自动启动 |
| vm2  | esxi     | -       | 2g   | 2   | ubuntu18.04.qcow2 100g | net2 | 允许删除                                                                       |
| vm3  | opnstack | t2.nano | -    | -   | centos6.qcow2          | net3 | -                                                                              |

```bash
# 创建 kvm vm1
$ climc server-create --hypervisor kvm --disk centos7.qcow2:60g --disk 100g:ext4:/opt --disk 50g:xfs:/data --ncpu 4 --net net1 --auto-start vm1 --mem-spec 4g

```


### 主机名表达式举例说明

主机（包括虚拟机和裸金属）名称支持表达式，表达式格式为：${变量名}，变量名需要小写。如${host}，则虚拟机名称显示为创建虚拟机的宿主机的名称；${region}-${zone}，则显示为区域名-可用区名称等。

支持的变量名如下：

变量名| 举例| 说明
---------|----------|---------
 brand | aliyun | 品牌
 charge_type | postpaid | 计费方式
 cloud_env | onpremise/public/private | 用于区分本地IDC、私有云和公有云平台
 cloudregion_id | default | 区域id
 cpu | 1 | CPU数量
 host | gobuild | 主机名
 host_id | 16f49f8a-88cc-4715-8870-f78130196fa9| 主机id
 ip_addr | 192.168.1.1 | IP地址
 mem | 1024 | 内存
 os_distribution	 | 操作系统 | CentOS
 os_type | Linux | 操作系统类型
 os_version | 6.9 | 操作系统版本
 owner_tenant	 | system | 项目
 owner_tenant_id | d56f5c37e36a42b782d7f32b19497c4c | 项目id
 provider | OpenStack | 提供方
 region | Default | 区域
 region_id | kvm | 虚拟化方式
 res_name | server | 资源类别
 template_id | 5199f56b-01c2-425c-8e29-0179d283e4a3| 模板id
 zone | zone1 | 可用区
 zone_id | 00f3f3c6-1d16-4053-81f1-4cb092f418f5| 可用区id



