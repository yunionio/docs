---
title: "云资源"
linktitle: "云资源"
weight: 5
description: >
  帮助用户解决云端服务的虚拟机、裸金属、镜像、硬盘等方面的问题。
---

## 计算资源管理具备哪些能力？

包括虚拟机和裸金属的生命周期管理，包括创建、修改、删除、启动和关闭等操作。

## 存储资源管理具备哪些能力？

包括虚拟磁盘的创建、挂载、卸载、扩容、删除等操作以及快照的创建、回滚、清除等操作。

## 镜像资源管理具备哪些能力?

支持对镜像进行创建（从镜像市场导入和上传镜像）、修改、删除等操作，支持分布式镜像缓存和跨平台镜像兼容能力等。

## 新建虚拟机场景失败原因汇总

### 配额不足

当错误原因提示“OutQuotaError”时，如下图报错信息。

![](../image/quotaerrormain.png)
![](../image/quotaerror.png)

该类报错为创建虚拟机所在项目的配额不足，配额用于人为的控制项目中资源的数量，可在项目详情-配额使用情况中调整资源的配额，或在全局设置中关闭配额检查。

**调整配额**

![](../image/adjustquota.png)

**关闭配额检查**

![](../image/quotacheck.png)

### 资源不足

当错误原因提示“OutofResource”时，该类报错为资源不足与创建虚拟机。需要用户检查宿主机、网络、存储等是否有足够的空间用于创建虚拟机等。

## 如何修改已删除主机和云硬盘在回收站的保留时间？

{{<oem_name>}}平台提供了主机和硬盘回收站的功能，当将主机和硬盘删除后，主机和硬盘将会在保留在回收站一段时间后自动删除，默认为保留3天。主机在回收站的保留时间可以修改，设置方法如下：

通过ssh远程连接控制节点，使用climc命令修改主机和硬盘在回收站的保留时间。

```bash
# 修改主机和硬盘的保留时间一周，参数值单位为s，604800 = 7*24*60。
$ climc service-config --config pending_delete_expire_seconds=604800 region2
```

设置完成后等待5分钟左右生效。或删除镜像所在pod重启镜像服务。

```bash
$ kubectl get pods -n onecloud |grep region
$ kubectl delete pods <region-pod-name> -n onecloud
```

## 如何修改已删除镜像在回收站的保留时间？

{{<oem_name>}}平台提供了镜像回收站功能，当镜像删除后，镜像将保留在镜像回收站中。在回收站中的镜像不会自动删除，但是可以手动设置镜像在回收站中的保留时间，设置方法如下：

通过ssh远程连接控制节点，使用climc命令修改镜像在回收站的保留时间。

```bash
# 修改镜像的保留时间一周，参数值单位为s，604800 = 7*24*60。
$ climc service-config --config pending_delete_expire_seconds=604800 glance
```

设置完成后，等待5分钟左右生效。或删除镜像所在pod重启镜像服务。

```bash
$ kubectl get pods -n onecloud |grep glance
$ kubectl delete pods <glance-pod-name> -n onecloud
```

由于{{<oem_name>}}平台上无法查看到回收站中镜像的删除时间，所以需要使用climc命令在控制节点上查看镜像自动删除的时间是否符合预期。

```bash
$ climc image-show <image-namge/image-id> 
# image-name、image-id为回收站中的镜像名称和id
 Field          |       Value                                                                                   
auto_delete_at  | 2019-08-20T09:14:47.000000Z   #镜像自动删除时间
```

## 为什么不能打开镜像市场？

常见原因：

1. 服务器时区或时间不对，导致OSS API无法正常工作。
2. 网络不可访问阿里云OSS（Object Storage Service，对象存储）北京。

## 为什么虚拟机系统盘有最小限制？

虚拟机系统盘最小值由以下几方面确定的，若同时满足以下3点，系统盘最小值为以下设置值最大值。

1. 制作镜像时设置了系统镜像内分区大小，镜像制作完成后无法更改。
2. 系统有一个DefaultDiskSizeMB的参数，2.6以前默认是30GB，现已改为默认是10GB，这个参数可以通过配置文件修改。
3. 公有云对虚拟机的系统盘都有一个最小限制，例如腾讯云的系统盘最小是50GB。

## 虚拟机启动失败，报错”qemu-system-x86_64: cannot set up guest memory 'pc.ram': Cannot allocate memory“，该怎么解决？

该问题是由于宿主机内存不够引起的，请增加宿主机内存或关闭宿主机上的其他虚拟机。

## 为什么在公有云阿里云平台上创建虚拟机总是失败？

主要有以下原因：

- 阿里云账户余额不足，在云管平台上创建按量付费的主机时，要求阿里云账户余额大于100元。

  ```bash
  SDK.ServerError
  ErrorCode: InvalidAccountStatus.NotEnoughBalance
  Message: Your account does not have enough balance.
  ```

- 阿里云账户没有授权OSS导入ESC镜像的权限。查看系统日志，可看到如下报错信息。对于这类新接入的阿里云账户，需要在阿里云控制台上为账户添加从OSS导入ECS镜像的角色权限，一般来讲，云管平台会通过阿里云RAM API自动设置权限，若账号无RAM API权限，则需要按下面方法手动授权：

  ```bash
  SDK.ServerError ErrorCode: NoSetRoletoECSServiceAcount Message: ECS service account Have no right to access your OSS.please attach a role of access your oss to ECS service account.
  ```

  1. 登录阿里云控制台，选择“监控与管理>访问控制>角色管理”，单击 **_"新建角色"_** 按钮，弹出设置对话框。
  2. 选择角色类型为“服务角色”、选择类型为“ESC虚拟机”、角色名称设置为AliyunECSImageImportDefaultRole；
  3. 单击 **_"创建"_** 按钮，创建角色。
  4. 角色创建完成后，进入创建授权策略页面。
  5. 选择“精确授权”，输入策略名称“AliyunECSImageImportRolePolicy”，单击 **_"确定"_** 按钮保存。
  6. 至此，为该账户设置了从OSS导入ESC镜像的权限。

- 阿里云账户没有开通OSS服务。

  ```bash
  oss: service returned error: StatusCode=403, ErrorCode=UserDisable, ErrorMessage=UserDisable
  ```

  登录阿里云平台，开通OSS服务。

  ![](../image/oss.png)

## 为什么在云管平台上创建微软Azure平台的虚拟机总是失败？

主要是因为以下原因：

- 微软Azure平台套餐中包含对磁盘数量的限制，但是云管平台上的套餐信息只显示CPU和内存的信息。请在创建Azure虚拟机时按照Azure平台上的套餐对磁盘的限制情况设置Azure磁盘数量。

  ![](../image/Azurepackage.png)

## 为什么在云管平台上创建VMware虚拟机时报磁盘错误创建错误？

可能的原因是esxiagent无法访问ESXi宿主机的端口，需要允许esxiagent能够访问所有被管理的esxi宿主机的如下端口：

- TCP 443
- TCP 902

VMware平台需开放的端口列表可参考[VMware官网文档](https://docs.vmware.com/en/VMware-vSphere/6.5/com.vmware.vsphere.security.doc/GUID-171B99EA-15B3-4CC5-8B9A-577D8336FAA0.html)。

## 快照和镜像有什么区别？

两者区别如下表所示：

操作  | 区别 | 应用场景
---------|----------|---------
 快照 | 快照保存了主机磁盘在某个时间点的完整状态，不占用太多空间，可以快速创建或者删除。基于快照创建的主机会保留原主机的个性化信息，是原主机的一个完整副本（克隆）。 | 数据恢复
 镜像 | 镜像是经过预处理的虚拟机磁盘的副本，预处理包括用户数据清理，磁盘压缩，消除个性化信息（主机ID，密钥）等。 | 应用分发

## 为什么在云管平台上创建或纳管的虚拟机中存在注入的公钥文件？

**原因**：虚拟机的公钥文件是由平台注入的，会同时注入一个全局和一个项目级别的公钥文件到虚拟机。私钥存放在控制节点，用户可以通过Climc命令查看密钥文件。
```
# 查看注入密钥，--admin表示全局的密钥；--project表示查看项目的密钥。
$ climc sshkeypair-show --admin 
$ climc sshkeypair-show --project <project-name>
```
**应用场景**：通过注入密钥文件，在云管平台上的虚拟机的Web SSH功能可以以cloudroot用户免密登录到虚拟机。后续平台的自动化运维功能也是基于该功能。

## 实例名称同步

平台自3.10开始默认开启实例名称同步, 若云上的实例名称发生变化后，当云账号同步完成资源或者单独指定实例进行状态同步，实例的名称会跟随云上进行同步
可以通过以下命令进行打开或者关闭
```bash
# 开启实例名称同步
$ climc service-config --config enable_sync_name=true region2
# 关闭实例名称同步
$ climc service-config --config enable_sync_name=false region2
```
