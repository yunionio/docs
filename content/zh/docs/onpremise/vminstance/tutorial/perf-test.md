---
title: "虚拟机性能测试"
date: 2019-07-19T17:38:36+08:00
weight: 41
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
- iperf: 测试网络性能

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

### IO 测试

TODO

### 网络测试


结论:

| 指标 | 物理机到物理机 | 虚拟机到物理机 | 虚拟机到虚拟机 | 开销 |
|------|----------------|----------------|----------------|------|
| 带宽 | 7.82 Gbits/sec | 7.11 Gbits/sec | 7.04 Gbits/sec | 9%   |

测试方法:

默认情况下虚拟机有流量限制，需要在前端或者用命令行工具 `climc server-change-bandwidth` 把带宽改为 0 ，表示取消限速。

```bash
# 找一台机器运行 iperf server 模式，假设 ip 是 10.127.100.3
$ iperf -s --bind 10.127.100.3

# 在另外一台机器作为 iperf client 模式连接 server
$ iperf -c 10.127.100.3
```

结果:

- 物理机到物理机:

```bash
Interval       Transfer     Bandwidth
0.0-10.0 sec  9.11 GBytes  7.82 Gbits/sec
```

- 虚拟机到物理机:

```bash
Interval       Transfer     Bandwidth
0.0-10.0 sec  8.29 GBytes  7.11 Gbits/sec
```

- 虚拟机到虚拟机:

```bash
Interval       Transfer     Bandwidth
0.0-10.0 sec  8.20 GBytes  7.04 Gbits/sec
```
