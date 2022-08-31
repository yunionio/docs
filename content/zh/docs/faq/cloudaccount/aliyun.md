---
title: "阿里云"
linktitle: "阿里云"
weight: 1
description: >
 介绍如何在阿里云平台获取在var_oem_name平台需要使用的配置参数。
---

## 什么是Access Key

为了保障虚拟机的安全性，阿里云在API调用时均需要验证访问者的身份，以确保访问者具有相关权限。这种验证方式通过Access Key来实现，Access Key由阿里云颁发给虚拟机的所有者，它由Access Key ID和Access Key Secret构成。

### 如何获取阿里云的Access Key

请注意，这里是以阿里云主账号为例来介绍如何获取Access Key，如果您使用RAM子账号，请参考[RAM子账号如何获取Access Key](#ram子账号如何获取access-key)

1. 使用主账号登录阿里云控制台，单击页面右上角个人信息，展开下拉菜单，单击 **_"accesskeys** "_** 菜单项进入安全信息管理页面。
   ![](../../image/aliyun-accesskeys.png)

2. 在安全信息管理页面，可以查看已存在的AccessKey信息，也可以单击 **_"创建AccessKey"_** 按钮新建用户AccessKey，新建AccessKey时阿里云会向账号联系人手机发送验证码，验证通过后才可以创建AccessKey。
   ![](../../image/aliyun-get_acceesskey_list.png)

3. Access Key Secret默认不显示，单击"**显示** "链接，阿里云将向账号所属的联系人手机发送一个验证码，验证通过后，才会显示Access Key Secret。
   ![](../../image/aliyun-get_access_key_secret.png)

   

### RAM子账号如何获取Access Key


1. 使用子账号登录阿里云控制台，单击页面右上角个人信息，展开下拉菜单，单击 "**accesskey...**" 进入安全信息管理页面。
   ![](../../image/aliyun_ram_get_access_key.png)

2. 在安全信息管理页面，单击 **_"创建AccessKey"_** 按钮，创建AccessKey。
   ![](../../image/aliyun_get_ram_access_key_create.png)
   
3. 创建成功后，AccessKeySecret信息只会展示一次，请及时保存。
   ![](../../image/aliyun_ram_access_key_get.png)

{{% alert title="注意" color="warning" %}}
已创建的AccessKey，无法再查看AccessKeySecret。
{{% /alert %}}

   
### 通过平台管理阿里云资源，账号需要拥有哪些权限

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

### 如何给子账号授权

1. 使用主账号登录阿里云控制台，单击页面右上角个人信息，展开下拉菜单，单击 **_"访问控制"_** 菜单项 ，进入访问控制页面。
   ![](../../image/aliyun_access_control.png)
2. 单击左侧菜单栏 **_"用户管理"_** 菜单项，进入用户管理页面。
   ![](../../image/aliyun_access_control_all.png)

3. 在用户管理页面，单击指定用户操作列 **_"授权"_** 按钮，进行授权操作。使用{{<oem_name>}}管理阿里云资源的账户所必须拥有的权限请查看[使用{{<oem_name>}}管理云资源，子账号需要拥有哪些权限](#使用{{<oem_name>}}管理阿里云资源-子账号需要拥有哪些权限) 。
   ![](../../image/aliyun_ram_user_access_control.png)


## 如何在阿里云平台获取账单存储桶URL和文件前缀？

### 如何获取账单存储桶URL？
    
1. 以阿里云主账号为例，以主账号登录阿里云控制台，单击顶部[费用]菜单的下拉菜单 **_"用户中心"_** 菜单项，进入费用用户中心页面。
   ![](../../image/aliyunusercenter.png)

2. 单击 **_"账单数据存储"_** 按钮，进入账单数据存储页面。
   ![](../../image/aliyunusercenterhome.png)

3. 查看并记录计费项消费明细和分账账单按天汇总的bucket名称，如未设置，需要在该页面添加存储文件的订阅上述两个账单到同一bucket，设置完成后，每天的增量账单数据将同步存储到对应的OSS上。建议该bucket中仅存放账单文件。
   ![](../../image/aliyunossbucket1.png)

{{% alert title="说明" %}}
由于阿里云OSS等类型资源的标签在计费项消费明细中账单中没有，仅在分账账单里显示，因此如需用费用上的标签分析费用，请配置分账账单按天汇总到存储桶。
{{% /alert %}}

4. 在阿里云控制台的对象存储页面中，查看对应bucket的概览信息，bucket域名即为存储桶URL。
   ![](../../image/aliyunbucketurl.png) 

### 如何获取文件前缀？

阿里云的账单文件前缀为账号ID，可在账号管理-安全设置中查看账号ID。  

{{% alert title="说明" %}}
当账单bucket中除账单文件外还存放了其他文件时，需要配置文件前缀仅获取bucket中的账单文件等。
{{% /alert %}}

