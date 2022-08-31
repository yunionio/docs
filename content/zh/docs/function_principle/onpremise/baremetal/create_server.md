---
title: "安装操作系统/新建裸金属"
weight: 2
description: >
  介绍如何在平台已有的物理机上安装操作系统创建裸金属。
---

目前平台支持通过两个入口创建裸金属。

- 在物理机页面安装操作系统即可基于当前物理机创建裸金属。
- 在裸金属页面新建裸金属，并通过规格筛选出对应的物理机新建裸金属。

## climc操作

### 安装操作系统

```bash
climc server-create \
    --hypervisor baremetal \ # 指定 server 的类型为 baremetal
    --ncpu 24 \ # 创建到 24 核 cpu 的物理机
    --mem-spec 64g \ # 创建到 64g 内存大小的物理机
    --net 'bms-net' \ # 创建到 bms-net 的网络下
    --raid-config 'raid1:2:MegaRaid' \ # 第1块盘，使用 MegaRaid 控制器上的(0-1)号两块物理盘做 raid1
    --raid-config 'none:1' \ # 第2块盘，使用 MegaRaid 控制器上的(2)号物理盘，不做 raid
    --raid-config 'raid10:4:MegaRaid' \ # 第3快盘, 使用 MegaRaid 控制器上的(3-6)号四块物理盘做raid10
    --disk CentOS-7.5.qcow2:100g \ # 系统盘使用 CentOS-7.5.qcow2 镜像作为操作系统，大小为 100g，使用第1块 raid1 的盘
    --disk 'autoextend:ext4:/opt' \ # 分区挂载到 /opt, 使用第1块 raid1 的盘，文件系统为 ext4, 大小为(第一块盘总大小 - 该盘其他分区的大小(100g))
    --disk 'autoextend:xfs:/data-nonraid' \ # 分区挂载到 /data-nonraid, 使用第2块没做 raid 的盘, 文件系统为 xfs，使用所有空间
    --disk 'autoextend:ext4:/data-raid10' \ # 分区挂载到 /data-raid10, 使用第3块 raid10 的盘，文件系统为 ext4, 使用所有空间
    <server_name> # 裸金属服务器名称

# 另外可以通过参数 `--prefer-host $baremetal-hostname` 创建到指定的物理机
```

#### raid 配置和分区

调用 server-create 接口时通过 '--raid-config' 传递参数来配置 raid，每个 raid-config 对应到操作系统可见的磁盘设备(/dev/sdx)。

'--disk' 参数对应不同磁盘上的分区，分区对应到磁盘的逻辑为: 分区按照顺序创建到第1块磁盘上，当 disk 设置 autoextend 参数后，表示接下来的 disk 分区会创建到下一个磁盘，以此类推。

- raid 配置 API 参数:

| Key                          | Type   | value                                           | 解释                                 |
|------------------------------|--------|-------------------------------------------------|--------------------------------------|
| type(磁盘类型)               | string | rotate(机械盘), ssd(固态盘), hybrid(未知)       | -                                    |
| conf (raid)                  | string | none, raid0, raid1, raid5, raid10               | 做raid几或者不做                     |
| count (磁盘数量)             | int    | e.g. 0, 2, 4                                    | 小于等于物理机实际的盘数             |
| range (磁盘范围)             | []int  | e.g. [0,1,2,3], [4,7], [5,6]                    | 物理磁盘在控制器上的索引号           |
| splits (切割物理盘)          | string | (30%,20%,), (300g,100g,)                        | 做好 raid 的物理盘再切割为多块物理盘 |
| adapter (控制器号)           | int    | 0, 1                                            | 对应driver的 Adapter 控制器          |
| driver  (控制器名称)         | string | MegaRaid,HPSARaid,Mpt2SAS,MarvelRaid,Linux,PCIE | 1台物理机上有多个控制器时用于选择盘  |
| strip  (设置raid strip 大小) | *int   | e.g. 64*1024                                    | 设置strip size, 可选                 |
| ra                           | *bool  |                                                 | 设置读模式                           |
| wt                           |        |                                                 | 设置写模式                           |
| cachedbadbbu                 | *bool  |                                                 |                                      |
| direct                       | *bool  |                                                 |                                      |

- 命令行格式:

    '(none,raid0,raid1,raid5,raid10):%d:(MegaRaid|HPSARaid|Mpt2SAS|MarvelRaid|Linux|PCIE):(rotate|ssd|hybrid):[0-n]:strip%dk:adapter%d:ra:nora:wt:wb:direct:cachedbadbbu:nocachedbadbbu'
