---
title: "操作相关"
date: 2019-07-19T20:25:05+08:00
weight: 10
---

### 查询物理机

```bash
# list baremetal 记录
climc host-list --baremetal true

# list 已经安装系统的物理机
climc host-list --baremetal true --occupied

# list 未安装系统的物理机
climc host-list --baremetal true --empty

# 查询物理机详情，包括硬件信息，机房信息
climc host-show <host_id>
```

### 注册物理机

```bash
climc host-create <host_id>
```

### 重新准备物理机

```bash
climc host-prepare <host_id>
```

### 获取物理机登录信息

```bash
climc host-logininfo <host_id>
```

### 获取串口登录控制台

```bash
climc webconsole-baremetal <host_id>
```

### 开/关机

```bash
climc host-start/host-stop <host_id>
```

### 进入/退出维护模式

```bash
climc host-maintenance/host-unmaintenance <host_id>
```

### 删除物理机

```bash
climc host-delete <host_id>
```

### 转换/回收宿主机

```bash
climc host-convert-hypervisor
climc host-undo-convert <host_id>
```

## 裸金属服务器相关

### 安装操作系统

```bash
climc server-create \
    --hypervisor baremetal \ # 指定 server 的类型为 baremetal
    --ncpu 24 \ # 创建到 24 核 cpu 的物理机
    --raid-config 'raid1:2:MegaRaid' \ # 第1块盘，使用 MegaRaid 控制器上的(0-1)号两块物理盘做 raid1
    --raid-config 'none:1' \ # 第2块盘，使用 MegaRaid 控制器上的(2)号物理盘，不做 raid
    --raid-config 'raid10:4:MegaRaid' \ # 第3快盘, 使用 MegaRaid 控制器上的(3-6)号四块物理盘做raid10
    --disk CentOS-7.5.qcow2:100g \ # 系统盘使用 CentOS-7.5.qcow2 镜像作为操作系统，大小为 100g，使用第1块 raid1 的盘
    --disk 'autoextend:ext4:/opt' \ # 分区挂载到 /opt, 使用第1块 raid1 的盘，文件系统为 ext4, 大小为(第一块盘总大小 - 该盘其他分区的大小(100g))
    --disk 'autoextend:xfs:/data-nonraid' \ # 分区挂载到 /data-nonraid, 使用第2块没做 raid 的盘, 文件系统为 xfs，使用所有空间
    --disk 'autoextend:ext4:/data-raid10' \ # 分区挂载到 /data-raid10, 使用第3块 raid10 的盘，文件系统为 ext4, 使用所有空间
    <server_name> \ # 裸金属服务器名称
    64g # 创建到 64g 内存大小的物理机
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

### 查询裸金属服务器

```bash
climc server-list --hypervisor baremetal
climc server-show <server_id>
```

### 重装操作系统

```bash
climc server-rebuild --image <image_id> <server_id>
```

### 开/关机

```bash
climc server-start <server_id>
climc server-stop <server_id>
```

### 删除裸金属服务器

删除 server 裸金属服务器会销毁物理机上的操作系统和 raid 配置，对应的 baremetal 重新进入未分配状态

```bash
climc server-delete <server_id>
```
