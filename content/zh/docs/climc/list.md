---
title: "climc命令列表"
date: 2022-01-05T17:01:00+08:00
weight: 10
description: >
    介绍climc常用的命令
---


  命令         | 交互模式备注                           | 解释说明
------------- | -------------------------------------|------------------------
accountbalances-list | list all account balances | 列出所有账户余额
action-show | Show operation action logs | 显示操作行为日志
add-alert-to-template | Add alert to alert-template | 给告警模板添加一条告警
add-alerttemplate-to-treenode | Bind alert-template to service-tree node | 绑定一条告警模板到服务树节点
add-labels-to-node | Add labels to node | 给节点添加标签
agent-disable | Disble agent | 禁用exsiagent或baremetal agent 
agent-delete | Delete agent | 删除exsiagent或baremetal agent 
agent-enable | Enable agent | 启用exsiagent或baremetal agent 
agent-list | list all agent | 显示所有agent 
agent-show | Show details of an agent | 显示agent详情 
alert-create | Create a alert | 创建一条告警
alert-delete | Delete a alert | 删除一条告警
alert-list | List all alerts | 显示所有告警
alert-show | Show alert details | 显示告警详情
alert-update | Update a alert | 更新一条告警
alertevent-ack-update | Update ack status of alert event | 更新告警事件应答状态
alertevent-list | List all alert's event | 显示所有告警事件
alertlog-create | Create a alert log | 创建一条告警日志
alertlog-list | List all alert's event | 显示所有告警事件
alerttemplate-alert-list | List alerts of alert template | 显示所有告警模板
alerttemplate-create | Create a alert-template | 创建一条告警模板
alerttemplate-delete | Delete a alert-template | 删除一条告警模板
alerttemplate-list | List all alert templates  | 列出所有告警模板
alerttemplate-show | Show alert template details | 显示告警模板详情
alerttemplate-update | Update a alert-template | 更新一条告警模板
ansible-hosts | List ansible inventory | 列出ansible清单
ansibleplaybook-create | Create ansible playbook | 创建一个ansible的playbook
ansibleplaybook-delete | Delete ansible playbook | 删除ansible的playbook
ansibleplaybook-list  |  List ansible playbooks | 列出所有ansible的playbook
ansibleplaybook-run  |   Run ansible playbook | 执行ansible的playbook
ansibleplaybook-show  |  Show ansible playbook | 显示ansible的playbook详情
ansibleplaybook-stop  |  Stop ansible playbook | 终止ansible的playbook的执行
ansibleplaybook-update | Update ansible playbook | 更新ansible的playbook
ansibleplaybookv2-list | List ansible playbooks | 列出所有ansible的playbook
ansibleplaybookv2-show | Show ansible playbook | 显示ansible的playbook详情
associate-bill-list |  List associated bills | 列出关联账单
baremetal-event-create | Create baremetal event | 创建裸金属服务器
baremetal-event-list | List baremetal events | 列出裸金属操作日志
baremetal-storage-list | List baremetal storage pairs |列出裸金属服务器存储配对
baremetal-storage-show | Show baremetal storage details |显示裸金属服务器存储详情
batch-add-labels-to-node | Batch add labels to nodes |为节点添加标签
batch-remove-labels-from-node | Batch remove labels from nodes |为节点移除标签
bind-template-to-node | Bind alert-template to service-tree node |为节点绑定告警模板
billanalysis-list | List all bill analysises | 多维度分析
billbalance-list | List all BillBalances | 列出账户余额
billbalance-show | Show BillBalance details | 显示余额详情
billcloudcheck-list | List all BillCloudChecks | 列出云账号状态
billcondition-list | List all bill conditions | 列出所有账单状况
billdetail-list | List all bill details | 列出所有流水账单
billresource-list | List all bill resources | 列出所有资源账单
bucket-access-info | Show backend access info of a bucket | 显示存储桶的后端访问信息
bucket-acl | Get ACL of bucket or object | 获取存储桶或存储对象的访问权限
bucket-create | Create a bucket | 创建存储桶
bucket-delete | delete bucket | 删除存储桶
bucket-limit | Set limit of bucket | 设置存储桶上限
bucket-list | List all buckets | 列出所有存储桶
bucket-mkdir | Mkdir in a bucket | 在存储桶中创建文件夹
bucket-options-verify | Expense OSS Bucket connection test | 账单存储连接测试
bucket-object-delete | Delete objects in a bucket | 删除存储桶中的对象
bucket-object-list | List objects in a bucket | 列出存储桶中的所有对象
bucket-object-tempurl | Get temporal URL for an object in a bucket | 生成临时URL
bucket-object-upload | Upload an object into a bucket | 在存储桶中上传文件
bucket-set-acl | Set ACL of bucket or object | 设置存储桶或存储对象的访问权限
bucket-sync | Sync bucket | 同步存储桶状态
bucket-show | Show details of bucket | 显示存储桶详情
bucket-update | update bucket | 更新存储桶
cached-image-delete | Remove cached image information |移除缓存镜像信息
cached-image-list | List cached images |列出缓存镜像
cached-image-refresh | Refresh cached image details |刷新缓存镜像详情
cached-image-show | Show cached image details |显示缓存镜像详情
change-alert-enabled | UnBind alert-template from service-tree node |从服务树节点中解绑告警模板
change-status-alerttemplate-for-treenode | UnBind alert-template from service-tree node |从服务树节点中解绑告警模板
clone-alerttemplate-to-treenode | Bind alert-template to service-tree node |给服务树节点绑定一条告警模板
cloud-account-create | Create a cloud account | 创建云账号
cloud-account-create-aliyun | Create an Alibaba Cloud cloud account | 创建阿里云账号
cloud-account-create-aws | Create an AWS cloud account | 创建AWS云账号
cloud-account-create-azure | Create an Azure cloud account | 创建Azure云账号
cloud-account-create-ceph | Create a ceph object storage account | 创建ceph对象存储账号 
cloud-account-create-ctyun | Create a ctyun cloud  account | 创建天翼云账号
cloud-account-create-google | Create a Google cloud account | 创建谷歌云账号
cloud-account-create-huawei | Create a Huawei cloud account | 创建华为云账号
cloud-account-create-openstack | Create an OpenStack cloud account | 创建OpenStack账号
cloud-account-create-qcloud | Create a Qcloud cloud account | 创建腾讯云账号
cloud-account-create-s3 | Create a generaic S3 object storage account | 创建S3对象存储账号
cloud-account-create-ucloud | Create a Ucloud cloud account | 创建UCloud云账号
cloud-account-create-vmware | Create a VMware cloud account | 创建VMware账号
cloud-account-create-xsky | Create a xsky object storage account | 创建XSKY账号
cloud-account-create-zstack | Create a ZStack cloud account | 创建ZStack账号
cloud-account-delete | Delete a cloud account | 删除云账号
cloud-account-disable | Disable cloud account | 禁用云账号
cloud-account-disable-auto-sync | Disable automatic sync for this account | 禁用自动同步
cloud-account-enable | Enable cloud account | 启用云账号
cloud-account-enable-auto-sync | Enable automatic sync for this account | 启用自动同步
cloud-account-event | Show operation event logs of cloudaccount | 显示云账号操作日志
cloud-account-import | Import sub cloud account | 导入子账号 
cloud-account-list | List cloud accounts | 列出云账号信息
cloud-account-private | Mark this cloud account private | 将云账号设置为私有
cloud-account-public | Mark this cloud account public | 将云账号设置为共享
cloud-account-share-mode | Set share_mode of a cloud account | 设置云账号共享模式
cloud-account-show | Get details of a cloud account | 显示云账号详情
cloud-account-sync | Sync of a cloud account account | 同步云账号
cloud-account-sync-skus | Sync skus of a cloud account | 同步云账号套餐
cloud-account-update | Update a cloud account | 更新云账号
cloud-account-update-aliyun | update an Alibaba Cloud cloud account | 更新阿里云账号
cloud-account-update-aws | update an AWS cloud account | 更新AWS账号
cloud-account-update-azure | update an Azure cloud account | 更新Azure账号
cloud-account-update-ctyun | update a ctyun cloud account | 更新天翼云账号
cloud-account-update-huawei | update a Huawei cloud account | 更新华为云账号
cloud-account-update-openstack | update an openstack cloud account | 更新OpenStack账号
cloud-account-update-qcloud | update a Tencent cloud account | 更新腾讯云账号
cloud-account-update-s3 | update a generic S3 cloud account | 更新S3对象存储账号
cloud-account-update-ucloud | update a Ucloud cloud account | 更新UCloud账号
cloud-account-update-vmware | update a vmware cloud account | 更新VMware账号
cloud-account-update-zstack | update a ZStack cloud account | 更新ZStack账号
cloud-account-update-credential | Update credential of a cloud account | 更新云账号身份验证信息 
cloud-account-update-credential-vmware | Update credential of a VMware cloud account | 更新VMware身份认证信息
cloud-account-update-credential-aliyun | Update credential of an Alibaba Cloud cloud account | 更新阿里云身份认证信息
cloud-account-update-credential-azure | Update credential of an Azure cloud account | 更新Azure身份认证信息
cloud-provider-balance | Get balance | 获取余额
cloud-provider-change-project | Change project for provider | 为云订阅更改项目
cloud-provider-clirc | Get client RC file of the cloud provider | 获取云订阅源信息
cloud-provider-delete | Delete a cloud provider | 删除云订阅
cloud-provider-disable | Disable cloud provider | 禁用云订阅
cloud-provider-enable | Enable cloud provider | 启用云订阅
cloud-provider-event | Show operation event logs of cloudprovider |  查看云订阅的操作日志
cloud-provider-list | List cloud providers | 列出所有云订阅
cloud-provider-region-list | List cloudprovider region synchronization status | 列出云订阅下的所有区域 
cloud-provider-region-enable | Enable automatic synchronization for cloudprovider/region pair | 开启云订阅的区域自定同步
cloud-provider-region-disable | Disable automatic synchronization for cloudprovider/region pair | 关闭云订阅的区域自定同步
cloud-provider-show | Get details of a cloud provider |获取云订阅详情
cloud-provider-storage-classes | Get list of supported storage classes of a cloud provider | 显示云订阅支持的存储列表       
cloud-provider-sync | Sync of a cloud provider account |同步云订阅账户
cloud-provider-update | Update a cloud provider |更新云订阅
cloud-provider-update-credential | Update credential of a cloud provider |更新云订阅的身份验证信息
cloud-provider-usage | Show general usage of vcenter | 显示云账号的使用率
cloud-region-capability | Show region's capacibilities | 查看云订阅下的可用区域 
cloud-region-cities | List cities where cloud region resides | 显示地域所属城市
cloud-region-create | Create a cloud region | 创建地域
cloud-region-delete | Delete a cloud region | 删除地域
cloud-region-list | List cloud regions | 列出所有地域
cloud-region-providers | List cities where cloud region resides | 列出云账号区域所在城市
cloud-region-set-default-vpc | Set default vpc for a region | 为地域设置默认VPC
cloud-region-show | Show a cloud region |显示云地域
cloud-region-update | Update a cloud region |更新云地域
cloud-region-usage | Show general usage of a cloud region | 显示区域下的云账号使用率
cloud-sku-rate-list | list cloud-sku-rates | 列出云账号套餐费率
contact-delete | Delete contact for user |删除用户联系信息
contact-group-list | List all contact groups for all the domainsconta |列出所有联系组
contact-list | List all contacts for all users |列出所有用户的联系方式
contact-pull | Pull contact | 根据手机号拉取联系方式
contact-show | Show all contacts for the users |显示所有用户的联系方式
contact-update | Create, delete or update contact for user |创建、删除、或更新用户联系方式
contact-verify | Contact verify |联系方式验证
contact-verify-trigger | Trigger contact verify |触发联系方式验证
copyright-update | update copyright | 更新版权信息
dbinstance-account-delete | Delete DB instance account | 删除RDS数据库账号
dbinstance-account-list | List DB instance accounts | 列出RDS数据库所有账号
dbinstance-account-show | Show DB instance account | 显示RDS数据库账号详情
dbinstance-backup-create | Create DB instance backup | 创建RDS数据库备份
dbinstance-backup-delete | Delete DB instance backup | 删除RDS数据库备份
dbinstance-backup-list | List DB instance backups | 列出所有RDS数据库备份
dbinstance-backup-show | Show DB instance backup | 显示RDS数据库备份详情
dbinstance-create | Create DB instance | 创建RDS数据库实例
dbinstance-change-config | ChangeConfig a dbinstance | 调整RDS数据库实例配置
dbinstance-close-public-connection | Close DB instance public connection | 关闭外网访问
dbinstance-change-owner | Change owner porject of a dbinstance | 更改RDS数据库所属
dbinstance-database-create | Create DB instance databases | 在RDS实例上创建数据库
dbinstance-database-delete | Delete DB instance databases | 在RDS实例上删除数据库
dbinstance-database-list | List DB instance databases | 列出RDS实例上所有数据库
dbinstance-list | List DB instance | 列出所有RDS实例
dbinstance-open-public-connection | Open DB instance public connection | 开启外网访问
dbinstance-parameter-list | List DB instance parameters | 列出RDS实例参数项
dbinstance-privilege-list | List DB instance accounts | 列出所有数据库账号
dbinstance-purge | Purge DB instance | 从数据库删除RDS实例
dbinstance-reboot | Reboot DB instance | 重启RDS实例
dbinstance-recovery | Recovery DB instance database from backup | 从备份恢复RDS实例
dbinstance-renew | Renew a dbinstance | 续费RDS实例
dbinstance-show | Show DB instance | 显示RDS实例详情
dbinstance-sku-list | List dbinstance skus | 列出RDS实例套餐信息
dbinstance-sku-show | Show dbinstance sku details dbinstance-sync-status  Sync status for DB instance | 显示RDS实例套餐详情
dbinstance-update | Update a dbinstance | 更新RDS实例
delete-alerttemplate-from-treenode | UnBind alert-template from service-tree node |从服务树模板解绑告警模板
devtoolcronjob-create | Create a cronjob repo component | 创建运维工具的定时任务
devtoolcronjob-delete | Delete DevToolCronjob | 删除运维工具的定时任务
devtoolcronjob-list | List Devtool Cronjobs | 列出所有运维工具的定时任务
devtoolcronjob-show | Show cronjob details | 显示运维工具定时任务的详情
devtoolcronjob-update | Update DevToolCronjob | 更新运维工具定时任务
devtooltemplate-bind | Binding devtool template to a host/vm | 运维模板关联虚拟机或宿主机
devtooltemplate-create | Create a template repo component | 创建运维模板
devtooltemplate-delete | Delete devtool template | 删除运维模板
devtooltemplate-list | List Devtool Templates | 列出所有运维模板
devtooltemplate-show | Show devtool template | 显示运维模板详情
devtooltemplate-unbind | Binding devtool template to a host/vm | 取消运维模板与虚拟机或宿主机的关联
devtooltemplate-update | Update ansible playbook | 更新运维模板
disk-cancel-delete | Cancel pending delete disks |取消待消除磁盘
disk-change-owner | Change owner porject of a disk | 更改磁盘所属项目
disk-create | Create a virtual disk |创建一块虚拟硬盘
disk-delete | Delete a disk |删除一块硬盘
disk-delete-snapshots | Delete a disk snapshots | 删除磁盘快照
disk-event | Show operation event logs of disk | 列出磁盘操作日志
disk-list | List virtual disks |列出所有虚拟硬盘
disk-metadata | Get metadata of a disk |获得硬盘元数据
disk-private | Make a disk private |使一块硬盘变为私有
disk-public | Make a disk public |使一块硬盘变为公有
disk-purge | Delete a disk record in database, not actually do deletion |数据库中删除硬盘记录，如残余信息等，并不删除硬盘
disk-resize | Resize a disk |重新分配一块硬盘大小
disk-reset | Resize a disk | 快照回滚磁盘
disk-show | Show details of disk |显示硬盘详情
disk-save | Disk save image | 磁盘保存镜像
disk-snapshot-policy-list | List snapshot policy attached | 列出磁盘绑定的快照策略
disk-snapshot-policy-attach | attach snapshot policy to disk | 为磁盘绑定快照策略
disk-snapshot-policy-detach | detach snapshot policy to disk | 为磁盘解绑快照策略
disk-update | Update property of a virtual disk |更新一块虚拟硬盘属性
disk-update-status | Set disk status | 更新硬盘状态
dnat-create | Create a DNAT | 创建一条DNAT记录
dnat-delete | Delete a DNAT | 删除一条DNAT记录
dnat-list | List DNAT entries | 列出所有DNAT记录
dnat-show | Show a DNAT | 显示DNAT详情
dns-add-records | Add DNS records to a name |给DNS记录增加名字
dns-create | Create dns record |创建一条DNS记录
dns-delete | Delete a dns record |删除一条DNS记录
dns-disable | Disable dns record | 禁用DNS
dns-enable | Enable dns record | 启用DNS
dns-list | List dns records |列出所有DNS记录
dns-private | Make a dns record private |使一条DNS记录私有
dns-public | Make a dns record publicly available |使一条DNS记录公有
dns-remove-records | Remove DNS records from a name |从名字中移除一条DNS记录
dns-show | Show details of a dns records |显示一条DNS记录的详情
dns-update | Update details of a dns records |更新一条DNS记录的详情
domain-create | Create domain |创建新的域
domain-delete | Delete a domain |删除域
domain-event | Show operation event logs of keystone domains | 显示域的操作日志
domain-list | List domains |列出所有域
domain-show | Show detail of domain |显示域详情
domain-update | Update a domain |更新域
dynamic-schedtag-create | create dynamic schedtag | 创建动态调度标签
dynamic-schedtag-delete | delete dynamic schedtag | 删除动态调度标签
dynamic-schedtag-evaluate | Evaluate dynamic schedtag condition | 设置动态调度标签的条件
dynamic-schedtag-list | List dynamic schedtag conditions | 列出所有动态调度标签
dynamic-schedtag-show | Show details of a dyanmic schedtag policy | 显示动态调度标签详情
eip-associate | Associate an EIP to an instance | 将EIP绑定到虚拟机
eip-change-bandwidth | Change maximal bandwidth of EIP | 更改弹性公网IP的带宽
eip-change-owner | Change owner porject of a eip | 更改弹性公网IP的所属项目
eip-create | Create an EIP | 创建弹性公网IP
eip-delete | Delete an EIP | 删除弹性公网IP
eip-dissociate | Dissociate an EIP from an instance | 将弹性公网IP从虚拟机上解绑
eip-event | Show operation event logs of elastic IP | 显示弹性公网IP操作日志
eip-list | List elastic IPs | 列出所有弹性公网IP
eip-purge | Purge EIP db records | 从数据库中删除EIP记录
eip-sync | Synchronize status of an EIP | 同步弹性公网IP状态
eip-show | show details of an EIP | 显示弹性公网IP详情
eip-update | Update EIP properties | 更新弹性公网IP
elastic-cache-account-create | Create elastisc cache account | 创建Redis用户账号
elastic-cache-account-delete | Delete elastisc cache account | 删除Redis用户账号
elastic-cache-account-list | List elastisc cache account | 列出所有Redis用户账号
elastic-cache-account-reset-password | Reset elastisc cache instance account password | 为Redis用户账号重置密码
elastic-cache-allocate-public-connect | Allocate elastisc cache instance public access connection | 分配Redis外网连接地址
elastic-cache-backup-create | Create elastisc cache backup | 创建Redis备份
elastic-cache-backup-delete | Delete elastisc cache backup | 删除Redis备份
elastic-cache-backup-list | List elastisc cache backup | 列出所有Redis备份
elastic-cache-backup-restore | Restore elastisc cache backup | 恢复Redis备份
elastic-cache-change-spec | Change elastisc cache instance specification | 调整Redis配置
elastic-cache-create | Create elastisc cache instance | 创建Redis实例
elastic-cache-delete | Delete elastisc cache instance | 删除Redis实例
elastic-cache-disable-auth | Disable elastisc cache instance auth | 关闭免密访问
elastic-cache-enable-auth | Enable elastisc cache instance auth | 开启免密访问
elastic-cache-flush-instance | Flush elastisc cache instance | 清空数据
elastic-cache-list | List elastisc cache instance | 列出所有Redis实例
elastic-cache-parameter-list | List elastisc cache parameters | 列出Redis的配置
elastic-cache-parameter-update | Update elastisc cache parameter | 更新Redis的配置
elastic-cache-restart | Restart elastisc cache instance | 重启Redis实例
elastic-cache-set-maintenance-time | set elastisc cache instance maintenance time | 设置Redis可维护时间段
elastic-cache-sku-list | List elastisc cache sku | 列出所有Redis套餐
email-config-create | Create a Email Config | 创建一条邮件配置
email-config-delete | Delete a email config | 删除一条邮件配置
email-config-show | Show email-config details | 显示邮件配置详情
email-config-update | Update a email-config | 更新一条邮件配置
endpoint-create | Create endpoint | 创建服务的接入端
endpoint-delete | Delete an endpoint | 删除服务的接入端
endpoint-event | Show operation event logs of keystone endpoints | 显示服务接入端的操作日志
endpoint-list | List service endpoints | 列出所有的服务接入端
endpoint-show | Show details of an endpoint | 显示接入端的详情
endpoint-update | Update a endpoint | 更新服务的接入端
event-show | Show operation event logs | 显示操作事件日志
external-project-list | List public cloud projects | 列出所有公有云云上项目
external-project-show | Show details of project mapping | 显示云上项目与本地项目的映射关系
external-project-change-project | Change external project point to local project | 更改云上项目对应的本地项目
global-vpc-list | List global vpcs | 列出所有全局VPC
global-vpc-show | Show details of a global vpc | 显示全局VPC的详情
group-create | Create a group | 创建用户组
group-delete | Delete a group | 删除用户组
group-event | Show operation event logs of keystone groups | 显示用户组操作日志
group-join-project | Group join projects with roles | 将用户组以某种角色加入项目
group-leave-project | Leave a group from projects | 将用户组退出项目
group-list | List groups | 列出所有组
group-show | Show details of a group | 显示组的详情
group-user-list | Show members of a group | 显示组的成员
guest-image-create | Create guest image's metadata | 创建主机镜像
guest-image-cancel-delete | Cancel pending delete images | 取消自动删除镜像
guest-image-delete | Delete a image | 删除主机镜像
guest-image-list | List guest images | 列出所有主机镜像
guest-image-mark-protected | Mark image protected | 设置主机镜像删除保护
guest-image-mark-unprotected | Mark image protected | 取消主机镜像删除保护
guest-image-private | Make a guest image private | 将主机镜像设置为私有
guest-image-public | Make a guest image public | 共享主机镜像
guest-image-update | update guest image | 更新主机镜像
historic-process-instance-list | List historic process definition | 列出所有发起历史工单信息
historic-process-instance-show | Show historic process definition | 显示历史工单详情
historic-process-instance-statistics | Delete all contacts for the user | 统计我参与的历史工单信息
historic-task-instance-list | List historic process instance | 列出所有历史审批信息
historic-task-instance-show | Show historic task instance | 显示历史审批信息详情
host-action | Show operation action logs of host | 显示宿主机操作日志
host-add-netif | Host add a NIC | 宿主增加一块网卡
host-cache-image | Ask a host to cache a image | 请求宿主机缓存镜像
host-cachedimage-list | List host cached image pairs | 列出宿主机缓存镜像
host-cachedimage-update | Update host cached image | 更新宿主机缓存镜像
host-convert-hypervisor | Convert a baremetal into a hypervisor | 物理机转换为宿主机
host-create | Create a baremetal host | 添加物理机
host-delete | Delete host record |删除一条宿主机记录
host-disable | Disable a host |禁用一台宿主机
host-disable-netif | Disable a network interface | 禁用宿主机网卡
host-eject-iso | Eject ISO from virtual cd-rom of host | 宿主机卸载ISO
host-enable-netif | Enable a network interface for a host | 启用宿主机网卡
host-enable | Enable a host |启用一台宿主机
host-event | Show operation event logs of host |显示宿主机操作事件日志
host-ipmi | Get IPMI information of a host |获取宿主机IPMI信息
host-ipmi-probe | Do ipmi probe host | 查看主机是否支持Redfish
host-insert-iso | Insert ISO into virtual cd-rom of host | 宿主机挂载ISO
host-list | List hosts | 列出宿主机
host-logininfo | Get SSH login information of a host | 获取一台宿主机SSH登录信息
host-maintenance | Reboot host into PXE offline OS, do maintenance jobs | 宿主机维护
host-metadata | Show metadata of a host | 显示一台宿主机元数据
host-network-list | List baremetal network pairs | 列出裸金属网络配对
host-network-show | Show baremetal network details | 显示裸金属网络详情
host-ping | Ping a host | ping一台宿主机
host-prepare | Prepare a host for installation | 准备一台宿主机安装
host-remove-netif | Remove NIC from host | 从宿主机移除网卡
host-reset | Power reset host |宿主机电源重置
host-remove-all-netifs | Remvoe all netifs expect admin&ipmi netifs | 移除宿主机除管理网卡和ipmi以外的网卡
host-renew-prepaid-recycle | Renew a prepaid recycle host | 宿主机回收为物理机
host-set-schedtag | Set schedtags to host | 为宿主机绑定调度标签
host-show | Show details of a host |显示一台宿主机详情
host-start | Power on host |宿主机上电
host-stop | Power-off on host |宿主机下电
host-spec | Get host spec info | 获取宿主机规格
host-storage-attach | Attach a storage to a host |为宿主机添加存储
host-storage-detach | Detach a storage from a host |为宿主机分离存储
host-storage-list | List host storage pairs |列出所有存储配对
host-storage-show | Show host storage details |显示宿主机存储详情
host-sync-config | Synchronize config of a host | 检测硬件配置
host-syncstatus | Synchronize status of a host |同步宿主机状态
host-uncache-image | Ask a host to remove image from a cache |请求宿主机从缓存中移除镜像
host-undo-convert | Undo converting a host to hypervisor |撤销宿主机转换为物理机
host-undo-recycle | Pull a prepaid server from recycle pool, so that it will not be shared any more | 撤销宿主机回收为物理机
host-unmaintenance | Reboot host back into disk installed OS |重启宿主机，硬盘安装操作系统
host-update | Update information of a host |更新一台宿主机信息
host-vnc | Get VNC information of a host |获取宿主机VNC信息
host-wire-detach | Detach host from wire |从二层网络解绑宿主机
host-wire-list | List host wire |列出宿主机的二层网络
host-wire-show | Show host wire details |显示宿主机二层网络详情
host-wire-update | Update host wire information |更新宿主机二层网络信息
idp-config-cas | Config an Identity provider with CAS driver | 配置CAS认证源
idp-config-ldap | Config an Identity provider with LDAP driver | 配置LDAP认证源
idp-config-ldap-multi-domain | Config an Identity provider with LDAP drivermulti domain template | 通过LDAP多域模板配置LDAP认证源
idp-config-ldap-single-domain | Config an Identity provider with LDAP driver/single domain template | 通过LDAP单域模板配置LDAP认证源
idp-config-show | Show detail of a domain config | 显示域配置详情
idp-create-cas | Create an identity provider with CAS driver | 创建CAS认证源
idp-create-ldap | Create an identity provider with LDAP driver | 创建LDAP认证源
idp-create-ldap-multi-domain | Create an identity provider with LDAP driver/single domain template | 创建LDAP多域认证源
idp-create-ldap-single-domain | Create an identity provider with LDAP driver/single domain template | 创建LDAP单域认证源
idp-delete | Delete an identity provider | 删除认证源
idp-disable | Disable an identity provider | 禁用认证源
idp-enable | Enable an identity provider | 启用认证源
idp-list | List all identity provider | 列出所有认证源
idp-show | Show details of idp | 显示认证源详情
idp-sync | Sync an identity provider | 同步认证源
image-add-project | Add a project to private image's membership list |增加项目到私有
image-cancel-delete | Cancel pending delete images | 从回收站恢复镜像
image-change-owner | Change owner project of an image | 更改镜像所属项目
image-delete | Delete a image |删除镜像
image-download | Download image data to a file or stdout | 下载镜像到文件或标准输出
image-event | Show operation event logs of glance images | 显示镜像操作日志
image-import | Import a external image | 导入镜像
image-list | List images | 列出所有镜像
image-list-project | List image members | 列出镜像所属项目
image-mark-standard | Mark image standard | 设置为公共镜像
image-mark-unstandard | Mark image not standard | 设置为自定义镜像
image-private | Make a image private | 将镜像设置为私有
image-public | Make a image public | 将镜像设置为共享
image-quota | Show image quota for current user or tenant | 显示当前用户或项目的镜像配额
image-quota-set | Set image quota for tenant | 设置项目的镜像配额
image-quota-list | List image quota of domains or projects of a domain | 列出域或项目的镜像配额
image-remove-project | Remove a project from private image's membership list |从私有镜像成员列表中移除项目
image-show | Show details of a image |显示镜像详情
image-subformats | Show all format status of a image | 显示镜像的所有格式状态
image-update | Update images meta infomation |更新镜像元数据信息
image-upload | Upload a local image |上传本地镜像
image-usage | Show general usage of images | 列出镜像的使用量    
instance-group-bind-guests | bind instancegroup to guests | 将虚拟机加入宿反亲和组
instance-group-create | Create a instance group | 创建反亲和组
instance-group-delete | delete a instance group | 删除反亲和组
instance-group-list | List instance group | 列出所有反亲和组
instance-group-show | Show details of a instance group | 显示反亲和组详情
instance-group-unbind-guests | bind instancegroup to guests | 将虚拟机移出反亲和组
instance-group-update | update a instance group | 更新反亲和组
instance-snapshot-and-clone | create instance snapshot and clone new instance | 创建主机快照，并基于主机快照创建新的虚拟机
instance-snapshot-create | create instance snapshot | 创建主机快照
instance-snapshot-delete |  Delete snapshots | 删除主机快照
instance-snapshot-list | Show instance snapshots | 列出所有主机快照
instance-snapshot-reset | reset instance snapshot | 还原主机快照
instance-type-list | query backend service for its version | 
isolated-device-delete | Delete a isolated device |删除已隔离设备
isolated-device-list | List isolated devices like GPU |列出已隔离设备如GPU
isolated-device-show | Show isolated device details |显示已隔离设备详情
keypair-create | Create keypair |创建新的密钥对
keypair-delete | Delete a keypair |删除密钥对
keypair-import | Create keypair with a existing public key |用已存在的公钥创建密钥对
keypair-list | List keypairs. |列出密钥对
keypair-privatekey | Private a keypair |显示密钥对的私钥
keypair-show | Show details of a keypair |显示密钥详情
keypair-update | Update a keypair |上传密钥对
kubecluster-add-machines | Add machines to cluster | 向K8s集群添加节点
kubecluster-addons | Get addon manifest of a cluster | 查看k8s集群额外插件
kubecluster-apply-addons | Apply base requirements addons | 应用k8s集群额外插件 
kubecluster-check-system-ready | Check system cluster status | 检查k8s集群的状态
kubecluster-component-delete | Delete cluster component | 删除k8s集群组件
kubecluster-component-disable | Enable cluster component | 禁用k8s集群组件
kubecluster-component-enable-ceph-csi | Enable cluster component | 启用k8s ceph csi组件
kubecluster-components-status | Get cluster component status | 查看k8s组件状态
kubecluster-component-setting | Get cluster component setting | 获取k8s组件配置信息
kubecluster-component-update-ceph-csi | Update cluster component | 更新k8s ceph csi组件
kubecluster-create | Create k8s cluster | 创建k8s集群
kubecluster-delete | Delete cluster | 删除k8s集群
kubecluster-delete-machines | Delete machines in cluster | 删除k8s集群中的节点
kubecluster-event | Show operation event logs of kubernetes cluster | 查看k8s集群操作日志
kubecluster-import | Import k8s cluster | 导入k8s集群
kubecluster-k8s-versions | Get kubernetes deployable versions  | 获取k8s集群版本
kubecluster-kubeconfig  |  Generate kubeconfig of a cluster | 生成k8s集群的kubeconfig配置文件
kubecluster-list | List k8s clusters | 列出所有k8s集群
kubecluster-public |  Make cluster public | 将k8s集群设置为共享
kubecluster-private | Make cluster private | 将k8s集群设置为私有 
kubecluster-show | Show details of a cluster | 显示k8s集群详情
kubecluster-syncstatus | Sync cluster status  | 同步k8s集群状态
kubecluster-terminate | Terminate cluster | 删除集群
kubecluster-usable-instances | Get deploy usable instance | 获取可用的节点
kubemachine-create | Create k8s machine | 在k8s集群中创建节点
kubemachine-delete | Delete machine | 在k8s集群中删除节点
kubemachine-event | Show operation event logs of kubernetes machine | 显示k8s集群中节点操作日志
kubemachine-list | List k8s node machines | 列出k8s集群中所有节点
kubemachine-recreate | Re-Create machine when create fail | 节点创建失败后重新创建
kubemachine-show | Show details of a machine | 显示节点详情
kubemachine-terminate |  Terminate a machine | 删除节点
k8s-app-meter-create | Create yunion meter helm release | 从应用目录部署meter服务
k8s-app-notify-create | Create yunion notify helm release | 从应用目录部署通知服务
k8s-app-servicetree-create | Create yunion servicetree helm release | 从应用目录部署服务树
k8s-chart-list | List k8s helm global charts | 列出所有应用目录
k8s-chart-show | Show details of a chart | 显示应用目录详情
k8s-configmap-delete | Delete k8s configmap | 删除k8s配置项
k8s-configmap-list | List k8s configmap | 列出所有k8s配置项
k8s-configmap-show | Show k8s configmap | 显示k8s配置项详情
k8s-cronjob-create | Create cronjob resource | 创建定时任务
k8s-cronjob-delete | Delete k8s cronjob | 删除定时任务
k8s-cronjob-list | List k8s cronjob | 列出所有定时任务
k8s-cronjob-show | Show k8s cronjob | 显示定时任务详情
k8s-create | Create resource by file | 通过文件创建资源
k8s-daemonset-delete | Delete k8s daemonset | 删除k8s daemonset资源
k8s-daemonset-list | List k8s daemonset | 列出所有k8s daemonset资源
k8s-daemonset-show | Show k8s daemonset | 显示k8s daemonset资源详情
k8s-delete | Delete k8s resource instance | 删除k8s资源
k8s-deployment-create | Create deployment resource |创建无状态应用
k8s-deployment-delete | Delete k8s deployment | 删除无状态应用
k8s-deployment-list | List k8s deployment | 列出所有无状态应用
k8s-deployment-show | Show k8s deployment | 显示无状态应用详情
k8s-deployment-update | Update deployment resource | 更新无状态应用
k8s-edit | Edit k8s resource instance | 修改k8s资源
k8s-get | Get k8s resource instance raw info | 获取k8s资源
k8s-ingress-create | Create ingress rules to service | 创建路由
k8s-ingress-delete | Delete k8s ingress | 删除路由
k8s-ingress-list | List k8s ingress | 列出所有路由
k8s-ingress-show | Show k8s ingress | 显示路由详情
k8s-job-create | Create job resource | 创建任务
k8s-job-delete | Delete k8s job | 删除任务
k8s-job-list | List k8s job | 列出所有任务
k8s-job-show | Show k8s job | 显示任务详情
k8s-namespace-delete | Delete k8s namespace | 删除命名空间
k8s-namespace-list | List k8s namespace | 列出所有命名空间
k8s-namespace-show | Show k8s namespace | 显示命名空间详情
k8s-node-list | List k8s node | 列出所有k8s节点信息
k8s-node-show | Show k8s node | 显示k8s详情
k8s-node-delete | Delete k8s node | 删除k8s节点
k8s-put | Update k8s resource instance | 更新k8s资源
k8s-pod-delete | Delete k8s pod | 删除容器组
k8s-pod-list | List k8s pod | 列出所有容器组
k8s-pod-show | Show k8s pod | 显示容器组详情
k8s-persistentvolume-delete | Delete k8s persistentvolume | 删除pv
k8s-persistentvolume-list | List k8s persistentvolume | 列出所有pv
k8s-persistentvolume-show | Show k8s persistentvolume | 显示pv详情
k8s-pvc-create | Create PersistentVolumeClaims resource | 创建pvc
k8s-pvc-delete | Delete k8s pvc | 删除pvc
k8s-pvc-list | List PersistentVolumeClaims resource | 列出所有pvc
k8s-pvc-show | Show k8s pvc | 显示pvc详情
k8s-rbacrole-delete | Delete k8s rbacrole | 删除rbac角色
k8s-rbacrole-list | List k8s rbacrole | 列出所有rbac角色
k8s-rbacrole-show | Show k8s rbacrole | 显示rbac详情
k8s-rbacrolebinding-delete | Delete k8s rbacrolebinding | 删除角色绑定
k8s-rbacrolebinding-list | List k8s rbacrolebinding | 列出所有角色绑定
k8s-rbacrolebinding-show | Show k8s rbacrolebinding | 显示角色绑定详情
k8s-registrysecret-create | Create docker registry secret resource | 新建镜像仓库密钥
k8s-registrysecret-delete | Delete k8s registrysecret | 删除镜像仓库密钥
k8s-registrysecret-list | List k8s registrysecret | 列出所有镜像仓库密钥
k8s-registrysecret-show | Show k8s registrysecret | 显示镜像仓库密钥详情
k8s-release-create | Create release with specified helm chart | 创建发布
k8s-release-delete | Delete release | 删除发布
k8s-release-history | Get release history | 获取发布的历史信息
k8s-release-list | List k8s cluster helm releases | 列出所有发布
k8s-release-rollback | Rollback release by history revision number | 回滚发布
k8s-release-show | Get helm release details | 获取发布详情
k8s-release-upgrade | Upgrade release | 更新发布
k8s-repo-create | Add repository | 添加应用目录
k8s-repo-delete | Delete a repository | 删除应用目录
k8s-repo-list | List k8s global helm repos | 列出所有应用目录
k8s-repo-private | Make repository private | 将应用目录设为私有
k8s-repo-public | Make repository public | 将应用目录设为共享
k8s-repo-show | Show details of a repo | 显示应用目录详情
k8s-repo-sync | Sync a repository | 同步应用目录
k8s-repo-update |  Update helm repository | 更新应用目录
k8s-secret-ceph-csi-create | Create ceph csi user secret | 创建ceph csi用户字典
k8s-secret-list | List secret resource | 列出所有保密字典
k8s-secret-show | Show k8s secret | 显示保密字典详情
k8s-service-create | Create service resource | 创建服务
k8s-service-delete |  Delete k8s service | 删除服务
k8s-service-list | List Services resource | 列出所有服务
k8s-service-show | Show k8s service | 显示服务详情
k8s-serviceaccount-delete | Delete k8s serviceaccount | 删除服务账户
k8s-serviceaccount-list | List k8s serviceaccount | 列出所有服务账户
k8s-serviceaccount-show | Show k8s serviceaccount | 显示服务账户详情
k8s-statefulset-create | Create statefulset resource | 创建有状态应用
k8s-statefulset-delete | Delete k8s statefulset | 删除有状态应用
k8s-statefulset-list | List k8s statefulset | 列出所有有状态应用
k8s-statefulset-show | Show k8s statefulset | 显示有状态应用详情
k8s-storageclass-ceph-csi-rbd-connection-test | Test storageclass connection | 测试与存储类的连接
k8s-storageclass-ceph-csi-rbd-create | Create ceph csi rbd | 创建ceph csi
k8s-storageclass-delete | Delete k8s storageclass | 删除存储类
k8s-storageclass-list | List k8s storageclass | 列出所有存储类
k8s-storageclass-set-default | Set storageclass as default | 将存储类设置成默认
k8s-storageclass-show | Show k8s storageclass | 显示存储类详情
k8s-tiller-create | Install helm tiller server to Kubernetes cluster | 安装helm服务端
label-create | Create a label | 创建标签
label-delete | Delete a label | 删除标签
label-list | List labels | 列出所有标签
label-update | Update a label | 更新标签
labels-for-alerttemplate | List all the labels for the alert-templates | 列出所有告警模板标签
lbacl-cache-create | Create cached lbacl | 创建负载均衡访问控制的缓存
lbacl-cache-delete | Delete cached lbacl | 删除负载均衡访问控制的缓存
lbacl-cache-list | List cached lbacls | 列出所有负载均衡访问控制缓存
lbacl-cache-purge | Purge cached lbacl | 从数据库删除负载均衡访问控制缓存
lbacl-cache-show | Show cached lbacl | 显示负载均衡访问控制缓存详情
lbacl-create | Create lbacl | 创建负载均衡访问控制
lbacl-delete | Show lbacl | 删除负载均衡访问控制
lbacl-list | List lbacls | 列出所有负载均衡访问控制
lbacl-patch | Patch lbacls | 修改负载均衡访问控制
lbacl-purge | Purge lbacl | 从数据库删除负载均衡访问控制
lbacl-show | Show lbacl | 显示负载均衡访问控制详情
lbacl-update | Update lbacls | 更新负载均衡访问控制ƒ
lbagent-create | Create lbagent | 创建负载均衡节点
lbagent-delete | Show lbagent | 显示负载均衡节点详情
lbagent-deploy | Deploy lbagent | 部署负载均衡节点
lbagent-heartbeat | Emulate a lbagent heartbeat | 检测负载均衡节点的心跳
lbagent-list | List lbagents | 列出所有负载均衡节点
lbagent-params-patch | Patch lbagent params | 更新负载均衡节点参数
lbagent-show | Show lbagent | 显示负载均衡节点详情 
lbagent-undeploy | Undeploy lbagent | 下线负载均衡节点
lbagent-update | Update lbagent | 更新负载均衡节点 
lbcert-cache-create | Create cached lbcert | 创建负载均衡证书缓存
lbcert-cache-delete | Delete cached lbcert | 删除负载均衡证书缓存
lbcert-cache-list | List cached lbcerts | 列出所有负载均衡证书缓存
lbcert-cache-purge | Purge cached lbcert | 清除关于负载均衡证书缓存的数据库记录
lbcert-cache-show | Show cached lbcert | 显示负载均衡证书缓存详情
lbcert-create | Create lbcert | 创建负载均衡证书
lbcert-delete | Delete lbcert | 删除负载均衡证书
lbcert-list | List lbcerts | 列出所有负载均衡证书
lbcert-purge | Purge lbcert | 清除关于负载均衡证书的数据库记录
lbcert-show | Show lbcert | 显示负载均衡证书详情
lbcert-update | Update lbcert | 更新负载均衡证书
lbcluster-create | Create lbcluster | 创建负载均衡集群
lbcluster-delete | Delete lbcluster | 删除负载均衡集群
lbcluster-list | List lbclusters | 列出所有负载均衡集群
lbcluster-show | Show lbcluster | 显示负载均衡集群详情
lbcluster-update | Update lbcluster | 更新负载均衡集群
lblistener-backend-status | Get lblistene backend status | 查看负载均衡实例监听的后端服务器组状态
lblistener-create | Create lblistener | 创建负载均衡实例监听
lblistener-delete | Delete lblistener | 删除负载均衡实例监听
lblistener-list | List lblisteners | 列出负载均衡实例监听
lblistener-purge | Purge lblistener | 清除关于负载均衡实例监听的数据库记录
lblistener-show | Show lblistener | 显示负载均衡实例监听详情
lblistener-status | Change lblistener status | 更改负载均衡实例监听状态
lblistener-syncstatus | Sync lblistener status | 同步负载均衡实例监听状态
lblistener-update | Update lblistener | 更新负载均衡实例监听
lblistenerrule-backend-status | Get lblistenerrule backend status | 查看负载均衡实例转发策略关联的后端服务器组状态
lblistenerrule-create | Create lblistenerrule | 创建负载均衡实例转发策略
lblistenerrule-delete | Delete lblistenerrule | 删除负载均衡实例转发策略
lblistenerrule-list | List lblistenerrules | 列出所有负载均衡实例转发策略
lblistenerrule-purge | Purge lblistenerrule | 清除关于负载均衡实例转发策略的数据库记录
lblistenerrule-show | Show lblistenerrule | 显示负载均衡实例转发策略详情
lblistenerrule-status | Change lblistenerrule status| 更改负载均衡实例转发策略
lblistenerrule-update | Update lblistenerrule | 更新负载均衡实例转发策略
lbnetwork-list | List loadbalancer network pairs | 列出负载均衡器网络配对
licenses-list | show licenses | 列出所有License
licenses-show | show actived license | 显示有效License详情
licenses-usage | show license usages status | 显示License利用率信息m
list-labels-for-node | List labels for the node | 列出节点所有标签
meshnetwork-create | Create mesh network | 创建mesh网络
meshnetwork-delete | Delete mesh network | 删除mesh网络
meshnetwork-list | List mesh networks | 列出所有mesh网络
meshnetwork-realize | Realize mesh network | 使mesh网络中的路由器配置生效
meshnetwork-show | Show mesh network | 显示mesh网络详情
meshnetwork-update | Update mesh network | 更新mesh网络
metadata-list | List metadatas | 列出元数据 
meteralert-create | Create a meter alert rule | 创建消费预警规则
meteralert-delete | Delete a meter alert | 删除消费预警
meteralert-change-status | Change status of a meter alert | 更新消费告警状态
meteralert-list | List meter alert | 列出所有消费告警
metric-details | Show metric details by name | 按名称显示计量详情
metric-list | List all metrics |列出所有计量
metric-show | Show metric details |显示计量详情
metrictype-metric-list | List metric types of the monitor type |列出监控类型的计量类型
module-list | List all modules | 列出所有模块信息
monitor-metrics-set | Set monitor metric for the tree-node |设置树节点的监控计量
monitorinputs-list | List all monitor-inputs |列出所有监控输入
monitorinputs-metrics-list | List all metrics for the monitor-inputs |列出所有监控输入的计量
monitortemplate-attach-monitorinput | Add a monitor-input to a monitor-template |增加一条监控输入给监控模板
monitortemplate-create | Create or update contact for user |创建或更新一条用户的联系信息
monitortemplate-delete | Delete a monitor-template |删除一条监控模板
monitortemplate-detach-monitorinput | Add a monitor-input to a monitor-template |增加一条监控输入到监控模板
monitortemplate-list | List all monitor-template |列出所有监控模板
monitortemplate-monitorinput-list | Get monitor-inputs of a monitor-template |获取监控模板的监控输入
monitortemplate-show | Show monitor-template |显示监控模板
monitortemplate-update | Update a monitor-template |更新一条监控模板
monitortype-list | List all monitor types |列出所有监控类型
monitortype-metrictype-list | List metric types of the monitor type |列出监控类型的计量类型
natgateway-dnat-resources | list resources in dnats of natgateway | 列出所有dnat资源
natgateway-list | List NAT gateways | 列出所有nat网关
natgateway-show | Show a NAT gateway | 显示nat网关详情
natgateway-snat-resources | list resources in snats of natgateway | 列出所有snat资源
network-add-dns-update-target | Add a dns update target to a network | 为IP子网添加dns
network-addresses | Query used addresses of network | 查询IP子网中已被使用的IP地址
network-create | Create a virtual network | 创建经典IP子网
network-create2 | Create a virtual network | 创建VPC类型的IP子网
network-delete | Delete a network | 删除IP子网
network-event | Show operation event logs of network | 显示IP子网操作日志
network-interface-list | List networkinterfaces | 列出所有网络接口
network-interface-show | Show networkinterface detail | 显示网络接口详情
network-list | List networks | 列出IP子网
network-merge | Merge two network to be one | 合并IP子网
network-metadata | Show metadata of a network | 显示IP子网元数据    
network-private | Make a network private | 使IP子网私有
network-public | Make a network public | 使IP子网公有
network-purge | Purge a managed network, not delete the remote entity | 删除IP子网的数据库记录
network-release-reserved-ip | Release a reserved IP into pool | 释放预留IP
network-reserve-ip | Reserve an IP address from pool | 预留IP
network-set-static-routes | Set static routes for a network | 为IP子网设置静态路由
network-set-schedtag | Set schedtags to network | 为IP子网设置调度标签
network-show | Show network details | 显示IP子网详情
network-split | Split a network at the specified IP address | 从指定IP分割IP子网
network-status | Set on-premise network status | 设置IP子网的可用状态
network-sync | Sync network status | 同步IP子网
network-update | Update network |更新IP子网
node-create | Create a monitor node record |创建监控节点记录
node-list | List all nodes |列出所有节点
nodealert-create | Create a node alert rule | 创建虚拟机告警规则
nodealert-delete | Delete a node alert | 删除虚拟机告警
nodealert-disable | Disaable alert rule for the specified ID | 禁用虚拟机告警
nodealert-enable | Enable alert rule for the specified ID | 启用虚拟机告警
nodealert-list | List node alert | 列出所有告警信息
nodealert-update | Update the node alert rule | 更新虚拟机告警规则
notice-create | create a notice | 创建公告
notice-delete | delete notice | 删除公告
notice-list | list notices | 列出所有公告
notice-update | update notice | 更新公告信息
notification-update-callback | Update send status of the notification task |更新通知任务的发送状态
notify | Send a notification to someone | 给某人发送通知
notify-batch | Send a notification to someones | 给一些人发通知
notify-broadcast | Send a notification to all online users | 给所有在线用户发通知
notify-config-delete | config delete | 删除通知配置信息
notify-config-update | config update, example: notify_config-update email mail.smtp.hostname hostname mail.smtp.hostport 123. | 更新通知配置
notify-config-validate | config validate | 使配置生效
notify-config-show | config show | 显示通知配置信息
notify-list | List notification history | 列出通知历史
notify-template-delete | delete notify template | 删除通知模板
notify-template-list | List all notify template | 列出所有通知模板
notify-template-update | Create, update contact for user | 为用户新增或更新联系方式
operation-create | Create a operation | 创建操作
operation-list | List operations | 列出所有操作
operation-show | Show operation details | 显示操作详情
operation-update | Update operation | 更新操作
parameter-create | create a parameter | 创建参数
parameter-delete | delete notice | 删除参数
parameter-list | list parameters | 列出所有参数
parameter-show | show a parameter | 显示参数详情
parameter-update | update parameter | 更新参数
performance-top5 | Show performance top5 | 显示性能top5
policy-admin-capable | Check admin capable | 检查是否有admin权限
policy-create | Create policy | 创建权限
policy-delete | Delete policy | 删除权限
policy-edit | Edit and update policy | 更新权限
policy-event | Show operation event logs of keystone policies | 显示权限操作日志
policy-explain | Explain policy result | 解释权限匹配结果
policy-list | List all policies | 列出所有权限
policy-patch | Patch policy | 更新权限
policy-public | Mark a policy public | 将权限设置为公有
policy-private | Mark a policy private | 将权限设置为私有
policy-show | Show policy | 显示权限详情
policy-update | Patch policy | 更新权限
pprof-profile | pprof profile of backend service | 调试后端服务
pprof-trace | pprof trace of backend service | 调试后端服务
process-definition-change-state | Update the state of the process definition | 更新工单流程的状态
process-definition-delete | Delete process definition by ID | 根据ID删除工单流程
process-definition-list | List process definition | 列出所有工单流程
process-definition-show | Show process definition | 显示工单流程详情   
process-instance-create | Create process instance | 发起工单
process-instance-delete |  Delete process instance by ID | 根据ID删除工单
process-instance-list | List process instance | 列出所有工单
process-instance-show | Show process instance  | 显示工单详情
process-task-operate | Operate task | 工单审批操作
process-task-list | List task | 列出所有审批操作
process-task-show | Show task details | 显示审批细节
process-list | List processes | 列出所有进程
process-show | Show process details | 显示进程详情
project-add-group | Add group to project with role |将组以某种角色加入项目
project-add-user | Add user to project with role |将用户以某种角色加入项目
project-add-user-group | Batch add users/groups to project | 同时将用户和组加入项目
project-batch-join | Batch join users or groups into project with role | 同时将用户和组以某种角色加入项目
project-create | Create a project | 创建项目
project-delete | Delete a project | 删除项目
project-event | Show operation event logs of keystone projects | 显示项目操作日志
project-group-roles | Get roles for group in project |从项目中的组中获取角色
project-has-group | Check a group in a project with a role |检查带有角色的项目中的组
project-has-user | Check a user in a project with a role |检查带有角色的项目中的用户
project-list | List projects |列出所有项目
project-quota | Show project-quota for current user or tenant | 显示项目配额
project-quota-set | Set project quota for tenant | 为项目设置配额
project-quota-list | List project quota of domains or projects of a domain | 列出所有项目配额或域配额
project-remove-group | Remove a role for a group in a project | 将组移出项目
project-remove-user | Remove a user role from a project | 将用户移出项目
project-remove-user-group | Remove users/groups from project | 同时将用户或组移出项目
project-resource-show | query backend service for its project resource count | 查询后端服务对应项目资源统计
project-show | Show details of project |显示项目详情
project-update | Update a project |更新项目
project-user-roles | Get roles of a user in a project |获取项目中用户的角色
projectadmin-list | List all Project Admins |列出所有项目的管理员
projectadmincandidate-list | List all Project Admin Candidates |列出所有项目管理候选人
prosesslog-list | List processlogs |列出进程日志
quota | Show quota for current user or tenant | 显示当前用户或项目的配额
quota-set | Set quota for tenant | 设置配额
quota-list | List quota of domains or projects of a domain | 列出配额
rate-create | Create a rate | 创建费率
rate-delete | Delete a rate | 删除费率
rate-list | List all rates  | 列出所有费率
rate-show | Show rate details | 显示费率详情
rate-update | Update a rate | 更新费率
region-create | Create a region |创建区域
region-delete | Delete region |删除区域
region-event | Show operation event logs of region | 显示区域操作日志
region-list | List regions |列出所有区域
region-quota | Show region-quota for current user or tenant | 区域配额
region-quota-list | List region quota of domains or projects of a domain | 列出区域配额
region-quota-set | Set regional quota for tenant | 设置区域配额
region-show | Show details of region |显示区域详情
region-task-list | List tasks on region server |列出区域服务器的任务
region-task-show | Show details of a region task |列出区域任务详情
region-update | Update a region |更新区域
remove-alert-from-template | Remove alert from alert-template |从告警模板中移除告警
remove-labels-from-node | Remove labels from node |从节点中移除标签
reserved-ip-list | Show all reserved IPs for any network | 显示所有网络中的预留IP
reserved-ip-update | update reserved ip notes | 更新预留IP
resourcedetail-list | List all resource details |列出所有资源详情
resourcefee-list | List all resource fees |列出所有资源费用
role-assignments | List all role assignments |列出所有角色分配
role-create | Create role |创建新角色
role-delete | Delete a role |删除角色
role-event | Show operation event logs of keystone roles | 显示角色操作日志
role-list | List keystone Roles | 列出所有角色
role-private | Mark a role private | 将角色设置为私有
role-public | Mark a role public | 将角色设置为公有    
role-show | Show details of a role | 显示角色详情
role-update | Update role | 更新角色
router-create | Create router | 创建路由器
router-delete | Delete router | 删除路由器
router-join-meshnetwork | Router join meshnetwork | 将路由器加入mesh网络
router-leave-meshnetwork | Router leave meshnetwork | 将路由器离开mesh网络
router-list | List routers | 列出所有路由器
router-realize | Router realize | 使路由器配置生效
router-register-ifname | Router register new ifname | 路由器注册网卡
router-route-create | Create router | 创建路由器的路由
router-route-delete | Delete router | 删除路由器的路由
router-route-list | List routers | 列出路由器的所有路由
router-route-show | Show router | 显示路由器的路由详情
router-route-update | Update router | 更新路由器的路由
router-rule-create | Create router rule | 创建路由器的防火墙规则
router-rule-delete | Delete router rule | 删除路由器的防火墙规则
router-rule-list | List router rules | 列出路由器的所有防火墙规则
router-rule-show | Show router rule | 显示路由器防火墙规则的详情
router-rule-update | Update router rule | 更新路由器防火墙规则
router-unregister-ifname | Router unregister ifname | 路由器取消注册网卡
router-update | Update router | 更新路由器           
routetable-add-routes | Add routes to routetable | 在路由表中添加路由
routetable-create | Create routetable | 创建路由表
routetable-del-routes | Del routes to routetable | 在路由表中删除路由
routetable-delete | Show routetable | 删除路由
routetable-list | List routetables | 列出所有路由表
routetable-purge | Purge routetable | 删除路由表的数据库记录
routetable-show | Show routetable | 显示路由表详情
routetable-update | Update routetable | 更新路由表
sched-policy-create | create a sched policty | 创建调度策略
sched-policy-delete | delete a sched policy | 删除调度策略
sched-policy-evaluate | Evaluate sched policy | 设置调度策略的条件
sched-policy-list | List scheduler policies | 列出所有调度策略
sched-policy-show | show details of a sched policy | 显示调度策略详情
sched-policy-update | update a sched policy | 更新调度策略
schedtag-create | Create a schedule tag |创建调度标签
schedtag-delete | Delete a scheduler tag |删除调度标签
schedtag-host-add | Add a schedtag to a host | 为宿主机增加调度标签
schedtag-host-list | List all scheduler tag and host pairs | 列出所有绑定调度标签的宿主机
schedtag-host-remove | Remove a schedtag from a host | 宿主机移除调度标签
schedtag-list | List schedule tags | 列出所有调度标签
schedtag-network-list | List all scheduler tag and network pairs | 列出所有绑定调度标签的IP子网
schedtag-network-add | Add a schedtag to a network | 为IP子网添加调度标签
schedtag-network-remove | Remove a schedtag to a network | 为IP子网移除调度标签
schedtag-show | Show scheduler tag details |显示调度标签详情
schedtag-storage-list | List all scheduler tag and storage pairs | 列出所有绑定调度标签的存储
schedtag-storage-add | Add a schedtag to a storage | 为存储绑定调度标签
schedtag-storage-remove | Remove a schedtag to a storage | 为存储移除标签
schedtag-update | Update a schedule tag | 更新调度标签
schedtag-usage | Show general usage of a scheduler tag | 显示调度标签通用用法
scheduler-candidate-list | List scheduler candidates | 列出默认调度标签
scheduler-candidate-show | Show candidate detail | 显示默认调度标签
scheduler-clean-cache | Clean scheduler hosts cache | 清除调度缓存
scheduler-forecast | Forecast scheduler result | 预测调度结果
scheduler-history-list | Show scheduler history list | 显示调度器历史列表
scheduler-history-show | Show scheduler history detail | 显示调度器详情
scheduler-sync-sku | Sync scheduler SKU cache | 同步调度套餐缓存
scheduler-test | Emulate schedule process | 模拟调度进程
secgroup-add-rules | Add security rules to a security group |给安全组增加安全规则
secgroup-cache-delete  | Delete security group cache | 删除安全组缓存
secgroup-cache-list | List security group caches | 列出所有安全组缓存
secgroup-cache-secgroup | Cache security group for special vpc | 为特殊VPC缓存安全组
secgroup-cache-show | Show security group cache | 显示安全组缓存详情
secgroup-create | Create a security group | 创建安全组
secgroup-delete | Delete a security group | 删除安全组
secgroup-list | List all security group | 列出所有安全组
secgroup-private | Make a security group private | 将安全组设置为私有
secgroup-public | Make a security group publicly available | 将安全组设置为公有
secgroup-rule-create | Create all security group rule | 新增安全组规则
secgroup-rule-delete | Delete a disk | 删除安全组规则
secgroup-rule-list | List all security group | 列出所有安全组规则
secgroup-rule-show | Show details of rule | 显示规则详情
secgroup-rule-update | Update property of a security group rule | 更新安全组
secgroup-show | Show details of a security group |显示安全组详情
secgroup-uncache-secgroup | Unache special secgroup cache | 禁止缓存安全组
secgroup-union | Union secgroups to one secgroup | 合并安全组
secgroup-update | Update details of a security group |更新安全组详情
server-add-tag | Set tag of a server | 为虚拟机绑标签server-add-secgroup | Add security group to a Server | 为虚拟机绑定安全组
server-add-extra-options | Add server extra options | 为虚拟机添加额外功能
server-action | Show operation action logs of server |显示虚拟机操作日志
server-assign-admin-secgroup | Assign administrative security group to a Server |为虚拟机配置管理安全组
server-assign-secgroup | Assign security group to a Server |为虚拟机配置安全组
server-associate-eip | Associate a server and an eip | 为虚拟机分配EIP
server-attach-disk | Attach an existing virtual disks to a virtual server |为虚拟服务器增加虚拟磁盘
server-attach-isolated-device | Attach an existing isolated device to a virtual server |为虚拟机增加隔离的设备
server-attach-network | Attach a server to a virtual network |给虚拟网络增加一台服务器
server-batch-add-tag | add tags for some server | 虚拟机批量添加标签
server-batch-set-tag | Set tags for some server | 虚拟机批量编辑标签
server-cancel-delete | Cancel pending delete servers | 从回收站恢复虚拟机
server-change-bandwidth | Change server network bandwidth in Mbps |更新服务器网络带宽Mbps
server-change-config | Change configuration of Server |修改虚拟机的配置
server-change-ipaddr | Change ipaddr of a virtual server | 修改虚拟机IP
server-change-owner | Change owner porject of a server |修改虚拟机项目拥有者
server-check-create-data | Check create server data | 检查新建虚拟机数据
server-clone | Clone a server | 克隆虚拟机
server-create | Create a server |新建虚拟机
server-create-backup | Create backup guest | 创建备份虚拟机
server-create-disk | Create a disk and attach it to a virtual server |创建磁盘，并挂载给一台宿主机
server-create-eip | allocate an EIP and associate EIP to server | 为虚拟机绑定EIP
server-create-from-instance-snapshot | server create from instance snapshot | 从主机快照创建虚拟机
server-create-params | Show server create params | 显示虚拟机创建参数
server-delete | Delete servers | 删除虚拟机
server-delete-backup | Guest delete backup | 删除备虚拟机
server-deploy | Deploy hostname and keypair to a stopped virtual server |为一台已停止的虚拟机部署主机名和密钥对
server-desc | Show desc info of server |显示虚拟机描述信息
server-detach-disk | Detach a disk from a virtual server |从虚拟机分离一块磁盘
server-detach-isolated-device | Detach a isolated device from a virtual server |从虚拟机中分离已隔离的设备
server-detach-network | Detach the virtual network from a virtual server |从虚拟机中分离虚拟网络
server-disable-recycle | Pull a prepaid server from recycle pool, so that it will not be shared anymore | 将主机删除放入回收站
server-disk-create-snapshot | Task server disk snapshot | 为虚拟机硬盘创建快照
server-disk-list | List server disk pairs |列出虚拟机硬盘配对
server-disk-show | Show server disk details |显示虚拟机硬盘详情
server-disk-update | Update details of a virtual disk of a virtual server |更新虚拟机的虚拟硬盘详情
server-dissociate-eip | Dissociate an eip from a server | 取消虚拟机与EIP的关联
server-eject-iso | Eject iso from servers' cdrom | 卸载iso
server-enable-recycle | Put a prepaid server into recycle pool, so that it can be shared | 从回收站恢复虚拟机
server-event | Show operation event logs of server |显示虚拟机的操作日志
server-export-virt-install-command | Export virt-install command line from existing guest | 从已存在的虚拟机中导出lib命令
server-import | Import a server by desc file | 导入虚拟机
server-insert-iso | Insert an ISO image into server's cdrom | 挂载iso
server-io-throttle | Guest io set throttle | 设置磁盘速度
server-iso | Show server's mounting ISO information | 显示虚拟机挂载的iso信息
server-leave-groups | Leave multiple groups | 从反亲和组移除虚拟机
server-live-migrate | Migrate server | 开机状态下迁移虚拟机
server-list | List virtual servers |列出所有虚拟虚拟机
server-logininfo | Get login info of a server |获取虚拟机的登录信息
server-metadata | Show metadata of a server |显示虚拟机的元数据
server-migrate | Migrate server | 迁移虚拟机
server-modify-src-check | Modify src ip, mac check settings | 修改虚拟机源IP和MAC绑定配置
server-monitor | Send commands to qemu monitor |给QEMU监控器发送命令
server-network-list | List server network pairs |列出虚拟机网络配对
server-network-show | Show server network details |显示虚拟机网络详情
server-network-update | Update server network settings |更新虚拟机网络设置
server-purge | Purge obsolete servers | 从数据库中删除虚拟机
server-rebuild-root | Rebuild Server root image with new template | 重装系统
server-remote-nics | Show remote nics of a server | 显示虚拟机网卡
server-remove-extra-options | Remove server extra options | 移除虚拟机额外选项
server-renew | Renew a server | 克隆
server-reset | Reset servers | 重置虚拟机
server-resize-disk | Resize attached disk of a server | 设置磁盘大小
server-restart | Restart servers | 重启
server-resume | Resume servers | 恢复
server-revoke-admin-secgroup | Assign administrative security group to a Server | 虚拟机取消系统关联安全组
server-revoke-secgroup | Revoke security group to a Server |虚拟机取消关联的安全组
server-save-image | Save root disk to new image and upload to glance. |保存硬盘镜像
server-save-guest-image | save root disk and data disks to new images and upload to glance. | 保存主机镜像
server-send-keys | Send keys to server |给虚拟机发送密钥
server-set-qemu-params | config qemu params | 配置qemu参数
server-set-secgroup | Set security groups to a Server | 为虚拟机设置安全组
server-set-tag | Set tag of a server | 编辑标签 
server-set-user-data | Update server user_data | 更新虚拟机用户数据
server-show | Show details of a server |显示虚拟机详情
server-sku-cache | Cache Server SKU for private cloud | 为私有云缓存虚拟机套餐
server-sku-create | Create a server sku record | 创建套餐
server-sku-delete | Delete a server sku | 删除套餐
server-sku-disable | Disable Server SKU | 禁用套餐
server-sku-enable | Enable Server SKU | 启用套餐
server-sku-list | List all avaiable Server SKU | 列出所有可用套餐
server-sku-specs-list | List all avaiable Server SKU specifications | 列出所有可用套餐规格
server-sku-show | show details of a avaiable Server SKU | 显示套餐详情
server-sku-update | Update server sku attributes | 更新套餐
server-start | Start servers |启动虚拟机
server-status | Show status of server |显示虚拟机状态
server-stop | Stop servers |停止虚拟机
server-suspend | Suspend servers |挂起虚拟机
server-switch-to-backup | Switch geust master to backup host | 切换到备虚拟机
server-sync | Sync servers status |同步虚拟机状态
server-syncstatus | Sync servers status |同步虚拟机状态
server-sync-fix-nics | Fix missing IP for each nics after syncing VNICS | 同步修复虚拟机没有IP的问题
server-tasks | Show tasks of a server | 显示虚拟机任务
server-template-create | Create a server template | 创建主机模板
server-tempalte-delete | Delete a server template | 删除主机模板
server-template-list | List server template | 列出所有主机模板
server-template-private | Private server template | 将主机模板设置为私有
server-template-public | Public server template | 将主机模板设置为公有
server-template-show | Show a server template | 显示主机模板详情
server-template-update | Update a server template | 更新主机模板
server-update | Update servers |更新虚拟机
server-vnc | Show vnc info of server |显示服务VNC信息
service-catalog-create | Create a service catalog | 创建服务目录
service-catalog-delete | delete a service catalog | 删除服务目录
service-catalog-deploy | deploy | 部署服务目录
service-catalog-list | List service catalog | 列出所有服务目录
service-catalog-show | show a service catalog | 显示服务目录详情
service-catalog-update | update a service catalog | 更新服务目录
service-config | Add config to service | 添加服务配置
service-config-edit | Edit config yaml of a service | 编辑服务配置
service-config-show | Show configs of a service | 显示服务配置
service-config-yaml | Config service with a yaml file | 通过yaml文件配置服务
service-create | Create a service |创建服务
service-delete | Delete a service |删除服务
service-event | Show operation event logs of keystone services | 显示服务日志
service-list | List services |列出所有虚拟机
service-registry-list | List all service registries | 列出所有服务仓库
service-show | Show details of a service |显示服务详情
service-update | Update a service |更新服务
servicehost-create | Add host to tree-node |给树节点增加宿主机
servicehost-delete | Remove host from tree-node |从树节点移除宿主机
servicehost-list | List all hosts for the tree-node |列出树节点所有宿主机
servicenamesuggestion-list | List all serviceNameSuggestion |列出所有的服务名字建议
servicetree-create | Create a service tree |创建一颗服务树
servicetree-delete | Delete a service tree |删除一颗服务树
servicetree-list | List all service tree |列出所有服务树
servicetree-node-change-project-type | servicetree-node-change-project-type | 更改服务树项目类型
servicetree-node-create | Create a service-tree node |创建服务树节点
servicetree-node-delete | Delete a servicetree node |删除服务树节点
servicetree-node-list | List servicetree nodes |列出所有服务树节点
servicetree-node-show | Show details of a servicetree node |显示服务树节点详情
servicetree-node-update | Update a servicetree node |更新服务树节点
servicetree-show | Show service tree details |显示服务树详情
servicetree-update | Update a service tree |更新一颗服务树
sms-config-create | Create a sms Config |创建一条sms配置
sms-config-delete | Delete a sms config |删除一条sms配置
sms-config-show | Show sms config details |显示sms配置详情
sms-config-update | Update a sms-config |更新一条sms配置
snapshot-create | Create a snapshot | 创建快照
snapshot-delete | Delete snapshots | 删除快照
snapshot-list | Show snapshots | 列出所有快照
snapshot-policy-bind-disk | bind snapshotpolicy to disks | 自动快照策略绑定硬盘
snapshot-policy-cache | upload local snapshotpolicy to cloud | 缓存自动快照策略
snapshot-policy-create | Create snapshot policy | 创建自动快照策略
snapshot-policy-delete | Delete snapshot policy | 删除自动快照策略
snapshot-policy-disk-list | List disk attached | 列出自动快照策略关联的硬盘
snapshot-policy-list | List snapshot policy | 列出所有自动快照策略
snapshot-policy-unbind-disk | bind snapshotpolicy to disks | 自动快照策略解绑硬盘
snapshot-purge | Purge Snapshot db records | 删除快照数据库记录
snapshot-show | Show snapshot details | 显示快照详情
snat-create | Create a SNAT | 创建SNAT
snat-delete | Delete a SNAT | 删除SNAT
snat-list | List SNAT entries | 列出所有SNAT
snat-show | Show a SNAT | 显示SNAT详情          
spec | List all kinds of model specs |列出所有模型规范
spec-hosts-list | List hosts according by specs |通过规范列出所有宿主机
spec-isolated-devices-list | List isolated devices according by specs |通过规范列出所有隔离的设备
sshkeypair-show | Get ssh keypairs | 获取ssh密钥
storage-cache-delete | Delete storage cache | 删除存储缓存
storage-cache-image | Ask a storage to cache a image | 将镜像缓存到存储
storage-cache-list | List storage caches | 列出存储缓存
storage-cache-show | Show details of storage caches | 显示存储缓存详情
storage-cached-image-list | List storage cached image pairs | 列出所有存储缓存的镜像
storage-cached-image-show | Show storage cached image | 显示存储缓存的镜像详情
storage-cached-image-update | Update storage cached image | 更新存储的镜像缓存
storage-create | Create a Storage |创建存储
storage-delete | Delete a storage |删除存储
storage-disable | Disable a storage |禁用存储
storage-enable | Enable a storage |启用存储
storage-list | List storages |列出所有存储
storage-offline | Offline a storage | 存储离线
storage-online | Online a storage | 存储在线
storage-set-schedtag | Set schedtags to storage | 为存储设置调度标签               
storage-show | Show storage details |显示存储详情
storage-uncache-image | Ask a storage to remove image from its cache | 移除镜像缓存
storage-update | Update a storage |更新存储
tag-list | List tags | 列出所有标签
task-list | List taskman |列出任务人
tenant-list | List tenants |列出用户
treenode-recipient-create | Add recipients to tree-node |为树节点增加接收人
treenode-recipient-delete | Remove recipients from tree-node |从树节点移除接收人
treenode-recipient-list | List recipient for the tree-node  |列出树节点所有接收人
unbind-template-from-node | Unbind alert-template from service-tree node |从服务树节点解绑一条告警模板
underutilized-instances-list | List underutilized instances | 列出低利用率的虚拟机
unusedresources-list | List all unused resources | 列出所有没被使用的资源
update-list | List updates | 列出所有更新
update-perform | Update the Controler | 更新控制节点
update-template-for-node | Update alert-template for service-tree node |为服务树节点更新告警模板
usage | Show general usage |显示通用使用率
user-create | Create a user |创建用户
user-delete | Delete user |删除用户
user-event | Show operation event logs of keystone users | 显示用户操作日志
user-group-list | List groups of user |列出用户的所有组
user-in-group | Check whether a user belongs a group |检查是否用户属于组
user-join-group | Add a user to a group |为组增加用户
user-join-project | User join projects with roles | 将用户以某种角色加入项目
user-leave-group | Remove a user from a group |从组中移除用户
user-leave-project | Leave a user from projects | 将用户移出项目
user-list | List users |列出所有用户
user-project-list | List projects of user |列出用户的所有项目
user-role-list | List roles of user |列出用户角色
user-show | Show details of user |显示用户详情
user-update | Update a user |更新用户
vcenter-action | Show operation action logs of vcenter |显示vCenter的操作日志
vcenter-create | Create a vcenter |创建vCenter
vcenter-delete | Delete a vcenter |删除vCenter
vcenter-list | List VMware vcenters |列出VMware vCenter
vcenter-show | Show details of a vcenter |显示vCenter详情
vcenter-sync | Sync a vcenter |同步vCenter
vcenter-update-credential | Update account and password information of a vcenter |更新vCenter的账号和密码信息
version-show | Show version of a backend service |显示后端服务版本
vnc-connect | Show the VNC console of given server |显示选中服务器是VNC控制台
vpc-available | Make vpc status available |使VPC状态可用
vpc-create | Create a VPC |创建VPC
vpc-delete | Delete a VPC |删除VPC
vpc-event | Show operation event logs of vpc | 显示VPC操作日志
vpc-list | List VPCs |列出所有VPC
vpc-pending | Make vpc status pending |使VPC状态挂起
vpc-purge | Purge a managed VPC, not delete the remote entity | 从数据库删除VPC
vpc-show | Show a VPC |显示VPC
vpc-sync | Synchronize the status of a vpc | 同步VPC状态
vpc-update | Update a VPC |更新VPC
webconsole-baremetal | Connect baremetal host webconsole | 通过web控制台连接物理机
webconsole-k8s-pod | Show TTY console of given pod | pod的外部登录控制台 
webconsole-k8s-pod-log | Get logs of given pod | 从pod中获取日志
webconsole-server | Connect server remote graphic console | 以图形方式连接虚拟机
webconsole-ssh | Connect ssh webconsole | 以ssh方式连接虚拟机
websocket-notify | post a Websocket msg | 发送websocket信息
wire-create | Create a wire |创建二层网络
wire-delete | Delete wire |删除二层网络
wire-event | Show operation event logs of wire | 显示二层网络操作日志
wire-list | List wires |列出所有二层网络
wire-show | Show wire details |显示二层网络详情
wire-update | Update wire |更新二层网络
wire-usage | Show general usage of wire |显示二层网络使用率
worker-list | List workers | 列出所有活动组件
yunionagent-version-list | show versions of backend services | 后端服务的版本
yunionagent-version-show | Show service version | 显示后端服务详情
zone-capability | Show zone's capacibilities | 显示能用的可用区
zone-create | Create a zone |创建可用区
zone-delete | Delete zone |删除可用区
zone-event | Show operation event logs of zone | 查看可用区操作日志
zone-list | List zones |列出所有可用区
zone-quota | Show zone-quota for current user or tenant | 区域配额
zone-quota-list | List zone quota of domains or projects of a domain | 显示可用区配额
zone-quota-set | Set zonal quota for tenant | 设置可用区配额
zone-show | Show zone details |显示可用区详情
zone-update | Update zone |更新可用区
zone-usage | Show general usage of zone |显示可用区使用率