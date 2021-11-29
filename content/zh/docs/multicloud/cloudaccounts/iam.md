---
title: "多云纳管权限表"
weight: 200
description: >
    云平台各功能需要权限情况
---

{{% alert title="注意" %}}
若使用精确权限,请确保添加对象存储权限,
此表会根据云平台纳管功能不断更新。
{{% /alert %}}

{{< tabs >}}
{{% tab name="阿里云" %}}

| 功能                               | 只读权限                                          | 可读可写权限                                 |
| :----------                        | :--------                                         | :----------                                  |
| 所有功能总和                       | ReadOnlyAccess                                    | AdministratorAccess                          |
| 虚拟机, 安全组, 镜像, 磁盘, 快照   | AliyunECSReadOnlyAccess                           | AliyunECSFullAccess                          |
| Vpc, Vpc对等连接, 路由表           | AliyunVPCReadOnlyAccess                           | AliyunVPCFullAccess                          |
| Eip                                | AliyunEIPReadOnlyAccess                           | AliyunEIPFullAccess                          |
| 弹性网卡                           | AliyunVPCNetworkIntelligenceReadOnlyAccess        | AliyunECSNetworkInterfaceManagementAccess    |
| 对象存储                           | AliyunOSSReadOnlyAccess                           | AliyunOSSFullAccess                          |
| NAT                                | AliyunNATGatewayReadOnlyAccess                    | AliyunNATGatewayFullAccess                   |
| 负载均衡                           | AliyunSLBReadOnlyAccess<br>AliyunALBFullAccess    | AliyunSLBFullAccess<br>AliyunALBFullAccess   |
| RDS                                | AliyunRDSReadOnlyAccess                           | AliyunRDSFullAccess                          |
| 弹性缓存                           | AliyunKvstoreReadOnlyAccess                       | AliyunKvstoreFullAccess                      |
| 操作日志                           | AliyunActionTrailFullAccess                       | AliyunActionTrailFullAccess                  |
| NAS                                | AliyunNASReadOnlyAccess                           | AliyunNASFullAccess                          |
| WAF                                | AliyunYundunWAFReadOnlyAccess                     | AliyunYundunWAFFullAccess                    |
| IAM                                | AliyunRAMReadOnlyAccess                           | AliyunRAMFullAccess                          |
| DNS                                | AliyunDNSReadOnlyAccess<br>AliyunPubDNSFullAccess | AliyunDNSFullAccess<br>AliyunPubDNSFullAccess|
| 账单,余额,费用                     | AliyunFinanceConsoleReadOnlyAccess                | AliyunFinanceConsoleFullAccess               |
| 监控                               | AliyunCloudMonitorReadOnlyAccess                  | AliyunCloudMonitorFullAccess                 |

{{% /tab %}}

{{% tab name="腾讯云" %}}

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
{{% /tab %}}

{{% tab name="华为云" %}}

| 功能                                          | 只读权限                                          | 可读可写权限                                     |
| :----------                                   | :--------                                         | :----------                                      |
| 所有功能总和                                  | Tenant Guest<br>IAM ReadOnlyAccess                | Tenant Administrator<br>Security Administrator   |
| 虚拟机                                        | ECS ReadOnlyAccess                                | ECS FullAccess                                   |
| 磁盘, 快照                                    | EVS ReadOnlyAccess                                | EVS FullAccess                                   |
| 项目                                          | EPS ReadOnlyAccess                                | EPS FullAccess                                   |
| 镜像                                          | IMS ReadOnlyAccess                                | IMS FullAccess                                   |
| Vpc, Vpc对等连接, 路由表, 弹性网卡,EIP,安全组 | VPC ReadOnlyAccess                                | VPC FullAccess                                   |
| NAT                                           | NAT ReadOnlyAccess                                | NAT FullAccess                                   |
| 对象存储                                      | OBS ReadOnlyAccess                                | OBS Administrator                                |
| 负载均衡                                      | ELB ReadOnlyAccess                                | ELB FullAccess                                   |
| RDS                                           | RDS ReadOnlyAccess                                | RDS FullAccess                                   |
| 弹性缓存                                      | DCS ReadOnlyAccess                                | DCS FullAccess                                   |
| 操作日志                                      | CTS ReadOnlyAccess                                | CTS FullAccess                                   |
| NAS                                           | SFS ReadOnlyAccess<br>SFS Turbo ReadOnlyAccess    | SFS FullAccess<br>SFS Turbo FullAccess           |
| WAF                                           | WAF ReadOnlyAccess                                | WAF FullAccess                                   |
| IAM                                           | IAM ReadOnlyAccess                                | Security Administrator                           |
| DNS                                           | DNS ReadOnlyAccess                                | DNS FullAccess                                   |
| 账单,余额,费用                                | BSS Operator                                      | BSS Administrator                                |
| 监控                                          | CES ReadOnlyAccess                                | CES FullAccess                                   |

{{% /tab %}}

{{% tab name="AWS" %}}
| 功能                                              | 只读权限                                          | 可读可写权限                                 |
| :----------                                       | :--------                                         | :----------                                  |
| 所有功能总和                                      | ReadOnlyAccess                                    | AdministratorAccess                          |
| 虚拟机, 磁盘, 安全组, 镜像, 快照, 磁盘, 镜像      | AmazonEC2ReadOnlyAccess                           | AmazonEC2FullAccess                          |
| 项目                                              | -                                                 | -                                            |
| Vpc, Vpc对等连接, 路由表, NAT, 弹性网卡,EIP, NAT  | AmazonVPCReadOnlyAccess                           | AmazonVPCFullAccess                          |
| 对象存储                                          | AmazonS3ReadOnlyAccess                            | AmazonS3FullAccess                           |
| 负载均衡                                          | ElasticLoadBalancingReadOnly                      | ElasticLoadBalancingFullAccess               |
| RDS                                               | AmazonRDSReadOnlyAccess                           | AmazonRDSFullAccess                          |
| 弹性缓存                                          | AmazonElastiCacheReadOnlyAccess                   | AmazonElastiCacheFullAccess                  |
| 操作日志                                          | AWSCloudTrailReadOnlyAccess                       | AWSCloudTrail_FullAccess                     |
| NAS                                               | AmazonElasticFileSystemReadOnlyAccess             | AmazonElasticFileSystemFullAccess            |
| WAF                                               | AWSWAFReadOnlyAccess                              | AWSWAFFullAccess                             |
| IAM                                               | IAMReadOnlyAccess                                 | IAMFullAccess                                |
| DNS                                               | AmazonRoute53DomainsReadOnlyAccess                | AmazonRoute53DomainsFullAccess               |
| 账单,费用                                         | AWSBillingReadOnlyAccess                          | Billing                                      |
| 监控                                              | CloudWatchReadOnlyAccess                          | CloudWatchFullAccess                         |
{{% /tab %}}

{{% tab name="Google云" %}}

| 功能                                                      | 只读权限                                              | 可读可写权限                     |
| :----------                                               | :--------                                             | :----------                      |
| 所有功能总和                                              | Viewer                                                | Editor                           |
| 虚拟机, 磁盘, 安全组, 镜像, 快照, 磁盘, 镜像, 负载均衡    | Compute Viewer                                        | Compute Editor                   |
| 项目                                                      | -                                                     | -                                |
| Vpc, Vpc对等连接, 路由表, NAT, 弹性网卡,EIP, NAT          | Compute Network Viewer                                | Compute Network Admin            |
| 对象存储                                                  | Storage Legacy Bucket Reader<br>Storage Object Viewer | Storage Admin                    |
| RDS                                                       | Cloud SQL Viewer                                      | Cloud SQL Admin                  |
| 弹性缓存                                                  | Redis Enterprise Cloud Viewer                         | Redis Enterprise Cloud Admin     |
| 操作日志                                                  | Logs Viewer                                           | Logging Admin                    |
| NAS                                                       | Cloud Filestore Viewer                                | Cloud Filestore Editor           |
| WAF                                                       | -                                                     | -                                |
| IAM                                                       | Role Viewer                                           | Role Administrator               |
| DNS                                                       | DNS Reader                                            | DNS Administrator                |
| 账单,费用                                                 | Billing Account Viewer                                | Billing Account Administrator    |
| 监控                                                      | Monitoring Viewer                                     | Monitoring Admin                 |

{{% /tab %}}

{{% tab name="Azure" %}}

| 功能                                                      | 只读权限                                              | 可读可写权限                                                      |
| :----------                                               | :--------                                             | :----------                                                       |
| 所有功能总和                                              | Reader                                                | Owner                                                             |
| 虚拟机, 磁盘, 安全组, 镜像, 快照, 磁盘, 镜像, 负载均衡    | -                                                     | Virtual Machine Contributor<br>Classic Virtual Machine Contributor|
| 项目                                                      | -                                                     | -                                                                 |
| Vpc, Vpc对等连接, 路由表, NAT, 弹性网卡,EIP, NAT, WAF     | -                                                     | Network Contributor,<br>Classic Network Contributor               |
| 对象存储                                                  | Storage Blob Data Reader                              | Storage Blob Data Owner                                           |
| RDS                                                       | Cloud SQL Viewer                                      | Cloud SQL Admin                                                   |
| 弹性缓存                                                  | Redis Enterprise Cloud Viewer                         | Redis Enterprise Cloud Admin                                      |
| NAS                                                       | Storage File Data SMB Share Reader                    | Storage File Data SMB Share Contributor                           |
| WAF                                                       | -                                                     | -                                                                 |
| IAM                                                       | -                                                     | Graph Owner<br>Resource Policy Contributor                        |
| DNS                                                       | -                                                     | DNS Zone Contributor<br>Private DNS Zone Contributor              |
| 账单,费用                                                 | Billing Reader<br>Cost Management Reader              | Cost Management Contributor                                       |
| 监控,操作日志                                             | Monitoring Reader                                     | Monitoring Contributor                                            |


{{% /tab %}}
{{< /tabs >}}
