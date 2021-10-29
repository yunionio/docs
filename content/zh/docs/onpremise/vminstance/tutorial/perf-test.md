---
title: "虚拟机性能测试"
date: 2019-07-19T17:38:36+08:00
weight: 50
description: >
  测试内置私有云虚拟机的性能。
---

## 测试环境

操作系统: CentOS 7
云平台版本: >= v3.7.7
宿主机: Dell PowerEdge R730xd
    - CPU: Intel(R) Xeon(R) CPU E5-2678 v3 @ 2.50GHz
    - 内存: DDR4 2133 MHz 256GB (16GB x 16)
    - 磁盘: 机械盘 20TB PERC H730P Mini (RAID 10)
    - 网卡: 10000Mb/s

## 安装测试软件

测试工具:

- UnixBench: 测试虚拟机CPU性能
- mbw: 测试内存性能
- fio: 测试 IO 性能
- iperf3: 测试网络性能

```bash
# 安装 UnixBench
$ yum install -y git gcc autoconf gcc-c++ time perl-Time-HiRes
$ git clone https://github.com/kdlucas/byte-unixbench.git

# 安装 mbw
$ git clone https://github.com/raas/mbw.git && cd mbw
$ make && ./mbw 512

# 安装 iperf 和 fio
$ yum  -y install iperf fio
```

## 性能测试

### CPU 测试

结论:

| 指标                       | 物理机         | 虚拟机         | 虚拟化开销（物理机-虚拟机/ 物理机） |
|----------------------------|----------------|----------------|-------------------------------------|
| Dhrystone                  | 34839728.4 lps | 33964545.0 lps | 2.5%                                |
| Double-Precision Whetstone | 4368.3 MWIPS   | 4244.3 MWIPS   | 2.8%                                |
| File Copy                  | 1825548.4 KBps | 1788048.3 KBps | 2.1%                                |


测试命令:

```bash
$ cd byte-unixbench/UnixBench
$ ./Run -c 1 whetstone-double dhry2reg fsdisk
```
输出结果:

- 物理机:

```bash
Benchmark Run: Mon Aug 09 2021 17:19:07 - 17:48:22
48 CPUs in system; running 1 parallel copy of tests
 
Dhrystone 2 using register variables       34839728.4 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     4368.3 MWIPS (8.8 s, 7 samples)
Execl Throughput                               1291.3 lps   (29.1 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        517296.7 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          139166.0 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks       1825548.4 KBps  (30.0 s, 2 samples)
Pipe Throughput                              670895.6 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                 111871.6 lps   (10.0 s, 7 samples)
Process Creation                               3276.8 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   3604.5 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   2900.6 lpm   (60.0 s, 2 samples)
System Call Overhead                         476273.4 lps   (10.0 s, 7 samples)
```

- 虚拟机:

```bash
Benchmark Run: Mon Aug 09 2021 10:03:04 - 10:31:06
8 CPUs in system; running 1 parallel copy of tests
 
Dhrystone 2 using register variables       33964545.0 lps   (10.0 s, 7 samples)
Double-Precision Whetstone                     4244.3 MWIPS (9.9 s, 7 samples)
Execl Throughput                               2348.2 lps   (30.0 s, 2 samples)
File Copy 1024 bufsize 2000 maxblocks        644436.7 KBps  (30.0 s, 2 samples)
File Copy 256 bufsize 500 maxblocks          169199.0 KBps  (30.0 s, 2 samples)
File Copy 4096 bufsize 8000 maxblocks       1788048.3 KBps  (30.0 s, 2 samples)
Pipe Throughput                              933768.1 lps   (10.0 s, 7 samples)
Pipe-based Context Switching                 139898.5 lps   (10.0 s, 7 samples)
Process Creation                               5991.6 lps   (30.0 s, 2 samples)
Shell Scripts (1 concurrent)                   5698.6 lpm   (60.0 s, 2 samples)
Shell Scripts (8 concurrent)                   2662.4 lpm   (60.0 s, 2 samples)
System Call Overhead                         920352.7 lps   (10.0 s, 7 samples)
```

### 内存测试

结论:

| 指标       | 物理机         | 虚拟机         | 虚拟化开销（物理机-虚拟机/物理机） |
|------------|----------------|----------------|------------------------------------|
| MEMCPY AVG | 7578.348 MiB/s | 6254.520 MiB/s | 1.7%                               |

输出结果：

- 物理机：

```bash
[root@baremetal-test mbw]# ./mbw 512
Long uses 8 bytes. Allocating 2*67108864 elements = 1073741824 bytes of memory.
Using 262144 bytes as blocks for memcpy block copy test.
Getting down to business... Doing 10 runs per test.
0       Method: MEMCPY  Elapsed: 0.07964        MiB: 512.00000  Copy: 6429.172 MiB/s
1       Method: MEMCPY  Elapsed: 0.06827        MiB: 512.00000  Copy: 7500.183 MiB/s
2       Method: MEMCPY  Elapsed: 0.06628        MiB: 512.00000  Copy: 7724.338 MiB/s
3       Method: MEMCPY  Elapsed: 0.06668        MiB: 512.00000  Copy: 7677.889 MiB/s
4       Method: MEMCPY  Elapsed: 0.06568        MiB: 512.00000  Copy: 7795.253 MiB/s
5       Method: MEMCPY  Elapsed: 0.06569        MiB: 512.00000  Copy: 7794.541 MiB/s
6       Method: MEMCPY  Elapsed: 0.06578        MiB: 512.00000  Copy: 7783.994 MiB/s
7       Method: MEMCPY  Elapsed: 0.06656        MiB: 512.00000  Copy: 7692.539 MiB/s
8       Method: MEMCPY  Elapsed: 0.06555        MiB: 512.00000  Copy: 7811.189 MiB/s
9       Method: MEMCPY  Elapsed: 0.06549        MiB: 512.00000  Copy: 7818.107 MiB/s
AVG     Method: MEMCPY  Elapsed: 0.06756        MiB: 512.00000  Copy: 7578.348 MiB/s
0       Method: DUMB    Elapsed: 0.17209        MiB: 512.00000  Copy: 2975.239 MiB/s
1       Method: DUMB    Elapsed: 0.17363        MiB: 512.00000  Copy: 2948.833 MiB/s
2       Method: DUMB    Elapsed: 0.16853        MiB: 512.00000  Copy: 3038.053 MiB/s
3       Method: DUMB    Elapsed: 0.17081        MiB: 512.00000  Copy: 2997.447 MiB/s
4       Method: DUMB    Elapsed: 0.17639        MiB: 512.00000  Copy: 2902.642 MiB/s
5       Method: DUMB    Elapsed: 0.16661        MiB: 512.00000  Copy: 3073.137 MiB/s
6       Method: DUMB    Elapsed: 0.17822        MiB: 512.00000  Copy: 2872.773 MiB/s
7       Method: DUMB    Elapsed: 0.16628        MiB: 512.00000  Copy: 3079.181 MiB/s
8       Method: DUMB    Elapsed: 0.16490        MiB: 512.00000  Copy: 3104.818 MiB/s
9       Method: DUMB    Elapsed: 0.17354        MiB: 512.00000  Copy: 2950.345 MiB/s
AVG     Method: DUMB    Elapsed: 0.17110        MiB: 512.00000  Copy: 2992.404 MiB/s
0       Method: MCBLOCK Elapsed: 0.09400        MiB: 512.00000  Copy: 5447.040 MiB/s
1       Method: MCBLOCK Elapsed: 0.09566        MiB: 512.00000  Copy: 5352.177 MiB/s
2       Method: MCBLOCK Elapsed: 0.09422        MiB: 512.00000  Copy: 5434.321 MiB/s
3       Method: MCBLOCK Elapsed: 0.09393        MiB: 512.00000  Copy: 5450.926 MiB/s
4       Method: MCBLOCK Elapsed: 0.09398        MiB: 512.00000  Copy: 5447.678 MiB/s
5       Method: MCBLOCK Elapsed: 0.09439        MiB: 512.00000  Copy: 5424.533 MiB/s
6       Method: MCBLOCK Elapsed: 0.09482        MiB: 512.00000  Copy: 5399.933 MiB/s
7       Method: MCBLOCK Elapsed: 0.09395        MiB: 512.00000  Copy: 5449.533 MiB/s
8       Method: MCBLOCK Elapsed: 0.09476        MiB: 512.00000  Copy: 5402.953 MiB/s
9       Method: MCBLOCK Elapsed: 0.09401        MiB: 512.00000  Copy: 5446.403 MiB/s
AVG     Method: MCBLOCK Elapsed: 0.09437        MiB: 512.00000  Copy: 5425.378 MiB/s
```

- 虚拟机:

```bash
[root@guest-test mbw]# ./mbw 512
Long uses 8 bytes. Allocating 2*67108864 elements = 1073741824 bytes of memory.
Using 262144 bytes as blocks for memcpy block copy test.
Getting down to business... Doing 10 runs per test.
0       Method: MEMCPY  Elapsed: 0.08215        MiB: 512.00000  Copy: 6232.350 MiB/s
1       Method: MEMCPY  Elapsed: 0.08157        MiB: 512.00000  Copy: 6276.433 MiB/s
2       Method: MEMCPY  Elapsed: 0.08259        MiB: 512.00000  Copy: 6198.998 MiB/s
3       Method: MEMCPY  Elapsed: 0.08155        MiB: 512.00000  Copy: 6278.357 MiB/s
4       Method: MEMCPY  Elapsed: 0.08166        MiB: 512.00000  Copy: 6269.746 MiB/s
5       Method: MEMCPY  Elapsed: 0.08159        MiB: 512.00000  Copy: 6275.125 MiB/s
6       Method: MEMCPY  Elapsed: 0.08167        MiB: 512.00000  Copy: 6268.978 MiB/s
7       Method: MEMCPY  Elapsed: 0.08157        MiB: 512.00000  Copy: 6276.587 MiB/s
8       Method: MEMCPY  Elapsed: 0.08261        MiB: 512.00000  Copy: 6198.022 MiB/s
9       Method: MEMCPY  Elapsed: 0.08163        MiB: 512.00000  Copy: 6272.127 MiB/s
AVG     Method: MEMCPY  Elapsed: 0.08186        MiB: 512.00000  Copy: 6254.520 MiB/s
0       Method: DUMB    Elapsed: 0.20884        MiB: 512.00000  Copy: 2451.649 MiB/s
1       Method: DUMB    Elapsed: 0.20017        MiB: 512.00000  Copy: 2557.864 MiB/s
2       Method: DUMB    Elapsed: 0.17721        MiB: 512.00000  Copy: 2889.179 MiB/s
3       Method: DUMB    Elapsed: 0.17734        MiB: 512.00000  Copy: 2887.110 MiB/s
4       Method: DUMB    Elapsed: 0.17337        MiB: 512.00000  Copy: 2953.238 MiB/s
5       Method: DUMB    Elapsed: 0.17051        MiB: 512.00000  Copy: 3002.704 MiB/s
6       Method: DUMB    Elapsed: 0.17720        MiB: 512.00000  Copy: 2889.358 MiB/s
7       Method: DUMB    Elapsed: 0.17516        MiB: 512.00000  Copy: 2923.008 MiB/s
8       Method: DUMB    Elapsed: 0.17527        MiB: 512.00000  Copy: 2921.174 MiB/s
9       Method: DUMB    Elapsed: 0.17683        MiB: 512.00000  Copy: 2895.354 MiB/s
AVG     Method: DUMB    Elapsed: 0.18119        MiB: 512.00000  Copy: 2825.744 MiB/s
0       Method: MCBLOCK Elapsed: 0.09484        MiB: 512.00000  Copy: 5398.338 MiB/s
1       Method: MCBLOCK Elapsed: 0.09387        MiB: 512.00000  Copy: 5454.294 MiB/s
2       Method: MCBLOCK Elapsed: 0.09394        MiB: 512.00000  Copy: 5450.055 MiB/s
3       Method: MCBLOCK Elapsed: 0.09392        MiB: 512.00000  Copy: 5451.390 MiB/s
4       Method: MCBLOCK Elapsed: 0.09394        MiB: 512.00000  Copy: 5450.403 MiB/s
5       Method: MCBLOCK Elapsed: 0.09391        MiB: 512.00000  Copy: 5451.912 MiB/s
6       Method: MCBLOCK Elapsed: 0.09496        MiB: 512.00000  Copy: 5391.914 MiB/s
7       Method: MCBLOCK Elapsed: 0.09400        MiB: 512.00000  Copy: 5446.866 MiB/s
8       Method: MCBLOCK Elapsed: 0.09388        MiB: 512.00000  Copy: 5454.003 MiB/s
9       Method: MCBLOCK Elapsed: 0.09381        MiB: 512.00000  Copy: 5457.549 MiB/s
AVG     Method: MCBLOCK Elapsed: 0.09411        MiB: 512.00000  Copy: 5440.575 MiB/s
```

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
 
#### 测试结论

| 场景           <td colspan=2> 4KB随机读 <td colspan=2> 4KB随机写 <td colspan=2> 4KB顺序读 <td colspan=2> 4KB顺序写 <td colspan=2> 1MB顺序读 <td colspan=2> 1MB顺序写 
|                            | IOPS     | Throughput | IOPS   | Throughput | IOPS   | Throughput | IOPS   | Throughput | IOPS   | Throughput | IOPS   | Throughput |
|----------------------------|----------|------------|--------|------------|--------|------------|--------|------------|--------|------------|--------|------------|
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

#### 测试数据

* 物理机

```bash

# 4KB随机读

random-read: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [r(1)][100.0%][r=828KiB/s,w=0KiB/s][r=207,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=24797: Sat Oct 30 00:06:20 2021
   read: IOPS=195, BW=782KiB/s (801kB/s)(45.9MiB/60039msec)
    slat (nsec): min=105, max=109517, avg=820.31, stdev=1377.18
    clat (msec): min=41, max=184, avg=81.76, stdev=15.04
     lat (msec): min=41, max=184, avg=81.76, stdev=15.04
    clat percentiles (msec):
     |  1.00th=[   53],  5.00th=[   61], 10.00th=[   65], 20.00th=[   70],
     | 30.00th=[   74], 40.00th=[   78], 50.00th=[   81], 60.00th=[   84],
     | 70.00th=[   88], 80.00th=[   92], 90.00th=[  100], 95.00th=[  109],
     | 99.00th=[  130], 99.50th=[  133], 99.90th=[  165], 99.95th=[  165],
     | 99.99th=[  182]
   bw (  KiB/s): min=  560, max=  992, per=99.97%, avg=781.78, stdev=75.68, samples=120
   iops        : min=  140, max=  248, avg=195.42, stdev=18.92, samples=120
  lat (msec)   : 50=0.65%, 100=90.14%, 250=9.21%
  cpu          : usr=0.15%, sys=0.06%, ctx=5878, majf=0, minf=54
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.0%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.8%, 8=0.1%, 16=4.2%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=11744,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=782KiB/s (801kB/s), 782KiB/s-782KiB/s (801kB/s-801kB/s), io=45.9MiB (48.1MB), run=60039-60039msec

# 4KB随机写

Disk stats (read/write):
  sda: ios=11821/13626, merge=0/68, ticks=60458/1750, in_queue=62206, util=99.61%
random-write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [w(1)][100.0%][r=0KiB/s,w=30.4MiB/s][r=0,w=7786 IOPS][eta 00m:00s]
random-write: (groupid=0, jobs=1): err= 0: pid=25911: Sat Oct 30 00:07:21 2021
  write: IOPS=7349, BW=28.7MiB/s (30.1MB/s)(1723MiB/60002msec)
    slat (nsec): min=106, max=126819, avg=490.79, stdev=527.24
    clat (usec): min=421, max=35306, avg=2173.06, stdev=1510.06
     lat (usec): min=422, max=35308, avg=2173.55, stdev=1510.07
    clat percentiles (usec):
     |  1.00th=[  701],  5.00th=[  816], 10.00th=[  906], 20.00th=[ 1045],
     | 30.00th=[ 1188], 40.00th=[ 1352], 50.00th=[ 1614], 60.00th=[ 1991],
     | 70.00th=[ 2507], 80.00th=[ 3195], 90.00th=[ 4228], 95.00th=[ 5211],
     | 99.00th=[ 7046], 99.50th=[ 7963], 99.90th=[11338], 99.95th=[13960],
     | 99.99th=[22152]
   bw (  KiB/s): min=22784, max=73576, per=99.99%, avg=29392.35, stdev=5074.51, samples=120
   iops        : min= 5696, max=18394, avg=7348.06, stdev=1268.63, samples=120
  lat (usec)   : 500=0.01%, 750=2.56%, 1000=14.13%
  lat (msec)   : 2=43.57%, 4=27.87%, 10=11.73%, 20=0.13%, 50=0.01%
  cpu          : usr=2.60%, sys=1.30%, ctx=220949, majf=0, minf=199
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.1%, 8=3.4%, 16=0.5%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,440960,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=28.7MiB/s (30.1MB/s), 28.7MiB/s-28.7MiB/s (30.1MB/s-30.1MB/s), io=1723MiB (1806MB), run=60002-60002msec

# 4KB顺序读

Disk stats (read/write):
  sda: ios=366/454672, merge=0/66, ticks=8513/72093, in_queue=80441, util=91.29%
random-read: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=102MiB/s,w=0KiB/s][r=26.2k,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=27058: Sat Oct 30 00:08:22 2021
   read: IOPS=22.1k, BW=86.3MiB/s (90.5MB/s)(5177MiB/60001msec)
    slat (nsec): min=85, max=514542, avg=279.98, stdev=729.38
    clat (usec): min=100, max=63893, avg=722.15, stdev=770.18
     lat (usec): min=101, max=63893, avg=722.43, stdev=770.20
    clat percentiles (usec):
     |  1.00th=[  523],  5.00th=[  537], 10.00th=[  553], 20.00th=[  578],
     | 30.00th=[  586], 40.00th=[  603], 50.00th=[  619], 60.00th=[  644],
     | 70.00th=[  676], 80.00th=[  717], 90.00th=[  816], 95.00th=[ 1319],
     | 99.00th=[ 1647], 99.50th=[ 3130], 99.90th=[10028], 99.95th=[13698],
     | 99.99th=[36963]
   bw (  KiB/s): min=48192, max=108624, per=99.99%, avg=88337.98, stdev=16408.38, samples=120
   iops        : min=12048, max=27156, avg=22084.47, stdev=4102.10, samples=120
  lat (usec)   : 250=0.01%, 500=0.12%, 750=85.27%, 1000=7.30%
  lat (msec)   : 2=6.59%, 4=0.29%, 10=0.32%, 20=0.08%, 50=0.02%
  lat (msec)   : 100=0.01%
  cpu          : usr=5.11%, sys=2.44%, ctx=668513, majf=0, minf=89
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.8%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.5%, 8=3.0%, 16=0.5%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1325257,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=86.3MiB/s (90.5MB/s), 86.3MiB/s-86.3MiB/s (90.5MB/s-90.5MB/s), io=5177MiB (5428MB), run=60001-60001msec

# 4KB顺序写

Disk stats (read/write):
  sda: ios=1322430/18311, merge=0/55, ticks=46838/2900, in_queue=49343, util=77.26%
random-write: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=112MiB/s][r=0,w=28.7k IOPS][eta 00m:00s]
random-write: (groupid=0, jobs=1): err= 0: pid=28222: Sat Oct 30 00:09:22 2021
  write: IOPS=24.5k, BW=95.8MiB/s (100MB/s)(5749MiB/60003msec)
    slat (nsec): min=104, max=265343, avg=332.75, stdev=542.34
    clat (usec): min=172, max=21303, avg=650.00, stdev=199.53
     lat (usec): min=172, max=21304, avg=650.34, stdev=199.55
    clat percentiles (usec):
     |  1.00th=[  474],  5.00th=[  490], 10.00th=[  506], 20.00th=[  545],
     | 30.00th=[  578], 40.00th=[  603], 50.00th=[  619], 60.00th=[  644],
     | 70.00th=[  668], 80.00th=[  709], 90.00th=[  783], 95.00th=[  848],
     | 99.00th=[ 1680], 99.50th=[ 1795], 99.90th=[ 1958], 99.95th=[ 2147],
     | 99.99th=[ 3458]
   bw (  KiB/s): min=71848, max=116968, per=99.84%, avg=97955.39, stdev=9230.84, samples=119
   iops        : min=17962, max=29242, avg=24488.86, stdev=2307.70, samples=119
  lat (usec)   : 250=0.01%, 500=7.71%, 750=78.94%, 1000=10.97%
  lat (msec)   : 2=2.31%, 4=0.07%, 10=0.01%, 20=0.01%, 50=0.01%
  cpu          : usr=5.70%, sys=2.47%, ctx=734099, majf=0, minf=106
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.5%, 8=2.9%, 16=0.6%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,1471719,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=95.8MiB/s (100MB/s), 95.8MiB/s-95.8MiB/s (100MB/s-100MB/s), io=5749MiB (6028MB), run=60003-60003msec

# 1MB顺序读

Disk stats (read/write):
  sda: ios=194/1485684, merge=0/68, ticks=781/41242, in_queue=41581, util=64.75%
seq-read: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=1012MiB/s,w=0KiB/s][r=1012,w=0 IOPS][eta 00m:00s]
seq-read: (groupid=0, jobs=1): err= 0: pid=29329: Sat Oct 30 00:10:23 2021
   read: IOPS=1055, BW=1056MiB/s (1107MB/s)(61.9GiB/60001msec)
    slat (nsec): min=1044, max=107499, avg=3986.03, stdev=1721.44
    clat (usec): min=322, max=57357, avg=941.21, stdev=1327.27
     lat (usec): min=327, max=57360, avg=945.20, stdev=1327.38
    clat percentiles (usec):
     |  1.00th=[  502],  5.00th=[  562], 10.00th=[  594], 20.00th=[  685],
     | 30.00th=[  750], 40.00th=[  807], 50.00th=[  840], 60.00th=[  865],
     | 70.00th=[  906], 80.00th=[  971], 90.00th=[ 1139], 95.00th=[ 1303],
     | 99.00th=[ 2540], 99.50th=[ 3621], 99.90th=[21365], 99.95th=[29754],
     | 99.99th=[47973]
   bw (  MiB/s): min=  411, max= 1234, per=99.99%, avg=1055.62, stdev=134.87, samples=120
   iops        : min=  411, max= 1234, avg=1055.60, stdev=134.86, samples=120
  lat (usec)   : 500=0.99%, 750=29.18%, 1000=52.75%
  lat (msec)   : 2=15.42%, 4=1.17%, 10=0.15%, 20=0.22%, 50=0.10%
  lat (msec)   : 100=0.01%
  cpu          : usr=0.94%, sys=1.04%, ctx=63587, majf=0, minf=88
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=63342,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=1056MiB/s (1107MB/s), 1056MiB/s-1056MiB/s (1107MB/s-1107MB/s), io=61.9GiB (66.4GB), run=60001-60001msec

# 1MB顺序写

Disk stats (read/write):
  sda: ios=253323/13507, merge=0/75, ticks=132267/1870, in_queue=128284, util=93.64%
seq-write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=859MiB/s][r=0,w=859 IOPS][eta 00m:00s] 
seq-write: (groupid=0, jobs=1): err= 0: pid=30516: Sat Oct 30 00:11:24 2021
  write: IOPS=1117, BW=1118MiB/s (1172MB/s)(65.5GiB/60001msec)
    slat (usec): min=9, max=6753, avg=24.51, stdev=29.94
    clat (usec): min=271, max=44824, avg=867.94, stdev=330.79
     lat (usec): min=290, max=44838, avg=892.45, stdev=333.21
    clat percentiles (usec):
     |  1.00th=[  420],  5.00th=[  635], 10.00th=[  685], 20.00th=[  734],
     | 30.00th=[  758], 40.00th=[  791], 50.00th=[  824], 60.00th=[  857],
     | 70.00th=[  898], 80.00th=[  971], 90.00th=[ 1090], 95.00th=[ 1221],
     | 99.00th=[ 1696], 99.50th=[ 2089], 99.90th=[ 3326], 99.95th=[ 4424],
     | 99.99th=[10421]
   bw (  MiB/s): min=  400, max= 2020, per=99.99%, avg=1117.69, stdev=155.96, samples=120
   iops        : min=  400, max= 2020, avg=1117.67, stdev=155.96, samples=120
  lat (usec)   : 500=1.61%, 750=25.22%, 1000=56.22%
  lat (msec)   : 2=16.38%, 4=0.52%, 10=0.04%, 20=0.01%, 50=0.01%
  cpu          : usr=3.48%, sys=0.91%, ctx=67526, majf=0, minf=1991
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,67068,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=1118MiB/s (1172MB/s), 1118MiB/s-1118MiB/s (1172MB/s-1172MB/s), io=65.5GiB (70.3GB), run=60001-60001msec

Disk stats (read/write):
  sda: ios=313/283336, merge=0/65, ticks=95351/143804, in_queue=232888, util=93.03%
```

* Linux虚拟机（cache=none）

```bash

# 4KB随机读

random-read: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
random-read: Laying out IO file (1 file / 4096MiB)
Jobs: 1 (f=1): [r(1)][100.0%][r=972KiB/s,w=0KiB/s][r=243,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=4810: Sat Oct 30 01:16:42 2021
   read: IOPS=245, BW=981KiB/s (1005kB/s)(57.6MiB/60069msec)
    slat (nsec): min=454, max=34511k, avg=3635.31, stdev=284257.42
    clat (msec): min=18, max=196, avg=65.14, stdev=20.14
     lat (msec): min=18, max=196, avg=65.14, stdev=20.14
    clat percentiles (msec):
     |  1.00th=[   32],  5.00th=[   40], 10.00th=[   44], 20.00th=[   50],
     | 30.00th=[   54], 40.00th=[   58], 50.00th=[   63], 60.00th=[   67],
     | 70.00th=[   72], 80.00th=[   79], 90.00th=[   89], 95.00th=[  104],
     | 99.00th=[  136], 99.50th=[  150], 99.90th=[  178], 99.95th=[  180],
     | 99.99th=[  192]
   bw (  KiB/s): min=  552, max= 1280, per=100.00%, avg=981.51, stdev=150.99, samples=120
   iops        : min=  138, max=  320, avg=245.37, stdev=37.74, samples=120
  lat (msec)   : 20=0.02%, 50=20.54%, 100=73.80%, 250=5.63%
  cpu          : usr=0.41%, sys=0.29%, ctx=7373, majf=1, minf=61
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.0%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.8%, 8=3.0%, 16=1.2%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=14739,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=981KiB/s (1005kB/s), 981KiB/s-981KiB/s (1005kB/s-1005kB/s), io=57.6MiB (60.4MB), run=60069-60069msec

# 4KB随机写

Disk stats (read/write):
  sdb: ios=14725/7, merge=0/5, ticks=59419/12, in_queue=59422, util=98.99%
random-write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
random-write: Laying out IO file (1 file / 4096MiB)
Jobs: 1 (f=1): [w(1)][100.0%][r=0KiB/s,w=24.2MiB/s][r=0,w=6195 IOPS][eta 00m:00s]
random-write: (groupid=0, jobs=1): err= 0: pid=4815: Sat Oct 30 01:17:43 2021
  write: IOPS=6096, BW=23.8MiB/s (24.0MB/s)(1430MiB/60030msec)
    slat (nsec): min=463, max=4844.2k, avg=1024.87, stdev=9101.74
    clat (usec): min=822, max=18757, avg=2612.45, stdev=539.56
     lat (usec): min=824, max=18759, avg=2613.48, stdev=539.70
    clat percentiles (usec):
     |  1.00th=[ 2245],  5.00th=[ 2278], 10.00th=[ 2311], 20.00th=[ 2376],
     | 30.00th=[ 2409], 40.00th=[ 2442], 50.00th=[ 2507], 60.00th=[ 2540],
     | 70.00th=[ 2638], 80.00th=[ 2737], 90.00th=[ 2933], 95.00th=[ 3195],
     | 99.00th=[ 4293], 99.50th=[ 5866], 99.90th=[ 9372], 99.95th=[10290],
     | 99.99th=[14877]
   bw (  KiB/s): min=20040, max=25856, per=100.00%, avg=24392.81, stdev=846.07, samples=120
   iops        : min= 5010, max= 6464, avg=6098.17, stdev=211.52, samples=120
  lat (usec)   : 1000=0.01%
  lat (msec)   : 2=0.05%, 4=98.69%, 10=1.20%, 20=0.05%
  cpu          : usr=5.74%, sys=4.52%, ctx=182607, majf=0, minf=58
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.9%, 8=2.5%, 16=1.6%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,365981,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=23.8MiB/s (24.0MB/s), 23.8MiB/s-23.8MiB/s (24.0MB/s-24.0MB/s), io=1430MiB (1499MB), run=60030-60030msec

# 4KB顺序读

Disk stats (read/write):
  sdb: ios=0/371909, merge=0/0, ticks=0/52257, in_queue=52136, util=78.35%
random-read: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=35.7MiB/s,w=0KiB/s][r=9130,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=4821: Sat Oct 30 01:18:44 2021
   read: IOPS=9458, BW=36.9MiB/s (38.7MB/s)(2217MiB/60002msec)
    slat (nsec): min=432, max=1340.5k, avg=807.74, stdev=2574.66
    clat (usec): min=137, max=84747, avg=1682.97, stdev=808.61
     lat (usec): min=209, max=84748, avg=1683.77, stdev=808.62
    clat percentiles (usec):
     |  1.00th=[ 1401],  5.00th=[ 1434], 10.00th=[ 1450], 20.00th=[ 1500],
     | 30.00th=[ 1532], 40.00th=[ 1565], 50.00th=[ 1614], 60.00th=[ 1647],
     | 70.00th=[ 1696], 80.00th=[ 1778], 90.00th=[ 1909], 95.00th=[ 2073],
     | 99.00th=[ 2540], 99.50th=[ 3556], 99.90th=[ 7832], 99.95th=[12911],
     | 99.99th=[42206]
   bw (  KiB/s): min=29016, max=41285, per=99.99%, avg=37829.40, stdev=2266.77, samples=120
   iops        : min= 7254, max=10321, avg=9457.33, stdev=566.68, samples=120
  lat (usec)   : 250=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=93.50%, 4=6.03%, 10=0.39%, 20=0.04%, 50=0.02%
  lat (msec)   : 100=0.01%
  cpu          : usr=6.26%, sys=6.74%, ctx=283036, majf=0, minf=62
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.1%, 8=2.0%, 16=1.9%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=567555,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=36.9MiB/s (38.7MB/s), 36.9MiB/s-36.9MiB/s (38.7MB/s-38.7MB/s), io=2217MiB (2325MB), run=60002-60002msec

# 4KB顺序写

Disk stats (read/write):
  sdb: ios=566497/24, merge=0/2019, ticks=51963/54, in_queue=51908, util=86.49%
random-write: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=25.1MiB/s][r=0,w=6428 IOPS][eta 00m:00s]
random-write: (groupid=0, jobs=1): err= 0: pid=4825: Sat Oct 30 01:19:44 2021
  write: IOPS=6278, BW=24.5MiB/s (25.7MB/s)(1472MiB/60006msec)
    slat (nsec): min=465, max=588878, avg=1013.68, stdev=1704.99
    clat (usec): min=1292, max=43347, avg=2539.67, stdev=513.14
     lat (usec): min=1302, max=43349, avg=2540.68, stdev=513.18
    clat percentiles (usec):
     |  1.00th=[ 2114],  5.00th=[ 2180], 10.00th=[ 2212], 20.00th=[ 2278],
     | 30.00th=[ 2311], 40.00th=[ 2343], 50.00th=[ 2409], 60.00th=[ 2474],
     | 70.00th=[ 2573], 80.00th=[ 2704], 90.00th=[ 3130], 95.00th=[ 3359],
     | 99.00th=[ 3884], 99.50th=[ 4293], 99.90th=[ 5997], 99.95th=[ 8225],
     | 99.99th=[15533]
   bw (  KiB/s): min=18850, max=26064, per=99.92%, avg=25095.27, stdev=851.44, samples=120
   iops        : min= 4712, max= 6516, avg=6273.70, stdev=212.93, samples=120
  lat (msec)   : 2=0.06%, 4=99.15%, 10=0.75%, 20=0.03%, 50=0.01%
  cpu          : usr=5.66%, sys=4.92%, ctx=188032, majf=0, minf=57
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.4%, 8=3.1%, 16=0.5%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,376770,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=24.5MiB/s (25.7MB/s), 24.5MiB/s-24.5MiB/s (25.7MB/s-25.7MB/s), io=1472MiB (1543MB), run=60006-60006msec

# 1MB顺序读

Disk stats (read/write):
  sdb: ios=0/376777, merge=0/0, ticks=0/50320, in_queue=50180, util=83.54%
seq-read: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
seq-read: Laying out IO file (1 file / 16384MiB)
Jobs: 1 (f=1): [R(1)][100.0%][r=1070MiB/s,w=0KiB/s][r=1070,w=0 IOPS][eta 00m:00s]
seq-read: (groupid=0, jobs=1): err= 0: pid=4831: Sat Oct 30 01:21:02 2021
   read: IOPS=979, BW=980MiB/s (1027MB/s)(57.4GiB/60001msec)
    slat (nsec): min=1520, max=5174.5k, avg=10653.72, stdev=22099.10
    clat (usec): min=468, max=66949, avg=1005.92, stdev=1405.26
     lat (usec): min=477, max=66958, avg=1016.57, stdev=1405.59
    clat percentiles (usec):
     |  1.00th=[  578],  5.00th=[  635], 10.00th=[  668], 20.00th=[  725],
     | 30.00th=[  791], 40.00th=[  857], 50.00th=[  906], 60.00th=[  938],
     | 70.00th=[  971], 80.00th=[ 1020], 90.00th=[ 1156], 95.00th=[ 1385],
     | 99.00th=[ 3032], 99.50th=[ 7373], 99.90th=[21890], 99.95th=[33817],
     | 99.99th=[52691]
   bw (  KiB/s): min=362496, max=1384448, per=99.90%, avg=1002091.21, stdev=157173.29, samples=119
   iops        : min=  354, max= 1352, avg=978.56, stdev=153.49, samples=119
  lat (usec)   : 500=0.05%, 750=24.05%, 1000=52.55%
  lat (msec)   : 2=21.68%, 4=0.91%, 10=0.46%, 20=0.17%, 50=0.11%
  lat (msec)   : 100=0.01%
  cpu          : usr=1.90%, sys=3.52%, ctx=58790, majf=0, minf=60
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=58776,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=980MiB/s (1027MB/s), 980MiB/s-980MiB/s (1027MB/s-1027MB/s), io=57.4GiB (61.6GB), run=60001-60001msec

# 1MB顺序写

Disk stats (read/write):
  sdb: ios=175957/5, merge=0/3, ticks=124683/0, in_queue=123610, util=88.13%
seq-write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
seq-write: Laying out IO file (1 file / 16384MiB)
Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=1036MiB/s][r=0,w=1036 IOPS][eta 00m:00s]
seq-write: (groupid=0, jobs=1): err= 0: pid=4835: Sat Oct 30 01:22:03 2021
  write: IOPS=1058, BW=1059MiB/s (1110MB/s)(62.0GiB/60001msec)
    slat (usec): min=12, max=1522, avg=31.91, stdev=12.80
    clat (usec): min=493, max=48198, avg=908.03, stdev=391.90
     lat (usec): min=528, max=48234, avg=939.94, stdev=392.47
    clat percentiles (usec):
     |  1.00th=[  627],  5.00th=[  709], 10.00th=[  742], 20.00th=[  783],
     | 30.00th=[  807], 40.00th=[  840], 50.00th=[  865], 60.00th=[  889],
     | 70.00th=[  930], 80.00th=[  979], 90.00th=[ 1074], 95.00th=[ 1205],
     | 99.00th=[ 1795], 99.50th=[ 2245], 99.90th=[ 4080], 99.95th=[ 4817],
     | 99.99th=[11076]
   bw (  MiB/s): min=  486, max= 1276, per=100.00%, avg=1058.92, stdev=112.74, samples=119
   iops        : min=  486, max= 1276, avg=1058.89, stdev=112.74, samples=119
  lat (usec)   : 500=0.01%, 750=11.46%, 1000=71.77%
  lat (msec)   : 2=16.05%, 4=0.61%, 10=0.09%, 20=0.01%, 50=0.01%
  cpu          : usr=4.91%, sys=2.88%, ctx=63546, majf=0, minf=58
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,63538,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=1059MiB/s (1110MB/s), 1059MiB/s-1059MiB/s (1110MB/s-1110MB/s), io=62.0GiB (66.6GB), run=60001-60001msec

Disk stats (read/write):
  sdb: ios=0/190623, merge=0/1, ticks=0/134765, in_queue=133681, util=85.12%
```

* Linux虚拟机（cache=none, multiqueue=2)

```bash

# 4KB随机读

random-read: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
random-read: Laying out IO file (1 file / 4096MiB)
Jobs: 1 (f=1): [r(1)][100.0%][r=896KiB/s,w=0KiB/s][r=224,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=4785: Sat Oct 30 01:52:12 2021
   read: IOPS=243, BW=973KiB/s (996kB/s)(57.1MiB/60049msec)
    slat (nsec): min=445, max=8814.3k, avg=1814.66, stdev=72928.10
    clat (msec): min=23, max=178, avg=65.72, stdev=19.18
     lat (msec): min=23, max=178, avg=65.73, stdev=19.18
    clat percentiles (msec):
     |  1.00th=[   32],  5.00th=[   41], 10.00th=[   46], 20.00th=[   52],
     | 30.00th=[   56], 40.00th=[   59], 50.00th=[   64], 60.00th=[   67],
     | 70.00th=[   72], 80.00th=[   78], 90.00th=[   89], 95.00th=[  102],
     | 99.00th=[  133], 99.50th=[  144], 99.90th=[  174], 99.95th=[  178],
     | 99.99th=[  178]
   bw (  KiB/s): min=  440, max= 1256, per=99.95%, avg=972.56, stdev=137.15, samples=120
   iops        : min=  110, max=  314, avg=243.09, stdev=34.28, samples=120
  lat (msec)   : 50=17.26%, 100=77.44%, 250=5.30%
  cpu          : usr=0.41%, sys=0.26%, ctx=7302, majf=1, minf=61
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.0%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.8%, 8=0.1%, 16=4.2%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=14608,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=973KiB/s (996kB/s), 973KiB/s-973KiB/s (996kB/s-996kB/s), io=57.1MiB (59.8MB), run=60049-60049msec

# 4KB随机写

Disk stats (read/write):
  sdb: ios=14568/7, merge=0/5, ticks=59340/180, in_queue=59514, util=98.95%
random-write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
random-write: Laying out IO file (1 file / 4096MiB)
Jobs: 1 (f=1): [w(1)][100.0%][r=0KiB/s,w=25.0MiB/s][r=0,w=6411 IOPS][eta 00m:00s]
random-write: (groupid=0, jobs=1): err= 0: pid=4789: Sat Oct 30 01:53:13 2021
  write: IOPS=7483, BW=29.2MiB/s (30.7MB/s)(1755MiB/60019msec)
    slat (nsec): min=447, max=6054.0k, avg=980.93, stdev=12417.10
    clat (usec): min=240, max=67969, avg=2127.42, stdev=729.10
     lat (usec): min=253, max=67971, avg=2128.40, stdev=729.22
    clat percentiles (usec):
     |  1.00th=[ 1729],  5.00th=[ 1795], 10.00th=[ 1827], 20.00th=[ 1860],
     | 30.00th=[ 1909], 40.00th=[ 1942], 50.00th=[ 1991], 60.00th=[ 2040],
     | 70.00th=[ 2114], 80.00th=[ 2245], 90.00th=[ 2474], 95.00th=[ 2769],
     | 99.00th=[ 4293], 99.50th=[ 6849], 99.90th=[ 9503], 99.95th=[11207],
     | 99.99th=[16581]
   bw (  KiB/s): min=22296, max=32512, per=100.00%, avg=29941.92, stdev=1923.92, samples=120
   iops        : min= 5574, max= 8128, avg=7485.46, stdev=480.97, samples=120
  lat (usec)   : 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.01%
  lat (msec)   : 2=52.88%, 4=45.95%, 10=1.10%, 20=0.06%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=6.32%, sys=5.68%, ctx=223660, majf=0, minf=58
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.8%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.1%, 8=2.5%, 16=1.3%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,449182,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=29.2MiB/s (30.7MB/s), 29.2MiB/s-29.2MiB/s (30.7MB/s-30.7MB/s), io=1755MiB (1840MB), run=60019-60019msec

# 4KB顺序读

Disk stats (read/write):
  sdb: ios=0/459554, merge=0/178, ticks=0/54640, in_queue=54482, util=75.42%
random-read: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=38.0MiB/s,w=0KiB/s][r=9729,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=4794: Sat Oct 30 01:54:14 2021
   read: IOPS=11.5k, BW=44.9MiB/s (47.0MB/s)(2691MiB/60002msec)
    slat (nsec): min=419, max=2605.9k, avg=854.55, stdev=5320.53
    clat (usec): min=29, max=24208, avg=1384.52, stdev=491.41
     lat (usec): min=209, max=24209, avg=1385.38, stdev=491.47
    clat percentiles (usec):
     |  1.00th=[  963],  5.00th=[ 1012], 10.00th=[ 1057], 20.00th=[ 1106],
     | 30.00th=[ 1172], 40.00th=[ 1237], 50.00th=[ 1303], 60.00th=[ 1385],
     | 70.00th=[ 1467], 80.00th=[ 1598], 90.00th=[ 1729], 95.00th=[ 1860],
     | 99.00th=[ 2802], 99.50th=[ 3654], 99.90th=[ 6915], 99.95th=[ 9241],
     | 99.99th=[15926]
   bw (  KiB/s): min=30728, max=54144, per=99.99%, avg=45925.91, stdev=4851.27, samples=120
   iops        : min= 7682, max=13536, avg=11481.45, stdev=1212.83, samples=120
  lat (usec)   : 50=0.01%, 250=0.01%, 500=0.01%, 750=0.02%, 1000=3.54%
  lat (msec)   : 2=92.99%, 4=3.04%, 10=0.37%, 20=0.04%, 50=0.01%
  cpu          : usr=8.11%, sys=8.32%, ctx=340402, majf=0, minf=61
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.3%, 16=49.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.8%, 8=2.6%, 16=1.6%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=688976,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=44.9MiB/s (47.0MB/s), 44.9MiB/s-44.9MiB/s (47.0MB/s-47.0MB/s), io=2691MiB (2822MB), run=60002-60002msec

# 4KB顺序写

Disk stats (read/write):
  sdb: ios=687927/27, merge=0/2076, ticks=49392/28, in_queue=49238, util=82.09%
random-write: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=29.9MiB/s][r=0,w=7662 IOPS][eta 00m:00s]
random-write: (groupid=0, jobs=1): err= 0: pid=4798: Sat Oct 30 01:55:14 2021
  write: IOPS=7271, BW=28.4MiB/s (29.8MB/s)(1704MiB/60004msec)
    slat (nsec): min=442, max=1140.2k, avg=1040.46, stdev=3941.55
    clat (usec): min=529, max=47390, avg=2190.82, stdev=663.74
     lat (usec): min=531, max=47392, avg=2191.86, stdev=663.82
    clat percentiles (usec):
     |  1.00th=[ 1663],  5.00th=[ 1729], 10.00th=[ 1762], 20.00th=[ 1827],
     | 30.00th=[ 1876], 40.00th=[ 1926], 50.00th=[ 2008], 60.00th=[ 2114],
     | 70.00th=[ 2245], 80.00th=[ 2474], 90.00th=[ 2868], 95.00th=[ 3163],
     | 99.00th=[ 4146], 99.50th=[ 4817], 99.90th=[ 7767], 99.95th=[10028],
     | 99.99th=[16450]
   bw (  KiB/s): min=23160, max=32184, per=99.99%, avg=29082.50, stdev=2032.53, samples=120
   iops        : min= 5790, max= 8046, avg=7270.61, stdev=508.13, samples=120
  lat (usec)   : 750=0.01%, 1000=0.01%
  lat (msec)   : 2=49.30%, 4=49.50%, 10=1.15%, 20=0.04%, 50=0.01%
  cpu          : usr=6.57%, sys=5.99%, ctx=216527, majf=0, minf=57
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.2%, 16=49.7%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.1%, 8=2.8%, 16=1.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,436332,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=28.4MiB/s (29.8MB/s), 28.4MiB/s-28.4MiB/s (29.8MB/s-29.8MB/s), io=1704MiB (1787MB), run=60004-60004msec

# 1MB顺序读

Disk stats (read/write):
  sdb: ios=0/436339, merge=0/0, ticks=0/48476, in_queue=48334, util=80.45%
seq-read: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
seq-read: Laying out IO file (1 file / 16384MiB)
Jobs: 1 (f=1): [R(1)][100.0%][r=986MiB/s,w=0KiB/s][r=986,w=0 IOPS][eta 00m:00s] 
seq-read: (groupid=0, jobs=1): err= 0: pid=4803: Sat Oct 30 01:56:32 2021
   read: IOPS=958, BW=959MiB/s (1005MB/s)(56.2GiB/60001msec)
    slat (usec): min=2, max=7236, avg=10.69, stdev=32.07
    clat (usec): min=480, max=61289, avg=1027.94, stdev=1508.77
     lat (usec): min=485, max=61300, avg=1038.63, stdev=1509.28
    clat percentiles (usec):
     |  1.00th=[  603],  5.00th=[  644], 10.00th=[  676], 20.00th=[  742],
     | 30.00th=[  799], 40.00th=[  857], 50.00th=[  906], 60.00th=[  938],
     | 70.00th=[  971], 80.00th=[ 1020], 90.00th=[ 1172], 95.00th=[ 1385],
     | 99.00th=[ 3195], 99.50th=[ 8717], 99.90th=[22938], 99.95th=[38536],
     | 99.99th=[51119]
   bw (  KiB/s): min=471040, max=1140736, per=99.97%, avg=981562.49, stdev=142088.97, samples=119
   iops        : min=  460, max= 1114, avg=958.54, stdev=138.75, samples=119
  lat (usec)   : 500=0.01%, 750=21.52%, 1000=54.93%
  lat (msec)   : 2=21.71%, 4=0.96%, 10=0.48%, 20=0.26%, 50=0.11%
  lat (msec)   : 100=0.01%
  cpu          : usr=2.16%, sys=3.59%, ctx=57553, majf=0, minf=61
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=57529,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=959MiB/s (1005MB/s), 959MiB/s-959MiB/s (1005MB/s-1005MB/s), io=56.2GiB (60.3GB), run=60001-60001msec

# 1MB顺序写

Disk stats (read/write):
  sdb: ios=172183/6, merge=0/3, ticks=123760/4, in_queue=122711, util=88.26%
seq-write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
seq-write: Laying out IO file (1 file / 16384MiB)
Jobs: 1 (f=1): [W(1)][100.0%][r=0KiB/s,w=1102MiB/s][r=0,w=1102 IOPS][eta 00m:00s]
seq-write: (groupid=0, jobs=1): err= 0: pid=4808: Sat Oct 30 01:57:33 2021
  write: IOPS=1052, BW=1052MiB/s (1104MB/s)(61.7GiB/60001msec)
    slat (usec): min=12, max=1388, avg=35.04, stdev=16.39
    clat (usec): min=528, max=50673, avg=910.62, stdev=506.20
     lat (usec): min=557, max=50700, avg=945.66, stdev=506.89
    clat percentiles (usec):
     |  1.00th=[  619],  5.00th=[  676], 10.00th=[  717], 20.00th=[  766],
     | 30.00th=[  799], 40.00th=[  832], 50.00th=[  857], 60.00th=[  889],
     | 70.00th=[  930], 80.00th=[  979], 90.00th=[ 1106], 95.00th=[ 1254],
     | 99.00th=[ 1811], 99.50th=[ 2278], 99.90th=[ 4686], 99.95th=[ 6521],
     | 99.99th=[19006]
   bw (  MiB/s): min=  594, max= 1310, per=99.96%, avg=1052.04, stdev=111.44, samples=119
   iops        : min=  594, max= 1310, avg=1052.02, stdev=111.43, samples=119
  lat (usec)   : 750=16.12%, 1000=66.01%
  lat (msec)   : 2=17.16%, 4=0.57%, 10=0.11%, 20=0.01%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=5.45%, sys=2.77%, ctx=63159, majf=0, minf=58
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,63147,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=1052MiB/s (1104MB/s), 1052MiB/s-1052MiB/s (1104MB/s-1104MB/s), io=61.7GiB (66.2GB), run=60001-60001msec

Disk stats (read/write):
  sdb: ios=0/189450, merge=0/1, ticks=0/133484, in_queue=132230, util=84.23%
```

* Linux虚拟机(cache=writeback)

```bash

# 4KB随机读

random-read: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
random-read: Laying out IO file (1 file / 4096MiB)
Jobs: 1 (f=1): [r(1)][100.0%][r=46.7MiB/s,w=0KiB/s][r=11.0k,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=5154: Sat Oct 30 00:37:09 2021
   read: IOPS=13.0k, BW=54.5MiB/s (57.2MB/s)(3273MiB/60002msec)
    slat (nsec): min=424, max=2322.4k, avg=784.96, stdev=3164.24
    clat (usec): min=155, max=48546, avg=1136.72, stdev=397.48
     lat (usec): min=156, max=48548, avg=1137.50, stdev=397.53
    clat percentiles (usec):
     |  1.00th=[  865],  5.00th=[  898], 10.00th=[  914], 20.00th=[  947],
     | 30.00th=[  979], 40.00th=[ 1012], 50.00th=[ 1057], 60.00th=[ 1090],
     | 70.00th=[ 1156], 80.00th=[ 1303], 90.00th=[ 1467], 95.00th=[ 1532],
     | 99.00th=[ 2008], 99.50th=[ 2507], 99.90th=[ 5080], 99.95th=[ 7308],
     | 99.99th=[12256]
   bw (  KiB/s): min=39928, max=67048, per=99.99%, avg=55844.02, stdev=5142.90, samples=120
   iops        : min= 9982, max=16762, avg=13960.98, stdev=1285.72, samples=120
  lat (usec)   : 250=0.01%, 500=0.01%, 750=0.04%, 1000=36.06%
  lat (msec)   : 2=62.89%, 4=0.82%, 10=0.16%, 20=0.02%, 50=0.01%
  cpu          : usr=8.97%, sys=8.57%, ctx=415284, majf=1, minf=61
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.8%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.9%, 8=2.5%, 16=1.5%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=837810,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=54.5MiB/s (57.2MB/s), 54.5MiB/s-54.5MiB/s (57.2MB/s-57.2MB/s), io=3273MiB (3432MB), run=60002-60002msec

# 4KB随机写

Disk stats (read/write):
  sdb: ios=836086/11, merge=0/7, ticks=47986/0, in_queue=47831, util=79.80%
random-write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
random-write: Laying out IO file (1 file / 4096MiB)
Jobs: 1 (f=1): [w(1)][100.0%][r=0KiB/s,w=29.8MiB/s][r=0,w=7624 IOPS][eta 00m:00s]
random-write: (groupid=0, jobs=1): err= 0: pid=5158: Sat Oct 30 00:38:10 2021
  write: IOPS=8360, BW=32.7MiB/s (34.2MB/s)(1961MiB/60049msec)
    slat (nsec): min=446, max=10314k, avg=1031.87, stdev=15008.45
    clat (usec): min=158, max=72950, avg=1901.29, stdev=819.44
     lat (usec): min=160, max=72951, avg=1902.32, stdev=819.63
    clat percentiles (usec):
     |  1.00th=[ 1237],  5.00th=[ 1319], 10.00th=[ 1385], 20.00th=[ 1483],
     | 30.00th=[ 1598], 40.00th=[ 1729], 50.00th=[ 1860], 60.00th=[ 1926],
     | 70.00th=[ 1975], 80.00th=[ 2040], 90.00th=[ 2278], 95.00th=[ 2737],
     | 99.00th=[ 4817], 99.50th=[ 6063], 99.90th=[10683], 99.95th=[12911],
     | 99.99th=[16909]
   bw (  KiB/s): min=24336, max=41536, per=100.00%, avg=33463.48, stdev=3564.38, samples=120
   iops        : min= 6084, max=10384, avg=8365.84, stdev=891.10, samples=120
  lat (usec)   : 250=0.01%, 500=0.01%, 750=0.01%, 1000=0.02%
  lat (msec)   : 2=74.38%, 4=23.96%, 10=1.53%, 20=0.11%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=8.01%, sys=6.53%, ctx=248268, majf=0, minf=58
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.3%, 16=49.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.0%, 8=2.6%, 16=1.4%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,502034,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=32.7MiB/s (34.2MB/s), 32.7MiB/s-32.7MiB/s (34.2MB/s-34.2MB/s), io=1961MiB (2056MB), run=60049-60049msec

# 4KB顺序读

Disk stats (read/write):
  sdb: ios=0/515160, merge=0/4, ticks=0/116065, in_queue=115875, util=72.02%
random-read: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=54.4MiB/s,w=0KiB/s][r=13.9k,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=5163: Sat Oct 30 00:39:11 2021
   read: IOPS=13.1k, BW=51.3MiB/s (53.8MB/s)(3076MiB/60001msec)
    slat (nsec): min=471, max=2159.4k, avg=875.32, stdev=4000.31
    clat (usec): min=46, max=43071, avg=1210.09, stdev=539.79
     lat (usec): min=211, max=43072, avg=1210.96, stdev=539.85
    clat percentiles (usec):
     |  1.00th=[  857],  5.00th=[  889], 10.00th=[  914], 20.00th=[  955],
     | 30.00th=[  996], 40.00th=[ 1037], 50.00th=[ 1090], 60.00th=[ 1172],
     | 70.00th=[ 1303], 80.00th=[ 1434], 90.00th=[ 1516], 95.00th=[ 1647],
     | 99.00th=[ 2671], 99.50th=[ 3654], 99.90th=[ 7570], 99.95th=[10028],
     | 99.99th=[17171]
   bw (  KiB/s): min=34760, max=65712, per=99.97%, avg=52480.80, stdev=6353.68, samples=120
   iops        : min= 8690, max=16428, avg=13120.16, stdev=1588.42, samples=120
  lat (usec)   : 50=0.01%, 100=0.01%, 250=0.01%, 500=0.01%, 750=0.07%
  lat (usec)   : 1000=30.60%
  lat (msec)   : 2=67.08%, 4=1.84%, 10=0.36%, 20=0.05%, 50=0.01%
  cpu          : usr=9.01%, sys=8.95%, ctx=388111, majf=0, minf=61
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.3%, 16=49.5%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.8%, 8=2.6%, 16=1.6%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=787495,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=51.3MiB/s (53.8MB/s), 51.3MiB/s-51.3MiB/s (53.8MB/s-53.8MB/s), io=3076MiB (3226MB), run=60001-60001msec

# 4KB顺序写

Disk stats (read/write):
  sdb: ios=785914/24, merge=0/2088, ticks=47770/54, in_queue=47625, util=79.36%
random-write: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [F(1)][100.0%][r=0KiB/s,w=0KiB/s][r=0,w=0 IOPS][eta 00m:00s]       
random-write: (groupid=0, jobs=1): err= 0: pid=5167: Sat Oct 30 00:40:16 2021
  write: IOPS=8976, BW=35.1MiB/s (36.8MB/s)(2263MiB/64549msec)
    slat (nsec): min=446, max=2998.0k, avg=925.01, stdev=4567.39
    clat (usec): min=212, max=7198.2k, avg=1647.56, stdev=37821.31
     lat (usec): min=224, max=7198.2k, avg=1648.49, stdev=37821.31
    clat percentiles (usec):
     |  1.00th=[ 1012],  5.00th=[ 1074], 10.00th=[ 1106], 20.00th=[ 1156],
     | 30.00th=[ 1205], 40.00th=[ 1254], 50.00th=[ 1319], 60.00th=[ 1401],
     | 70.00th=[ 1582], 80.00th=[ 1713], 90.00th=[ 1795], 95.00th=[ 1942],
     | 99.00th=[ 3064], 99.50th=[ 4015], 99.90th=[ 9110], 99.95th=[12518],
     | 99.99th=[24773]
   bw (  KiB/s): min= 7025, max=53776, per=100.00%, avg=43316.14, stdev=7568.27, samples=107
   iops        : min= 1756, max=13444, avg=10829.04, stdev=1892.09, samples=107
  lat (usec)   : 250=0.01%, 750=0.01%, 1000=0.63%
  lat (msec)   : 2=95.48%, 4=3.38%, 10=0.42%, 20=0.06%, 50=0.02%
  cpu          : usr=6.19%, sys=5.83%, ctx=288082, majf=0, minf=59
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.8%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.7%, 8=2.2%, 16=2.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,579449,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=35.1MiB/s (36.8MB/s), 35.1MiB/s-35.1MiB/s (36.8MB/s-36.8MB/s), io=2263MiB (2373MB), run=64549-64549msec

# 1MB顺序读

Disk stats (read/write):
  sdb: ios=0/579459, merge=0/0, ticks=0/123683, in_queue=123488, util=80.62%
seq-read: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
seq-read: Laying out IO file (1 file / 16384MiB)
Jobs: 1 (f=1): [R(1)][100.0%][r=2463MiB/s,w=0KiB/s][r=2463,w=0 IOPS][eta 00m:00s]
seq-read: (groupid=0, jobs=1): err= 0: pid=5171: Sat Oct 30 00:41:46 2021
   read: IOPS=2550, BW=2551MiB/s (2675MB/s)(149GiB/60001msec)
    slat (usec): min=2, max=6584, avg= 8.53, stdev=22.98
    clat (usec): min=242, max=29625, avg=379.48, stdev=271.90
     lat (usec): min=252, max=29647, avg=388.01, stdev=273.60
    clat percentiles (usec):
     |  1.00th=[  269],  5.00th=[  285], 10.00th=[  293], 20.00th=[  310],
     | 30.00th=[  326], 40.00th=[  338], 50.00th=[  351], 60.00th=[  367],
     | 70.00th=[  379], 80.00th=[  400], 90.00th=[  437], 95.00th=[  502],
     | 99.00th=[  898], 99.50th=[ 1336], 99.90th=[ 4228], 99.95th=[ 6194],
     | 99.99th=[10421]
   bw (  MiB/s): min= 1748, max= 3012, per=99.98%, avg=2550.44, stdev=232.06, samples=120
   iops        : min= 1748, max= 3012, avg=2550.39, stdev=232.05, samples=120
  lat (usec)   : 250=0.01%, 500=94.89%, 750=3.62%, 1000=0.70%
  lat (msec)   : 2=0.48%, 4=0.19%, 10=0.10%, 20=0.01%, 50=0.01%
  cpu          : usr=4.57%, sys=8.60%, ctx=153106, majf=0, minf=61
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=153059,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=2551MiB/s (2675MB/s), 2551MiB/s-2551MiB/s (2675MB/s-2675MB/s), io=149GiB (160GB), run=60001-60001msec

# 1MB顺序写

Disk stats (read/write):
  sdb: ios=459043/6, merge=0/2, ticks=107748/1, in_queue=105258, util=74.40%
seq-write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
seq-write: Laying out IO file (1 file / 16384MiB)
Jobs: 1 (f=1): [F(1)][100.0%][r=0KiB/s,w=0KiB/s][r=0,w=0 IOPS][eta 00m:00s]      
seq-write: (groupid=0, jobs=1): err= 0: pid=5175: Sat Oct 30 00:42:58 2021
  write: IOPS=1045, BW=1046MiB/s (1096MB/s)(73.3GiB/71818msec)
    slat (usec): min=14, max=8756, avg=35.70, stdev=57.72
    clat (usec): min=7, max=139859, avg=758.68, stdev=1543.97
     lat (usec): min=428, max=139891, avg=794.38, stdev=1545.57
    clat percentiles (usec):
     |  1.00th=[  449],  5.00th=[  482], 10.00th=[  498], 20.00th=[  529],
     | 30.00th=[  553], 40.00th=[  578], 50.00th=[  611], 60.00th=[  644],
     | 70.00th=[  685], 80.00th=[  750], 90.00th=[  873], 95.00th=[ 1057],
     | 99.00th=[ 3589], 99.50th=[ 5538], 99.90th=[18220], 99.95th=[23200],
     | 99.99th=[68682]
   bw (  MiB/s): min=  542, max= 1852, per=100.00%, avg=1250.35, stdev=317.10, samples=119
   iops        : min=  542, max= 1852, avg=1250.30, stdev=317.12, samples=119
  lat (usec)   : 10=0.01%, 500=10.44%, 750=69.25%, 1000=14.47%
  lat (msec)   : 2=3.90%, 4=1.11%, 10=0.55%, 20=0.21%, 50=0.05%
  lat (msec)   : 100=0.01%, 250=0.01%
  cpu          : usr=6.34%, sys=3.38%, ctx=75158, majf=0, minf=59
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,75097,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=1046MiB/s (1096MB/s), 1046MiB/s-1046MiB/s (1096MB/s-1096MB/s), io=73.3GiB (78.7GB), run=71818-71818msec

Disk stats (read/write):
  sdb: ios=0/225300, merge=0/1, ticks=0/212470, in_queue=211023, util=90.99%
```

* Linux虚拟机(cache=writeback, queues=4)

```bash

# 4KB随机读

random-read: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
random-read: Laying out IO file (1 file / 4096MiB)
Jobs: 1 (f=1): [r(1)][100.0%][r=126MiB/s,w=0KiB/s][r=32.2k,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=4808: Sat Oct 30 02:09:21 2021
   read: IOPS=28.7k, BW=112MiB/s (117MB/s)(6717MiB/60001msec)
    slat (nsec): min=418, max=774286, avg=648.17, stdev=1117.03
    clat (usec): min=45, max=39467, avg=551.68, stdev=262.35
     lat (usec): min=102, max=39469, avg=552.33, stdev=262.39
    clat percentiles (usec):
     |  1.00th=[  412],  5.00th=[  429], 10.00th=[  437], 20.00th=[  449],
     | 30.00th=[  461], 40.00th=[  478], 50.00th=[  494], 60.00th=[  515],
     | 70.00th=[  545], 80.00th=[  594], 90.00th=[  742], 95.00th=[  898],
     | 99.00th=[ 1139], 99.50th=[ 1369], 99.90th=[ 2802], 99.95th=[ 4293],
     | 99.99th=[ 8586]
   bw (  KiB/s): min=82672, max=136023, per=99.98%, avg=114605.57, stdev=12051.84, samples=120
   iops        : min=20668, max=34005, avg=28651.37, stdev=3012.97, samples=120
  lat (usec)   : 50=0.01%, 250=0.01%, 500=53.60%, 750=36.73%, 1000=7.48%
  lat (msec)   : 2=2.00%, 4=0.14%, 10=0.05%, 20=0.01%, 50=0.01%
  cpu          : usr=10.62%, sys=13.94%, ctx=820177, majf=1, minf=61
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=49.9%, 16=50.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.2%, 8=3.0%, 16=0.8%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1719435,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=112MiB/s (117MB/s), 112MiB/s-112MiB/s (117MB/s-117MB/s), io=6717MiB (7043MB), run=60001-60001msec

# 4KB随机写

Disk stats (read/write):
  sdb: ios=1717107/7, merge=0/5, ticks=39989/0, in_queue=39689, util=66.18%
random-write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
random-write: Laying out IO file (1 file / 4096MiB)
Jobs: 1 (f=1): [w(1)][100.0%][r=0KiB/s,w=50.0MiB/s][r=0,w=12.8k IOPS][eta 00m:00s]
random-write: (groupid=0, jobs=1): err= 0: pid=4812: Sat Oct 30 02:10:22 2021
  write: IOPS=12.2k, BW=47.5MiB/s (49.8MB/s)(2851MiB/60047msec)
    slat (nsec): min=446, max=890642, avg=868.68, stdev=1701.53
    clat (usec): min=101, max=209944, avg=1306.04, stdev=1963.58
     lat (usec): min=447, max=209945, avg=1306.91, stdev=1963.60
    clat percentiles (usec):
     |  1.00th=[   848],  5.00th=[   906], 10.00th=[   947], 20.00th=[   996],
     | 30.00th=[  1045], 40.00th=[  1106], 50.00th=[  1172], 60.00th=[  1303],
     | 70.00th=[  1418], 80.00th=[  1467], 90.00th=[  1549], 95.00th=[  1680],
     | 99.00th=[  2900], 99.50th=[  4359], 99.90th=[  9634], 99.95th=[ 21103],
     | 99.99th=[111674]
   bw (  KiB/s): min=10072, max=61056, per=100.00%, avg=48655.44, stdev=7643.55, samples=120
   iops        : min= 2518, max=15264, avg=12163.83, stdev=1910.88, samples=120
  lat (usec)   : 250=0.01%, 500=0.01%, 750=0.03%, 1000=20.64%
  lat (msec)   : 2=76.81%, 4=1.91%, 10=0.51%, 20=0.04%, 50=0.02%
  lat (msec)   : 100=0.02%, 250=0.01%
  cpu          : usr=8.05%, sys=7.93%, ctx=362299, majf=0, minf=58
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.1%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.8%, 8=2.6%, 16=1.5%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,729934,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=47.5MiB/s (49.8MB/s), 47.5MiB/s-47.5MiB/s (49.8MB/s-49.8MB/s), io=2851MiB (2990MB), run=60047-60047msec

# 4KB顺序读

Disk stats (read/write):
  sdb: ios=0/753722, merge=0/301, ticks=0/156690, in_queue=156482, util=69.53%
random-read: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [R(1)][100.0%][r=125MiB/s,w=0KiB/s][r=31.9k,w=0 IOPS][eta 00m:00s]
random-read: (groupid=0, jobs=1): err= 0: pid=4817: Sat Oct 30 02:11:22 2021
   read: IOPS=29.6k, BW=116MiB/s (121MB/s)(6938MiB/60001msec)
    slat (nsec): min=419, max=547504, avg=636.55, stdev=1095.32
    clat (usec): min=28, max=48101, avg=534.43, stdev=269.89
     lat (usec): min=39, max=48102, avg=535.07, stdev=269.94
    clat percentiles (usec):
     |  1.00th=[  400],  5.00th=[  412], 10.00th=[  420], 20.00th=[  433],
     | 30.00th=[  445], 40.00th=[  457], 50.00th=[  474], 60.00th=[  494],
     | 70.00th=[  529], 80.00th=[  578], 90.00th=[  734], 95.00th=[  873],
     | 99.00th=[ 1090], 99.50th=[ 1369], 99.90th=[ 2999], 99.95th=[ 4146],
     | 99.99th=[ 8160]
   bw (  KiB/s): min=82568, max=143200, per=99.98%, avg=118380.02, stdev=13225.77, samples=119
   iops        : min=20642, max=35800, avg=29594.97, stdev=3306.45, samples=119
  lat (usec)   : 50=0.01%, 250=0.01%, 500=62.00%, 750=28.61%, 1000=7.84%
  lat (msec)   : 2=1.33%, 4=0.16%, 10=0.05%, 20=0.01%, 50=0.01%
  cpu          : usr=9.65%, sys=14.23%, ctx=852125, majf=0, minf=61
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.0%, 16=50.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=96.0%, 8=3.2%, 16=0.8%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1776117,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=116MiB/s (121MB/s), 116MiB/s-116MiB/s (121MB/s-121MB/s), io=6938MiB (7275MB), run=60001-60001msec

# 4KB顺序写

Disk stats (read/write):
  sdb: ios=1772977/62, merge=0/2004, ticks=39158/47, in_queue=38891, util=64.78%
random-write: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=posixaio, iodepth=16
fio-3.7
Starting 1 process
Jobs: 1 (f=1): [F(1)][100.0%][r=0KiB/s,w=0KiB/s][r=0,w=0 IOPS][eta 00m:00s]      
random-write: (groupid=0, jobs=1): err= 0: pid=4821: Sat Oct 30 02:12:43 2021
  write: IOPS=11.2k, BW=43.8MiB/s (45.9MB/s)(3503MiB/79939msec)
    slat (nsec): min=446, max=656366, avg=816.76, stdev=1500.08
    clat (usec): min=163, max=14400k, avg=1062.44, stdev=60832.15
     lat (usec): min=173, max=14400k, avg=1063.26, stdev=60832.15
    clat percentiles (usec):
     |  1.00th=[  461],  5.00th=[  502], 10.00th=[  537], 20.00th=[  578],
     | 30.00th=[  619], 40.00th=[  660], 50.00th=[  701], 60.00th=[  758],
     | 70.00th=[  832], 80.00th=[  971], 90.00th=[ 1172], 95.00th=[ 1287],
     | 99.00th=[ 2114], 99.50th=[ 2671], 99.90th=[ 5211], 99.95th=[ 6915],
     | 99.99th=[16909]
   bw (  KiB/s): min=26360, max=106264, per=100.00%, avg=77976.51, stdev=15679.69, samples=92
   iops        : min= 6590, max=26566, avg=19494.12, stdev=3919.92, samples=92
  lat (usec)   : 250=0.01%, 500=4.65%, 750=54.58%, 1000=21.87%
  lat (msec)   : 2=17.75%, 4=0.96%, 10=0.16%, 20=0.02%, 50=0.01%
  lat (msec)   : 500=0.01%
  cpu          : usr=5.37%, sys=6.70%, ctx=429626, majf=0, minf=58
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=50.0%, 16=49.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.7%, 8=2.4%, 16=1.9%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,896763,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=43.8MiB/s (45.9MB/s), 43.8MiB/s-43.8MiB/s (45.9MB/s-45.9MB/s), io=3503MiB (3673MB), run=79939-79939msec

# 1MB顺序读

Disk stats (read/write):
  sdb: ios=0/896774, merge=0/0, ticks=0/186488, in_queue=186261, util=79.67%
seq-read: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
seq-read: Laying out IO file (1 file / 16384MiB)
Jobs: 1 (f=1): [R(1)][100.0%][r=2731MiB/s,w=0KiB/s][r=2730,w=0 IOPS][eta 00m:00s]
seq-read: (groupid=0, jobs=1): err= 0: pid=4827: Sat Oct 30 02:14:09 2021
   read: IOPS=2931, BW=2932MiB/s (3074MB/s)(172GiB/60001msec)
    slat (nsec): min=1939, max=3778.2k, avg=7671.60, stdev=10036.59
    clat (usec): min=126, max=53500, avg=329.76, stdev=204.26
     lat (usec): min=243, max=53517, avg=337.43, stdev=204.80
    clat percentiles (usec):
     |  1.00th=[  258],  5.00th=[  269], 10.00th=[  277], 20.00th=[  285],
     | 30.00th=[  297], 40.00th=[  306], 50.00th=[  318], 60.00th=[  330],
     | 70.00th=[  343], 80.00th=[  359], 90.00th=[  383], 95.00th=[  408],
     | 99.00th=[  515], 99.50th=[  652], 99.90th=[ 1631], 99.95th=[ 2999],
     | 99.99th=[ 5866]
   bw (  MiB/s): min= 2198, max= 3214, per=99.98%, avg=2931.44, stdev=179.13, samples=120
   iops        : min= 2198, max= 3214, avg=2931.39, stdev=179.11, samples=120
  lat (usec)   : 250=0.21%, 500=98.67%, 750=0.75%, 1000=0.18%
  lat (msec)   : 2=0.11%, 4=0.05%, 10=0.02%, 20=0.01%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=4.24%, sys=7.87%, ctx=175932, majf=0, minf=61
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=175919,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=2932MiB/s (3074MB/s), 2932MiB/s-2932MiB/s (3074MB/s-3074MB/s), io=172GiB (184GB), run=60001-60001msec

# 1MB顺序写

Disk stats (read/write):
  sdb: ios=526776/5, merge=0/3, ticks=104637/0, in_queue=101736, util=74.41%
seq-write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=posixaio, iodepth=1
fio-3.7
Starting 1 process
seq-write: Laying out IO file (1 file / 16384MiB)
Jobs: 1 (f=1): [F(1)][100.0%][r=0KiB/s,w=0KiB/s][r=0,w=0 IOPS][eta 00m:00s]      
seq-write: (groupid=0, jobs=1): err= 0: pid=4832: Sat Oct 30 02:15:25 2021
  write: IOPS=1220, BW=1220MiB/s (1280MB/s)(90.0GiB/75522msec)
    slat (usec): min=12, max=6901, avg=33.17, stdev=29.64
    clat (usec): min=4, max=84036, avg=613.76, stdev=935.28
     lat (usec): min=368, max=84056, avg=646.93, stdev=935.93
    clat percentiles (usec):
     |  1.00th=[  388],  5.00th=[  412], 10.00th=[  433], 20.00th=[  461],
     | 30.00th=[  482], 40.00th=[  502], 50.00th=[  523], 60.00th=[  545],
     | 70.00th=[  586], 80.00th=[  668], 90.00th=[  758], 95.00th=[  840],
     | 99.00th=[ 1893], 99.50th=[ 3359], 99.90th=[13698], 99.95th=[20579],
     | 99.99th=[36439]
   bw (  MiB/s): min=  672, max= 2184, per=100.00%, avg=1536.11, stdev=367.42, samples=120
   iops        : min=  672, max= 2184, avg=1536.09, stdev=367.42, samples=120
  lat (usec)   : 10=0.01%, 500=39.34%, 750=50.19%, 1000=8.44%
  lat (msec)   : 2=1.08%, 4=0.60%, 10=0.22%, 20=0.07%, 50=0.05%
  lat (msec)   : 100=0.01%
  cpu          : usr=5.75%, sys=3.13%, ctx=92204, majf=0, minf=59
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,92174,0,1 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=1220MiB/s (1280MB/s), 1220MiB/s-1220MiB/s (1280MB/s-1280MB/s), io=90.0GiB (96.7GB), run=75522-75522msec

Disk stats (read/write):
  sdb: ios=0/276525, merge=0/0, ticks=0/182473, in_queue=181017, util=96.13%
```

* Windows虚拟机(cache=none)

```bash

# 4KB随机读

D:\>c:\fio\fio\fio --name=random-read --ioengine=windowsaio --rw=randread --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-read: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-read: (groupid=0, jobs=1): err= 0: pid=2072: Sat Oct 30 02:40:25 2021
  read: IOPS=2811, BW=11.0MiB/s (11.5MB/s)(659MiB/60015msec)
    slat (usec): min=10, max=5373, avg=25.68, stdev=25.09
    clat (usec): min=11, max=73724, avg=5621.21, stdev=5224.92
     lat (usec): min=103, max=73749, avg=5646.90, stdev=5224.95
    clat percentiles (usec):
     |  1.00th=[  128],  5.00th=[  163], 10.00th=[  206], 20.00th=[  404],
     | 30.00th=[ 2409], 40.00th=[ 3687], 50.00th=[ 4883], 60.00th=[ 6128],
     | 70.00th=[ 7373], 80.00th=[ 8586], 90.00th=[11076], 95.00th=[15533],
     | 99.00th=[24511], 99.50th=[28967], 99.90th=[40109], 99.95th=[43779],
     | 99.99th=[56361]
   bw (  KiB/s): min= 9635, max=12200, per=100.00%, avg=11257.24, stdev=457.67, samples=119
   iops        : min= 2408, max= 3050, avg=2813.85, stdev=114.34, samples=119
  lat (usec)   : 20=0.01%, 50=0.01%, 100=0.10%, 250=14.68%, 500=5.68%
  lat (usec)   : 750=0.51%, 1000=0.37%
  lat (msec)   : 2=5.78%, 4=15.49%, 10=45.38%, 20=9.97%, 50=2.01%
  lat (msec)   : 100=0.02%
  cpu          : usr=0.00%, sys=16.66%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=16.1%, 16=83.8%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=168728,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=11.0MiB/s (11.5MB/s), 11.0MiB/s-11.0MiB/s (11.5MB/s-11.5MB/s), io=659MiB (691MB), run=60015-60015msec

# 4KB随机写

D:\>c:\fio\fio\fio --name=random-write --ioengine=windowsaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread
random-write: Laying out IO file (1 file / 4096MiB)

random-write: (groupid=0, jobs=1): err= 0: pid=2456: Sat Oct 30 02:41:26 2021
  write: IOPS=6002, BW=23.4MiB/s (24.6MB/s)(1407MiB/60002msec); 0 zone resets
    slat (usec): min=9, max=3977.2k, avg=46.96, stdev=7329.99
    clat (usec): min=11, max=10631k, avg=1894.52, stdev=19237.01
     lat (usec): min=126, max=11336k, avg=1953.41, stdev=26987.94
    clat percentiles (usec):
     |  1.00th=[  219],  5.00th=[  404], 10.00th=[  586], 20.00th=[  832],
     | 30.00th=[ 1012], 40.00th=[ 1156], 50.00th=[ 1336], 60.00th=[ 1582],
     | 70.00th=[ 2008], 80.00th=[ 2671], 90.00th=[ 3720], 95.00th=[ 4686],
     | 99.00th=[ 6783], 99.50th=[ 7767], 99.90th=[12125], 99.95th=[15401],
     | 99.99th=[33817]
   bw (  KiB/s): min=  100, max=44498, per=100.00%, avg=29609.35, stdev=4988.31, samples=96
   iops        : min=   25, max=11124, avg=7401.96, stdev=1247.04, samples=96
  lat (usec)   : 20=0.01%, 50=0.01%, 100=0.01%, 250=1.56%, 500=5.94%
  lat (usec)   : 750=8.75%, 1000=13.06%
  lat (msec)   : 2=40.57%, 4=21.97%, 10=7.96%, 20=0.16%, 50=0.01%
  lat (msec)   : 100=0.01%, 250=0.01%, 1000=0.01%, 2000=0.01%, >=2000=0.01%
  cpu          : usr=0.00%, sys=46.67%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=1.5%, 4=8.9%, 8=58.0%, 16=31.5%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=95.5%, 8=2.2%, 16=2.3%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,360164,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=23.4MiB/s (24.6MB/s), 23.4MiB/s-23.4MiB/s (24.6MB/s-24.6MB/s), io=1407MiB (1475MB), run=60002-60002msec

# 4KB顺序读

D:\>c:\fio\fio\fio --name=random-read --ioengine=windowsaio --rw=read --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-read: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-read: (groupid=0, jobs=1): err= 0: pid=1312: Sat Oct 30 02:42:26 2021
  read: IOPS=11.8k, BW=46.1MiB/s (48.3MB/s)(2766MiB/60001msec)
    slat (usec): min=9, max=3359, avg=25.73, stdev=18.48
    clat (usec): min=9, max=37137, avg=758.01, stdev=583.93
     lat (usec): min=109, max=37162, avg=783.75, stdev=584.80
    clat percentiles (usec):
     |  1.00th=[  147],  5.00th=[  208], 10.00th=[  262], 20.00th=[  375],
     | 30.00th=[  490], 40.00th=[  603], 50.00th=[  717], 60.00th=[  824],
     | 70.00th=[  938], 80.00th=[ 1057], 90.00th=[ 1237], 95.00th=[ 1401],
     | 99.00th=[ 1663], 99.50th=[ 2343], 99.90th=[ 6783], 99.95th=[10421],
     | 99.99th=[16909]
   bw (  KiB/s): min=32996, max=54700, per=100.00%, avg=47296.58, stdev=3546.02, samples=118
   iops        : min= 8249, max=13675, avg=11823.78, stdev=886.47, samples=118
  lat (usec)   : 10=0.01%, 20=0.01%, 50=0.01%, 100=0.05%, 250=8.94%
  lat (usec)   : 500=21.86%, 750=22.33%, 1000=22.27%
  lat (msec)   : 2=23.95%, 4=0.33%, 10=0.21%, 20=0.05%, 50=0.01%
  cpu          : usr=5.00%, sys=90.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=7.1%, 4=28.2%, 8=57.3%, 16=7.3%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=93.3%, 8=0.1%, 16=6.6%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=708142,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=46.1MiB/s (48.3MB/s), 46.1MiB/s-46.1MiB/s (48.3MB/s-48.3MB/s), io=2766MiB (2901MB), run=60001-60001msec

# 4KB顺序写

D:\>c:\fio\fio\fio --name=random-write --ioengine=windowsaio --rw=write --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-write: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread
random-write: Laying out IO file (1 file / 4096MiB)

random-write: (groupid=0, jobs=1): err= 0: pid=2540: Sat Oct 30 02:43:27 2021
  write: IOPS=4289, BW=16.8MiB/s (17.6MB/s)(1006MiB/60010msec); 0 zone resets
    slat (usec): min=134, max=22745, avg=210.38, stdev=95.53
    clat (usec): min=6, max=34614, avg=1859.32, stdev=1074.17
     lat (usec): min=152, max=39000, avg=2069.70, stdev=1083.80
    clat percentiles (usec):
     |  1.00th=[  198],  5.00th=[  247], 10.00th=[  449], 20.00th=[  799],
     | 30.00th=[ 1139], 40.00th=[ 1483], 50.00th=[ 1827], 60.00th=[ 2180],
     | 70.00th=[ 2540], 80.00th=[ 2868], 90.00th=[ 3228], 95.00th=[ 3490],
     | 99.00th=[ 4113], 99.50th=[ 4490], 99.90th=[ 6194], 99.95th=[ 6915],
     | 99.99th=[15401]
   bw (  KiB/s): min=13314, max=18292, per=100.00%, avg=17174.08, stdev=784.88, samples=119
   iops        : min= 3328, max= 4573, avg=4293.07, stdev=196.15, samples=119
  lat (usec)   : 10=0.35%, 20=0.15%, 50=0.01%, 100=0.01%, 250=4.71%
  lat (usec)   : 500=6.92%, 750=6.75%, 1000=7.09%
  lat (msec)   : 2=28.86%, 4=43.93%, 10=1.22%, 20=0.02%, 50=0.01%
  cpu          : usr=1.67%, sys=18.33%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.5%, 2=13.3%, 4=26.5%, 8=53.1%, 16=6.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=93.8%, 8=0.1%, 16=6.2%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,257440,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=16.8MiB/s (17.6MB/s), 16.8MiB/s-16.8MiB/s (17.6MB/s-17.6MB/s), io=1006MiB (1054MB), run=60010-60010msec

# 1MB顺序读

D:\>c:\fio\fio\fio --name=seq-read --ioengine=windowsaio --rw=read --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
seq-read: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=windowsaio, iodepth=1
fio-3.27
Starting 1 thread
seq-read: Laying out IO file (1 file / 16384MiB)

seq-read: (groupid=0, jobs=1): err= 0: pid=1500: Sat Oct 30 02:45:12 2021
  read: IOPS=1009, BW=1009MiB/s (1058MB/s)(59.1GiB/59992msec)
    slat (usec): min=38, max=15026, avg=438.79, stdev=230.48
    clat (usec): min=19, max=60713, avg=522.65, stdev=1027.99
     lat (usec): min=496, max=61028, avg=961.44, stdev=1018.88
    clat percentiles (usec):
     |  1.00th=[  165],  5.00th=[  192], 10.00th=[  206], 20.00th=[  227],
     | 30.00th=[  247], 40.00th=[  297], 50.00th=[  400], 60.00th=[  494],
     | 70.00th=[  578], 80.00th=[  693], 90.00th=[  898], 95.00th=[ 1012],
     | 99.00th=[ 1860], 99.50th=[ 2704], 99.90th=[13173], 99.95th=[24249],
     | 99.99th=[41157]
   bw (  KiB/s): min=75624, max=1410490, per=100.00%, avg=1034463.46, stdev=127259.41, samples=117
   iops        : min=   73, max= 1377, avg=1009.67, stdev=124.33, samples=117
  lat (usec)   : 20=0.01%, 50=0.02%, 100=0.05%, 250=30.69%, 500=29.89%
  lat (usec)   : 750=21.90%, 1000=12.10%
  lat (msec)   : 2=4.44%, 4=0.60%, 10=0.18%, 20=0.07%, 50=0.06%
  lat (msec)   : 100=0.01%
  cpu          : usr=1.67%, sys=36.67%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=60558,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=1009MiB/s (1058MB/s), 1009MiB/s-1009MiB/s (1058MB/s-1058MB/s), io=59.1GiB (63.5GB), run=59992-59992msec

# 1MB顺序写

D:\>c:\fio\fio\fio --name=seq-write --ioengine=windowsaio --rw=write --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
seq-write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=windowsaio, iodepth=1
fio-3.27
Starting 1 thread
seq-write: Laying out IO file (1 file / 16384MiB)

seq-write: (groupid=0, jobs=1): err= 0: pid=2548: Sat Oct 30 02:46:13 2021
  write: IOPS=685, BW=686MiB/s (719MB/s)(40.2GiB/60002msec); 0 zone resets
    slat (usec): min=45, max=17742, avg=1136.73, stdev=1006.24
    clat (usec): min=6, max=33881, avg=298.00, stdev=352.03
     lat (usec): min=586, max=40335, avg=1434.73, stdev=871.99
    clat percentiles (usec):
     |  1.00th=[   12],  5.00th=[   34], 10.00th=[   38], 20.00th=[   45],
     | 30.00th=[   54], 40.00th=[  194], 50.00th=[  281], 60.00th=[  318],
     | 70.00th=[  355], 80.00th=[  412], 90.00th=[  750], 95.00th=[  873],
     | 99.00th=[ 1188], 99.50th=[ 1401], 99.90th=[ 2999], 99.95th=[ 3458],
     | 99.99th=[ 6521]
   bw (  KiB/s): min=336684, max=1247128, per=99.67%, avg=700054.70, stdev=343978.89, samples=116
   iops        : min=  328, max= 1217, avg=683.12, stdev=335.96, samples=116
  lat (usec)   : 10=0.59%, 20=1.12%, 50=25.39%, 100=12.28%, 250=4.27%
  lat (usec)   : 500=41.26%, 750=5.22%, 1000=7.52%
  lat (msec)   : 2=2.16%, 4=0.16%, 10=0.03%, 20=0.01%, 50=0.01%
  cpu          : usr=0.00%, sys=21.67%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,41155,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=686MiB/s (719MB/s), 686MiB/s-686MiB/s (719MB/s-719MB/s), io=40.2GiB (43.2GB), run=60002-60002msec
```

* Windows虚拟机(cache=none,queues=4)

```bash

# 4KB随机读

D:\>c:\fio\fio\fio --name=random-read --ioengine=windowsaio --rw=randread --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-read: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-read: (groupid=0, jobs=1): err= 0: pid=540: Sat Oct 30 03:56:43 2021
  read: IOPS=2794, BW=10.9MiB/s (11.4MB/s)(655MiB/60013msec)
    slat (usec): min=10, max=19968, avg=22.98, stdev=55.80
    clat (usec): min=17, max=74355, avg=5669.51, stdev=5362.47
     lat (usec): min=65, max=74370, avg=5692.49, stdev=5362.73
    clat percentiles (usec):
     |  1.00th=[   93],  5.00th=[  119], 10.00th=[  155], 20.00th=[  375],
     | 30.00th=[ 2376], 40.00th=[ 3654], 50.00th=[ 4883], 60.00th=[ 6194],
     | 70.00th=[ 7439], 80.00th=[ 8586], 90.00th=[11469], 95.00th=[15926],
     | 99.00th=[25035], 99.50th=[29754], 99.90th=[41157], 99.95th=[46400],
     | 99.99th=[56361]
   bw (  KiB/s): min= 9105, max=12389, per=100.00%, avg=11191.02, stdev=483.54, samples=118
   iops        : min= 2276, max= 3097, avg=2797.34, stdev=120.82, samples=118
  lat (usec)   : 20=0.01%, 50=0.01%, 100=1.96%, 250=16.53%, 500=1.96%
  lat (usec)   : 750=0.36%, 1000=0.42%
  lat (msec)   : 2=6.03%, 4=15.47%, 10=44.79%, 20=10.23%, 50=2.22%
  lat (msec)   : 100=0.03%
  cpu          : usr=0.00%, sys=15.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=13.0%, 16=86.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=99.9%, 8=0.1%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=167713,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=10.9MiB/s (11.4MB/s), 10.9MiB/s-10.9MiB/s (11.4MB/s-11.4MB/s), io=655MiB (687MB), run=60013-60013msec

# 4KB随机写

D:\>c:\fio\fio\fio --name=random-write --ioengine=windowsaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-write: (groupid=0, jobs=1): err= 0: pid=560: Sat Oct 30 03:57:43 2021
  write: IOPS=7448, BW=29.1MiB/s (30.5MB/s)(1746MiB/60004msec); 0 zone resets
    slat (usec): min=10, max=10490, avg=20.82, stdev=39.04
    clat (usec): min=8, max=25743, avg=2033.13, stdev=1681.68
     lat (usec): min=90, max=25772, avg=2053.95, stdev=1682.24
    clat percentiles (usec):
     |  1.00th=[  237],  5.00th=[  420], 10.00th=[  553], 20.00th=[  775],
     | 30.00th=[  971], 40.00th=[ 1205], 50.00th=[ 1500], 60.00th=[ 1893],
     | 70.00th=[ 2409], 80.00th=[ 3130], 90.00th=[ 4228], 95.00th=[ 5211],
     | 99.00th=[ 7635], 99.50th=[ 8979], 99.90th=[14222], 99.95th=[16581],
     | 99.99th=[21890]
   bw (  KiB/s): min=21431, max=101105, per=100.00%, avg=29820.11, stdev=6928.42, samples=117
   iops        : min= 5357, max=25276, avg=7454.65, stdev=1732.10, samples=117
  lat (usec)   : 10=0.01%, 20=0.01%, 50=0.01%, 100=0.01%, 250=1.16%
  lat (usec)   : 500=6.64%, 750=10.90%, 1000=12.50%
  lat (msec)   : 2=31.15%, 4=26.13%, 10=11.17%, 20=0.32%, 50=0.02%
  cpu          : usr=0.00%, sys=35.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=0.3%, 4=2.1%, 8=49.2%, 16=48.4%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=97.6%, 8=1.7%, 16=0.7%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,446927,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=29.1MiB/s (30.5MB/s), 29.1MiB/s-29.1MiB/s (30.5MB/s-30.5MB/s), io=1746MiB (1831MB), run=60004-60004msec

# 4KB顺序读

D:\>c:\fio\fio\fio --name=random-read --ioengine=windowsaio --rw=read --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-read: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-read: (groupid=0, jobs=1): err= 0: pid=1128: Sat Oct 30 03:58:44 2021
  read: IOPS=21.1k, BW=82.6MiB/s (86.6MB/s)(4956MiB/60002msec)
    slat (usec): min=9, max=15198, avg=19.43, stdev=22.72
    clat (usec): min=9, max=34197, avg=433.84, stdev=613.35
     lat (usec): min=57, max=34209, avg=453.27, stdev=614.34
    clat percentiles (usec):
     |  1.00th=[   82],  5.00th=[  121], 10.00th=[  155], 20.00th=[  210],
     | 30.00th=[  269], 40.00th=[  326], 50.00th=[  383], 60.00th=[  441],
     | 70.00th=[  498], 80.00th=[  570], 90.00th=[  685], 95.00th=[  791],
     | 99.00th=[ 1045], 99.50th=[ 2073], 99.90th=[ 9110], 99.95th=[13698],
     | 99.99th=[22938]
   bw (  KiB/s): min=43595, max=103126, per=100.00%, avg=84693.01, stdev=9673.83, samples=118
   iops        : min=10898, max=25781, avg=21171.96, stdev=2418.17, samples=118
  lat (usec)   : 10=0.01%, 20=0.01%, 50=0.01%, 100=2.68%, 250=24.04%
  lat (usec)   : 500=43.43%, 750=23.21%, 1000=5.48%
  lat (msec)   : 2=0.65%, 4=0.20%, 10=0.22%, 20=0.07%, 50=0.01%
  cpu          : usr=3.33%, sys=83.33%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=4.7%, 4=27.7%, 8=60.0%, 16=7.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=93.0%, 8=0.1%, 16=6.9%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1268693,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=82.6MiB/s (86.6MB/s), 82.6MiB/s-82.6MiB/s (86.6MB/s-86.6MB/s), io=4956MiB (5197MB), run=60002-60002msec

# 4KB顺序写

D:\>c:\fio\fio\fio --name=random-write --ioengine=windowsaio --rw=write --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-write: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-write: (groupid=0, jobs=1): err= 0: pid=1536: Sat Oct 30 03:59:45 2021
  write: IOPS=25.5k, BW=99.7MiB/s (105MB/s)(5983MiB/60001msec); 0 zone resets
    slat (usec): min=10, max=14796, avg=16.13, stdev=22.73
    clat (usec): min=9, max=30672, avg=367.49, stdev=231.32
     lat (usec): min=59, max=30770, avg=383.62, stdev=233.71
    clat percentiles (usec):
     |  1.00th=[  100],  5.00th=[  131], 10.00th=[  159], 20.00th=[  208],
     | 30.00th=[  258], 40.00th=[  306], 50.00th=[  355], 60.00th=[  400],
     | 70.00th=[  449], 80.00th=[  494], 90.00th=[  570], 95.00th=[  668],
     | 99.00th=[  840], 99.50th=[  930], 99.90th=[ 1614], 99.95th=[ 2474],
     | 99.99th=[ 6194]
   bw (  KiB/s): min=79337, max=116184, per=100.00%, avg=102242.19, stdev=6398.98, samples=118
   iops        : min=19834, max=29046, avg=25560.14, stdev=1599.72, samples=118
  lat (usec)   : 10=0.01%, 20=0.01%, 50=0.01%, 100=1.07%, 250=27.07%
  lat (usec)   : 500=53.16%, 750=16.33%, 1000=2.00%
  lat (msec)   : 2=0.30%, 4=0.04%, 10=0.02%, 20=0.01%, 50=0.01%
  cpu          : usr=0.00%, sys=95.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=1.7%, 4=25.8%, 8=64.1%, 16=8.4%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=92.5%, 8=0.5%, 16=7.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,1531734,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=99.7MiB/s (105MB/s), 99.7MiB/s-99.7MiB/s (105MB/s-105MB/s), io=5983MiB (6274MB), run=60001-60001msec

# 1MB顺序读

D:\>c:\fio\fio\fio --name=seq-read --ioengine=windowsaio --rw=read --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
seq-read: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=windowsaio, iodepth=1
fio-3.27
Starting 1 thread

seq-read: (groupid=0, jobs=1): err= 0: pid=1432: Sat Oct 30 04:00:45 2021
  read: IOPS=930, BW=930MiB/s (975MB/s)(54.5GiB/60001msec)
    slat (usec): min=41, max=3057, avg=62.87, stdev=29.97
    clat (usec): min=38, max=62841, avg=987.57, stdev=1620.63
     lat (usec): min=501, max=62898, avg=1050.44, stdev=1623.78
    clat percentiles (usec):
     |  1.00th=[  523],  5.00th=[  570], 10.00th=[  611], 20.00th=[  668],
     | 30.00th=[  742], 40.00th=[  807], 50.00th=[  848], 60.00th=[  889],
     | 70.00th=[  930], 80.00th=[  971], 90.00th=[ 1156], 95.00th=[ 1336],
     | 99.00th=[ 3130], 99.50th=[ 9765], 99.90th=[26870], 99.95th=[38011],
     | 99.99th=[48497]
   bw (  KiB/s): min=442272, max=1111657, per=100.00%, avg=953627.81, stdev=152555.97, samples=118
   iops        : min=  431, max= 1085, avg=930.76, stdev=149.05, samples=118
  lat (usec)   : 50=0.01%, 250=0.01%, 500=0.31%, 750=30.91%, 1000=52.41%
  lat (msec)   : 2=14.64%, 4=0.83%, 10=0.41%, 20=0.29%, 50=0.18%
  lat (msec)   : 100=0.01%
  cpu          : usr=0.00%, sys=8.33%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=55819,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=930MiB/s (975MB/s), 930MiB/s-930MiB/s (975MB/s-975MB/s), io=54.5GiB (58.5GB), run=60001-60001msec

# 1MB顺序写

D:\>c:\fio\fio\fio --name=seq-write --ioengine=windowsaio --rw=write --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
seq-write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=windowsaio, iodepth=1
fio-3.27
Starting 1 thread

seq-write: (groupid=0, jobs=1): err= 0: pid=1328: Sat Oct 30 04:01:46 2021
  write: IOPS=1013, BW=1014MiB/s (1063MB/s)(59.4GiB/60001msec); 0 zone resets
    slat (usec): min=44, max=3181, avg=80.72, stdev=41.64
    clat (usec): min=22, max=51315, avg=881.05, stdev=487.72
     lat (usec): min=505, max=51424, avg=961.77, stdev=492.14
    clat percentiles (usec):
     |  1.00th=[  562],  5.00th=[  611], 10.00th=[  644], 20.00th=[  693],
     | 30.00th=[  742], 40.00th=[  775], 50.00th=[  807], 60.00th=[  848],
     | 70.00th=[  906], 80.00th=[  979], 90.00th=[ 1106], 95.00th=[ 1270],
     | 99.00th=[ 2245], 99.50th=[ 2966], 99.90th=[ 5932], 99.95th=[ 8225],
     | 99.99th=[15533]
   bw (  KiB/s): min=364575, max=1290773, per=100.00%, avg=1039189.05, stdev=128733.87, samples=118
   iops        : min=  356, max= 1260, avg=1014.40, stdev=125.76, samples=118
  lat (usec)   : 50=0.01%, 250=0.01%, 500=0.08%, 750=33.40%, 1000=48.93%
  lat (msec)   : 2=16.30%, 4=1.03%, 10=0.23%, 20=0.02%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=1.67%, sys=10.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,60822,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=1014MiB/s (1063MB/s), 1014MiB/s-1014MiB/s (1063MB/s-1063MB/s), io=59.4GiB (63.8GB), run=60001-60001msec
```

* Windows虚拟机(cache=writeback)

```bash

# 4KB随机读

D:\>c:\fio\fio\fio --name=random-read --ioengine=windowsaio --rw=randread --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-read: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-read: (groupid=0, jobs=1): err= 0: pid=1860: Sat Oct 30 03:14:35 2021
  read: IOPS=2483, BW=9935KiB/s (10.2MB/s)(582MiB/60021msec)
    slat (usec): min=10, max=5108, avg=25.73, stdev=28.44
    clat (usec): min=11, max=82816, avg=6379.55, stdev=5707.01
     lat (usec): min=66, max=82842, avg=6405.28, stdev=5707.04
    clat percentiles (usec):
     |  1.00th=[   82],  5.00th=[  121], 10.00th=[  215], 20.00th=[ 1647],
     | 30.00th=[ 3097], 40.00th=[ 4359], 50.00th=[ 5604], 60.00th=[ 6783],
     | 70.00th=[ 7963], 80.00th=[ 9241], 90.00th=[13173], 95.00th=[16909],
     | 99.00th=[26608], 99.50th=[32113], 99.90th=[42730], 99.95th=[48497],
     | 99.99th=[58983]
   bw (  KiB/s): min= 7929, max=11486, per=100.00%, avg=9944.61, stdev=582.24, samples=119
   iops        : min= 1982, max= 2871, avg=2485.75, stdev=145.63, samples=119
  lat (usec)   : 20=0.01%, 50=0.02%, 100=2.82%, 250=9.50%, 500=3.95%
  lat (usec)   : 750=0.32%, 1000=0.27%
  lat (msec)   : 2=5.28%, 4=14.95%, 10=47.00%, 20=12.91%, 50=2.94%
  lat (msec)   : 100=0.04%
  cpu          : usr=0.00%, sys=15.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=12.3%, 16=87.6%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.1%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=149075,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=9935KiB/s (10.2MB/s), 9935KiB/s-9935KiB/s (10.2MB/s-10.2MB/s), io=582MiB (611MB), run=60021-60021msec

# 4KB随机写

D:\>c:\fio\fio\fio --name=random-write --ioengine=windowsaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread
random-write: Laying out IO file (1 file / 4096MiB)

random-write: (groupid=0, jobs=1): err= 0: pid=1644: Sat Oct 30 03:15:40 2021
  write: IOPS=7430, BW=29.0MiB/s (30.4MB/s)(1876MiB/64650msec); 0 zone resets
    slat (usec): min=9, max=1857.7k, avg=40.31, stdev=4122.89
    clat (usec): min=8, max=10449k, avg=1079.48, stdev=55621.16
     lat (usec): min=73, max=10449k, avg=1146.62, stdev=58826.07
    clat percentiles (usec):
     |  1.00th=[   95],  5.00th=[  161], 10.00th=[  231], 20.00th=[  367],
     | 30.00th=[  478], 40.00th=[  586], 50.00th=[  693], 60.00th=[  799],
     | 70.00th=[  906], 80.00th=[ 1045], 90.00th=[ 1237], 95.00th=[ 1385],
     | 99.00th=[ 2180], 99.50th=[ 3556], 99.90th=[ 9896], 99.95th=[13566],
     | 99.99th=[52691]
   bw (  KiB/s): min=  200, max=63326, per=100.00%, avg=45994.33, stdev=8566.10, samples=82
   iops        : min=   50, max=15831, avg=11498.26, stdev=2141.49, samples=82
  lat (usec)   : 10=0.01%, 20=0.01%, 50=0.01%, 100=1.17%, 250=10.12%
  lat (usec)   : 500=20.87%, 750=23.48%, 1000=21.39%
  lat (msec)   : 2=21.75%, 4=0.80%, 10=0.33%, 20=0.08%, 50=0.01%
  lat (msec)   : 100=0.01%, 250=0.01%, 500=0.01%, 750=0.01%, 2000=0.01%
  lat (msec)   : >=2000=0.01%
  cpu          : usr=0.00%, sys=54.14%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.7%, 2=10.3%, 4=26.0%, 8=55.6%, 16=7.4%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=93.5%, 8=0.3%, 16=6.2%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,480369,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=29.0MiB/s (30.4MB/s), 29.0MiB/s-29.0MiB/s (30.4MB/s-30.4MB/s), io=1876MiB (1968MB), run=64650-64650msec

# 4KB顺序读

D:\>c:\fio\fio\fio --name=random-read --ioengine=windowsaio --rw=read --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-read: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-read: (groupid=0, jobs=1): err= 0: pid=1708: Sat Oct 30 03:16:40 2021
  read: IOPS=10.9k, BW=42.8MiB/s (44.9MB/s)(2567MiB/60001msec)
    slat (usec): min=9, max=16037, avg=30.37, stdev=80.30
    clat (usec): min=8, max=53075, avg=822.29, stdev=1068.55
     lat (usec): min=70, max=53099, avg=852.66, stdev=1073.29
    clat percentiles (usec):
     |  1.00th=[   87],  5.00th=[  147], 10.00th=[  223], 20.00th=[  367],
     | 30.00th=[  486], 40.00th=[  603], 50.00th=[  717], 60.00th=[  832],
     | 70.00th=[  955], 80.00th=[ 1090], 90.00th=[ 1303], 95.00th=[ 1483],
     | 99.00th=[ 3326], 99.50th=[ 5800], 99.90th=[16188], 99.95th=[20579],
     | 99.99th=[35914]
   bw (  KiB/s): min=16779, max=59060, per=100.00%, avg=43863.93, stdev=7149.84, samples=117
   iops        : min= 4194, max=14765, avg=10965.62, stdev=1787.44, samples=117
  lat (usec)   : 10=0.01%, 20=0.02%, 50=0.01%, 100=1.53%, 250=10.27%
  lat (usec)   : 500=19.37%, 750=21.75%, 1000=20.61%
  lat (msec)   : 2=24.39%, 4=1.25%, 10=0.56%, 20=0.19%, 50=0.06%
  lat (msec)   : 100=0.01%
  cpu          : usr=3.33%, sys=73.33%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.4%, 2=10.8%, 4=25.7%, 8=55.5%, 16=7.5%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=93.5%, 8=0.3%, 16=6.2%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=657055,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=42.8MiB/s (44.9MB/s), 42.8MiB/s-42.8MiB/s (44.9MB/s-44.9MB/s), io=2567MiB (2691MB), run=60001-60001msec

# 4KB顺序写

D:\>c:\fio\fio\fio --name=random-write --ioengine=windowsaio --rw=write --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-write: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-write: (groupid=0, jobs=1): err= 0: pid=1844: Sat Oct 30 03:17:42 2021
  write: IOPS=13.6k, BW=53.0MiB/s (55.6MB/s)(3225MiB/60869msec); 0 zone resets
    slat (usec): min=10, max=31877, avg=24.34, stdev=46.77
    clat (usec): min=12, max=36621, avg=613.12, stdev=460.77
     lat (usec): min=63, max=36729, avg=637.46, stdev=464.13
    clat percentiles (usec):
     |  1.00th=[   76],  5.00th=[  123], 10.00th=[  182], 20.00th=[  281],
     | 30.00th=[  383], 40.00th=[  486], 50.00th=[  586], 60.00th=[  685],
     | 70.00th=[  783], 80.00th=[  898], 90.00th=[ 1057], 95.00th=[ 1188],
     | 99.00th=[ 1401], 99.50th=[ 1549], 99.90th=[ 3523], 99.95th=[ 5211],
     | 99.99th=[15533]
   bw (  KiB/s): min=42653, max=63911, per=100.00%, avg=55109.35, stdev=5005.73, samples=119
   iops        : min=10663, max=15977, avg=13776.94, stdev=1251.41, samples=119
  lat (usec)   : 20=0.01%, 50=0.01%, 100=2.67%, 250=14.12%, 500=24.62%
  lat (usec)   : 750=25.02%, 1000=20.59%
  lat (msec)   : 2=12.77%, 4=0.13%, 10=0.07%, 20=0.01%, 50=0.01%
  cpu          : usr=3.29%, sys=90.36%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.2%, 2=11.5%, 4=26.9%, 8=54.5%, 16=6.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=93.6%, 8=0.1%, 16=6.3%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,825695,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=53.0MiB/s (55.6MB/s), 53.0MiB/s-53.0MiB/s (55.6MB/s-55.6MB/s), io=3225MiB (3382MB), run=60869-60869msec

# 1MB顺序读

D:\>c:\fio\fio\fio --name=seq-read --ioengine=windowsaio --rw=read --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
seq-read: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=windowsaio, iodepth=1
fio-3.27
Starting 1 thread

seq-read: (groupid=0, jobs=1): err= 0: pid=888: Sat Oct 30 03:18:42 2021
  read: IOPS=1993, BW=1994MiB/s (2091MB/s)(117GiB/60001msec)
    slat (usec): min=36, max=6062, avg=138.32, stdev=57.54
    clat (usec): min=8, max=58046, avg=340.18, stdev=1029.30
     lat (usec): min=234, max=58150, avg=478.50, stdev=1032.07
    clat percentiles (usec):
     |  1.00th=[  127],  5.00th=[  145], 10.00th=[  153], 20.00th=[  165],
     | 30.00th=[  176], 40.00th=[  184], 50.00th=[  196], 60.00th=[  210],
     | 70.00th=[  243], 80.00th=[  322], 90.00th=[  750], 95.00th=[  857],
     | 99.00th=[ 1106], 99.50th=[ 1631], 99.90th=[20317], 99.95th=[25035],
     | 99.99th=[35914]
   bw (  MiB/s): min=  354, max= 2937, per=99.77%, avg=1989.21, stdev=953.24, samples=118
   iops        : min=  354, max= 2937, avg=1988.64, stdev=953.24, samples=118
  lat (usec)   : 10=0.01%, 20=0.01%, 50=0.01%, 100=0.53%, 250=70.42%
  lat (usec)   : 500=14.57%, 750=4.65%, 1000=8.18%
  lat (msec)   : 2=1.19%, 4=0.12%, 10=0.14%, 20=0.08%, 50=0.10%
  lat (msec)   : 100=0.01%
  cpu          : usr=1.67%, sys=23.33%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=119635,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=1994MiB/s (2091MB/s), 1994MiB/s-1994MiB/s (2091MB/s-2091MB/s), io=117GiB (125GB), run=60001-60001msec

# 1MB顺序写

D:\>c:\fio\fio\fio --name=seq-write --ioengine=windowsaio --rw=write --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
seq-write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=windowsaio, iodepth=1
fio-3.27
Starting 1 thread

seq-write: (groupid=0, jobs=1): err= 0: pid=752: Sat Oct 30 03:19:59 2021
  write: IOPS=920, BW=920MiB/s (965MB/s)(68.0GiB/75656msec); 0 zone resets
    slat (usec): min=47, max=15591, avg=188.06, stdev=148.77
    clat (usec): min=16, max=99062, avg=648.07, stdev=746.30
     lat (usec): min=520, max=99575, avg=836.12, stdev=754.78
    clat percentiles (usec):
     |  1.00th=[  225],  5.00th=[  420], 10.00th=[  445], 20.00th=[  474],
     | 30.00th=[  502], 40.00th=[  529], 50.00th=[  570], 60.00th=[  611],
     | 70.00th=[  660], 80.00th=[  734], 90.00th=[  848], 95.00th=[  996],
     | 99.00th=[ 1844], 99.50th=[ 2802], 99.90th=[ 8094], 99.95th=[12780],
     | 99.99th=[22414]
   bw (  MiB/s): min=  814, max= 1414, per=100.00%, avg=1163.16, stdev=144.28, samples=117
   iops        : min=  814, max= 1414, avg=1162.67, stdev=144.21, samples=117
  lat (usec)   : 20=0.01%, 50=0.07%, 100=0.07%, 250=1.13%, 500=28.58%
  lat (usec)   : 750=52.20%, 1000=13.03%
  lat (msec)   : 2=4.04%, 4=0.56%, 10=0.24%, 20=0.06%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=1.32%, sys=19.83%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,69621,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=920MiB/s (965MB/s), 920MiB/s-920MiB/s (965MB/s-965MB/s), io=68.0GiB (73.0GB), run=75656-75656msec
```

* Windows虚拟机(cache=writeback,queues=4)

```bash

# 4KB随机读

D:\>c:\fio\fio\fio --name=random-read --ioengine=windowsaio --rw=randread --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-read: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-read: (groupid=0, jobs=1): err= 0: pid=744: Sat Oct 30 03:26:54 2021
  read: IOPS=4520, BW=17.7MiB/s (18.5MB/s)(1060MiB/60018msec)
    slat (usec): min=10, max=11291, avg=21.51, stdev=28.16
    clat (usec): min=7, max=104583, avg=3483.03, stdev=5554.09
     lat (usec): min=40, max=104616, avg=3504.54, stdev=5554.55
    clat percentiles (usec):
     |  1.00th=[   46],  5.00th=[   56], 10.00th=[   65], 20.00th=[   78],
     | 30.00th=[   91], 40.00th=[  113], 50.00th=[  169], 60.00th=[ 1745],
     | 70.00th=[ 4621], 80.00th=[ 7177], 90.00th=[ 9896], 95.00th=[14484],
     | 99.00th=[24773], 99.50th=[29754], 99.90th=[41681], 99.95th=[46400],
     | 99.99th=[58459]
   bw (  KiB/s): min= 9074, max=34435, per=99.64%, avg=18017.24, stdev=8984.02, samples=119
   iops        : min= 2268, max= 8608, avg=4503.92, stdev=2246.05, samples=119
  lat (usec)   : 10=0.01%, 20=0.01%, 50=3.30%, 100=31.72%, 250=20.52%
  lat (usec)   : 500=2.30%, 750=0.30%, 1000=0.19%
  lat (msec)   : 2=2.37%, 4=6.91%, 10=22.64%, 20=7.81%, 50=1.90%
  lat (msec)   : 100=0.03%, 250=0.01%
  cpu          : usr=1.67%, sys=23.33%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=17.5%, 16=82.5%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=99.9%, 8=0.1%, 16=0.1%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=271323,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=17.7MiB/s (18.5MB/s), 17.7MiB/s-17.7MiB/s (18.5MB/s-18.5MB/s), io=1060MiB (1111MB), run=60018-60018msec

# 4KB随机写

D:\>c:\fio\fio\fio --name=random-write --ioengine=windowsaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-write: (g=0): rw=randwrite, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-write: (groupid=0, jobs=1): err= 0: pid=1560: Sat Oct 30 03:28:09 2021
  write: IOPS=18.8k, BW=73.6MiB/s (77.1MB/s)(5516MiB/74982msec); 0 zone resets
    slat (usec): min=10, max=13548, avg=17.65, stdev=20.57
    clat (usec): min=7, max=52330, avg=353.93, stdev=290.90
     lat (usec): min=41, max=52372, avg=371.58, stdev=292.80
    clat percentiles (usec):
     |  1.00th=[   42],  5.00th=[   74], 10.00th=[  108], 20.00th=[  163],
     | 30.00th=[  219], 40.00th=[  277], 50.00th=[  338], 60.00th=[  400],
     | 70.00th=[  457], 80.00th=[  519], 90.00th=[  603], 95.00th=[  693],
     | 99.00th=[  832], 99.50th=[  898], 99.90th=[ 1532], 99.95th=[ 3261],
     | 99.99th=[ 9765]
   bw (  KiB/s): min=69809, max=108038, per=100.00%, avg=94186.97, stdev=5958.06, samples=117
   iops        : min=17452, max=27009, avg=23546.34, stdev=1489.56, samples=117
  lat (usec)   : 10=0.01%, 20=0.01%, 50=2.00%, 100=6.50%, 250=26.64%
  lat (usec)   : 500=42.11%, 750=19.75%, 1000=2.73%
  lat (msec)   : 2=0.18%, 4=0.04%, 10=0.02%, 20=0.01%, 50=0.01%
  lat (msec)   : 100=0.01%
  cpu          : usr=1.33%, sys=74.69%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=10.7%, 4=27.4%, 8=55.0%, 16=6.9%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=93.6%, 8=0.1%, 16=6.4%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,1411978,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=73.6MiB/s (77.1MB/s), 73.6MiB/s-73.6MiB/s (77.1MB/s-77.1MB/s), io=5516MiB (5783MB), run=74982-74982msec

# 4KB顺序读

D:\>c:\fio\fio\fio --name=random-read --ioengine=windowsaio --rw=read --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-read: (g=0): rw=read, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-read: (groupid=0, jobs=1): err= 0: pid=1176: Sat Oct 30 03:29:10 2021
  read: IOPS=23.3k, BW=90.8MiB/s (95.2MB/s)(5450MiB/60001msec)
    slat (usec): min=10, max=7312, avg=17.20, stdev=11.52
    clat (usec): min=8, max=130244, avg=373.35, stdev=982.26
     lat (usec): min=34, max=130256, avg=390.55, stdev=982.72
    clat percentiles (usec):
     |  1.00th=[   40],  5.00th=[   73], 10.00th=[  104], 20.00th=[  155],
     | 30.00th=[  210], 40.00th=[  269], 50.00th=[  330], 60.00th=[  388],
     | 70.00th=[  445], 80.00th=[  506], 90.00th=[  594], 95.00th=[  685],
     | 99.00th=[  848], 99.50th=[ 1004], 99.90th=[ 8848], 99.95th=[17171],
     | 99.99th=[45351]
   bw (  KiB/s): min=12959, max=109779, per=100.00%, avg=93136.24, stdev=12016.94, samples=119
   iops        : min= 3239, max=27444, avg=23283.70, stdev=3004.27, samples=119
  lat (usec)   : 10=0.01%, 20=0.01%, 50=2.48%, 100=6.84%, 250=27.50%
  lat (usec)   : 500=42.20%, 750=18.18%, 1000=2.30%
  lat (msec)   : 2=0.19%, 4=0.10%, 10=0.13%, 20=0.04%, 50=0.03%
  lat (msec)   : 100=0.01%, 250=0.01%
  cpu          : usr=5.00%, sys=88.33%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=10.7%, 4=26.7%, 8=55.2%, 16=7.3%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=93.6%, 8=0.1%, 16=6.3%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=1395265,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
   READ: bw=90.8MiB/s (95.2MB/s), 90.8MiB/s-90.8MiB/s (95.2MB/s-95.2MB/s), io=5450MiB (5715MB), run=60001-60001msec

# 4KB顺序写

D:\>c:\fio\fio\fio --name=random-write --ioengine=windowsaio --rw=write --bs=4k --size=4g --numjobs=1 --iodepth=16 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
random-write: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 4096B-4096B, ioengine=windowsaio, iodepth=16
fio-3.27
Starting 1 thread

random-write: (groupid=0, jobs=1): err= 0: pid=1904: Sat Oct 30 03:30:12 2021
  write: IOPS=21.8k, BW=85.1MiB/s (89.3MB/s)(5307MiB/62348msec); 0 zone resets
    slat (usec): min=10, max=5404, avg=18.20, stdev=14.48
    clat (usec): min=8, max=42255, avg=363.23, stdev=253.82
     lat (usec): min=30, max=42322, avg=381.42, stdev=255.57
    clat percentiles (usec):
     |  1.00th=[   42],  5.00th=[   73], 10.00th=[  105], 20.00th=[  161],
     | 30.00th=[  223], 40.00th=[  285], 50.00th=[  347], 60.00th=[  408],
     | 70.00th=[  469], 80.00th=[  537], 90.00th=[  627], 95.00th=[  725],
     | 99.00th=[  898], 99.50th=[  938], 99.90th=[ 1450], 99.95th=[ 2507],
     | 99.99th=[ 5604]
   bw (  KiB/s): min=67968, max=105995, per=100.00%, avg=90679.54, stdev=7415.13, samples=118
   iops        : min=16992, max=26498, avg=22669.50, stdev=1853.74, samples=118
  lat (usec)   : 10=0.01%, 20=0.01%, 50=2.97%, 100=6.69%, 250=25.02%
  lat (usec)   : 500=39.93%, 750=21.18%, 1000=3.88%
  lat (msec)   : 2=0.26%, 4=0.04%, 10=0.03%, 20=0.01%, 50=0.01%
  cpu          : usr=1.60%, sys=88.22%, ctx=0, majf=0, minf=0
  IO depths    : 1=0.1%, 2=11.9%, 4=27.0%, 8=54.2%, 16=6.8%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=93.7%, 8=0.1%, 16=6.3%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,1358610,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=16

Run status group 0 (all jobs):
  WRITE: bw=85.1MiB/s (89.3MB/s), 85.1MiB/s-85.1MiB/s (89.3MB/s-89.3MB/s), io=5307MiB (5565MB), run=62348-62348msec

# 1MB顺序读

D:\>c:\fio\fio\fio --name=seq-read --ioengine=windowsaio --rw=read --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
seq-read: (g=0): rw=read, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=windowsaio, iodepth=1
fio-3.27
Starting 1 thread

seq-read: (groupid=0, jobs=1): err= 0: pid=1112: Sat Oct 30 03:31:13 2021
  read: IOPS=2628, BW=2628MiB/s (2756MB/s)(154GiB/60001msec)
    slat (usec): min=41, max=5273, avg=62.79, stdev=26.58
    clat (usec): min=9, max=35828, avg=292.48, stdev=202.04
     lat (usec): min=221, max=35886, avg=355.27, stdev=205.63
    clat percentiles (usec):
     |  1.00th=[  208],  5.00th=[  225], 10.00th=[  235], 20.00th=[  249],
     | 30.00th=[  260], 40.00th=[  269], 50.00th=[  277], 60.00th=[  289],
     | 70.00th=[  302], 80.00th=[  318], 90.00th=[  343], 95.00th=[  371],
     | 99.00th=[  529], 99.50th=[  693], 99.90th=[ 1516], 99.95th=[ 2638],
     | 99.99th=[ 8029]
   bw (  MiB/s): min= 1827, max= 2839, per=100.00%, avg=2629.96, stdev=129.75, samples=119
   iops        : min= 1827, max= 2839, avg=2629.53, stdev=129.76, samples=119
  lat (usec)   : 10=0.01%, 20=0.01%, 50=0.01%, 100=0.01%, 250=21.27%
  lat (usec)   : 500=77.55%, 750=0.76%, 1000=0.20%
  lat (msec)   : 2=0.16%, 4=0.02%, 10=0.04%, 20=0.01%, 50=0.01%
  cpu          : usr=0.00%, sys=25.00%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=157697,0,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
   READ: bw=2628MiB/s (2756MB/s), 2628MiB/s-2628MiB/s (2756MB/s-2756MB/s), io=154GiB (165GB), run=60001-60001msec

# 1MB顺序写

D:\>c:\fio\fio\fio --name=seq-write --ioengine=windowsaio --rw=write --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --direct=1 --end_fsync=1 
fio: this platform does not support process shared mutexes, forcing use of threads. Use the 'thread' option to get rid of this warning.
seq-write: (g=0): rw=write, bs=(R) 1024KiB-1024KiB, (W) 1024KiB-1024KiB, (T) 1024KiB-1024KiB, ioengine=windowsaio, iodepth=1
fio-3.27
Starting 1 thread

seq-write: (groupid=0, jobs=1): err= 0: pid=1768: Sat Oct 30 03:32:25 2021
  write: IOPS=1191, BW=1192MiB/s (1250MB/s)(83.1GiB/71391msec); 0 zone resets
    slat (usec): min=47, max=15215, avg=79.43, stdev=97.94
    clat (usec): min=18, max=279462, avg=600.78, stdev=1584.12
     lat (usec): min=434, max=279525, avg=680.21, stdev=1587.71
    clat percentiles (usec):
     |  1.00th=[  424],  5.00th=[  449], 10.00th=[  461], 20.00th=[  482],
     | 30.00th=[  494], 40.00th=[  510], 50.00th=[  523], 60.00th=[  537],
     | 70.00th=[  562], 80.00th=[  586], 90.00th=[  627], 95.00th=[  701],
     | 99.00th=[ 2180], 99.50th=[ 3228], 99.90th=[12387], 99.95th=[16450],
     | 99.99th=[46400]
   bw (  MiB/s): min=  384, max= 1747, per=100.00%, avg=1418.29, stdev=247.74, samples=118
   iops        : min=  384, max= 1747, avg=1417.84, stdev=247.79, samples=118
  lat (usec)   : 20=0.01%, 50=0.01%, 100=0.01%, 250=0.01%, 500=33.56%
  lat (usec)   : 750=62.63%, 1000=1.74%
  lat (msec)   : 2=0.96%, 4=0.73%, 10=0.22%, 20=0.11%, 50=0.02%
  lat (msec)   : 100=0.01%, 250=0.01%, 500=0.01%
  cpu          : usr=1.40%, sys=11.21%, ctx=0, majf=0, minf=0
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     issued rwts: total=0,85092,0,0 short=0,0,0,0 dropped=0,0,0,0
     latency   : target=0, window=0, percentile=100.00%, depth=1

Run status group 0 (all jobs):
  WRITE: bw=1192MiB/s (1250MB/s), 1192MiB/s-1192MiB/s (1250MB/s-1250MB/s), io=83.1GiB (89.2GB), run=71391-71391msec
```

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

##### 测试数据

- 虚拟机到虚拟机

```bash
[cloudroot@testperf ~]$ iperf3 -c 10.127.100.234 -t 30
Connecting to host 10.127.100.234, port 5201
[  4] local 10.127.90.238 port 56856 connected to 10.127.100.234 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec   818 MBytes  6.86 Gbits/sec   32   1.09 MBytes       
[  4]   1.00-2.00   sec  1014 MBytes  8.50 Gbits/sec    0   1.64 MBytes       
[  4]   2.00-3.00   sec  1014 MBytes  8.50 Gbits/sec    0   2.02 MBytes       
[  4]   3.00-4.00   sec   975 MBytes  8.18 Gbits/sec  900   1.71 MBytes       
[  4]   4.00-5.00   sec  1022 MBytes  8.58 Gbits/sec  770   1.65 MBytes       
[  4]   5.00-6.00   sec  1.00 GBytes  8.62 Gbits/sec    0   2.03 MBytes       
[  4]   6.00-7.00   sec  1020 MBytes  8.56 Gbits/sec    0   2.30 MBytes       
[  4]   7.00-8.00   sec  1.03 GBytes  8.82 Gbits/sec    0   2.53 MBytes       
[  4]   8.00-9.00   sec  1004 MBytes  8.42 Gbits/sec    0   2.71 MBytes       
[  4]   9.00-10.00  sec  1018 MBytes  8.54 Gbits/sec  509   2.17 MBytes       
[  4]  10.00-11.00  sec  1.03 GBytes  8.82 Gbits/sec    0   2.42 MBytes       
[  4]  11.00-12.00  sec  1018 MBytes  8.54 Gbits/sec  245   2.61 MBytes       
[  4]  12.00-13.00  sec   994 MBytes  8.33 Gbits/sec  2623   1.08 MBytes       
[  4]  13.00-14.00  sec  1002 MBytes  8.41 Gbits/sec    0   1.63 MBytes       
[  4]  14.00-15.00  sec  1.01 GBytes  8.71 Gbits/sec   76   2.01 MBytes       
[  4]  15.00-16.00  sec  1014 MBytes  8.50 Gbits/sec  647   2.30 MBytes       
[  4]  16.00-17.00  sec  1.01 GBytes  8.66 Gbits/sec   87   1.98 MBytes       
[  4]  17.00-18.00  sec  1.02 GBytes  8.72 Gbits/sec  990   2.28 MBytes       
[  4]  18.00-19.00  sec  1.03 GBytes  8.85 Gbits/sec    0   2.52 MBytes       
[  4]  19.00-20.00  sec  1.01 GBytes  8.65 Gbits/sec    0   2.71 MBytes       
[  4]  20.00-21.00  sec   798 MBytes  6.69 Gbits/sec  1193   2.82 MBytes       
[  4]  21.00-22.00  sec   839 MBytes  7.04 Gbits/sec  971   2.05 MBytes       
[  4]  22.00-23.00  sec   819 MBytes  6.87 Gbits/sec    0   2.24 MBytes       
[  4]  23.00-24.00  sec   951 MBytes  7.98 Gbits/sec  1149   1.53 MBytes       
[  4]  24.00-25.00  sec  1020 MBytes  8.56 Gbits/sec    0   1.94 MBytes       
[  4]  25.00-26.00  sec  1006 MBytes  8.44 Gbits/sec  940   1.69 MBytes       
[  4]  26.00-27.00  sec  1.02 GBytes  8.76 Gbits/sec   35   1.46 MBytes       
[  4]  27.00-28.00  sec  1.04 GBytes  8.90 Gbits/sec    0   1.91 MBytes       
[  4]  28.00-29.00  sec   999 MBytes  8.38 Gbits/sec  540   2.22 MBytes       
[  4]  29.00-30.00  sec  1000 MBytes  8.39 Gbits/sec  1889   1.77 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec  29.1 GBytes  8.33 Gbits/sec  13596             sender
[  4]   0.00-30.00  sec  29.1 GBytes  8.33 Gbits/sec                  receiver
```

- 虚拟机到物理机

```bash
[cloudroot@testperf ~]$ iperf3 -c 10.127.100.4 -t 30
Connecting to host 10.127.100.4, port 5201
[  4] local 10.127.90.238 port 51382 connected to 10.127.100.4 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec   927 MBytes  7.77 Gbits/sec   31   1.03 MBytes       
[  4]   1.00-2.00   sec  1018 MBytes  8.54 Gbits/sec    0   1.60 MBytes       
[  4]   2.00-3.00   sec  1.02 GBytes  8.77 Gbits/sec    0   2.02 MBytes       
[  4]   3.00-4.00   sec   844 MBytes  7.08 Gbits/sec  486   1.38 MBytes       
[  4]   4.00-5.00   sec   844 MBytes  7.08 Gbits/sec    0   1.70 MBytes       
[  4]   5.00-6.00   sec   945 MBytes  7.93 Gbits/sec  1829    512 KBytes       
[  4]   6.00-7.00   sec   836 MBytes  7.01 Gbits/sec  1525   1.58 MBytes       
[  4]   7.00-8.00   sec  1.04 GBytes  8.95 Gbits/sec    0   2.00 MBytes       
[  4]   8.00-9.00   sec  1.01 GBytes  8.66 Gbits/sec  1704   1.46 MBytes       
[  4]   9.00-10.00  sec  1.05 GBytes  9.01 Gbits/sec  160   1.61 MBytes       
[  4]  10.00-11.00  sec   938 MBytes  7.86 Gbits/sec  863   1.48 MBytes       
[  4]  11.00-12.00  sec  1.02 GBytes  8.79 Gbits/sec  814   1.18 MBytes       
[  4]  12.00-13.00  sec  1.04 GBytes  8.89 Gbits/sec    0   1.72 MBytes       
[  4]  13.00-14.00  sec  1.02 GBytes  8.76 Gbits/sec  559   1.71 MBytes       
[  4]  14.00-15.00  sec  1.01 GBytes  8.69 Gbits/sec    0   2.09 MBytes       
[  4]  15.00-16.00  sec  1.01 GBytes  8.71 Gbits/sec  818   1.36 MBytes       
[  4]  16.00-17.00  sec   981 MBytes  8.23 Gbits/sec  979   1.22 MBytes       
[  4]  17.00-18.00  sec  1010 MBytes  8.47 Gbits/sec  625   1003 KBytes       
[  4]  18.00-19.00  sec  1.01 GBytes  8.64 Gbits/sec    0   1.57 MBytes       
[  4]  19.00-20.00  sec  1019 MBytes  8.55 Gbits/sec  968   1.24 MBytes       
[  4]  20.00-21.00  sec  1.05 GBytes  9.01 Gbits/sec    0   1.77 MBytes       
[  4]  21.00-22.00  sec  1.01 GBytes  8.64 Gbits/sec    0   2.15 MBytes       
[  4]  22.00-23.00  sec   992 MBytes  8.33 Gbits/sec  492   1.45 MBytes       
[  4]  23.00-24.00  sec  1.01 GBytes  8.67 Gbits/sec   16   1.89 MBytes       
[  4]  24.00-25.00  sec  1006 MBytes  8.44 Gbits/sec    0   2.23 MBytes       
[  4]  25.00-26.00  sec  1008 MBytes  8.45 Gbits/sec    0   2.47 MBytes       
[  4]  26.00-27.00  sec   984 MBytes  8.25 Gbits/sec  1567   1.87 MBytes       
[  4]  27.00-28.00  sec  1.02 GBytes  8.77 Gbits/sec  361   1.60 MBytes       
[  4]  28.00-29.00  sec  1012 MBytes  8.49 Gbits/sec    0   1.99 MBytes       
[  4]  29.00-30.00  sec  1.04 GBytes  8.97 Gbits/sec  374   1.84 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec  29.4 GBytes  8.41 Gbits/sec  14171             sender
[  4]   0.00-30.00  sec  29.4 GBytes  8.41 Gbits/sec                  receiver
```

- 物理机到虚拟机

```bash
[cloudroot@test-66-onecloud02 ~]$ iperf3 -c 10.127.100.234 -t 30
Connecting to host 10.127.100.234, port 5201
[  4] local 10.127.100.3 port 54230 connected to 10.127.100.234 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec   864 MBytes  7.24 Gbits/sec    7   1004 KBytes
[  4]   1.00-2.00   sec   956 MBytes  8.03 Gbits/sec    0   1.31 MBytes
[  4]   2.00-3.00   sec   985 MBytes  8.25 Gbits/sec    0   1.53 MBytes
[  4]   3.00-4.00   sec  1019 MBytes  8.55 Gbits/sec    0   1.66 MBytes
[  4]   4.00-5.00   sec   999 MBytes  8.38 Gbits/sec    0   1.74 MBytes
[  4]   5.00-6.00   sec  1.01 GBytes  8.70 Gbits/sec    0   1.83 MBytes
[  4]   6.00-7.00   sec  1018 MBytes  8.54 Gbits/sec    0   1.90 MBytes
[  4]   7.00-8.00   sec  1019 MBytes  8.54 Gbits/sec    0   1.97 MBytes
[  4]   8.00-9.00   sec  1024 MBytes  8.59 Gbits/sec    0   2.00 MBytes
[  4]   9.00-10.00  sec  1020 MBytes  8.56 Gbits/sec    0   2.05 MBytes
[  4]  10.00-11.00  sec   991 MBytes  8.31 Gbits/sec    0   2.06 MBytes
[  4]  11.00-12.00  sec  1.01 GBytes  8.65 Gbits/sec    0   2.07 MBytes
[  4]  12.00-13.00  sec  1018 MBytes  8.53 Gbits/sec    0   2.10 MBytes
[  4]  13.00-14.00  sec  1.00 GBytes  8.63 Gbits/sec    0   2.12 MBytes
[  4]  14.00-15.00  sec   996 MBytes  8.35 Gbits/sec    0   2.14 MBytes
[  4]  15.00-16.00  sec   804 MBytes  6.75 Gbits/sec  492   1.95 MBytes
[  4]  16.00-17.00  sec   982 MBytes  8.24 Gbits/sec    0   2.15 MBytes
[  4]  17.00-18.00  sec  1021 MBytes  8.57 Gbits/sec    0   2.43 MBytes
[  4]  18.00-19.00  sec  1020 MBytes  8.55 Gbits/sec    0   2.47 MBytes
[  4]  19.00-20.00  sec  1.00 GBytes  8.61 Gbits/sec  110   1.90 MBytes
[  4]  20.00-21.00  sec  1006 MBytes  8.44 Gbits/sec    0   2.05 MBytes
[  4]  21.00-22.00  sec  1.01 GBytes  8.65 Gbits/sec    0   2.18 MBytes
[  4]  22.00-23.00  sec  1006 MBytes  8.45 Gbits/sec    0   2.27 MBytes
[  4]  23.00-24.00  sec  1.01 GBytes  8.71 Gbits/sec    0   2.34 MBytes
[  4]  24.00-25.00  sec  1.01 GBytes  8.66 Gbits/sec    0   2.39 MBytes
[  4]  25.00-26.00  sec  1024 MBytes  8.60 Gbits/sec    0   2.44 MBytes
[  4]  26.00-27.00  sec   985 MBytes  8.26 Gbits/sec    0   2.46 MBytes
[  4]  27.00-28.00  sec  1.01 GBytes  8.65 Gbits/sec  209   1.82 MBytes
[  4]  28.00-29.00  sec  1011 MBytes  8.48 Gbits/sec    0   1.92 MBytes
[  4]  29.00-30.00  sec  1016 MBytes  8.52 Gbits/sec    0   1.98 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec  29.3 GBytes  8.40 Gbits/sec  818             sender
[  4]   0.00-30.00  sec  29.3 GBytes  8.40 Gbits/sec                  receiver
```

- 物理机到物理机

```bash
[cloudroot@test-66-onecloud02 ~]$ iperf3 -c 10.127.100.4 -t 30
Connecting to host 10.127.100.4, port 5201
[  4] local 10.127.100.3 port 34186 connected to 10.127.100.4 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec   966 MBytes  8.10 Gbits/sec   17    691 KBytes
[  4]   1.00-2.00   sec   995 MBytes  8.35 Gbits/sec   48    991 KBytes
[  4]   2.00-3.00   sec  1.01 GBytes  8.64 Gbits/sec  429    878 KBytes
[  4]   3.00-4.00   sec   979 MBytes  8.21 Gbits/sec   99    857 KBytes
[  4]   4.00-5.00   sec   972 MBytes  8.16 Gbits/sec    0   1.05 MBytes
[  4]   5.00-6.00   sec   994 MBytes  8.34 Gbits/sec    0   1.24 MBytes
[  4]   6.00-7.00   sec  1011 MBytes  8.48 Gbits/sec  131    868 KBytes
[  4]   7.00-8.00   sec  1016 MBytes  8.53 Gbits/sec  242   1.08 MBytes
[  4]   8.00-9.00   sec   945 MBytes  7.92 Gbits/sec  280    921 KBytes
[  4]   9.00-10.00  sec   962 MBytes  8.07 Gbits/sec   79   1.14 MBytes
[  4]  10.00-11.00  sec   985 MBytes  8.26 Gbits/sec  568    824 KBytes
[  4]  11.00-12.00  sec   922 MBytes  7.73 Gbits/sec  239    700 KBytes
[  4]  12.00-13.00  sec   990 MBytes  8.32 Gbits/sec  217    799 KBytes
[  4]  13.00-14.00  sec   998 MBytes  8.37 Gbits/sec  157    949 KBytes
[  4]  14.00-15.00  sec   948 MBytes  7.94 Gbits/sec  126    901 KBytes
[  4]  15.00-16.00  sec  1015 MBytes  8.52 Gbits/sec    0   1.18 MBytes
[  4]  16.00-17.00  sec  1019 MBytes  8.53 Gbits/sec  146   1.34 MBytes
[  4]  17.00-18.00  sec  1.00 GBytes  8.63 Gbits/sec   19   1.45 MBytes
[  4]  18.00-19.00  sec   979 MBytes  8.21 Gbits/sec  270    915 KBytes
[  4]  19.00-20.00  sec   988 MBytes  8.28 Gbits/sec  179    823 KBytes
[  4]  20.00-21.00  sec  1021 MBytes  8.56 Gbits/sec  184    689 KBytes
[  4]  21.00-22.00  sec  1000 MBytes  8.39 Gbits/sec    0   1.10 MBytes
[  4]  22.00-23.00  sec  1.02 GBytes  8.77 Gbits/sec  410    946 KBytes
[  4]  23.00-24.00  sec   979 MBytes  8.21 Gbits/sec  120    906 KBytes
[  4]  24.00-25.00  sec  1022 MBytes  8.57 Gbits/sec  431    892 KBytes
[  4]  25.00-26.00  sec   988 MBytes  8.29 Gbits/sec  103    930 KBytes
[  4]  26.00-27.00  sec  1.01 GBytes  8.68 Gbits/sec   22    870 KBytes
[  4]  27.00-28.00  sec  1.02 GBytes  8.74 Gbits/sec  360    700 KBytes
[  4]  28.00-29.00  sec   988 MBytes  8.28 Gbits/sec    0   1.09 MBytes
[  4]  29.00-30.00  sec   990 MBytes  8.31 Gbits/sec   49   1.27 MBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec  29.2 GBytes  8.35 Gbits/sec  4925             sender
[  4]   0.00-30.00  sec  29.1 GBytes  8.35 Gbits/sec                  receiver
```

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

##### 测试数据

- 物理机到物理机:

```bash
[root@x86-node06 ~]# iperf3 -c 10.90.0.47 -t 30
Connecting to host 10.90.0.47, port 5201
[  4] local 10.90.0.46 port 40526 connected to 10.90.0.47 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  1.08 GBytes  9.27 Gbits/sec  476    503 KBytes       
[  4]   1.00-2.00   sec  1.09 GBytes  9.35 Gbits/sec    0    720 KBytes       
[  4]   2.00-3.00   sec  1.09 GBytes  9.33 Gbits/sec  205    711 KBytes       
[  4]   3.00-4.00   sec  1.09 GBytes  9.33 Gbits/sec   90    758 KBytes       
[  4]   4.00-5.00   sec  1.09 GBytes  9.34 Gbits/sec  145    706 KBytes       
[  4]   5.00-6.00   sec  1.08 GBytes  9.26 Gbits/sec    3    535 KBytes       
[  4]   6.00-7.00   sec  1.08 GBytes  9.23 Gbits/sec   45    730 KBytes       
[  4]   7.00-8.00   sec  1.08 GBytes  9.28 Gbits/sec  308    752 KBytes       
[  4]   8.00-9.00   sec  1.07 GBytes  9.21 Gbits/sec    0    904 KBytes       
[  4]   9.00-10.00  sec  1.06 GBytes  9.12 Gbits/sec  413    839 KBytes       
[  4]  10.00-11.00  sec  1.09 GBytes  9.31 Gbits/sec    0    981 KBytes       
[  4]  11.00-12.00  sec  1.07 GBytes  9.22 Gbits/sec    0   1020 KBytes       
[  4]  12.00-13.00  sec  1.07 GBytes  9.21 Gbits/sec  448    840 KBytes       
[  4]  13.00-14.00  sec  1.09 GBytes  9.33 Gbits/sec    0    938 KBytes       
[  4]  14.00-15.00  sec   862 MBytes  7.23 Gbits/sec  182   1.36 MBytes       
[  4]  15.00-16.00  sec  1.07 GBytes  9.16 Gbits/sec    0   1.79 MBytes       
[  4]  16.00-17.00  sec  1.09 GBytes  9.40 Gbits/sec    0   1.79 MBytes       
[  4]  17.00-18.00  sec  1.07 GBytes  9.16 Gbits/sec  441   1.32 MBytes       
[  4]  18.00-19.00  sec  1.05 GBytes  9.06 Gbits/sec   53   1.03 MBytes       
[  4]  19.00-20.00  sec  1.09 GBytes  9.35 Gbits/sec    0   1.11 MBytes       
[  4]  20.00-21.00  sec  1.07 GBytes  9.22 Gbits/sec  244    798 KBytes       
[  4]  21.00-22.00  sec  1.08 GBytes  9.29 Gbits/sec    0    916 KBytes       
[  4]  22.00-23.00  sec  1.08 GBytes  9.29 Gbits/sec  337    481 KBytes       
[  4]  23.00-24.00  sec  1.07 GBytes  9.21 Gbits/sec    0    868 KBytes       
[  4]  24.00-25.00  sec  1.09 GBytes  9.35 Gbits/sec    0    952 KBytes       
[  4]  25.00-26.00  sec  1.08 GBytes  9.25 Gbits/sec    0    991 KBytes       
[  4]  26.00-27.00  sec  1.04 GBytes  8.93 Gbits/sec    0   1015 KBytes       
[  4]  27.00-28.00  sec  1.09 GBytes  9.41 Gbits/sec    0   1.02 MBytes       
[  4]  28.00-29.00  sec  1.06 GBytes  9.09 Gbits/sec  670    773 KBytes       
[  4]  29.00-30.00  sec  1.09 GBytes  9.39 Gbits/sec    0    926 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec  32.1 GBytes  9.19 Gbits/sec  4060             sender
[  4]   0.00-30.00  sec  32.1 GBytes  9.19 Gbits/sec                  receiver
```

- 虚拟机到虚拟机:

```bash
[cloudroot@test-eip-46 ~]$ iperf3 -c 10.0.123.241 -t 30
Connecting to host 10.0.123.241, port 5201
[  4] local 10.0.123.242 port 57238 connected to 10.0.123.241 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec  1.01 GBytes  8.66 Gbits/sec   30   1.67 MBytes       
[  4]   1.00-2.00   sec  1.03 GBytes  8.87 Gbits/sec  208   1.61 MBytes       
[  4]   2.00-3.00   sec  1.05 GBytes  9.02 Gbits/sec    7   1.57 MBytes       
[  4]   3.00-4.00   sec  1.05 GBytes  9.04 Gbits/sec    1   1.52 MBytes       
[  4]   4.00-5.00   sec  1.03 GBytes  8.86 Gbits/sec  189   1.40 MBytes       
[  4]   5.00-6.00   sec  1.04 GBytes  8.95 Gbits/sec   24   1.35 MBytes       
[  4]   6.00-7.00   sec  1.01 GBytes  8.65 Gbits/sec    0   1.81 MBytes       
[  4]   7.00-8.00   sec  1.05 GBytes  9.03 Gbits/sec    4   1.76 MBytes       
[  4]   8.00-9.00   sec  1.04 GBytes  8.98 Gbits/sec    3   1.69 MBytes       
[  4]   9.00-10.00  sec  1.05 GBytes  9.03 Gbits/sec    6   1.62 MBytes       
[  4]  10.00-11.00  sec  1.04 GBytes  8.97 Gbits/sec    3   1.53 MBytes       
[  4]  11.00-12.00  sec  1.05 GBytes  8.99 Gbits/sec   15   1.46 MBytes       
[  4]  12.00-13.00  sec  1.05 GBytes  9.03 Gbits/sec    2   1.36 MBytes       
[  4]  13.00-14.00  sec  1.04 GBytes  8.97 Gbits/sec  708   1.37 MBytes       
[  4]  14.00-15.00  sec  1.04 GBytes  8.95 Gbits/sec  771   1.39 MBytes       
[  4]  15.00-16.00  sec  1.05 GBytes  9.01 Gbits/sec    0   1.86 MBytes       
[  4]  16.00-17.00  sec  1.05 GBytes  9.03 Gbits/sec   19   1.79 MBytes       
[  4]  17.00-18.00  sec  1.05 GBytes  9.04 Gbits/sec    2   1.72 MBytes       
[  4]  18.00-19.00  sec  1.05 GBytes  9.02 Gbits/sec    2   1.66 MBytes       
[  4]  19.00-20.00  sec  1.05 GBytes  9.03 Gbits/sec   22   1.57 MBytes       
[  4]  20.00-21.00  sec  1.05 GBytes  9.01 Gbits/sec    8   1.48 MBytes       
[  4]  21.00-22.00  sec  1.04 GBytes  8.95 Gbits/sec    1   1.39 MBytes       
[  4]  22.00-23.00  sec  1.05 GBytes  9.01 Gbits/sec    2   1.32 MBytes       
[  4]  23.00-24.00  sec  1.04 GBytes  8.97 Gbits/sec    0   1.80 MBytes       
[  4]  24.00-25.00  sec  1.05 GBytes  9.02 Gbits/sec    3   1.76 MBytes       
[  4]  25.00-26.00  sec  1.02 GBytes  8.74 Gbits/sec    3   1.67 MBytes       
[  4]  26.00-27.00  sec  1.04 GBytes  8.91 Gbits/sec   16   1.58 MBytes       
[  4]  27.00-28.00  sec  1.05 GBytes  9.01 Gbits/sec    2   1.48 MBytes       
[  4]  28.00-29.00  sec  1.04 GBytes  8.98 Gbits/sec    0   1.93 MBytes       
[  4]  29.00-30.00  sec  1.05 GBytes  9.03 Gbits/sec    1   1.80 MBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec  31.3 GBytes  8.96 Gbits/sec  2052             sender
[  4]   0.00-30.00  sec  31.3 GBytes  8.96 Gbits/sec                  receiver
```

虚拟机EIP到虚拟机EIP：

```bash
[cloudroot@test-eip-46 ~]$ iperf3 -c 100.89.2.2 -t 30
Connecting to host 100.89.2.2, port 5201
[  4] local 10.0.123.242 port 55730 connected to 100.89.2.2 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-1.00   sec   663 MBytes  5.56 Gbits/sec  212    756 KBytes       
[  4]   1.00-2.00   sec   694 MBytes  5.82 Gbits/sec   55    706 KBytes       
[  4]   2.00-3.00   sec   688 MBytes  5.77 Gbits/sec  111    795 KBytes       
[  4]   3.00-4.00   sec   694 MBytes  5.82 Gbits/sec   26    778 KBytes       
[  4]   4.00-5.00   sec   696 MBytes  5.84 Gbits/sec   32    744 KBytes       
[  4]   5.00-6.00   sec   696 MBytes  5.84 Gbits/sec   23    965 KBytes       
[  4]   6.00-7.00   sec   692 MBytes  5.81 Gbits/sec   47    930 KBytes       
[  4]   7.00-8.00   sec   695 MBytes  5.83 Gbits/sec   30    884 KBytes       
[  4]   8.00-9.00   sec   672 MBytes  5.64 Gbits/sec   56    863 KBytes       
[  4]   9.00-10.00  sec   681 MBytes  5.71 Gbits/sec   22    827 KBytes       
[  4]  10.00-11.00  sec   685 MBytes  5.75 Gbits/sec   64    775 KBytes       
[  4]  11.00-12.00  sec   674 MBytes  5.65 Gbits/sec   92    790 KBytes       
[  4]  12.00-13.00  sec   688 MBytes  5.77 Gbits/sec   28    766 KBytes       
[  4]  13.00-14.00  sec   696 MBytes  5.84 Gbits/sec   39    741 KBytes       
[  4]  14.00-15.00  sec   681 MBytes  5.71 Gbits/sec   13   1003 KBytes       
[  4]  15.00-16.00  sec   685 MBytes  5.75 Gbits/sec   60    714 KBytes       
[  4]  16.00-17.00  sec   635 MBytes  5.33 Gbits/sec   12   1000 KBytes       
[  4]  17.00-18.00  sec   704 MBytes  5.90 Gbits/sec  206    721 KBytes       
[  4]  18.00-19.00  sec   688 MBytes  5.77 Gbits/sec   52    741 KBytes       
[  4]  19.00-20.00  sec   694 MBytes  5.82 Gbits/sec   12    753 KBytes       
[  4]  20.00-21.00  sec   728 MBytes  6.10 Gbits/sec   35    747 KBytes       
[  4]  21.00-22.00  sec   714 MBytes  5.99 Gbits/sec  117    759 KBytes       
[  4]  22.00-23.00  sec   726 MBytes  6.09 Gbits/sec   86    797 KBytes       
[  4]  23.00-24.00  sec   731 MBytes  6.13 Gbits/sec   43    772 KBytes       
[  4]  24.00-25.00  sec   708 MBytes  5.94 Gbits/sec   24    719 KBytes       
[  4]  25.00-26.00  sec   696 MBytes  5.84 Gbits/sec   61   1019 KBytes       
[  4]  26.00-27.00  sec   725 MBytes  6.08 Gbits/sec   41    760 KBytes       
[  4]  27.00-28.00  sec   711 MBytes  5.97 Gbits/sec   17    744 KBytes       
[  4]  28.00-29.00  sec   695 MBytes  5.83 Gbits/sec   18    791 KBytes       
[  4]  29.00-30.00  sec   710 MBytes  5.96 Gbits/sec   11    806 KBytes       
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-30.00  sec  20.4 GBytes  5.83 Gbits/sec  1645             sender
[  4]   0.00-30.00  sec  20.4 GBytes  5.83 Gbits/sec                  receiver
```
