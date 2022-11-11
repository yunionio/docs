---
title: "控制面板"
weight: 3
description: >
  控制面板用于展示平台的参数指标等信息，便于用户快速了解系统使用情况。
---

控制面板用于展示平台的参数指标等信息，便于用户快速了解系统使用情况。{{<oem_name>}}新版控制面板内置管理后台视图、域管理后台视图和项目视图的默认模板，且支持自定义任意视图下的控制面板的显示指标，针对用户需求定制专属用户的控制面板。

**入口**：在云管平台单击左上角![](../../images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"控制面板"_** 菜单项，进入控制面板页面。

![](../../images/dashboard/dashboard.png)

- 在控制面板页面，单击指标右上方![](../../images/dashboard/more.png)图标将会跳转到对应的资源页面，如单击虚拟机数量指标右上方![](../../images/dashboard/more.png)图标将会跳转到虚拟机列表页面。

## 控制面板管理

默认面板暂不支持删除和编辑。控制面板相关指标说明请参考[指标](#指标)。

### 新建控制面板

当默认控制面板不符合用户需求时，用户可以新建控制面板定制专属用户的控制面板。在不同视图下都可以创建控制面板。

1. 在控制面板页面，单击控制面板右上角![](../../images/dashboard/operation1.png)图标，选择下拉菜单 **_"新建"_** 菜单项，进入新建控制面板页面。
2. 设置仪表盘名称并从磁贴库拖拽磁贴进行配置，配置方法如下。
   - 通用配置：任意磁贴都支持![](../../images/dashboard/delete.png)、配置![](../../images/dashboard/config.png)、复制粘贴![](../images/dashboard/copy.png)操作、以及放大或缩小磁贴。下面重点介绍如何配置磁贴。
   - 数字图：用于展示资源的数量。
       1. 将数字图的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出配置磁贴对话框。
       2. 配置以下参数：
        
            ![](../../images/dashboard/number1.png) 

           - 类型：支持设置主机资源和容器资源。
           - 当设置“主机资源” 时，配置以下参数：  
               - 磁贴名称：自定义磁贴显示的指标名称。
               - 云环境和平台：选择指标统计的平台，如不选择，则代表全部平台。
               - 区域或云账号：选择指标统计的区域或云账号或调度标签，如不选择，则代表全部区域或全部云账号或全部调度标签。
               - 项目标签：选择指标统计的项目标签进行过滤。
               - 指标：选择具体的指标值，如server代表虚拟机数量等。
           - 当设置“容器资源”时，配置以下参数：
               - 磁贴名称：自定义磁贴显示的指标名称。
               - 指标：选择容器相关指标，如all.cluster.count表示容器集群数量。
       3. 配置完成后，单击 **_"确定"_** 按钮，保存配置。
   - 使用率：用于展示资源的利用率。
       1. 将使用率的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出配置磁贴对话框。
       2. 配置以下参数：
       
            ![](../../images/dashboard/usage.png)

           - 类型：支持设置主机资源和容器资源。
           - 当设置“主机资源” 时，配置以下参数：
               - 磁贴名称：自定义磁贴显示的指标名称，如内存利用率等。
               - 云环境和平台：选择指标统计的平台，如不选择，则代表全部平台。
               - 区域或云账号：选择指标统计的区域或云账号，如不选择，则代表全部区域或全部云账号。
               - 总量指标和使用量指标：使用率即使用量与总量的比值。分别选择对应的指标。如总量指标选择host.memory(宿主机内存容量)、使用率选择all.servers.memory(虚拟机内存总量)，两者的比值即内存使用率。
           - 当设置“容器资源”时，配置以下参数：
               - 磁贴名称：自定义磁贴的显示名称，如容器内存使用率。
               - 总量指标和使用量指标：使用率即使用量与总量的比值。分别选择对应的指标。
       3. 配置完成后，单击 **_"确定"_** 按钮，保存配置。
   - 公告：用于展示系统公告，具体公告展示内容需要在系统配置-公告中进行配置。
       1. 将公告的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框。
       2. 设置磁贴名称，单击 **_"确定"_** 按钮，保存配置。
       
        ![](../../images/dashboard/post1.png) 

   - TOP5：用于展示指标TOP5的资源信息。
       1. 将公告的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出配置磁贴对话框
       2. 配置以下参数：
       
            ![](../../images/dashboard/top5.png)

           - 磁贴名称：自定义磁贴显示的指标名称。
           - 平台：选择指标统计的平台。
           - 资源类型：选择指标统计的资源类型，当选择{{<oem_name>}}、VMware、ZStack、DStack、HCSO时支持选择宿主机。
           - 指标：包括CPU利用率、磁盘读取速度、磁盘写入速度、网络入流量、网络出流量等。
           - TOP/Bottom：选择统计最高或最低的指标。
           - 显示行数：显示统计最高或最低的几条记录。
           - 近：选择统计多久时间的指标，包括5分钟、10分钟、15分钟、20分钟、25分钟、30分钟等。
       3. 配置完成后，单击 **_"确定"_** 按钮，保存配置。
   - 操作日志：用于展示操作日志信息。
       1. 将操作日志的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框中
       2. 设置磁贴名称、显示行数。
       3. 配置完成后，单击 **_"确定"_** 按钮，保存配置。
       
        ![](../../images/dashboard/log.png)

   - 费用优化资源类型成本分布：用于展示优化建议中不同规则类型的占比。
       1. 将费用优化资源类型分布成本分布的磁贴拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框。
       2. 设置磁贴名称，单击 **_"确定"_** 按钮，保存配置。
       
        ![](../../images/dashboard/costresource1.png)

    - 费用优化总览：展示通过费用优化规则可节省的成本、本月预估成本以及本月可节省成本利用率等。
       1. 将费用优化总览的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框。
       2. 设置磁贴名称，单击 **_"确定"_** 按钮，保存配置。
    
       ![](../../images/dashboard/costopt.png) 

   - 配额：展示资源的配额使用情况。
       1. 将配额的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框。
       2. 配置以下参数：
       
            ![](../../images/dashboard/peie.png)
        
          - 磁贴名称：自定义磁贴显示的指标名称。
          - 指标：包括各域CPU配额使用情况、各域内存配额使用情况、各域存储配额使用情况、各域公网IP配额使用情况、各域IP配额使用情况、各域GPU配额使用情况、各域镜像配额使用情况、各域快照配额使用情况。
       3. 配置完成后，单击 **_"确定"_** 按钮，保存配置。
   
   - 未恢复报警：展示不同资源类型的未恢复报警数量。
       1. 将未恢复报警的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框。
       2. 设置磁贴名称，单击 **_"确定"_** 按钮，保存配置。

        ![](../../images/dashboard/alertfiring.png)

   - 本月消费占比：分别支持展示本月不同资源类型的消费占比以及本月平台的消费占比。
       1. 将本月消费占比的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框
       2. 配置以下参数：
   
             ![](../../images/dashboard/resourcepercent.png)

           - 类型：包括本月资源类型消费占比和本月平台消费占比。
           - 本月资源类型消费占比：即展示本月不同资源类型的消费占比。当选择该项后，需要配置以下参数：
               - 磁贴名称：自定义磁贴显示的指标名称。
               - 币种：选择磁贴展示的币种。
               - 云平台：选择指标统计的平台。
               - 云账号：选择指标统计的云账号。
           - 本月平台消费占比：即展示不同平台的消费占比，当选择该项后，需要配置以下参数：
               - 磁贴名称：自定义磁贴显示的指标名称。
               - 币种：选择磁贴展示的币种。
       3. 配置完成后，单击 **_"确定"_** 按钮，保存配置。
   - 近30天消费趋势：展示近30天内的消费趋势图。
       1. 将近30天消费趋势磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框
       2. 配置以下参数：
      
            ![](../../images/dashboard/30cost.png)

           - 磁贴名称：自定义磁贴显示的指标名称。
           - 币种：选择磁贴展示的币种。
           - 云平台：选择指标统计的平台。
           - 云账号：选择指标统计的云账号。
       3. 配置完成后，单击 **_"确定"_** 按钮，保存配置。
   - 虚拟机数量趋势：展示自定义时间内虚拟机数量的趋势图。
       1. 将虚拟机数量趋势的磁贴拖拽到面板的任意位置，单击单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框。
       2. 设置磁贴名称以及时间，配置完成后，单击 **_"确定"_** 按钮，保存配置。

        ![](../../images/dashboard/servernum.png)
        
   - 近30天告警趋势：展示近30天内的告警趋势图，以及不同资源类型的告警比重等。
       1. 将近30天告警趋势的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框。
       2. 设置磁贴名称，配置完成后，单击 **_"确定"_** 按钮，保存配置。
       
        ![](../../images/dashboard/30alert.png)

   - 云账号健康状态：将会展示状态正常的云账号数量以及状态异常的云账号数量。
       1. 将云账号健康状态的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框。
       2. 设置磁贴名称，配置完成后，单击 **_"确定"_** 按钮，保存配置。
        
        ![](../../images/dashboard/account.png)

   - 个人信息：包括当前登录用户的用户名、当前角色、当前项目以及最后登录时间。
       1. 将个人信息的磁贴拖拽到面板的任意位置，单击磁贴的![](../../images/dashboard/config.png)图标，在右侧弹出的配置磁贴对话框。
       2. 设置磁贴名称，配置完成后，单击 **_"确定"_** 按钮，保存配置。
       
        ![](../../images/dashboard/userinfo.png)

3. 所有磁贴配置完成后，单击顶部 **_"保存"_** 按钮，保存控制面板，并在控制面板页面显示。

### 编辑控制面板

该功能用于基于已有的控制面板修改控制面板。可以添加或删除磁贴或更改已配置的磁贴参数等。

1. 在控制面板页面，单击控制面板右上角![](../../images/dashboard/operation1.png)图标，选择下拉菜单 **_"编辑"_** 菜单项，进入编辑控制面板页面。
2. 支持修改控制面板名称、或添加或删除磁贴或更改已配置的磁贴参数等。
3. 修改完成后，单击顶部 **_"确定"_** 按钮，完成修改。

### 导出控制面板

用户可以将已配置好的控制面板导出，并分享给其他用户使用。

1. 在控制面板页面，单击控制面板右上角![](../../images/dashboard/operation1.png)图标，选择下拉菜单 **_"导出"_** 菜单项，下载控制面板文件（后缀为ocdb）。

### 导入控制面板

用户可以将导出的控制面板文件导入到平台使用。

1. 在控制面板页面，单击控制面板右上角![](../../images/dashboard/operation1.png)图标，选择下拉菜单 **_"导入"_** 菜单项，弹出导入对话框。
2. 将控制面板文件（后缀为ocdb）拖拽到对话框上，单击 **_"确定"_** 按钮。
3. 导入的控制面板将显示在控制面板页面。

### 克隆控制面板

该功能用于将已有的控制面板复制一份，并显示在控制面板页面中。用户可以基于克隆的控制面板编辑定义自己的面板。

1. 在控制面板页面，单击控制面板右上角![](../../images/dashboard/operation1.png)图标，选择下拉菜单 **_"克隆"_** 菜单项，复制控制面板。
2. 克隆的控制面板与原控制面板完全相同，仅名称变成名称-1。

### 共享控制面板

{{% alert title="注意" color="warning" %}}
- 支持系统管理员操作，支持以admin角色加入项目的用户操作
- 只有默认面板支持共享，其他不支持
- 按照视图区分，共享后只影响当前视图
{{% /alert %}}

该功能用于将所有人的默认面板更新为当前面板。

1. 在控制面板页面，单击控制面板右上角![](../../images/dashboard/operation1.png)图标，选择下拉菜单 **_"共享"_** 菜单项，弹出共享对话框。
2.  单击 **_"确定"_** 按钮，完成操作。

### 重置控制面板

该功能用于重置默认面板，当默认控制面板被修改后，可通过该功能恢复到初始状态。

1. 在控制面板页面，单击默认控制面板右上角![](../../images/dashboard/operation1.png)图标，选择下拉菜单 **_"重置"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，完成操作。

## 指标

| kind      | metric                                         | 说明                 |
|-----------|------------------------------------------------|-----------------------|
| usage     | all.bucket_bytes                               | 对象存储容量                |
| usage     | all.bucket_objects                             | 对象存储文件数量              |
| usage     | all.buckets                                    | 存储桶数量                 |
| usage     | all.cpu_commit_rate.running                    | 运行状态的虚拟机CPU超售比        |
| usage     | all.disks                                      | 磁盘总容量                 |
| usage     | all.disks.mounted                              | 已挂载磁盘总容量              |
| usage     | all.disks.unmounted                            | 未挂载的磁盘总容量             |
| usage     | all.disks.unready                              | 异常状态的磁盘容量             |
| usage     | all.eip                                        | 弹性公网IP和公网IP总数         |
| usage     | all.eip.floating_ip                            | 弹性公网IP总量              |
| usage     | all.eip.floating_ip.used                       | 已使用的弹性公网IP数量          |
| usage     | all.eip.public_ip                              | 公网IP总量                |
| usage     | all.eip.used                                   | 已使用的弹性公网IP和公网IP数量     |
| usage     | all.memory_commit_rate.running                 | 运行状态的虚拟机内存超售比         |
| usage     | all.nics                                       | 已分配IP总量               |
| usage     | all.nics.guest                                 | 虚拟机分配IP数量             |
| usage     | all.nics.host                                  | 宿主机分配IP数量             |
| usage     | all.nics.lb                                    | 负载均衡分配IP数量            |
| usage     | all.nics.reserve                               | 预留IP数量                |
| usage     | all.nics.guest.pending_delete                  | 回收站内虚拟机分配IP数量         |
| usage     | all.nics.netif                                 | 虚拟网卡分配IP数量            |
| usage     | all.nics.eip                                   | 已分配EIP数量              |
| usage     | all.nics.db                                    | RDS实例分配IP数量           |
| usage     | domain.nics                                    | 当前域已分配IP总量            |
| usage     | domain.nics.guest                              | 当前域虚拟机分配IP数量          |
| usage     | domain.nics.host                               | 当前域宿主机分配IP数量          |
| usage     | domain.nics.lb                                 | 当前域负载均衡分配IP数量         |
| usage     | domain.nics.reserve                            | 当前域预留IP数量             |
| usage     | domain.nics.guest.pending_delete               | 当前域回收站内虚拟机分配IP数量      |
| usage     | domain.nics.netif                              | 当前域虚拟网卡分配IP数量         |
| usage     | domain.nics.eip                                | 当前域已分配EIP数量           |
| usage     | domain.nics.db                                 | 当前域RDS实例分配IP数量        |
| usage     | all.pending_delete_servers                     | 回收站虚拟机的数量             |
| usage     | all.pending_delete_servers.cpu                 | 回收站虚拟机CPU的数量          |
| usage     | all.pending_delete_servers.disk                | 回收站虚拟机磁盘容量            |
| usage     | all.pending_delete_servers.ha                  | 回收站高可用虚拟机数量           |
| usage     | all.pending_delete_servers.ha.cpu              | 回收站高可用虚拟机CPU的数量       |
| usage     | all.pending_delete_servers.ha.disk             | 回收站高可用虚拟机磁盘容量         |
| usage     | all.pending_delete_servers.ha.memory           | 回收站高可用虚拟机内存容量         |
| usage     | all.pending_delete_servers.isolated_devices    | 回收站虚拟机GPU卡数量          |
| usage     | all.pending_delete_servers.memory              | 回收站虚拟机内存容量            |
| usage     | all.ports                                      | IP总量                  |
| usage     | all.ports.eip                                  | EIP类型IP总量             |
| usage     | all.ports_exit                                 | 外网IP总量                |
| usage     | all.ports_exit.eip                             | EIP类型外网IP总量           |
| usage     | all.ready_servers                              | 关机状态虚拟机数量             |
| usage     | all.ready_servers.cpu                          | 关机状态虚拟机CPU数量          |
| usage     | all.ready_servers.disk                         | 关机状态虚拟机磁盘容量           |
| usage     | all.ready_servers.ha                           | 关机状态高可用虚拟机数量          |
| usage     | all.ready_servers.ha.cpu                       | 关机状态高可用虚拟机CPU的数量      |
| usage     | all.ready_servers.ha.disk                      | 关机状态高可用虚拟机磁盘容量        |
| usage     | all.ready_servers.ha.memory                    | 关机状态高可用虚拟机内存容量        |
| usage     | all.ready_servers.isolated_devices             | 关机状态的虚拟机GPU卡数量        |
| usage     | all.ready_servers.memory                       | 关机状态的虚拟机内存容量          |
| usage     | all.running_servers                            | 运行状态的虚拟机数量            |
| usage     | all.running_servers.cpu                        | 运行状态的虚拟机CPU数量         |
| usage     | all.running_servers.disk                       | 运行状态的虚拟机磁盘容量          |
| usage     | all.running_servers.ha                         | 运行状态的高可用虚拟机数量         |
| usage     | all.running_servers.ha.cpu                     | 运行状态的高可用虚拟机CPU的数量     |
| usage     | all.running_servers.ha.disk                    | 运行状态的高可用虚拟机磁盘容量       |
| usage     | all.running_servers.ha.memory                  | 运行状态的高可用虚拟机内存容量       |
| usage     | all.running_servers.isolated_devices           | 运行状态的虚拟机GPU卡数量        |
| usage     | all.running_servers.memory                     | 运行状态的虚拟机内存容量          |
| usage     | all.servers                                    | 虚拟机数量                 |
| usage     | all.servers.cpu                                | 虚拟机CPU数量              |
| usage     | all.servers.disk                               | 虚拟机磁盘容量               |
| usage     | all.servers.ha                                 | 高可用虚拟机数量              |
| usage     | all.servers.ha.cpu                             | 高可用虚拟机CPU数量           |
| usage     | all.servers.ha.disk                            | 高可用虚拟机硬盘容量            |
| usage     | all.servers.ha.memory                          | 高可用虚拟机内存容量            |
| usage     | all.servers.isolated_devices                   | 虚拟机GPU卡数量             |
| usage     | all.servers.memory                             | 虚拟机内存容量               |
| usage     | all.snapshot                                   | 快照数量                  |
| usage     | baremetals                                     | 裸金属服务器数量              |
| usage     | baremetals.cpu                                 | 裸金属服务器CPU数量           |
| usage     | baremetals.memory                              | 裸金属服务器内存容量            |
| usage     | bucket_bytes                                   | 当前项目对象存储容量            |
| usage     | bucket_objects                                 | 当前项目对象存储文件数量          |
| usage     | buckets                                        | 当前项目存储桶数量             |
| usage     | disks                                          | 当前项目磁盘容量              |
| usage     | disks.mounted                                  | 当前项目已挂载磁盘的容量          |
| usage     | disks.unmounted                                | 当前项目未挂载磁盘的容量          |
| usage     | disks.unready                                  | 当前项目异常状态的磁盘容量         |
| usage     | eip                                            | 当前项目弹性公网IP和公网IP总数     |
| usage     | eip.floating_ip                                | 当前项目弹性公网IP总量          |
| usage     | eip.floating_ip.used                           | 当前项目已使用的弹性公网IP数量      |
| usage     | eip.public_ip                                  | 当前项目公网IP总量            |
| usage     | eip.used                                       | 当前项目已使用的弹性公网IP和公网IP数量 |
| usage     | enabled_hosts                                  | 启用的宿主机数量              |
| usage     | enabled_hosts.cpu                              | 启用的宿主机CPU数量           |
| usage     | enabled_hosts.cpu.virtual                      | 启用的宿主机CPU虚拟数量         |
| usage     | enabled_hosts.memory                           | 启用的宿主机内存容量            |
| usage     | enabled_hosts.memory.virtual                   | 启用的宿主机内存虚拟容量          |
| usage     | hosts                                          | 宿主机总量                 |
| usage     | hosts.cpu                                      | 宿主机CPU核数总量(不含预留CPU核数) |
| usage     | hosts.cpu.virtual                              | 宿主机CPU核数虚拟总量          |
| usage     | hosts.cpu.total                                | 宿主机CPU核数总量            |
| usage     | hosts.memory                                   | 宿主机内存容量(不含预留内存容量)     |
| usage     | hosts.memory.virtual                           | 宿主机内存虚拟容量             |
| usage     | hosts.memory.total                             | 宿主机内容总容量              |
| usage     | isolated_devices                               | GPU卡总量                |
| usage     | networks                                       | IP子网总量                |
| usage     | nics                                           | 当前项目已分配IP总量           |
| usage     | nics.guest                                     | 当前项目虚拟机分配IP数量         |
| usage     | nics.lb                                        | 当前项目负载均衡分配IP数量        |
| usage     | nics.reserve                                   | 当前项目预留IP数量            |
| usage     | nics.guest.pending_delete                      | 当前项目回收站内虚拟机分配IP数量     |
| usage     | nics.eip                                       | 当前项目已分配EIP数量          |
| usage     | nics.db                                        | 当前项目RDS实例分配IP数量       |
| usage     | pending_delete_servers                         | 当前项目回收站虚拟机数量          |
| usage     | pending_delete_servers.cpu                     | 当前项目回收站虚拟机CPU的数量      |
| usage     | pending_delete_servers.disk                    | 当前项目回收站虚拟机磁盘容量        |
| usage     | pending_delete_servers.ha                      | 当前项目回收站高可用虚拟机数量       |
| usage     | pending_delete_servers.ha.cpu                  | 当前项目回收站高可用虚拟机CPU的数量   |
| usage     | pending_delete_servers.ha.disk                 | 当前项目回收站高可用虚拟机磁盘容量     |
| usage     | pending_delete_servers.ha.memory               | 当前项目回收站高可用虚拟机内存容量     |
| usage     | pending_delete_servers.isolated_devices        | 当前项目回收站虚拟机GPU卡数量      |
| usage     | pending_delete_servers.memory                  | 当前项目回收站虚拟机内存容量        |
| usage     | ports                                          | 当前项目IP总量              |
| usage     | ports.eip                                      | 当前项目EIP类型IP总量         |
| usage     | ports_exit                                     | 当前项目外网IP总量            |
| usage     | ports_exit.eip                                 | 当前项目EIP类型外网IP总量       |
| usage     | ready_servers                                  | 当前项目关机状态虚拟机数量         |
| usage     | ready_servers.cpu                              | 当前项目关机状态虚拟机CPU数量      |
| usage     | ready_servers.disk                             | 当前项目关机状态虚拟机磁盘容量       |
| usage     | ready_servers.ha                               | 当前项目关机状态高可用虚拟机数量      |
| usage     | ready_servers.ha.cpu                           | 当前项目关机状态高可用虚拟机CPU的数量  |
| usage     | ready_servers.ha.disk                          | 当前项目关机状态高可用虚拟机磁盘容量    |
| usage     | ready_servers.ha.memory                        | 当前项目关机状态高可用虚拟机内存容量    |
| usage     | ready_servers.isolated_devices                 | 当前项目关机状态的虚拟机GPU卡数量    |
| usage     | ready_servers.memory                           | 当前项目关机状态的虚拟机内存容量      |
| usage     | regions                                        | 区域总数量                 |
| usage     | running_servers                                | 当前项目运行状态的虚拟机数量        |
| usage     | running_servers.cpu                            | 当前项目运行状态的虚拟机CPU数量     |
| usage     | running_servers.disk                           | 当前项目运行状态的虚拟机磁盘容量      |
| usage     | running_servers.ha                             | 当前项目运行状态的高可用虚拟机数量     |
| usage     | running_servers.ha.cpu                         | 当前项目运行状态的高可用虚拟机CPU的数量 |
| usage     | running_servers.ha.disk                        | 当前项目运行状态的高可用虚拟机磁盘容量   |
| usage     | running_servers.ha.memory                      | 当前项目运行状态的高可用虚拟机内存容量   |
| usage     | running_servers.isolated_devices               | 当前项目运行状态的虚拟机GPU卡数量    |
| usage     | running_servers.memory                         | 当前项目运行状态的虚拟机内存容量      |
| usage     | servers                                        | 当前项目虚拟机数量             |
| usage     | servers.cpu                                    | 当前项目虚拟机CPU数量          |
| usage     | servers.disk                                   | 当前项目虚拟机磁盘容量           |
| usage     | servers.ha                                     | 当前项目高可用虚拟机数量          |
| usage     | servers.ha.cpu                                 | 当前项目高可用虚拟机CPU数量       |
| usage     | servers.ha.disk                                | 当前项目高可用虚拟机硬盘容量        |
| usage     | servers.ha.memory                              | 当前项目高可用虚拟机内存容量        |
| usage     | servers.isolated_devices                       | 当前项目虚拟机GPU卡数量         |
| usage     | servers.memory                                 | 当前项目虚拟机内存容量           |
| usage     | snapshot                                       | 当前项目快照数量              |
| usage     | storages                                       | 存储总容量                 |
| usage     | storages.commit_rate                           | 存储超售比                 |
| usage     | storages.virtual                               | 存储总虚拟容量               |
| usage     | vpcs                                           | 专有网络VPC数量             |
| usage     | wires                                          | 二层网络数量                |
| usage     | zones                                          | 可用区的数量                |
| usage     | all.disks.count                                | 磁盘数量                  |
| usage     | all.disks.mounted.count                        | 已挂载磁盘数量               |
| usage     | all.disks.unmounted.count                      | 未挂载磁盘数量               |
| usage     | all.disks.unready.count                        | 异常状态磁盘数量              |
| usage     | all.loadbalancer                               | 负载均衡数量                |
| usage     | all.cache                                      | Redis实例数量             |
| usage     | all.rds                                        | RDS实例数量               |
| usage     | all.servers.system                             | 系统使用虚拟机数量             |
| usage     | all.disks.system                               | 系统存储使用量               |
| usage     | all.servers.system.cpu                         | 系统虚拟机CPU使用量           |
| usage     | all.servers.system.memory                      | 系统虚拟机内存使用量            |
| usage     | cache                                          | 当前项目下Redis数量          |
| usage     | disks.count                                    | 当前项目下磁盘数量             |
| usage     | disks.mounted.count                            | 当前项目下已挂载磁盘数量          |
| usage     | disks.unmounted.count                          | 当前项目下未挂载磁盘数量          |
| usage     | disks.unready.count                            | 当前项目下异常状态磁盘数量         |
| usage     | loadbalancer                                   | 当前项目下负载均衡数量           |
| usage     | rds                                            | 当前项目下RDS实例数量          |
| usage     | domain.baremetals                              | 当前域裸金属服务器数量           |
| usage     | domain.baremetals.cpu                          | 当前域裸金属服务器CPU数量        |
| usage     | domain.baremetals.memory                       | 当前域裸金属服务器内存容量         |
| usage     | domain.bucket_bytes                            | 当前域对象存储容量             |
| usage     | domain.bucket_objects                          | 当前域对象存储文件数量           |
| usage     | domain.buckets                                 | 当前域存储桶数量              |
| usage     | domain.cache                                   | 当前域Redis实例数量          |
| usage     | domain.cpu_commit_rate.running                 | 当前域运行状态的虚拟机CPU超售比     |
| usage     | domain.disks                                   | 当前域磁盘总容量              |
| usage     | domain.disks.mounted                           | 当前域已挂载磁盘总容量           |
| usage     | domain.disks.mounted.count                     | 当前域已挂载磁盘数量            |
| usage     | domain.disks.count                             | 当前域磁盘总数量              |
| usage     | domain.disks.unmounted                         | 当前域未挂载的磁盘总容量          |
| usage     | domain.disks.unmounted.count                   | 当前域未挂载的磁盘总数量          |
| usage     | domain.disks.unready                           | 当前域异常状态的磁盘容量          |
| usage     | domain.disks.unready.count                     | 当前域异常状态的磁盘数量          |
| usage     | domain.eip                                     | 当前域弹性公网IP和公网IP总数      |
| usage     | domain.eip.floating_ip                         | 当前域弹性公网IP总量           |
| usage     | domain.eip.floating_ip.used                    | 当前域已使用的弹性公网IP数量       |
| usage     | domain.eip.public_ip                           | 当前域公网IP总量             |
| usage     | domain.eip.used                                | 当前域已使用的弹性公网IP和公网IP数量  |
| usage     | domain.enabled_hosts                           | 当前域启用的宿主机数量           |
| usage     | domain.enabled_hosts.cpu                       | 当前域启用的宿主机CPU数量        |
| usage     | domain.enabled_hosts.cpu.virtual               | 当前域启用的宿主机CPU虚拟数量      |
| usage     | domain.enabled_hosts.memory                    | 当前域启用的宿主机内存容量         |
| usage     | domain.enabled_hosts.memory.virtual            | 当前域启用的宿主机内存虚拟容量       |
| usage     | domain.hosts                                   | 当前域宿主机总量              |
| usage     | domain.hosts.cpu                               | 当前域宿主机CPU总量           |
| usage     | domain.hosts.cpu.virtual                       | 当前域宿主机CPU虚拟总量         |
| usage     | domain.hosts.memory                            | 当前域宿主机内存容量            |
| usage     | domain.hosts.memory.virtual                    | 当前域宿主机内存虚拟容量          |
| usage     | domain.loadbalancer                            | 当前域负载均衡实例数量           |
| usage     | domain.memory_commit_rate.running              | 当前域运行状态的虚拟机内存超售比      |
| usage     | domain.pending_delete_servers                  | 当前域回收站虚拟机的数量          |
| usage     | domain.pending_delete_servers.cpu              | 当前域回收站虚拟机CPU的数量       |
| usage     | domain.pending_delete_servers.disk             | 当前域回收站虚拟机磁盘容量         |
| usage     | domain.pending_delete_servers.ha               | 当前域回收站高可用虚拟机数量        |
| usage     | domain.pending_delete_servers.ha.cpu           | 当前域回收站高可用虚拟机CPU的数量    |
| usage     | domain.pending_delete_servers.ha.disk          | 当前域回收站高可用虚拟机磁盘容量      |
| usage     | domain.pending_delete_servers.ha.memory        | 当前域回收站高可用虚拟机内存容量      |
| usage     | domain.pending_delete_servers.isolated_devices | 当前域回收站虚拟机GPU卡数量       |
| usage     | domain.pending_delete_servers.memory           | 当前域回收站虚拟机内存容量         |
| usage     | domain.ports                                   | 当前域IP总量               |
| usage     | domain.ports.eip                               | 当前域EIP类型IP总量          |
| usage     | domain.ports_exit                              | 当前域外网IP总量             |
| usage     | domain.ports_exit.eip                          | 当前域EIP类型外网IP总量        |
| usage     | domain.rds                                     | 当前域RDS实例数量            |
| usage     | domain.ready_servers                           | 当前域关机状态虚拟机数量          |
| usage     | domain.ready_servers.cpu                       | 当前域关机状态虚拟机CPU数量       |
| usage     | domain.ready_servers.disk                      | 当前域关机状态虚拟机磁盘容量        |
| usage     | domain.ready_servers.ha                        | 当前域关机状态高可用虚拟机数量       |
| usage     | domain.ready_servers.ha.cpu                    | 当前域关机状态高可用虚拟机CPU的数量   |
| usage     | domain.ready_servers.ha.disk                   | 当前域关机状态高可用虚拟机磁盘容量     |
| usage     | domain.ready_servers.ha.memory                 | 当前域关机状态高可用虚拟机内存容量     |
| usage     | domain.ready_servers.isolated_devices          | 当前域关机状态的虚拟机GPU卡数量     |
| usage     | domain.ready_servers.memory                    | 当前域关机状态的虚拟机内存容量       |
| usage     | domain.running_servers                         | 当前域运行状态的虚拟机数量         |
| usage     | domain.running_servers.cpu                     | 当前域运行状态的虚拟机CPU数量      |
| usage     | domain.running_servers.disk                    | 当前域运行状态的虚拟机磁盘容量       |
| usage     | domain.running_servers.ha                      | 当前域运行状态的高可用虚拟机数量      |
| usage     | domain.running_servers.ha.cpu                  | 当前域运行状态的高可用虚拟机CPU的数量  |
| usage     | domain.running_servers.ha.disk                 | 当前域运行状态的高可用虚拟机磁盘容量    |
| usage     | domain.running_servers.ha.memory               | 当前域运行状态的高可用虚拟机内存容量    |
| usage     | domain.running_servers.isolated_devices        | 当前域运行状态的虚拟机GPU卡数量     |
| usage     | domain.running_servers.memory                  | 当前域运行状态的虚拟机内存容量       |
| usage     | domain.servers                                 | 当前域虚拟机数量              |
| usage     | domain.servers.cpu                             | 当前域虚拟机CPU数量           |
| usage     | domain.servers.disk                            | 当前域虚拟机磁盘容量            |
| usage     | domain.servers.ha                              | 当前域高可用虚拟机数量           |
| usage     | domain.servers.ha.cpu                          | 当前域高可用虚拟机CPU数量        |
| usage     | domain.servers.ha.disk                         | 当前域高可用虚拟机硬盘容量         |
| usage     | domain.servers.ha.memory                       | 当前域高可用虚拟机内存容量         |
| usage     | domain.servers.isolated_devices                | 当前域虚拟机GPU卡数量          |
| usage     | domain.servers.memory                          | 当前域虚拟机内存容量            |
| usage     | domain.snapshot                                | 当前域快照数量               |
| usage     | domain.storages                                | 当前域存储总容量              |
| usage     | domain.storages.commit_rate                    | 当前域存储超售比              |
| usage     | domain.storages.virtual                        | 当前域存储总虚拟容量            |
| usage     | domain.vpcs                                    | 当前域专有网络VPC数量          |
| usage     | all.img.total.size                             | 所有虚拟机镜像的总大小           |
| usage     | domain.img.total.size                          | 当前域的虚拟机镜像的总大小         |
| usage     | img.total.size                                 | 当前项目的虚拟机镜像的总大小        |
| usage     | all.iso.total.size                             | 所有ISO的总大小             |
| usage     | domain.iso.total.size                          | 当前域的ISO的总大小           |
| usage     | iso.total.size                                 | 当前项目的ISO的总大小          |
| usage     | all.imgiso.total.size                          | 所有虚拟机镜像和ISO的总大小       |
| usage     | domain.imgiso.total.size                       | 当前域的虚拟机镜像和ISO的总大小     |
| usage     | imgiso.total.size                              | 当前项目的虚拟机镜像和ISO的总大小    |
| usage     | all.pending_delete_servers.last_week           | 过去1周删除虚拟机数量           |
| usage     | domain.pending_delete_servers.last_week        | 当前域过去1周新增虚拟机数量        |
| usage     | pending_delete_servers.last_week               | 当前项目过去1周新增虚拟机数量       |
| usage     | all.servers.last_week                          | 过去1周新增虚拟机数量           |
| usage     | domain.servers.last_week                       | 当前域过去1周新增虚拟机数量        |
| usage     | servers.last_week                              | 当前项目过去1周新增虚拟机数量       |
| k8s_usage | all.cluster.count                              | 集群数量                  |
| k8s_usage | all.cluster.node.count                         | 节点数量                  |
| k8s_usage | all.cluster.node.not_ready_count               | 不健康节点数量               |
| k8s_usage | all.cluster.node.ready_count                   | 健康节点数量                |
| k8s_usage | all.cluster.node.pod.capacity                  | pod数上限                |
| k8s_usage | all.cluster.node.pod.count                     | pod数量                 |
| k8s_usage | all.cluster.node.cpu.capacity                  | cpu总量                 |
| k8s_usage | all.cluster.node.cpu.limit                     | cpu限制量                |
| k8s_usage | all.cluster.node.cpu.request                   | cpu使用量                |
| k8s_usage | all.cluster.node.memory.capacity               | 内存总量                  |
| k8s_usage | all.cluster.node.memory.limit                  | 内存限制量                 |
| k8s_usage | all.cluster.node.memory.request                | 内存使用量                 |
| k8s_usage | domain.cluster.count                           | 当前域集群数量               |
| k8s_usage | domain.cluster.node.count                      | 当前域节点数量               |
| k8s_usage | domain.cluster.node.not_ready_count            | 当前域不健康节点数量            |
| k8s_usage | domain.cluster.node.ready_count                | 当前域健康节点数量             |
| k8s_usage | domain.cluster.node.pod.capacity               | 当前域pod数上限             |
| k8s_usage | domain.cluster.node.pod.count                  | 当前域pod数量              |
| k8s_usage | domain.cluster.node.cpu.capacity               | 当前域cpu总量              |
| k8s_usage | domain.cluster.node.cpu.limit                  | 当前域cpu限制量             |
| k8s_usage | domain.cluster.node.cpu.request                | 当前域cpu使用量             |
| k8s_usage | domain.cluster.node.memory.capacity            | 当前域内存总量               |
| k8s_usage | domain.cluster.node.memory.limit               | 当前域内存限制量              |
| k8s_usage | domain.cluster.node.memory.request             | 当前域内存使用量              |
| k8s_usage | project.cluster.count                          | 当前项目集群数量              |
| k8s_usage | project.cluster.node.count                     | 当前项目节点数量              |
| k8s_usage | project.cluster.node.not_ready_count           | 当前项目不健康节点数量           |
| k8s_usage | project.cluster.node.ready_count               | 当前项目健康节点数量            |
| k8s_usage | project.cluster.node.pod.capacity              | 当前项目pod数上限            |
| k8s_usage | project.cluster.node.pod.count                 | 当前项目pod数量             |
| k8s_usage | project.cluster.node.cpu.capacity              | 当前项目cpu总量             |
| k8s_usage | project.cluster.node.cpu.limit                 | 当前项目cpu限制量            |
| k8s_usage | project.cluster.node.cpu.request               | 当前项目cpu使用量            |
| k8s_usage | project.cluster.node.memory.capacity           | 当前项目内存总量              |
| k8s_usage | project.cluster.node.memory.limit              | 当前项目内存限制量             |
| k8s_usage | project.cluster.node.memory.request            | 当前项目内存使用量             |
