---
title: "外部数据导入"
weight: 9
description: 介绍如何设定外部数据
---

## 说明
- 外部数据导入仅支持只读操作
- 外部数据导入需要数据源是指定的数据结构
- 外部数据源资源与资源直接需要存在直接的关联关系
- 外部数据源数据文件必须是指定的文件名

## 以下以资源层级举例资源信息

## 通用字段说明

有些字段是各个资源都具备的，这里根据每个字段加以说明

emulate(bool): 是否是虚拟资源, 同步资源后会根据字段判断是否需要隐藏资源
created_at(time): 资源创建时间
tags(map[string]string) 资源标签
sys_tags(map[string]string) 系统标签


### 区域(region)

文件名: regions.json
此文件必须要存在

内容举例:
```json
[
    {
        "id":"area-1",
        "name":"区域一"
    },
    {
        "id":"area-2",
        "name":"区域二"
    }
]
```

### 可用区(zone)

文件名: zones.json
若需要导入虚拟机信息，此文件必须存在

内容举例:
```json
[
    {
        "id":"area-zone-1",
        "region_id": "area-1"
        "name":"可用区一"
    },
    {
        "id":"area-2",
        "region_id": "area-2"
        "name":"可用区二"
    }
]
```

region_id必须存在且能对应到region文件中的id

### 专有网络(vpc)

文件名 vpcs.json

内容举例:
```json
[
    {
        "id":"vpc-1",
        "region_id": "area-1"
        "name":"Test-Vpc"
        "cidr": "192.168.1.0/24"
    },
    {
        "id":"vpc-2",
        "region_id": "area-2"
        "name":"vpc-2"
        "cidr": "192.168.13.0/24"
    }
]
```

region_id必须存在且能对应到region文件中的id

### 宿主机(host)

文件名: hosts.json

内容举例:
```json
[
    {
        "id":"host-1",
        "zone_id": "area-zone-1"
        "name":"Test-Vpc"
        "enabled": true,
        "host_status": "online/offline",
        "access_ip": "",
        "access_mac": "",
        "sn": "",
        "cpu_count": 1,
        "node_count": 2,
        "cpu_desc": "",
        "cpu_mhz": 10000,
        "mem_size_mb": 10000,
        "storage_size_mb": 10000,
    },
    {
        "id":"host-2",
        "zone_id": "area-zone-2"
        "name":"vpc-2"
    }
]
```

zone_id必须存在且能对应到zone文件中的id


### 虚拟机(instance)

文件名 instances.json
