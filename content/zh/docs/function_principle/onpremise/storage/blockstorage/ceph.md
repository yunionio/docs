---
title: "Ceph存储"
weight: 1000
description: >
  如何配置和使用Ceph存储
---

Ceph是著名的开源分布式存储，一个存储集群可以同时提供块存储（RBD），对象存储（RadosGw）和文件存储（CephFs）三种存储接口。本文介绍虚拟机使用Ceph RBD块存储的配置和使用方法。

## 支持Ceph版本

平台通过调用部署在宿主机的 ceph 命令来访问Ceph存储。

平台部署一台宿主机时，会默认安装开源版本的 ceph-common，其中包含了 ceph 的客户端。

各个Linux发行版安装的 ceph-common 版本如下：

* CentOS 7: 10.2.5
* CentOS 8: 12.2.8
* Kylin V10: 12.2.8
* Debian 10: 12.2.11
* Debian 11: 14.2.21
* OpenEuler 22.03 SP1: 16.2.7

如果用户需要其他版本的 ceph-common，或者用户希望使用商用的ceph，则需要自行手动在宿主机安装对应版本的 ceph-common。

由于这个机制，导致如下的限制：同一台宿主机只能对接一个版本的Ceph存储。

## Ceph的对接配置

### 网络要求

挂载使用Ceph存储的宿主机需要能够直接网络访问Ceph集群。

### 配置参数

需要准备如下配置参数：

| 参数                   | 是否可选 | 说明                                     |
|-----------------------|---------|-----------------------------------------|
| RbdMonHost            | 必填     | Ceph集群的monitor服务的IP地址，多个以,号分隔 | 
| RbdPool               | 必填     | Ceph Pool名称，一个Pool对应一个Ceph存储实例  |
| RbdKey                | 可选     | Ceph认证key                              |
| RbdRadosMonOpTimeout  | 可选     | 访问Ceph Monitor的超时时间（秒）            |
| RbdRadosOsdOpTimeout  | 可选     | 访问Ceph OSD的超时时间（秒）                |
| RbdClientMountTimeout | 可选     | 客户端挂载Ceph RBD设备的超时时间（秒）        |

## Ceph访问凭证

每次在宿主机执行ceph的命令，如果该存储配置了rbd_key参数，则会使用rbd_key秘钥生成临时ceph凭证文件，用于访问ceph存储。不会使用保存在宿主机/etc/ceph的凭证文件。

## Ceph容量的识别

平台对接一个Ceph RBD存储后，会周期性从Ceph拉取存储的容量信息。

Ceph存储的容量信息通过 ceph df 的命令获取：

```bash
# ceph df
RAW STORAGE:
    CLASS     SIZE       AVAIL      USED       RAW USED     %RAW USED
    hdd       31 TiB     21 TiB     10 TiB       10 TiB         32.72
    TOTAL     31 TiB     21 TiB     10 TiB       10 TiB         32.72

POOLS:
    POOL               ID     PGS     STORED      OBJECTS     USED       %USED     MAX AVAIL
    cloudpods-test      1     128     5.0 TiB       1.54M     10 TiB     31.62        11 TiB
```

存储的总容量为对应Pool的 STORED + MAX AVAIL，使用量为对应 Pool 的 STORED