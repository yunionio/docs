---
title: "性能测试"
date: 2019-07-19T17:38:36+08:00
weight: 50
description: >
  测试 var_oem_name 内置私有云虚拟机的性能
---

### CPU和内存性能测试

#### 测试环境

操作系统: CentOS 7
云平台版本: >= v3.7.7
宿主机: Dell PowerEdge R730xd
    - CPU: Intel(R) Xeon(R) CPU E5-2678 v3 @ 2.50GHz
    - 内存: DDR4 2133 MHz 256GB (16GB x 16)
    - 磁盘: 机械盘 20TB PERC H730P Mini (RAID 10)
    - 网卡: 10000Mb/s

#### 安装测试软件

测试工具:

- UnixBench: 测试虚拟机CPU性能
- mbw: 测试内存性能

```bash
# 安装 UnixBench
$ yum install -y git gcc autoconf gcc-c++ time perl-Time-HiRes
$ git clone https://github.com/kdlucas/byte-unixbench.git

# 安装 mbw
$ git clone https://github.com/raas/mbw.git && cd mbw
$ make && ./mbw 512
```

#### CPU 测试

测试命令:

```bash
$ cd byte-unixbench/UnixBench
$ ./Run -c 1 whetstone-double dhry2reg fsdisk
```

结论:

| 指标                       | 物理机         | 虚拟机         | 虚拟化开销（物理机-虚拟机/ 物理机） |
|----------------------------|----------------|----------------|-------------------------------------|
| Dhrystone                  | 34839728.4 lps | 33964545.0 lps | 2.5%                                |
| Double-Precision Whetstone | 4368.3 MWIPS   | 4244.3 MWIPS   | 2.8%                                |
| File Copy                  | 1825548.4 KBps | 1788048.3 KBps | 2.1%                                |

#### 内存测试

结论:

| 指标       | 物理机         | 虚拟机         | 虚拟化开销（物理机-虚拟机/物理机） |
|------------|----------------|----------------|------------------------------------|
| MEMCPY AVG | 7578.348 MiB/s | 6254.520 MiB/s | 1.7%                               |


### 本地存储IO测试

#### 测试方法

采用fio，分别用如下场景和命令测试：

* 4KB随机读

```bash
fio --name=random-read --ioengine=posixaio --rw=randread --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1
```

* 4KB随机写

```bash
fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1
```

* 4K顺序读

```bash
fio --name=random-read --ioengine=posixaio --rw=read --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1
```

* 4K顺序写

```bash
fio --name=random-write --ioengine=posixaio --rw=write --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1
```

* 1MB顺序读

```bash
fio --name=seq-read --ioengine=posixaio --rw=read --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1
```

* 1MB顺序写

```bash
fio --name=seq-write --ioengine=posixaio --rw=write --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1 --end_fsync=1
```

#### 测试环境

* 物理机

    OS: CentOS Linux release 7.9.2009 (Core)
    内核：3.10.0-1062.4.3.el7.yn20191203.x86_64
    CPU: Intel(R) Xeon(R) CPU E5-2678 v3 @ 2.50GHz
    内存：256G
    RAID控制器：Broadcom / LSI MegaRAID SAS-3 3108
    RAID Level: RAID10

* Linxu 虚拟机

    OS: CentOS Linux release 7.6.1810 (Core)
    内核：3.10.0-957.12.1.el7.x86_64
    配置：4核CPU4G内存30G系统盘100G数据盘

* Windows 虚拟机

    OS: Windows Server 2008 R2 Datacenter 6.1
    配置：4核CPU4G内存40G系统盘100G数据盘
 
#### 测试结果

| 场景                       | 4KB      | 随机读     | 4KB    | 随机写     | 4KB    | 顺序读     | 4KB    | 顺序写     | 1MB    | 顺序读     | 1MB    |顺序写      | 
|----------------------------|---------:|:-----------|-------:|:-----------|-------:|:-----------|-------:|:-----------|-------:|:-----------|-------:|:-----------|
|                            | IOPS     | Throughput | IOPS   | Throughput | IOPS   | Throughput | IOPS   | Throughput | IOPS   | Throughput | IOPS   | Throughput |
| 物理机                     | 195      | 782KiB/s   | 7349   | 28.7MiB/s  | 22.1k  | 86.3MiB/s  | 24.5k  | 95.8MiB/s  | 1055   | 1056MiB/s  | 1117   | 1118MiB/s  |
|                            | (100%)   | (100%)     | (100%) | (100%)     | (100%) | (100%)     | (100%) | (100%)     | (100%) | (100%)     | (100%) | (100%)     |
| Linux 虚拟机               | 245      | 981KiB/s   | 6096   | 23.8MiB/s  | 9458   | 36.9MiB/s  | 6278   | 24.5MiB/s  | 979    | 980MiB/s   | 1058   | 1059MiB/s  |
| (cache=none)               | (126%)   | (125%)     | (83%)  | (83%)      | (43%)  | (43%)      | (26%)  | (26%)      | (93%)  | (93%)      | (95%)  | (95%)      |
| Linux 虚拟机               | 243      | 973KiB/s   | 7483   | 29.2MiB/s  | 11.5k  | 44.9MiB/s  | 7271   | 28.4MiB/s  | 958    | 959MiB/s   | 1052   | 1052MiB/s  |
| (cache=none,queues=4)      | (125%)   | (124%)     | (102%) | (102%)     | (52%)  | (52%)      | (30%)  | (30%)      | (91%)  | (91%)      | (94%)  | (94%)      |
| Linux 虚拟机               | 13.0k    | 54.5MiB/s  | 8360   | 32.7MiB/s  | 13.1k  | 51.3MiB/s  | 8976   | 35.1MiB/s  | 2550   | 2551MiB/s  | 1045   | 1046MiB/s  |
| (cache=writeback)          | (6667%)  | (6969%)    | (114%) | (114%)     | (59%)  | (59%)      | (37%)  | (37%)      | (242%) | (242%)     | (94%)  | (94%)      |
| Linux 虚拟机               | 28.7k    | 112MiB/s   | 12.2k  | 47.5MiB/s  | 29.6k  | 116MiB/s   | 11.2k  | 43.8MiB/s  | 2931   | 2932MiB/s  | 1220   | 1220MiB/s  |
| (cache=writeback,queues=4) | (14718%) | (14322%)   | (166%) | (166%)     | (134%) | (134%)     | (46%)  | (46%)      | (278%) | (278%)     | (109%) | (109%)     |
| Windows 虚拟机             | 2811     | 11.0MiB/s  | 6002   | 23.4MiB/s  | 11.8k  | 46.1MiB/s  | 4289   | 16.8MiB/s  | 1009   | 1009MiB/s  | 685    | 686MiB/s   |
| (cache=none)               | (1441%)  | (1407%)    | (82%)  | (82%)      | (53%)  | (53%)      | (18%)  | (18%)      | (96%)  | (96%)      | (61%)  | (61%)      |
| Windows 虚拟机             | 2794     | 10.9MiB/s  | 7448   | 29.1MiB/s  | 21.1k  | 82.6MiB/s  | 25.5k  | 99.7MiB/s  | 930    | 930MiB/s   | 1013   | 1014MiB/s  |
| (cache=none,queues=4)      | (1432%)  | (1394%)    | (101%) | (101%)     | (95%)  | (96%)      | (104%) | (104%)     | (88%)  | (88%)      | (91%)  | (91%)      |
| Windows 虚拟机             | 2483     | 9935KiB/s  | 7430   | 29.0MiB/s  | 10.9k  | 42.8MiB/s  | 13.6k  | 53.0MiB/s  | 1993   | 1994MiB/s  | 920    | 920MiB/s   |
| (cache=writeback)          | (1273%)  | (1270%)    | (101%) | (101%)     | (49%)  | (50%)      | (56%)  | (55%)      | (189%) | (189%)     | (82%)  | (82%)      |
| Windows 虚拟机             | 4520     | 17.7MiB/s  | 18.8k  | 73.6MiB/s  | 23.3k  | 90.8MiB/s  | 21.8k  | 85.1MiB/s  | 2628   | 2628MiB/s  | 1191   | 1192MiB/s  |
| (cache=writeback,queues=4) | (2317%)  | (2263%)    | (2558%) | (2564%)   | (105%) | (105%)     | (89%)  | (89%)      | (249%) | (249%)     | (106%) | (106%)     |

#### 测试结论

1. 和物理机相比，在4KB随机读写，1MB顺序读写方面，有10%左右的虚拟化开销。可以认为虚拟机性能和物理机相当。由于缓存的作用，虚拟机性能在某些场景甚至超过物理机。
2. 开启writeback和多队列之后，写性能有明显加速
3. 在4KB顺序读写性能方面，虚拟机仅有物理机的一半性能。这是因为磁盘采用thin provision方式，虚拟机内的顺序读写转换到物理机其实是随机读写。为了改善虚拟机4KB顺序读写性能，需要将虚拟磁盘文件进行预分配。这样虚拟机内的顺序读写在物理机也是顺序读写。

### 共享存储(ceph)IO性能测试

#### 测试环境

1、宿主机配置：

    OS: CentOS Linux release 7.9.2009 (Core)
    内核：3.10.0-1062.4.3.el7.yn20191203.x86_64
    CPU: Intel(R) Xeon(R) CPU E5-2678 v3 @ 2.50GHz
    内存：256GB

2、虚拟机配置：

    OS: CentOS Linux release 7.6.1810 (Core)
    内核：3.10.0-957.12.1.el7.x86_64
    配置：4核CPU4G内存30G系统盘100G数据盘

3、Ceph存储配置

    网卡：2x10G双光口存储网 + 2x10G双光口接入网
    磁盘：全闪SSD

#### 测试数据

| 场景                     | 4KB      | 随机读    | 4KB   | 随机写    | 4KB  | 顺序读    | 4KB   | 顺序写    | 1MB | 顺序读   | 1MB | 顺序写   |
|--------------------------|---------:|:----------|------:|:----------|-----:|:----------|------:|:----------|----:|:---------|----:|:---------|
|                            | IOPS     | Throughput | IOPS   | Throughput | IOPS   | Throughput | IOPS   | Throughput | IOPS   | Throughput | IOPS   | Throughput |
| cache=none               | 1054     | 4217KiB/s |  405  | 1622KiB/s | 1864 | 7456KiB/s | 552   | 2209KiB/s | 159 | 159MiB/s | 163 | 164MiB/s |
| cache=none,queues=4      | 1152     | 4608KiB/s | 441   | 1767KiB/s | 2066 | 8265KiB/s | 368   | 1472KiB/s | 168 | 169MiB/s | 168 | 168MiB/s |
| cache=writeback          | 978      | 3913KiB/s | 9425  | 36.8MiB/s | 1623 | 6494KiB/s | 10.7k | 41.7MiB/s | 149 | 149MiB/s | 474 | 474MiB/s |
| cache=writeback,queues=4 | 1071     | 4284KiB/s | 12.6k | 49.3MiB/s | 1711 | 6848KiB/s | 15.1k | 59.1MiB/s | 161 | 161MiB/s | 475 | 475MiB/s |

#### 测试结论

1. 开启writeback和多队列能够明显提升写性能
2. 读性能比较难优化，可以调高虚拟机内的 read ahead 缓存（blockdev --setra /dev/sda）
3. Ceph并未把网络打满，也未能用满SSD的性能，性能瓶颈感觉还是在软件层面

### 网络测试

#### 测试条件

1) 默认情况下虚拟机有流量限制，需要在前端或者用命令行工具 `climc server-change-bandwidth` 把带宽改为 0 ，表示取消限速。

2) 默认情况下，VPC虚拟机的EIP也有带宽限制（默认30Mbps），也需要在前端，或者用climc修改限制为0，表示取消限制。

#### 测试方法:

```bash
# 找一台机器运行 iperf server 模式，假设 ip 是 10.127.100.3
$ iperf3 -s --bind 10.127.100.3

# 在另外一台机器作为 iperf client 模式连接 server
$ iperf3 -c 10.127.100.3 -t 30
```

以上重复执行三次，取最好的一次。

#### 经典网络性能测试

##### 环境

1、宿主机配置：

    OS: CentOS Linux release 7.9.2009 (Core)
    内核：3.10.0-1062.4.3.el7.yn20191203.x86_64
    CPU: Intel(R) Xeon(R) CPU E5-2678 v3 @ 2.50GHz
    内存：256GB

2、虚拟机配置：

    OS: CentOS Linux release 7.6.1810 (Core)
    内核：3.10.0-957.12.1.el7.x86_64
    配置：2核CPU 2G内存 30G系统盘

##### 结论

| 源 \ 目的 | 物理机           | 虚拟机            |
|-----------|------------------|-------------------|
| 物理机    | 8.35 Gbps (100%) | 8.40 Gbps (101%)  |
| 虚拟机    | 8.41 Gbps (101%) | 8.33 Gbps (99.7%) |

说明：饱和流量测试，网路虚拟化开销很低（1%量级）。

#### VPC网络性能测试

##### 测试环境

1、宿主机配置：

    OS: CentOS Linux release 7.7.1908 (Core)
    内核：5.4.130-1.yn20210710.el7.x86_64
    CPU: Intel(R) Xeon(R) Gold 5218R CPU @ 2.10GHz
    内存：256GB

2、虚拟机配置：

    OS: CentOS Linux release 7.8.2003
    内核：3.10.0-1127.el7.x86_64
    配置：2核CPU 2G内存 30G系统盘

##### 结论

| 场景        | 物理机到物理机 | 虚拟机到虚拟机 | 虚拟机EIP到虚拟机EIP |
|-------------|----------------|----------------|----------------------|
| 性能 (Gbps) | 9.19 (100%)    | 8.96 (97%)     | 5.83 (63%)           |

说明：饱和流量情况下，网络虚拟化开销很低（3%量级）。由于转换路径较长，EIP的性能要差很多（36%损耗）。
