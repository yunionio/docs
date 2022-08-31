---
title: "腾讯云"
linktitle: "腾讯云"
weight: 5
description: >
  介绍如何获取腾讯云API密钥信息
---

## 如何获取腾讯云API密钥

1. 登录腾讯云控制台，单击右上角 **_"云产品"_** 菜单项，在展开的菜单中搜索 **_"云API密钥"_** 菜单项，单击进入API密钥管理页面。
   ![](../../image/faq_account_qcloud_1.png)

2. 在API密钥管理页面获取APP ID、密钥ID（SecretId）、密码（SecretKey）对应的值。
   ![](../../image/faq_account_qcloud_2.png)

## 管理腾讯云资源，需要云账号具备哪些权限

| 功能                                          | 只读权限                                                                                                          | 可读可写权限                                                                                      |
| :----------                                   | :--------                                                                                                         | :----------                                                                                       |
| 所有功能总和                                  | ReadOnlyAccess                                                                                                    | AdministratorAccess                                                                               |
| 虚拟机, 安全组, 镜像, 磁盘, 快照              | QcloudCVMReadOnlyAccess                                                                                           | QcloudCVMFullAccess                                                                               |
| Vpc, Vpc对等连接, 路由表, NAT, 弹性网卡       | QcloudVPCReadOnlyAccess                                                                                           | QcloudVPCFullAccess                                                                               |
| Eip                                           | -                                                                                                                 | QcloudEIPFullAccess                                                                               |
| 对象存储                                      | QcloudCOSReadOnlyAccess                                                                                           | QcloudCOSFullAccess                                                                               |
| 负载均衡                                      | QcloudCLBReadOnlyAccess                                                                                           | QcloudCLBFullAccess                                                                               |
| RDS                                           | QcloudMariaDBReadOnlyAccess<br>QcloudCDBReadOnlyAccess<br>QcloudSQLServerReadOnlyAccess<br>QcloudPostgreSQLReadOnlyAccess  | QcloudMariaDBFullAccess<br>QcloudCDBFullAccess<br>QcloudSQLServerFullAccess<br>QcloudPostgreSQLFullAccess  |
| 弹性缓存                                      | QcloudRedisReadOnlyAccess                                                                                         | QcloudRedisFullAccess                                                                             |
| 操作日志                                      | QcloudAuditReadOnlyAccess                                                                                         | QcloudAuditFullAccess                                                                             |
| NAS                                           | -                                                                                                                 | -                                                                                                 |
| WAF                                           | -                                                                                                                 | -                                                                                                 |
| IAM                                           | QcloudCamReadOnlyAccess                                                                                           | QcloudCamFullAccess                                                                               |
| DNS                                           | QcloudDNSPodReadOnlyAccess<br>QcloudPrivateDNSReadOnlyAccess                                                         | QcloudPrivateDNSFullAccess<br>QcloudDNSPodFullAccess                                                 |
| 账单,余额,费用                                | -                                                                                                                 | QCloudFinanceFullAccess                                                                           |
| 监控                                          | QcloudMonitorReadOnlyAccess                                                                                       | QcloudMonitorFullAccess                                                                           |
