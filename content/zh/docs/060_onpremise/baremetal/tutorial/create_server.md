---
title: "安装操作系统"
weight: 2
description: >
  介绍如何在平台已有的物理机上安装操作系统。
---

## 安装操作系统

### 界面操作

该功能用于新建裸金属设备。

1. 单击物理机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"安装操作系统"_** 菜单项，进入新建裸金属页面。
2. 设置以下参数：
    - 名称：裸金属设备名称。
    - 主机数量与规格：由于裸金属设备独占物理机，数量和规格不可改。
    - 操作系统：
        - 公共镜像：对应系统镜像列表中的Linux操作系统的公共镜像，由管理员维护。
        - 自定义镜像：对应系统镜像列表中的Linux操作系统的自定义镜像，一般是由用户上传。
        - 从ISO启动：对应系统镜像列表中ISO格式的Linux操作系统镜像。选择ISO镜像文件时，需要用户为裸金属服务器安装操作系统。
    - 磁盘配置：单击 **_"新增磁盘"_** 按钮，弹出新建磁盘配置对话框。
        - 选择物理机上的磁盘类型（HDD:3.6TIB表示物理机上一块磁盘大小为3.6TiB、磁盘类HDD）、设置RAID（包括不做RAID、RAID0、RAID1、RAID5、RAID10）
        - 设置磁盘数量，即使用几块相同配置的磁盘做RAID配置，如对磁盘做RAID0，磁盘利用率为100%；对2块磁盘做RAID1，磁盘利用率为50%；对3块及以上磁盘做RAID5，磁盘利用率为(n-1)/n；对4块及以上磁盘做RAID10，磁盘利用率为50%。
            - RAID0和不做RAID对磁盘数量无要求；
            - RAID1要求至少有2块相同的磁盘；
            - RAID5要求至少有3块相同的磁盘；
            - RAID10要求至少有4块相同的磁盘；
    
             ![](../../../images/computing/raid.png)
             ![](../../../images/computing/partition.png)
        - 磁盘RAID配置完成后，显示磁盘分区名称和大小信息，支持在界面修改分区，可分别单击“系统分区”黄色区域修改分区设置、单击“待分区”区域设置分区。分区参数如下：
            - 挂载点：设置分区挂载点，系统分区挂载点默认为“/”。
            - 分区格式：包括ext4、xfs、ntfs、swap分区。
            - 分区大小：包括最大容量和手动输入两种，最大容量使用磁盘所有空间，手动输入可以手动设置分区大小，单位为GB。

            ![](../../../images/computing/createpartition1\.png)

    - 网络：设置裸金属的IP地址。当环境中有两张与网线连接的网卡需要做绑定设置时，可勾选"启用bonding"
{{% alert title="说明" %}}
当物理机有两张连接网线的网卡时，将会自动绑定，当物理机有大于两张连接网线的网卡时，网卡绑定结果不可控，请谨慎操作。
{{% /alert %}}
        - 指定IP子网：选择IP子网，如需指定静态IP，可单击 **_"手动配置IP"_** 按钮，设置IP地址，单击 **_"确定"_** 按钮。
        - 指定调度标签：设置调度标签以及调度标签偏好。设置的调度标签偏好将会覆盖调度标签上的默认策略。根据调度标签及调度偏好选择最优的IP子网。
            - 尽量使用（prefer）：调度时优先使用拥有这种标签的IP子网。
            - 避免使用（avoid）：调度时尽量避免拥有这种标签的IP子网。
            - 禁止使用（exclude）：调度时排除拥有这种标签的IP子网。
            - 必须使用（require）：调度时必须使用拥有这种标签的IP子网。
    - 管理员密码：设置管理员密码，在Linux系统中为root用户的密码，在Windows操作系统中为administrator用户的密码。
        - 随机生成：随机生成管理员密码，用户可在虚拟机列表密码列查看复制管理员密码。
        - 关联密钥：仅支持Linux操作系统的虚拟机。在关联密钥之前请先在“网络-密钥”页面新建SSH密钥。关联密钥后，用户需要使用SSH密钥对登录虚拟机。
        - 保留镜像设置：管理员密码为镜像中已有的管理员密码。
        - 手工输入：可手动设置管理员密码。
    - 备注：设置裸金属的备注信息。
3. 单击 **_"新建"_** 按钮，创建裸金属设备。

### Climc


#### 安装操作系统

```bash
climc server-create \
    --hypervisor baremetal \ # 指定 server 的类型为 baremetal
    --ncpu 24 \ # 创建到 24 核 cpu 的物理机
    --raid-config 'raid1:2:MegaRaid' \ # 第1块盘，使用 MegaRaid 控制器上的(0-1)号两块物理盘做 raid1
    --raid-config 'none:1' \ # 第2块盘，使用 MegaRaid 控制器上的(2)号物理盘，不做 raid
    --raid-config 'raid10:4:MegaRaid' \ # 第3快盘, 使用 MegaRaid 控制器上的(3-6)号四块物理盘做raid10
    --disk CentOS-7.5.qcow2:100g \ # 系统盘使用 CentOS-7.5.qcow2 镜像作为操作系统，大小为 100g，使用第1块 raid1 的盘
    --disk 'autoextend:ext4:/opt' \ # 分区挂载到 /opt, 使用第1块 raid1 的盘，文件系统为 ext4, 大小为(第一块盘总大小 - 该盘其他分区的大小(100g))
    --disk 'autoextend:xfs:/data-nonraid' \ # 分区挂载到 /data-nonraid, 使用第2块没做 raid 的盘, 文件系统为 xfs，使用所有空间
    --disk 'autoextend:ext4:/data-raid10' \ # 分区挂载到 /data-raid10, 使用第3块 raid10 的盘，文件系统为 ext4, 使用所有空间
    <server_name> \ # 裸金属服务器名称
    64g # 创建到 64g 内存大小的物理机
```

#### raid 配置和分区

调用 server-create 接口时通过 '--raid-config' 传递参数来配置 raid，每个 raid-config 对应到操作系统可见的磁盘设备(/dev/sdx)。

'--disk' 参数对应不同磁盘上的分区，分区对应到磁盘的逻辑为: 分区按照顺序创建到第1块磁盘上，当 disk 设置 autoextend 参数后，表示接下来的 disk 分区会创建到下一个磁盘，以此类推。

- raid 配置 API 参数:

| Key                          | Type   | value                                           | 解释                                 |
|------------------------------|--------|-------------------------------------------------|--------------------------------------|
| type(磁盘类型)               | string | rotate(机械盘), ssd(固态盘), hybrid(未知)       | -                                    |
| conf (raid)                  | string | none, raid0, raid1, raid5, raid10               | 做raid几或者不做                     |
| count (磁盘数量)             | int    | e.g. 0, 2, 4                                    | 小于等于物理机实际的盘数             |
| range (磁盘范围)             | []int  | e.g. [0,1,2,3], [4,7], [5,6]                    | 物理磁盘在控制器上的索引号           |
| splits (切割物理盘)          | string | (30%,20%,), (300g,100g,)                        | 做好 raid 的物理盘再切割为多块物理盘 |
| adapter (控制器号)           | int    | 0, 1                                            | 对应driver的 Adapter 控制器          |
| driver  (控制器名称)         | string | MegaRaid,HPSARaid,Mpt2SAS,MarvelRaid,Linux,PCIE | 1台物理机上有多个控制器时用于选择盘  |
| strip  (设置raid strip 大小) | *int   | e.g. 64*1024                                    | 设置strip size, 可选                 |
| ra                           | *bool  |                                                 | 设置读模式                           |
| wt                           |        |                                                 | 设置写模式                           |
| cachedbadbbu                 | *bool  |                                                 |                                      |
| direct                       | *bool  |                                                 |                                      |

- 命令行格式:

    '(none,raid0,raid1,raid5,raid10):%d:(MegaRaid|HPSARaid|Mpt2SAS|MarvelRaid|Linux|PCIE):(rotate|ssd|hybrid):[0-n]:strip%dk:adapter%d:ra:nora:wt:wb:direct:cachedbadbbu:nocachedbadbbu'


