---
title: "宿主机"
weight: 1
description: 宿主机是云管平台中为虚拟机提供底层资源的物理服务器。 
---

宿主机是云管平台中为虚拟机提供底层资源的物理服务器。宿主机属于域资源。

宿主机来源：

- 云管平台支持同步VMware、ZStack、DStack、OpenStack以及HCSO平台上的宿主机信息。
- 物理服务器安装自研host服务后将会自动上报宿主机信息到default域，并默认共享。
- 物理机转换为宿主机。

**入口**：在云管平台单击左上角![](../../../images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"主机/基础资源/宿主机"_** 菜单项，进入宿主机页面。

  ![](../../../images/computing/host1.png)

- 列表右上方将显示宿主机总数以及处于运行、关机、操作失败以及未知状态的宿主机数量。

    ![](../../../images/computing/statistics.png)
## 查看宿主机列表

该功能用于查看宿主机列表的信息。

1. 在云管平台单击左上角![](../../../images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"主机/基础资源/宿主机"_** 菜单项，进入宿主机页面。
2. 查看以下参数：
   - 启用状态：表示宿主机是否能用于创建虚拟机，只有启用状态的宿主机可以创建虚拟机。
   - 状态：宿主机的运行状态。
   - 服务：服务即宿主机上的host服务，用于管理虚拟机。在线表示host服务正常运行，离线表示host服务异常或未运行。
{{% alert title="说明" %}}
{{<oem_name>}}平台宿主机host服务离线的以下情况：

   - 宿主机host服务启动时会检测宿主机是否安装了qemu、是否有nbd模块、是否有原生openvswitch内核模块等，当不符合以上任意一条时，宿主机服务将变为离线，并提示具体的错误信息。 
   - 当宿主机由管理员主动将host服务离线（管理员在控制节点执行`ocadm node disable-host-agnet <node-name> `）时，宿主机上虚拟机状态不变，用户可正常通过远程协议连接并使用虚拟机，但在云管平台不能对虚拟机进行管理操作；
   - 若宿主机由region检测到异常离线时，宿主机上的虚拟机都将设置为unknown状态，无法正常使用。
私有云平台宿主机服务离线情况可能有宿主机关机或相关服务异常等。
{{% /alert %}}
   - IP：宿主机的管理IP。
   - #VM：宿主机上的虚拟机数量。
   - CPU架构：包括x86和ARM架构。宿主机和宿主机上的虚拟机CPU架构一致。如x86架构的宿主机只能创建x86架构的虚拟机。
   - 物理CPU：宿主机上的物理CPU总数量及宿主机上运行状态的虚拟机CPU核数占宿主机物理CPU的百分比。
   - 物理内存：宿主机上的物理内存总量及宿主机上运行状态的虚拟机内存容量占宿主机物理内存容量的百分比。
   - 物理存储：宿主机上的物理存储总量及已分配的存储容量占存储总量的百分比。
   - SN：序列号等。
   - IPMI：IPMI信息，可通过IPMI信息远程连接宿主机。
   - 初始账号：通过ssh连接宿主机使用的用户名和密码信息。 

## 远程终端

该功能支持ssh远程连接到宿主机。连接之后需要使用初始账号列中的用户名和密码进行登录。

1. 单击指定宿主机右侧操作列 **_"远程终端"_** 按钮，选择下拉菜单 **_"SSH IP地址"_** 菜单项，与宿主机建立web SSH连接。
2. 若宿主机上的22端口被其他应用占用，ssh服务端口为其他端口时，可选择下拉菜单 **_"SSH IP地址:自定义端口"_** 菜单项，在弹出的对话框框中设置ssh服务实际端口号，单击 **_"确定"_** 按钮与宿主机建立web SSH连接。

## 启用

该功能用于启用"禁用"状态的宿主机。启用状态的宿主机用于创建虚拟机。

**单个启用**

1. 在宿主机页面，单击"禁用"状态的宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"启用"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，启用宿主机。

**批量启用**

1. 在宿主机列表中勾选一个或多个"禁用"状态的宿主机，单击列表上方 **_"启用"_** 按钮，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，启用宿主机。

## 禁用

该功能用于禁用”启用“状态的宿主机，禁用状态的宿主机不能创建虚拟机。

**单个禁用**

1. 在宿主机页面，单击”启用“状态的宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"禁用"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，禁用宿主机。

**批量禁用**

1. 在宿主机列表中勾选一个或多个"启用"状态的宿主机，单击列表上方 **_"禁用"_** 按钮，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，禁用宿主机。

## 更改域

该功能用于更改宿主机的所属域。服务器安装自研host服务后将自动上报注册到{{<oem_name>}}平台。自动上报到{{<oem_name>}}平台的宿主机默认都属于default域，用户可通过更改域功能，更改宿主机的所属域。

{{% alert title="说明" %}}
更改域的条件：需同时满足

- 当前用户在管理后台。
- 在{{<oem_name>}}已开启三级权限。
- 宿主机的共享范围为私有。
{{% /alert %}}

**单个宿主机更改域**

1. 在宿主机页面，单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"更改域"_** 菜单项，弹出更改域对话框。
2. 选择宿主机所属的域，单击 **_"确定"_** 按钮。

**批量更改域**

1. 在宿主机列表中勾选一个或多个宿主机，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"更改域"_** 菜单项，弹出更改域对话框。
2. 选择宿主机所属的域，单击 **_"确定"_** 按钮。


## 设置共享

该功能用于设置宿主机的共享范围。

域资源的共享范围有三种：

- 不共享（私有）：即域资源只能本域的用户可以使用。
- 域共享-部分（多域共享）：即域资源可以共享到指定域（一个或多个），只有域资源所在域和共享域下的用户可以使用域资源。
- 域共享-全部（全局共享）：即域资源可以共享给全部域使用，即系统中所有用户都可以使用域资源。

{{% alert title="说明" %}}
设置共享的条件：需同时满足

- 当前用户在管理后台。
- 在{{<oem_name>}}已开启三级权限。
{{% /alert %}}

**单个宿主机设置共享**

1. 在宿主机页面，单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"设置共享"_** 菜单项，弹出设置共享对话框。
2. 配置以下参数：
   - 当共享范围选择为“不共享”时，即域资源的共享范围为私有，仅本域的用户可以使用。
   - 当共享范围选择为“域共享”时，需要选择共享的域。
       - 当域选择其中的一个或多个域时，即域资源的共享范围为域共享-部分，只有域资源所在域和共享域下的用户可以使用域资源。
       - 当域选择全部时，即域资源的共享范围为域共享-全部，系统中的所有用户都可以使用域资源。
3. 单击 **_"确定"_** 按钮，完成操作。

**批量设置共享**

1. 在宿主机列表中选择一个或多个宿主机，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"设置共享"_** 菜单项，弹出设置共享对话框。
2. 配置以下参数：
   - 当共享范围选择为“不共享”时，即域资源的共享范围为私有，仅本域的用户可以使用。
   - 当共享范围选择为“域共享”时，需要选择共享的域。
       - 当域选择其中的一个或多个域时，即域资源的共享范围为域共享-部分，只有域资源所在域和共享域下的用户可以使用域资源。
       - 当域选择全部时，即域资源的共享范围为域共享-全部，系统中的所有用户都可以使用域资源。
3. 单击 **_"确定"_** 按钮，完成操作。

## 调整调度标签

该功能用于为宿主机绑定调度标签，绑定调度标签的宿主机将按照调度策略调度创建虚拟机。当宿主机需要绑定同一个标签时，推荐使用批量为宿主机调整标签功能，若需要绑定不同标签，需要分别调整单个宿主机的调度标签。

**为单个宿主机调整标签**

1. 在宿主机页面，单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"调整调度标签"_** 菜单项，弹出调整调度标签对话框。
2. 选择调度标签，单击 **_"确定"_** 按钮。

**批量为宿主机调整标签**

1. 在宿主机列表中勾选一个或多个宿主机，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"调整调度标签"_** 菜单项，弹出调整调度标签对话框。
2. 选择调度标签，单击 **_"确定"_** 按钮。

## 调整超售上限

该功能用于设置宿主机CPU和内存的超售比以及系统预留内存，超售即宿主机提供超过自身拥有的CPU或内存资源，宿主机实际可分配资源为实际资源*超售比。一般情况下CPU超售比可以远大于1，内存超售比建议为1。

**单个宿主机调整超售上限**

1. 在宿主机页面，单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"调整超售比"_** 菜单项，弹出修改属性对话框。
2. 设置以下参数：
    - CPU超售比上限：设置宿主机CPU的超售比上限，宿主机可分配虚拟机CPU数量 = 宿主机的CPU数量 * 超售比。
    - 内存超售比上限：设置宿主机内存的超售比上限，宿主机可分配虚拟机内存 = （宿主机实际内存 - 系统预留内存 ）* 超售比。
    - 系统内存预留（GB）：设置宿主机的系统预留内存，最低为1GB。宿主机的预留内存将不会用于分配虚拟机使用。
3. 单击 **_"确定"_** 按钮。

**批量调整超售比**

1. 在宿主机列表中勾选一个或多个宿主机，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"调整超售比"_** 菜单项，弹出修改属性对话框。
2. 设置以下参数：
    - CPU超售比上限：设置宿主机CPU的超售比上限，宿主机可分配虚拟机CPU数量 = 宿主机的CPU数量 * 超售比。
    - 内存超售比上限：设置宿主机内存的超售比上限，宿主机可分配虚拟机内存 = （宿主机实际内存 - 系统预留内存 ）* 超售比。
    - 系统内存预留（GB）：设置宿主机的系统预留内存，最低为1GB。宿主机的预留内存将不会用于分配虚拟机使用。
3. 单击 **_"确定"_** 按钮。
## 宕机自动迁移

该功能用于设置{{<oem_name>}}平台的宿主机是否启用宕机自动迁移。宿主机启用宕机迁移后，宿主机上使用共享存储创建的虚拟机都可以在宿主机关机或故障时迁移到其他宿主机上。宿主机上使用宿主机本地存储的虚拟机不会迁移。

1. 在宿主机页面，单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"宕机自动迁移"_** 菜单项，弹出宕机自动迁移对话框。
2. 选择是否勾选自动迁移，单击 **_"确定"_** 按钮，完成操作。


## 回收为物理机

该功能用于将宿主机回收成物理机。当宿主机类型为KVM且包含IPMI信息时可转为宿主机。物理机用于创建裸金属服务器，宿主机用于创建虚拟机。

**单个宿主机回收为物理机**

1. 单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"回收为宿主机"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作，可在物理机列表查看到服务器信息。

**批量将宿主机回收为物理机**

1. 在宿主机列表中勾选一个或多个宿主机，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"回收为宿主机"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作，可在物理机列表查看到服务器信息。

## 进入维护模式

当宿主机临时下线时需要将宿主机进入维护模式，进入维护模式的宿主机上的虚拟机将自动迁移到其它宿主机上。仅{{<oem_name>}}平台宿主机支持。

{{% alert title="说明" %}}
宿主机进入维护模式的条件如下：

- 仅{{<oem_name>}}平台上的宿主机支持进入维护模式；
- 在{{<oem_name>}}平台上存在空闲的其他宿主机；
- 宿主机上虚拟机未挂载GPU设备或光盘；若宿主机上虚拟机已挂载GPU设备或光盘，需要保证虚拟机处于关机状态。
- 宿主机上虚拟机不存在备份机；
- 宿主机上虚拟机状态为关机、运行中或未知状态任意一种；

{{% /alert %}}

1. 单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"进入维护模式"_** 菜单项，弹出进入维护模式操作确认对话框。
2. 单击 **_"确定"_** 按钮，宿主机上的虚拟机将迁移到其它宿主机上，宿主机状态为”维护中“，启用状态为禁用。

## 退出维护模式

当宿主机恢复正常后，可将宿主机退出维护模式。仅{{<oem_name>}}平台宿主机支持。

{{% alert title="说明" %}}
宿主机进入维护失败时，可通过退出维护模式功能将宿主机的状态调整为运行。
{{% /alert %}}

1. 单击“维护模式”的宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"退出维护模式"_** 菜单项，弹出退出维护模式操作确认对话框。
2. 单击 **_"确定"_** 按钮，宿主机状态变为”运行中“，此时宿主机的启用状态为禁用，需要用户手动启用。

## 设置GPU卡预留资源

该功能用于在宿主机上为GPU卡预留CPU、内存、存储资源。预留的资源不能被分配出去。

{{% alert title="说明" %}}
- 仅带GPU卡的{{<oem_name>}}平台的宿主机支持该功能。
- 当宿主机上有多块GPU卡时，该功能即为每块GPU卡预留相同的资源。
- GPU卡预留的资源是宿主机CPU、内存、存储超售后的预留的资源。
{{% /alert %}}

1. 单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"设置GPU卡预留资源"_** 菜单项，弹出设置GPU卡预留资源。
2. 设置每个GPU预留资源，分别设置CPU、内存、硬盘大小，单击 **_"确定"_** 按钮。

## 删除

该功能用于删除宿主机。当宿主机上虚拟机数量为0，且处于禁用状态下才可以删除。

**单个删除**

1. 单击宿主机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"删除"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作。

**批量删除**

1. 在宿主机列表中勾选一个或多个宿主机，单击列表上方 **_"批量操作"_** 按钮，选择下拉菜单 **_"删除"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作。

## 查看宿主机详情

该功能用于查看宿主机详细信息等。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 详情页面顶部菜单项支持对宿主机进行远程终端连接、启用、禁用、调整标签、调整超售比、回收物理机、进入维护模式、退出维护模式、删除等操作。
3. 查看宿主机详细信息。
    - 基本信息：包括宿主机的云上ID、ID、名称、状态、域、项目、主机名、标签、共享范围、平台、启用状态、IP、MAC地址、服务、#VM、调度策略、host版本、硬件虚拟化、ISO启动、区域、可用区、云账号、创建时间、更新时间、备注。
    - 品牌信息：包括宿主机的品牌名称、型号、序列号。
    - CPU：包括宿主机物理CPU核数、插槽数、超售比、虚拟CPU、当前超售比率、描述、GPU卡预留。
    - 内存：包括宿主机内存物理容量(总量/已分配)、超售比、当前超售比率、系统预留(系统预留内存一般为宿主机实际内存的10%，且最大不会超过10GB)、GPU卡预留。
    - 存储：包括宿主机根分区容量（已使用量/总量）、存储池容量（已使用量/总量）、类型、当前超售比率、无效存储（宿主机上状态非可用的磁盘容量总和）、GPU卡预留、适配器相关信息。
    - 网络接口：包括宿主机的所有网卡信息，包括IP地址、MAC地址、子网掩码、类型以及速率。

### 查看宿主机资源统计信息

该功能用于查看宿主机容量统计、实时监控以及top5信息等。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 单击“仪表盘”页签，进入仪表盘页面。查看以下信息。
    - 容量统计：以环形图的形式分别表示宿主机CPU、内存、本地存储、VM的总数量、已使用数量以及使用利用率信息。
    - TOP5：分别显示CPU使用率、网络入流量、网络出流量、磁盘读速率、磁盘写速率TOP5的虚拟机名称及对应值。
    - 实时监控：以仪表盘的形式实时显示宿主机的系统负载、内存利用率、磁盘IO使用率、磁盘空间使用率、网卡入带宽使用率、网卡出带宽使用率。

### 查看宿主机上的虚拟机信息

该功能用于查看宿主机上的虚拟机信息，并支持对虚拟机进行管理操作等。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 单击“虚拟机”页签，进入虚拟机页面。
3. 查看宿主机上的所有虚拟机信息，并支持对虚拟机进行管理操作。具体操作使用方法请参考[虚拟机](../../server/vminstance)页面。

### 查看宿主机网络信息

该功能用于查看宿主机的网络信息。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 单击“网络”页签，进入网络页面。
3. 查看宿主机的网络信息，包括序号、MAC地址、网卡类型、IP地址、IP子网、二层网络、驱动。
4. 当宿主机上的网卡未分配IP地址时，支持设置二层网络。单击网卡操作列 **_设置二层网络_** 按钮，在弹出的设置二层网络对话框中选择二层网络，单击 **_"确定"_** 按钮。

### 查看宿主机存储信息

该功能用于查看宿主机上的存储信息。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 单击“存储”页签，进入存储页面。
3. 查看宿主机的存储信息，包括名称、容量、分配、浪费、存储类型、启用、挂载点。
4. 支持对存储进行管理操作。

### 查看宿主机的GPU卡

该功能用于查看宿主机的GPU卡设备。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 单击“GPU”页签，进入GPU页面。
3. 查看宿主机的GPU卡信息，包括设备类型、设备型号、关联主机。
4. 支持对GPU卡进行管理操作。

### 查看宿主机上在回收站的虚拟机信息

该功能用于查看宿主机上在回收站的虚拟机的信息。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 单击“回收站”页签，进入回收站页面。
3. 查看在回收站的虚拟机信息，支持对虚拟机进行清除或恢复操作。

### 查看宿主机的监控信息

该功能用于查看宿主机的监控信息。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 单击“监控”页签，进入监控页面。
3. 查看以下监控信息。
    - 以折线图的形式显示近1小时、近3小时、近6小时内的宿主机CPU使用率信息、系统负载情况、内存使用率、内存使用情况、磁盘使用率、磁盘使用情况、磁盘IO使用率、磁盘IOPS、网络入流量、网络出流量。
        - CPU使用率包括CPU使用率、CPU空闲率、用户空间占用CPU、内核空间占用CPU、等待输入输出的CPU时间占比。
        - 系统负载情况包括系统1分钟平均负载、系统5分钟平均负载、系统15分钟平均负载、平均每个CPU核的系统1分钟平均负载、平均每个CPU核的系统5分钟平均负载、平均每个CPU核的系统15分钟平均负载。
        - 内存使用情况包括内存使用量、内存剩余量、内存总量。
        - 磁盘使用情况包括磁盘使用量、磁盘剩余量、磁盘总量。
        - 磁盘IOPS包括磁盘当前每秒平均读IO次数、磁盘当前每秒平均写IO次数）
4. 支持对上述监控信息设置监控告警。
    - 单击监控指标右侧 **_"设置监控告警"_** 按钮，弹出新建监控告警对话框。
    - 监控指标项已固定，设置查询周期、比较运算符、阈值、告警级别、告警方式、并选择告警接收人，单击 **_"确定"_** 按钮，新建告警。

### 查看硬件日志

只有由物理机转换为宿主机的详情页面支持查看硬件日志。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 单击“硬件日志”页签，进入硬件日志页面。
3. 支持设置终止时间查询指定时间之前的硬件日志信息。
4. 当日志信息较多时，可单击列表下面 **_"加载更多"_** 按钮，查看更多硬件日志信息。

### 查看宿主机操作日志

该功能用于查看宿主机相关操作的日志信息。

1. 在宿主机列表单击指定宿主机名称项，进入宿主机详情页面。
2. 单击“操作日志”页签，进入操作日志页面。
    - 加载更多日志：列表默认显示20条操作日志信息，如需查看更多操作日志，请单击 **_"加载更多"_** 按钮，获取更多日志信息。
    - 查看日志详情：单击操作日志右侧操作列 **_"查看"_** 按钮，查看日志的详情信息。支持复制详情内容。
    - 查看指定时间段的日志：如需查看某个时间段的操作日志，在列表右上方的开始日期和结束日期中设置具体的日期，查询指定时间段的日志信息。
    - 导出日志：目前仅支持导出本页显示的日志。单击右上角![](../../../images/system/download.png)图标，在弹出的导出数据对话框中，设置导出数据列，单击 **_"确定"_** 按钮，导出日志。