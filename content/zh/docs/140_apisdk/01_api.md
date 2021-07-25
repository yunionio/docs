---
title: "API调用方法"
date: 2019-07-11T20:39:39+08:00
weight: 1
description: >
  介绍Cloudpods API调用方法
---

本章节介绍Cloudpods API的调用方法。

[详细的API内容请参考API](../swagger)。

## 请求方法

不同类型的API使用不同的请求方法，如下所示

API类型 | 请求方法
------- | -------
查询资源 | GET
更新资源 | PUT
创建资源 | POST
删除资源 | DELETE

## 公共请求头

头域 | 是否必须 | 说明
------- | ------- | -------
X-Auth-Token | 必须 | 使用keystone v3认证机制
Content-Type | 必须 | 应该总是application/json

## 公共响应头

头域 | 说明
------- | -------
Content-Type | 总是application/json; charset=UTF-8
X-Request-Id | 对应请求的requestId

## API调用方法

API调用分为两个步骤：

1. 调用Keystone的认证接口，获得token（如果已经获得token，并且在token有效期内，则可以跳过该步骤）

2. 调用接口，此时需要第1步获得的服务访问地址以及token，将token作为请求header的X-Auth-Token参数中保存。


## keystone认证

### 认证信息

方法 | API | 说明
---- | ---- | ----
POST | /v3/auth/tokens | 获取认证信息

### 请求示例

```bash
> POST /v3/auth/tokens HTTP/1.1
> Host: 192.168.0.246:5000
> Content-Type: application/json

{
  "auth": {
    "context": {
      "ip": "string",
      "source": "string"
    },
    "identity": {
      "access_key_secret": "string",
      "cas_ticket": {
        "id": "string"
      },
      "methods": [
        "string"
      ],
      "password": {
        "user": {
          "Domain": {
            "id": "string",
            "name": "string"
          },
          "id": "string",
          "name": "string",
          "password": "string"
        }
      },
      "token": {
        "id": "string"
      }
    },
    "scope": {
      "domain": {
        "id": "string",
        "name": "string"
      },
      "project": {
        "domain": {
          "id": "string",
          "name": "string"
        },
        "id": "string",
        "name": "string"
      }
    }
  }
}
```

### 返回示例

```bash
< HTTP/1.1 201 Created
< Date: Thu, 12 Jul 2018 10:04:10 GMT
< Server: Apache/2.4.6 (CentOS) PHP/5.6.24 mod_wsgi/3.4 Python/2.7.5
< X-Subject-Token: gAAAAABbRyeaDF-FJj_roQXFXA2KLILvQbAxUcQ4TjT65UGL9C2v3jfDqfhWix9UURZ0TkIN0q_8GF5EjNxTTIEdh2k5vtqgCImYKtf_WKA03C8vlb1tl6gNukyxmH7yNiFZQFvXLHTo8ZPyL1vvI9m_bnW5NxTpCI9JVyTDe3BG_BG9gW8Lrsg
< Vary: X-Auth-Token
< x-openstack-request-id: req-3ed7d320-956e-4ee7-a424-d3d3b12a4bf7
< Content-Length: 3514
< Content-Type: application/json
<
* Connection #0 to host 10.168.222.209 left intact
{
  "token": {
    "access_key": {
      "AccessKey": "string",
      "expire": 0,
      "secret": "string"
    },
    "catalog": [
      {
        "endpoints": [
          {
            "id": "75f4e36100184a5a8a3e36cb0f12aa87",
            "interface": "string",
            "name": "string",
            "region": "string",
            "region_id": "string",
            "url": "string"
          }
        ],
        "id": "string",
        "name": "string",
        "type": "string"
      }
    ],
    "context": {
      "ip": "string",
      "source": "string"
    },
    "expires_at": "2020-07-21T07:32:39Z",
    "is_domain": true,
    "issued_at": "2020-07-21T07:32:39Z",
    "methods": [
      "string"
    ],
    "policies": {
      "Domain": [
        "string"
      ],
      "Project": [
        "string"
      ],
      "System": [
        "string"
      ]
    },
    "project": {
      "Domain": {
        "id": "string",
        "name": "string"
      },
      "Id": "string",
      "Name": "string"
    },
    "projects": [
      {
        "Domain": {
          "id": "string",
          "name": "string"
        },
        "Id": "string",
        "Name": "string"
      }
    ],
    "role_assignments": [
      {
        "group": {
          "domain": {
            "id": "string",
            "name": "string"
          },
          "id": "string",
          "name": "string"
        },
        "policies": {
          "domain": [
            "string"
          ],
          "project": [
            "string"
          ],
          "system": [
            "string"
          ]
        },
        "role": {
          "domain": {
            "id": "string",
            "name": "string"
          },
          "id": "string",
          "name": "string"
        },
        "scope": {
          "domain": {
            "id": "string",
            "name": "string"
          },
          "project": {
            "domain": {
              "id": "string",
              "name": "string"
            },
            "id": "string",
            "name": "string"
          }
        },
        "user": {
          "domain": {
            "id": "string",
            "name": "string"
          },
          "id": "string",
          "name": "string"
        }
      }
    ],
    "roles": [
      {
        "id": "string",
        "name": "string"
      }
    ],
    "user": {
      "Displayname": "string",
      "Domain": {
        "id": "string",
        "name": "string"
      },
      "Email": "string",
      "Id": "string",
      "Mobile": "string",
      "Name": "string",
      "PasswordExpiresAt": "2020-07-21T07:32:39Z"
    }
  }
}
```

## API网关

目前只应用于前端。

## 举例说明

以虚拟机API为例介绍具体的使用方法

### 虚拟机列表 {#server-list}

方法 | API | 说明
---- | ---- | ----
GET | /servers | 获取虚拟机列表

#### 请求示例

```bash
> GET /servers?details=true&with_meta=true&limit=1 HTTP/1.1
> Host: 192.168.222.171:8888
> Content-Type: application/json
> X-Auth-Token: gAAAAABbQHesYGnonUgZo2vqHIb4RFAE5ptZVOpKA0DcH5dyVB_5-rBAAsjGZszFXJNr46q52iXh7K26G1tYAGh9PtDHUv9j3E7bb4dt9Q6NBXRhGodJ7L25D-yvVL0Qx3dpXqGvqcSAhEe-wBKqN8pmyMyXKvQLfhwW7LsXc0dC8SIp6uUBKiFIxXzdlh1APAmqTTjR9Bog8DKDtXbFPHhKN2o4NNaItdo4h5ZJ3qFzo7Uy19osyQg
```

#### 返回示例

```bash
< HTTP/1.1 200 OK
< X-Request-Id: 7bc5a
< Content-Length: 1330
< Server: TornadoServer/3.2.2
< Date: Sat, 07 Jul 2018 08:32:21 GMT
< Content-Type: application/json; charset=UTF-8
<
{
  {
  "limit": 0,
  "offset": 0,
  "servers": [
    {
      "account": "google-account",
      "account_id": "4d3c8979-9dd0-439b-8d78-36fe1ab1666c",
      "admin_secgrp_id": "string",
      "admin_security_rules": "string",
      "attach_time": "2020-07-21T07:40:04Z",
      "auto_delete_at": "2020-07-21T07:40:04Z",
      "auto_renew": true,
      "backup_host_id": "string",
      "backup_host_name": "string",
      "backup_host_status": "string",
      "billing_cycle": "string",
      "billing_type": "postpaid",
      "bios": "string",
      "boot_order": "string",
      "brand": "Google",
      "can_delete": true,
      "can_recycle": true,
      "can_update": true,
      "cdrom": "string",
      "cdrom_support": true,
      "cloud_env": "public",
      "cloudregion": "string",
      "cloudregion_id": "string",
      "created_at": "2020-07-21T07:40:04Z",
      "delete_fail_reason": "string",
      "deleted": true,
      "deleted_at": "2020-07-21T07:40:04Z",
      "description": "string",
      "disable_delete": true,
      "disk": 30720,
      "disk_count": 0,
      "disks": "string",
      "disks_info": [
        {
          "aio_mode": "string",
          "bps": 0,
          "cache_mode": "string",
          "disk_format": "string",
          "disk_type": "string",
          "driver": "string",
          "fs": "string",
          "id": "string",
          "image": "string",
          "image_id": "string",
          "index": 0,
          "iops": 0,
          "medium_type": "string",
          "name": "string",
          "size": 0,
          "storage_type": "string"
        }
      ],
      "domain_id": "string",
      "eip": "string",
      "eip_mode": "string",
      "environment": "string",
      "expired_at": "2020-07-21T07:40:04Z",
      "external_id": "string",
      "flavor_id": "string",
      "host": "string",
      "host_id": "string",
      "host_service_status": "string",
      "host_sn": "string",
      "host_status": "string",
      "host_type": "string",
      "hypervisor": "kvm",
      "id": "string",
      "instance_type": "string",
      "ips": "10.165.2.1,172.16.8.1",
      "is_emulated": true,
      "is_gpu": true,
      "is_prepaid_recycle": true,
      "is_system": true,
      "isolated_devices": [
        {
          "addr": "string",
          "created_at": "2020-07-21T07:40:04Z",
          "deleted": true,
          "deleted_at": "2020-07-21T07:40:04Z",
          "description": "string",
          "dev_type": "string",
          "guest_id": "string",
          "host_id": "string",
          "id": "string",
          "is_emulated": true,
          "model": "string",
          "name": "string",
          "reserved_cpu": 0,
          "reserved_memory": 0,
          "reserved_storage": 0,
          "update_version": 0,
          "updated_at": "2020-07-21T07:40:04Z",
          "vendor_device_id": "string"
        }
      ],
      "keypair": "string",
      "keypair_id": "string",
      "machine": "string",
      "manager": "google-account",
      "manager_domain": "Default",
      "manager_domain_id": "default",
      "manager_id": "string",
      "manager_project": "system",
      "manager_project_id": "4d3c8979-9dd0-439b-8d78-36fe1ab1666c",
      "metadata": {
        "property1": "string",
        "property2": "string"
      },
      "name": "string",
      "networks": "string",
      "nics": [
        {
          "ip_addr": "string",
          "ip6_addr": "string",
          "is_exit": true,
          "mac": "string",
          "network_id": "string",
          "team_with": "string",
          "vpc_id": "string"
        }
      ],
      "os_name": "string",
      "os_type": "string",
      "pending_deleted": true,
      "pending_deleted_at": "2020-07-21T07:40:04Z",
      "project": "string",
      "project_domain": "string",
      "project_id": "string",
      "project_src": "local",
      "provider": "Google",
      "region": "Default",
      "region_ext_id": "59e7bc87-a6b3-4c39-8f02-c68e8243d4e4",
      "region_external_id": "ZStack/59e7bc87-a6b3-4c39-8f02-c68e8243d4e4",
      "region_id": "default",
      "scaling_group_id": "string",
      "scaling_status": "string",
      "secgroup": "string",
      "secgroups": [
        {
          "id": "string",
          "name": "string"
        }
      ],
      "secgrp_id": "default",
      "security_rules": "string",
      "shutdown_behavior": "stop",
      "src_ip_check": true,
      "src_mac_check": true,
      "status": "string",
      "tenant": "string",
      "tenant_id": "string",
      "update_fail_reason": "string",
      "update_version": 0,
      "updated_at": "2020-07-21T07:40:04Z",
      "vcpu_count": 0,
      "vdi": "string",
      "vga": "string",
      "virtual_ips": "string",
      "vmem_size": 0,
      "vpc": "string",
      "vpc_id": "string",
      "zone": "zone1",
      "zone_ext_id": "string",
      "zone_id": "string"
    }
  ],
  "total": 0
}
```

### 虚拟机详情 {#server-show}

方法 | API | 说明
---- | ---- | ----
GET | /servers/&lt;id&gt; | 获取虚拟机详情

#### 请求示例

```bash
> GET /servers/d983993b-2356-48ed-860b-550b8490c45d HTTP/1.1
> Host: 192.168.222.171:8888
> Content-Type: application/json
> X-Auth-Token: gAAAAABbQHesYGnonUgZo2vqHIb4RFAE5ptZVOpKA0DcH5dyVB_5-rBAAsjGZszFXJNr46q52iXh7K26G1tYAGh9PtDHUv9j3E7bb4dt9Q6NBXRhGodJ7L25D-yvVL0Qx3dpXqGvqcSAhEe-wBKqN8pmyMyXKvQLfhwW7LsXc0dC8SIp6uUBKiFIxXzdlh1APAmqTTjR9Bog8DKDtXbFPHhKN2o4NNaItdo4h5ZJ3qFzo7Uy19osyQg
```

#### 返回示例

```bash
< HTTP/1.1 200 OK
< X-Request-Id: 7bc5a
< Content-Length: 2085
< Server: TornadoServer/3.2.2
< Date: Sat, 07 Jul 2018 08:32:21 GMT
< Content-Type: application/json; charset=UTF-8
<
{
  {
  "server": {
    "account": "google-account",
    "account_id": "4d3c8979-9dd0-439b-8d78-36fe1ab1666c",
    "admin_secgrp_id": "string",
    "admin_security_rules": "string",
    "attach_time": "2020-07-21T07:40:04Z",
    "auto_delete_at": "2020-07-21T07:40:04Z",
    "auto_renew": true,
    "backup_host_id": "string",
    "backup_host_name": "string",
    "backup_host_status": "string",
    "billing_cycle": "string",
    "billing_type": "postpaid",
    "bios": "string",
    "boot_order": "string",
    "brand": "Google",
    "can_delete": true,
    "can_recycle": true,
    "can_update": true,
    "cdrom": "string",
    "cdrom_support": true,
    "cloud_env": "public",
    "cloudregion": "string",
    "cloudregion_id": "string",
    "created_at": "2020-07-21T07:40:04Z",
    "delete_fail_reason": "string",
    "deleted": true,
    "deleted_at": "2020-07-21T07:40:04Z",
    "description": "string",
    "disable_delete": true,
    "disk": 30720,
    "disk_count": 0,
    "disks": "string",
    "disks_info": [
      {
        "aio_mode": "string",
        "bps": 0,
        "cache_mode": "string",
        "disk_format": "string",
        "disk_type": "string",
        "driver": "string",
        "fs": "string",
        "id": "string",
        "image": "string",
        "image_id": "string",
        "index": 0,
        "iops": 0,
        "medium_type": "string",
        "name": "string",
        "size": 0,
        "storage_type": "string"
      }
    ],
    "domain_id": "string",
    "eip": "string",
    "eip_mode": "string",
    "environment": "string",
    "expired_at": "2020-07-21T07:40:04Z",
    "external_id": "string",
    "flavor_id": "string",
    "host": "string",
    "host_id": "string",
    "host_service_status": "string",
    "host_sn": "string",
    "host_status": "string",
    "host_type": "string",
    "hypervisor": "kvm",
    "id": "string",
    "instance_type": "string",
    "ips": "10.165.2.1,172.16.8.1",
    "is_emulated": true,
    "is_gpu": true,
    "is_prepaid_recycle": true,
    "is_system": true,
    "isolated_devices": [
      {
        "addr": "string",
        "created_at": "2020-07-21T07:40:04Z",
        "deleted": true,
        "deleted_at": "2020-07-21T07:40:04Z",
        "description": "string",
        "dev_type": "string",
        "guest_id": "string",
        "host_id": "string",
        "id": "string",
        "is_emulated": true,
        "model": "string",
        "name": "string",
        "reserved_cpu": 0,
        "reserved_memory": 0,
        "reserved_storage": 0,
        "update_version": 0,
        "updated_at": "2020-07-21T07:40:04Z",
        "vendor_device_id": "string"
      }
    ],
    "keypair": "string",
    "keypair_id": "string",
    "machine": "string",
    "manager": "google-account",
    "manager_domain": "Default",
    "manager_domain_id": "default",
    "manager_id": "string",
    "manager_project": "system",
    "manager_project_id": "4d3c8979-9dd0-439b-8d78-36fe1ab1666c",
    "metadata": {
      "property1": "string",
      "property2": "string"
    },
    "name": "string",
    "networks": "string",
    "nics": [
      {
        "ip_addr": "string",
        "ip6_addr": "string",
        "is_exit": true,
        "mac": "string",
        "network_id": "string",
        "team_with": "string",
        "vpc_id": "string"
      }
    ],
    "os_name": "string",
    "os_type": "string",
    "pending_deleted": true,
    "pending_deleted_at": "2020-07-21T07:40:04Z",
    "project": "string",
    "project_domain": "string",
    "project_id": "string",
    "project_src": "local",
    "provider": "Google",
    "region": "Default",
    "region_ext_id": "59e7bc87-a6b3-4c39-8f02-c68e8243d4e4",
    "region_external_id": "ZStack/59e7bc87-a6b3-4c39-8f02-c68e8243d4e4",
    "region_id": "default",
    "scaling_group_id": "string",
    "scaling_status": "string",
    "secgroup": "string",
    "secgroups": [
      {
        "id": "string",
        "name": "string"
      }
    ],
    "secgrp_id": "default",
    "security_rules": "string",
    "shutdown_behavior": "stop",
    "src_ip_check": true,
    "src_mac_check": true,
    "status": "string",
    "tenant": "string",
    "tenant_id": "string",
    "update_fail_reason": "string",
    "update_version": 0,
    "updated_at": "2020-07-21T07:40:04Z",
    "vcpu_count": 0,
    "vdi": "string",
    "vga": "string",
    "virtual_ips": "string",
    "vmem_size": 0,
    "vpc": "string",
    "vpc_id": "string",
    "zone": "zone1",
    "zone_ext_id": "string",
    "zone_id": "string"
  }
}
```
