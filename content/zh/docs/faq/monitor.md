---
title: "运维监控"
weight: 10
oem_ignore: true
description: 帮助用户解决产品运维、数据迁移、告警、监控方面的问题。
---

## License如何计算？

平台上License根据使用场景分为两类，私有云授权和云管授权。

![](../../admin/images/license/licenseinfo1.png)

私有云授权按照宿主机的CPU数量计算，云管授权按照虚拟机数量计算。

-	CPU数量：即基础设施中启用状态的服务器的CPU颗数（Socket数）总和，如四路x86服务器有两颗CPU，在基础设施中启用该服务器，License已使用数量为2。
-	虚拟机数量：云管平台纳管的各个公有云平台的虚拟机数量的总和。


## Host服务问题

### 宿主机安装Host服务完成后，默认处于禁用状态，需要启用后使用。宿主机启用方法如下：

- 在云管平台的宿主机列表中启用该宿主机；

- 在控制节点使用climc命令启用该宿主机；

    ```bash
    $ climc host-enable id
    ```

### Host服务为什么会变成离线？

region的HostPingDetectionTask将超过3分钟未收到ping的host服务置为offline，并将宿主机上的虚拟机状态设置为unknown。

### 宿主机的Host服务启动失败，且报错“Fail to get network info：no networks”，该怎么解决？

该问题一般是没有为宿主机注册网络，需要在云管平台为宿主机创建一个IP子网或使用Climc命令在控制节点创建一个网络。

```bash
$ climc network-create bcast0 host02  10.168.222.226  10.168.222.226 24 --gateway 10.168.222.1
```

## 如何解决qemu版本不匹配的问题？

- 现象：使用过程中，启动虚拟机时可能遇到类似这样的错误信息：

    ```bash
    uses a qcow2 feature which is not supported by this qemu version: QCOW version 3
    ```

- 原因：主要原因是qcow版本不一致。原始的qcow2创建版本使用的qemu-img为较新版本，现在创建时使用的为较旧版本，旧版本不支持新版本。

- 解决方案：在拥有较新版本的qemu-img里面进行兼容性转换，例如执行以下命令进行转换，转换完毕后，再重新添加镜像：

    ```bash
    $ qemu-img convert -o compat=0.10 -f qcow2 -O qcow2 centos6-cloud-init.qcow2 centos-st-ssh-key.qcow2
    ```

## 如何将其它KVM平台上的虚拟机迁移到系统中？

1. 通过libvirt导出虚拟机的镜像（.qcow2文件）。
2. 将镜像上传至一个http服务器中。
3. 使用{{<oem_name>}}镜像服务器导入镜像。
4. 通过镜像创建虚拟机。
5. 若原来的虚拟机挂载了云硬盘，可按照以下方式迁移：
   - 与上述操作类似，需要先将数据盘生成镜像，同理导入，{{<oem_name>}}使用该镜像创建数据
     云盘，再将云硬盘挂载到虚拟机即可。
   - 先在{{<oem_name>}}中创建一个相同大小的云硬盘，找到对应的路径，将原云盘数据直接复
     制到新的路径下，最后再挂载到虚拟机上。

## 如何检查一台虚拟机或宿主机是否支持硬件虚拟化？

在终端中执行egrep "vmx|svm" /proc/cpuinfo命令，如果有输出代表支持硬件虚拟化。ESXi主机和WIndows系统不支持该命令。

## 机房准备断电维护，上电后如何自动恢复虚拟机的业务？

当机房需要断电维护时，{{<oem_name>}}平台无需任何配置即可实现服务器上电后可以自动恢复虚拟机业务。

## 在Windows系统的Outlook客户端接收的验证邮件或告警邮件乱码，没有样式，该怎么解决？

**现象**

![](../image/emailreason.png)

**原因**

该问题是由于Outlook客户端设置了“以纯文本格式读取所有标准邮件”，导致html样式的邮件被转换成了文本消息，没有了样式。

**解决方法**

在“Outlook客户端->文件->选项->信任中心->信任中心设置->电子邮件安全性”中取消勾选“以纯文本格式读取所有标准邮件”。

![](../image/emailsettingoption.png)
![](../image/emailsecurity.png)
![](../image/emailrtf.png)

## 如何查看系统中常用组件以及常用组件的日志？

{{<oem_name>}}容器化部署后可通过Kubernetes相关命令查看{{<oem_name>}}平台中的系统组件以及组件日志等。

### 查看组件pod运行情况

系统组件都以 k8s pod的形式运行，通过以下命令查看{{<oem_name>}}平台的系统组件以及运行情况等。

```bash
# -n表示namespace的意思，目前我们的服务都部署在onecloud namespace下，查看所有组件的pod的运行情况
$ kubectl get pods -n onecloud 
```

```bash
# -o wide查看pod的更多详细信息，比如运行在哪个节点上
$ kubectl get pods -n onecloud -o wide
```

```bash
# 查看指定pod资源的详细信息，如查看region组件的pod的详细信息
$ kubectl describe pods -n onecloud default-region-759b4bff4c-hpmdd
```

```bash
# 查看指定主机上运行的所有pod信息
$ kubectl get pods -n onecloud -o wide --field-selector=spec.nodeName=<host-name>
```

### 重启服务

在Kubernetes集群上，组件pods大部分通过deployment管理的，当删除pod时将会自动重建新的pod，所以重启组件服务时可以直接删除对应组件的pod。

```bash
# 重启web服务，如删除web前端pod
$ kubectl delete pods $web_pod_name -n onecloud
```

```bash
# 重启host服务，如删除所有host pod
$ kubectl get pods -n onecloud  -o wide | grep default-host  | awk '{print #1}' | xargs kubectl delete pods -n onecloud
# 重启所有服务，服务都以default开头
$ kubectl get pods -n onecloud  |grep default | awk '{print $1}' | xargs kubectl delete pods -n onecloud
```

### 更新服务配置并重启服务

{{<oem_name>}}的所有组件服务都有对应的Configmaps文件保存服务配置，当配置信息需要更改时，可通过以下步骤更新服务配置并使其生效。

```bash
# 以region服务为例更新其configmaps配置信息
$ kubectl edit configmaps default-region -n onecloud
```

```bash
# 修改完成后，删除对应服务的pod即可生效
$ kubectl get pods -n onecloud |grep region
$ kubectl delete $region_pod_name -n onecloud
```

### 查看服务日志

以region组件为例介绍如何查看region组件的日志信息。

```bash
# 首先需要找到region服务所在pod
$ kubectl get pods -n onecloud |grep region
```

```bash
# 查看region服务容器的日志，其中-f表示follow，即持续输出日志，类似于journalctl的 -f；--since 5m 表示查看近5分钟的日志信息。按CTRL+C退出日志输出
$ kubectl logs -n onecloud $region_pod_name -f --since 5m
```

```bash
# 查看region容器日志，将最近5分钟的所有日志到region.log
$ kubectl logs -n onecloud $region_pod_name --since 5m > region.log
```

```bash
# 若有些服务有两个容器，如host服务有名称为host和host-image的容器，此时查看容器命令时需要加'-c' 指定查看哪个容器的日志
$ kubectl logs -n onecloud $host_pod_name -c host-image -f
```

## 其它常用管理命令

kubectl更多命令请参考[kubectl官方文档](https://kubernetes.io/zh/docs/reference/kubectl/)

### 查看平台版本信息

```bash
# 其中onecloudcluster 可以简写成oc；default为OneCloudCluster的名称；
$ kubectl get oc -n onecloud default -o go-template --template='{{printf "%s\n" .spec.version}}'
```

### 查看MySQL信息

```bash
# 查看MySQL的配置连接新，其中oc为onecloudcluster；default为oc的名称；grep -A 4即属于匹配后4行数据。
$ kubectl get oc -n onecloud default -o yaml | grep -A 4 mysql
```

### 查看OC的的API对象信息

```bash
# 查看OC的运行情况
$ kubectl get onecloudcluster -n onecloud
```

```bash
# 以yaml文件的形式查看OC的API对象信息，该信息中包含集群的所有配置信息。
$ kubeclt get oc -n onecloud -o yaml
```

## 部署管理工具ocadm的常用管理命令

部署管理工具ocadm类似于Kubernetes集群中的kubeadm工具。

```bash
# 创建集群 
$ ocadm cluster create
```

```bash
# 查看集群认证信息
$ ocadm cluster rcadmin
```

```bash
# 将本地镜像源切换到阿里云镜像源
$ ocadm cluster update --image-repository registry.cn-beijing.aliyuncs.com/yunionio --wait
```

```bash
# 将产品升级或回滚到指定版本，当系统镜像源为阿里云镜像源的情况下才可以使用下面的命令升级
$ ocadm cluster update --version $version 
```

```bash
# 禁用节点的host服务
$ ocadm node disable-host-agent --node $node_name 
```

```bash
# 启用节点的host服务
$ ocadm node enable-host-agent --node $node_name 
```

```bash
# 禁用节点的controller服务
$ ocadm node disable-onecloud-controller --node $node_name 
```

```bash
# 启用节点的controller服务
$ ocadm node enable-onecloud-controller --node $node_name 
```

```bash
# 禁用Baremetal服务
$ ocadm baremetal disable --node $node_name
```

```bash
# 如在node1主机上启用baremetal服务，并监听br0网卡。
$ ocadm baremetal enable --node node1 --listen-interface br0
```

```bash
# 在First Node节点获取加入节点的token信息
$ ocadm token create
```

```bash
# 在First Node查看token信息
$ ocadm token list
```

```bash
# 切换到开源版前端，ce(community edition)为开源版前端；
$ ocadm cluster update --use-ce --wait 
# 切换到商业版前端，ee(enterprise edition)为商业版前端 
$ ocadm cluster update --use-ee --wait
```

```bash
# 启用itsm组件
$ ocadm component enable itsm
# 禁用itsm组件
$ ocadm component disable itsm
# 安装失败时清理环境，请谨慎使用该命令
$ ocadm reset --force
```
