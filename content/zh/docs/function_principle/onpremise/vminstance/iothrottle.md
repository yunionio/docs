---
title: "磁盘限速"
weight: 90
description: >
  本文介绍如何配置磁盘限速
---

磁盘限速可以为虚机的每个磁盘限制 IOPS 和 BPS。

## 设置磁盘限速

```bash
# 获取虚机的磁盘 id
$ climc server-disk-list --server 8c387da0-2627-4c65-8c8c-0c241eadb5df
+--------------------------------------+--------------------------------------+--------+------------+-------+------------+
|               Guest_ID               |               Disk_ID                | Driver | Cache_mode | Index | Boot_index |
+--------------------------------------+--------------------------------------+--------+------------+-------+------------+
| 8c387da0-2627-4c65-8c8c-0c241eadb5df | 229e2063-139a-4750-8842-3a681193d42c | scsi   | none       | 0     | -1         |
+--------------------------------------+--------------------------------------+--------+------------+-------+------------+

# 设置磁盘限速
$ climc server-io-throttle --help
Usage: climc server-io-throttle [--iops IOPS] [--help] [--bps BPS] <ID>

Guest io set throttle

Positional arguments:
    <ID>
        ID or name of the server

Optional arguments:
    [--iops IOPS]
        disk iops of throttle, input diskId=IOPS
    [--help]
        Print usage and this help message and exit.
    [--bps BPS]
        disk bps of throttle, input diskId=BPS

# 注意bps 单位为 byte/s
# 设置磁盘 iops 为 10000
$ climc server-io-throttle --iops 229e2063-139a-4750-8842-3a681193d42c=10000 8c387da0-2627-4c65-8c8c-0c241eadb5df

```

如果需要取消限速，则设置 iops 和 bps 为 0：

```bash
$ climc server-io-throttle --iops 229e2063-139a-4750-8842-3a681193d42c=0  --bps 229e2063-139a-4750-8842-3a681193d42c=0 8c387da0-2627-4c65-8c8c-0c241eadb5df
```

如果有多个磁盘需要设置，只需要添加命令行 --iops <DISK_ID>=iops 或则 --bps <DISK_ID>=bps, eg:
```bash
climc server-io-throttle --iops <DISK_1>=iops1 --iops <DISK_2>=iops2 --bps <DISK_1>=bps1 --bps <DISK_2>=bps2 <GUEST_ID>
```


