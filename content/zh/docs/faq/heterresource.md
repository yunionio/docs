---
title: "资源纳管"
linktitle: "资源纳管"
weight: 4
oem_ignore: true
description: >
  帮助用户解决异构虚拟化平台、宿主机、物理机等资源纳管等方面的问题。
---

## 支持哪些虚拟化平台？

支持管理KVM、VMware等虚拟化平台，同时支持阿里云、腾讯云等公有云平台

## 支持哪些类别的裸金属服务器？

目前主要支持x86服务器，如Intel与AMD平台的物理服务器。

## VMware ESXi设置虚拟机嵌套虚拟化的方法？

在{{<oem_name>}}平台上创建虚拟化平台未VMware的虚拟机默认无法嵌套虚拟化，需要在VMware上配置虚拟机的嵌套虚拟化。设置方法如下：

- 修改ESXi宿主机上的配置文件，使所有在宿主机上创建的虚拟机都支持嵌套虚拟化。

  1. 通过ssh服务远程连接VMware ESXi主机，在/etc/vmware/config文件的末尾添加vhv.enable = “TRUE” 命令。
  2. 重启ESXi宿主机。若vCenter部署在ESXi宿主机，重启ESXi宿主机可能会出现vCenter无法访问的问题，请谨慎操作。由于ESXi重启，ESXi上的所有虚拟机都会关机，需要手动启动vCenter虚拟机。等待一段时间后，vCenter才可以正常访问。

- 通过在vSphere上修改虚拟机的设置，对单个服务器启用嵌套虚拟化。

  1. 将需要启用嵌套虚拟化的虚拟机关机。
  2. 在vSphere控制台上选择该虚拟机，进入虚拟机详情页面。
  3. 单击虚拟机名称右侧的 **_"操作"_** 按钮，选择下拉菜单 **_"编辑设置"_** 菜单项，弹出编辑设置对话框。
  4. 在虚拟硬件页签中展开CPU配置项，在硬件虚拟化列勾选”向客户机操作系统公开硬件辅助的虚拟化“，单击 **_"确定"_** 按钮。

    ![](../image/VMware.png)

- 通过在vSphere上替换虚拟机的配置文件（xxx.vmx），启用单个服务器的嵌套虚拟化。该步骤较为复杂，请优先用上一种。

  1. 将需要启用嵌套虚拟化的虚拟机关机。
  2. 在vSphere上查看并复制指定虚拟机的配置文件（虚拟机详情-编辑设置-虚拟机选项-常规选项）。
  3. 在存储-文件中搜索配置文件，并将配置文件下载到本地。
  4. 在配置文件的末尾尾添加vhv.enable = “TRUE” 命令，保存配置文件。
  5. 将修改后的配置文件上传到对应目录下替换原来的配置文件。
  6. 启动虚拟机，在vSphere上虚拟机详情-摘要-虚拟机硬件-CPU中可以查看到硬件虚拟化已开启。

## 如何在BIOS打开硬件虚拟化支持？

BIOS中默认开启硬件虚拟化支持。如果有修改，需要在BIOS中打开Intel Virtual Technology或Secure Virtual Machine选项，保存并退出。

## 如何指定宿主机的启动内核？

1. 首先通过以下命令查看当前宿主机的启动内核：

   ```bash
   $ uname -r
   ```

2. 通过以下命令查看宿主机上所有可用内核：

   ```bash
   $ grep '^menuentry' /boot/grub2/grub.cfg
   ```

      ![](../image/hostkernel.png)

3. 如上图，当前宿主机的启动内核为序号0“3.10.0-957.12.1.el7.x86_64”，内核序号从0开始，依次排序。如需将启动内核指定为“3.10.0-862.14.4.el7.yn20190712.x86_64”，该内核序号为1。则需要修改/etc/default/grub文件，增加或将原来的GRUB_DEFAULT的值改为1。

   ```bash
   $ vi /etc/default/grub   #按进入insert模式修改以下内容
   GRUB_DEFAULT=1     #修改完成后，按ESC后输入：wq保存配置
   ```

4. 执行以下命令重新生成启动菜单。

   ```bash
   $ grub2-mkconfig -o /boot/grub2/grub.cfg
   ```

5. 重启宿主机，查看宿主机启动内核是否已修改为“3.10.0-862.14.4.el7.yn20190712.x86_64”。

   ```bash
   $ uname -r
   ```

      ![](../image/hostkernelmodify.png)

## 如何将宿主机新的本地磁盘加入存储池，用于存储虚拟机的虚拟磁盘？

1. 首先将该磁盘分区格式化，建议用**parted**进行分区，建议用**ext4**格式化磁盘。
2. 格式化完成后，将磁盘挂载在“/opt/cloud/”下的任意目录，并且修改/etc/fstab，将配置持久化fstab中，建议使用磁盘的UUID来指定磁盘，使用blkid命令来获取磁盘UUID。
3. 以上操作完成后，修改该宿主机的/etc/yunion/host.conf，找到 **local_image_path** 配置项，将新磁盘的挂载目录路径加入数组中。保存后，重启host服务。

    ```bash
    # 查看host服务所在pod，并删除
    $ kubectl get pods -n onecloud | grep host
    $ kubectl delete pod <host-pod-name> -n onecloud
    ```

4. 如用户没有将磁盘挂载到“/opt/cloud/”目录下，且不想修改挂载目录，可按照下面步骤进行操作。

    ```bash
    # 假设之前挂载目录为“/data/test”，通过mount --bind命令将“/data/test”挂载到“/opt/cloud/test”
    $ mount --bind /data/test /opt/cloud/test
    ```

5. 并修改/etc/fstab，将配置持久化fstab中。
    
    ```bash
    /data/test /opt/cloud/test none defaults,bind 0 0
    ```

6. 修改该宿主机的/etc/yunion/host.conf，找到 **local_image_path** 配置项，将新磁盘的挂载目录路径加入数组中。保存后，重启host服务。

    ```bash
    # 查看host和host-image服务所在pod，并删除
    $ kubectl get pods -n onecloud | grep -E 'host|host-image'
    $ kubectl delete pod -n onecloud <host-pod-name> <host-image-pod-name> 
    ```

{{% alert title="注意" color="warning" %}}
当磁盘挂载到非“/opt/cloud”目录下，且已修改/etc/yunion/host.conf的local_image_path配置项后，此时{{<oem_name>}}平台上显示的存储大小可能与存储的真实容量不符。此时用户按照步骤4修改将之前的挂载目录挂载到“/opt/cloud”目录下，宿主机和本地存储的服务将变成离线状态，在{{<oem_name>}}平台上删除离线状态的新增的存储，即可恢复正常。
{{% /alert %}}

## 如何清理一台已经下线的宿主机上面的虚拟机的记录？

在云管平台上删除虚拟机时，控制器会请求虚拟机所在宿主机上的host服务清理虚拟机对应的配置文件和磁盘文件信息，宿主机上清理虚拟机信息成功返回后，控制器才会删除虚拟机对应的数据库记录。

当宿主机由于异常原因（故障或其他原因）下线时，在云管平台上删除宿主机上的虚拟机时，控制器请求删除虚拟机配置文件等信息无法得到宿主机host服务的响应，将导致虚拟机删除失败。为了删除已下线宿主机上的虚拟机，云管平台Climc命令提供server-purge的接口，在宿主机不可用状态，可以使用server-purge命令清理虚拟机的数据库记录。

server-purge命令使用如下：

通过ssh远程连接控制节点，执行以下命令。

```bash
# 模拟宿主机下线操作，将宿主机禁用
$ climc host-disabled <host_id> 
# 删除宿主机上的虚拟机记录 
$ climc server-purge <server_id>  
```

## 如何快速清理一台已经下线的宿主机上面的数据库记录？

删除宿主机的数据库记录要求删除宿主机上所有的虚拟机和本地磁盘信息。当宿主机下线时，云管平台无法在界面正常删除虚拟机和本地磁盘，只能在控制节点使用server-purge和disk-purge命令在后台逐个删除，删除操作较为麻烦。为了能快速清理以及下线的宿主机数据库记录，云管平台的控制节点提供了快速清理脚本clean_host.sh。

使用方法如下：

通过ssh远程连接控制节点，执行以下命令：

```bash
$ /opt/yunion/scripts/tools/clean_host.sh <host_id>
```

## 为什么物理服务器Baremetal无法被云管平台纳管？

请检查并确保物理服务器满足以下配置项：

- 物理服务器启动方式为legacy bios，而不是uefi。

- 服务器支持网络启动，且启动顺序为pxe优先。pxe启动可能需要配置对应网卡，如Dell服务器。

- 如果待纳管的物理服务器跟barametal服务端在一个网段内，需要保证两端交换机配置一致，比如端口都设置为access模式，且pvid相同。同时需要启动host服务，并打开dhcp relay功能，使host服务能接收dhcp广播请求并relay到baremetal服务；

- 如果待纳管服务器跟baremetal服务端不在一个网段内，需要确保网关交换机或同一网段host服务开启dhcp relay；

- 检查ipmi设置，如果使用独立的管理口，需要确保管理口网络能跟baremetal服务端互通，pxe请求也能够到达baremetal服务端；

  - HP服务器默认未开启IPMI over LAN，需要手动开启，设置方法：登入ILO web管理界面，选择Administration -> Access Settings. 勾选Enable IPMI / DCIM over LAN on port 623。
  - Dell/EMC服务器开启IPMI over LAN的方法：登入iDRAC web管理界面，选择iDRAC设置，网络设置，IPMI设置，勾选IPMI over LAN (Enabled)。

  ![](../image/ipmi.png)

- 云管平台上需要配置物理IP子网网段，具有足够的可用IP地址。一台pxe服务器需要3个IP地址才能完成纳管后系统部署。

## 为什么将网线插到Dell物理服务器第一个网卡可以通过PXE启动，而将网线插入其他网卡则不能通过PXE启动？

需要启用网卡的PXE启动设置。

设置方法如下：

进入Device setting，选择插入网线的网卡，选择NIC Setting，设置PXE启动即可。

## 如何设置物理机转换宿主机使用的默认镜像？

{{<oem_name>}}平台物理机转换宿主机功能使用的镜像不同于直接从镜像市场导入的镜像，需要由我司专门制作并提供的宿主机镜像（可联系运维人员获取宿主机镜像）。为了方便用户使用，云管平台还提供了物理机转换宿主机时默认镜像配置的功能，默认镜像设置完成后，用户无需考虑选择哪个镜像或网络，只需要选择磁盘RAID配置即可快速将物理机转换为宿主机使用。若物理机不满足磁盘RAID配置条件，用户只能通过自定义设置，手动配置磁盘RAID、选择镜像、设置网络等。


{{% alert title="注意" color="warning" %}}

当物理机只存在一个RAID控制器，且该控制器下存在大于等于4块相同配置的磁盘时，磁盘支持”默认配置（最高）冗余“、”RAID-1/RAID-10(2倍冗余)“、”RAID-5(1.x倍冗余)“、”RAID-0(无冗余)“以及自定义配置等选项。用户可直接选择除自定义配置以外的选项快速将物理机转换为宿主机。

{{% /alert %}}

设置默认镜像步骤如下：

1. 当获取到物理机转换成宿主机镜像后，需要将其上传到云管平台。

2. 通过ssh远程连接控制节点，获取宿主机镜像id。

   ```bash
   $ climc image-show <image-name> #获取镜像id
   ```

3. 使用climc命令在region服务配置中添加”convert_hypervisor_default_template“为宿主机镜像的id信息。

   ```bash
   $ climc service-config --config convert_hypervisor_default_template=a9b67435-8c08-4063-8ea6-d885ea26aa79 region2
   ```

4. 设置完成后，用户在云管平台界面上进行将物理机转换为宿主机操作时，当选择”默认配置（最高）冗余“、”RAID-1/RAID-10(2倍冗余)“、”RAID-5(1.x倍冗余)“、”RAID-0(无冗余)“时，将使用默认镜像转换为宿主机。

## 物理机转换为宿主机时，如何设置宿主机双网卡绑定（bonding）？

当在云管平台上将物理机转换为宿主机时，支持界面绑定宿主机网卡。操作步骤如下：

{{% alert title="注意" color="warning" %}}
在使用网卡绑定功能时，确保物理机上只有需要绑定的两张网卡与网线连接。若物理机存在两张以上连接网线的网卡，网卡绑定结果不可控，请谨慎操作。
{{% /alert %}}

1. 在云管平台的物理机页面，单击指定物理机对应操作列 **_"更多"_** 按钮，选择下拉菜单 **_"转换为宿主机"_** 菜单项，弹出转换为宿主机对话框。

2. 设置宿主机类型，磁盘RAID配置选择”自定义配置“后，根据需求配置其他参数，设置网络勾选”启用bonding“，单击 **_"确定"_** 按钮，即可实现将物理机转换为宿主机，将绑定宿主机的双网卡。   
    ![](../image/bonding1.png)

## 宿主机上GPU卡无法注册成功，该怎么解决？

可能原因有以下两种：

- 宿主机的引导方式为UEFI模式。GPU卡注册需要在内核启动参数中添加相关配置，当宿主机为BIOS引导时，部署脚本将会自动添加，若宿主机为UEFI引导，则需要执行以下命令并进行重启操作。

    ```bash
    $ grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg 
    ```

- BIOS未开启vt-d：检查宿主机BIOS是否开启vt-d。

{{% alert title="说明" %}}
BIOS是否开启vt-d的检查方式的[参考链接](https://stackoverflow.com/questions/51261999/check-if-vt-d-iommu-has-been-enabled-in-the-bios-uefi)。
{{% /alert %}}

```bash
# 针对于Intel主机生效，AMD主机可尝试使用"dmesg | grep AMD-Vi"
$ dmesg | grep DMAR 
```

1. 若执行命令后有显示内容，且最后一行内容为D`MAR-IR: Enabled IRQ remapping in <whichever> mode`，表示BIOS已开启vt-d。
2. 若执行命令后提示错误信息或无信息，表示BIOS未开启vt-d，需要用户在BIOS设置中启用vt-d或X2APIC。不同型号主机启用方式不同，请根据实际情况进行操作。


## 托管物理机时，报“Could not open device at /dev/ipmi0 or /dev/ipmi/0 or /dev/ipmidev/0: No such file or directory”错误，该如何处理？

解决方法：需要加载ipmi相关模块。

在控制节点上执行以下命令：

```bash
$ lsmod |grep ^ipmi
$ modprobe ipmi_watchdog
$ modprobe ipmi_poweroff
$ modprobe ipmi_devintf
$ modprobe ipmi_si  # 加载该模块如果没有不影响ipmi的使用（与系统版本有关）
$ modprobe ipmi_msghandler  # 加载该模块如果没有不影响ipmi的使用
```

## 导入VMware云账号时，如何查看未导入到平台的VMware宿主机的IP地址？

导入VMware云账号时，需要在{{<oem_name>}}平台上为VMware宿主机添加IP子网，此时VMware宿主机才可以导入到{{<oem_name>}}平台，当不清楚宿主机IP地址时，可通过查看region操作日志的方法获取到宿主机的IP地址。

操作步骤如下：

```bash
# 查看region所在pod的操作日志并实时输出日志
$ kubectl get pods -n onecloud |grep region |awk '{print $1}'  | xargs kubectl logs -n onecloud -f
# 将region日志信息保存在region文件中
$ kubectl get pods -n onecloud |grep region |awk '{print $1}'  | xargs kubectl logs -n onecloud >region1.log 
# 在日志中查看“SyncHosts for provider”字段，该条日志信息将包含宿主机的IP地址。
$ cat region.log | grep 'yncHosts for provider' 
[I 200211 17:07:46 models.syncOnPremiseCloudProviderInfo(cloudsync.go:1123)] SyncHosts for provider vm result: removed 0 failed 0 updated 0 failed 0 added 0 failed 1;fail to find wire for host esix65 10.127.10.178: sql: no rows in result set
```
