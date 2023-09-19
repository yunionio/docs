---
title: "网卡附属IP(SubIPs)"
weight: 2000
description: >
  介绍虚拟网卡的附属IP
---

默认情况下，虚拟机的虚拟网卡只能分配一个IP，但可以通过如下方式给一个网卡分配诺干个附属IP，平台默认会检查虚拟机网卡流量的源IP进行检查，通过附属IP，可以允许在虚拟机内使用多个IP。

申请附属IP的API为：

```
POST /servers/<sid>/add-sub-ips

{
    "mac": "aa:bb:cc:dd:ee:ff",
    "count": 10,
    "sub_ips": ["192.168.20.2", "192.168.20.3"],
}
```

也可以通过climc为虚拟机的指定网卡申请附属IP：

```
climc server-add-sub-ips <sid> --mac "aa:bb:cc:dd:ee:ff" --count 10 --sub-ips 192.168.20.2 --sub-ips 192.168.20.3
```

查看附属IP：

```
climc server-network-show <sid> <nid> --mac <mac>
```

删除附属IP：

```
DELETE /networkaddress/<id>
```

```
climc networkaddress-delete <id1> <id2> ...
```

一般分配的附属IP用于虚拟机内容器的IP，允许容器直接使用和虚拟机网络同一平面的IP，避免额外的容器网络虚拟化带来的性能开销。