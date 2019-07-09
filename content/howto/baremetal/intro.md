---
title: "介绍"
weight: 10
date: 2019-07-09T16:25:11+08:00
draft: true
---

# 术语解释

- Baremetal: 指尚未安装操作系统的服务器， 也叫作物理机
- [PXE (Preboot eXecution Environment)](https://zh.wikipedia.org/wiki/%E9%A2%84%E5%90%AF%E5%8A%A8%E6%89%A7%E8%A1%8C%E7%8E%AF%E5%A2%83): 使用网络接口启动计算机的机制。这种机制不依赖本地数据存储设备（如硬盘）或本地已安装的操作系统，使用 DHCP 协议查找引导服务器并获取 IP，再通过 TFTP 协议下载初始引导程序和附加文件启动
- [DHCP (Dynamic Host Configuration Protocol)](https://zh.wikipedia.org/wiki/%E5%8A%A8%E6%80%81%E4%B8%BB%E6%9C%BA%E8%AE%BE%E7%BD%AE%E5%8D%8F%E8%AE%AE): 动态主机设置协议是一个局域网的网络协议，使用UDP协议工作，为机器分配 IP
- [TFTP (Trivial File Transfer Protocol)](https://zh.wikipedia.org/wiki/%E5%B0%8F%E5%9E%8B%E6%96%87%E4%BB%B6%E4%BC%A0%E8%BE%93%E5%8D%8F%E8%AE%AE): 小型文件传输协议，使用UDP协议传输文件
- DHCP Relay: 在不同子网和物理网段之间处理和转发dhcp信息的功能
- [IPMI (Intelligent Platform Management Interface)](https://zh.wikipedia.org/wiki/IPMI)：管理服务器硬件的标准，特性是独立于操作系统外自行运行，即使在缺少操作系统或系统管理软件、或受监控的系统关机但有接电源的情况下仍能远程管理系统，也能在操作系统引导后运行
- [BMC (Baseboard management controller)](https://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface#Baseboard_management_controller): 基板管理控制器，支持行业标准的 IPMI 规范
- [SSH (Secure Shell)](https://zh.wikipedia.org/wiki/Secure_Shell): 用于远程登录控制服务器
- [RAID (Redundant Array of Independent Disks)](https://zh.wikipedia.org/wiki/RAID): 磁盘阵列，把多个硬盘组合成为一个逻辑扇区，操作系统只会把它当作一个硬盘

- Region Service: 云平台控制服务，提供 baremetal 相关 API
- Baremetal Agent: 云平台管理 baremetal 的服务
- Glance Service: 云平台镜像服务，提供物理机装机的 Image 镜像
- 裸金属服务器: baremetal 物理机安装操作系统后，在云平台创建的 server 的记录
- 宿主机: 可以运行云平台虚拟机的节点

# 功能介绍

云平台支持 Baremetal(物理机) 管理，提供的功能如下:

1. 自动化上架: 物理机上架加电启动后，自动注册到云管平台，自动分配BMC IP地址，初始化IPMI账号密码，自动上报物理机硬件配置（CPU、内存、序列号、网卡、磁盘等）

2. 自动化装机: 根据配置要求自动配置 RAID，自动分区格式化磁盘，自动部署操作系统镜像，自动初始化操作系统账号密码，自动分配IP地址，可以植入配置文件

3. 生命周期管理: 支持物理机自动化开机，关机，重装系统，远程带外管理，卸载操作系统等操作

4. 与虚拟机共享镜像: 使用虚拟机镜像部署物理机，便于虚拟机和物理机统一操作系统运行环境

5. API 支持: 以上操作均支持API操作，便于与其他系统的自动化流程集成

6. 服务器型号支持: 支持Dell、HP、华为、浪潮、联想、超微等主流x86服务器厂商和机型

7. RAID 控制器支持: LSI MegaRaid, HP Smart Array, LSI MPT2SAS, LSI MPT3SAS, Mrarvell RAID等

8. 转换为宿主机: 直接将物理机转换为运行虚拟机的宿主机

9. 托管已有服务器： 托管已有并装好系统的物理机

# 设计实现

## 服务架构

物理机管理服务架构如下:

![物理机管理架构](/images/baremetal/intro/baremetal.png)

- Baremetal <-> DHCP Relay： 处理 PXE 网络启动
- DHCP Relay <-> Baremetal Agent:
    - 转发 PXE Boot 请求，获取网络启动相关的信息
    - 通过 DHCP 和 TFTP 服务下发 PXE 配置
        - 云平台定制的[网络启动小系统(yunionos)](https://github.com/yunionio/yunionos) kernel 和 initramfs: 运行 SSH 服务，制作 RAID，收集硬件信息等
- Baremetal Agent <-> Region Server: 
    - 通过 Region Server 注册物理机记录
    - 获取网络 IP 地址
- Baremetal Agent <-> Baremetal:
    - Baremetal 通知 Agent SSH 相关的登录信息
    - Agent 通过 SSH 配置 Baremetal 的 IPMI
    - Agent 通过 IPMI 控制 Baremetal 开关机等操作
    - Agent 通过 SSH 执行做 RAID，装机，销毁等操作
- Glance Server -> Baremetal: Baremetal 从 Glance server 下载装机镜像

- 在交换机上开启 DHCP Relay 功能(或者使用 DHCP Relay软件)，relay 指向 Baremetal Agent
    - 物理机上架通电后，设置 PXE 网络启动，DHCP Relay 会将 PXE Boot 请求转发到 Baremetal Agent，Baremetal Agent 收到 PXE Boot 请求，向 Region Server 注册物理机记录

## 技术细节

### 注册物理机

注册物理机有自动注册和手动注册两种方式，如果 Baremetal Agent 开启了自动注册功能，就会自动在云平台创建 baremetal 记录；如果为手动注册方式，就需要先调用物理机创建接口把对应的 PXE 网卡对应的 MAC 地址注册到平台。

注册的流程如下:

1. 物理机 PXE 启动时会发送 DHCP PXE boot 的请求，通过 DHCP Relay 请求会到 Baremetal Agent;
2. Baremetal Agent 从 DHCP 请求中取出网卡 MAC 地址，拿 MAC 地址向 Region Server 过滤物理机记录;
3. Region Server 告诉 Baremetal Agent 改 MAC 地址没有物理机，Baremetal Agent 就会新建记录，并从 Region Server 获取分配对应网段的 IP 地址, 通过内置 DHCP 服务回包给物理机;
4. 物理机 PXE DHCP 请求获得分配的 IP 地址后，会通过 TFTP 从 Baremetal Agent 下载启动引导文件(kernel 和 initramfs)，然后使用 ramdisk 机制进入我们定制的 initramfs 小系统;
5. initramfs 小系统启动后，会启动 sshd 服务，然后修改 root 用户密码，将这些登录信息通知回 Baremetal Agent;
6. Baremetal Agent 收到通知后，记录 ssh 登录的信息，开始进行准备工作;
7. 准备工作包括配置 IPMI，收集硬件信息等，当这些操作完成后，将所有信息上报给 Region Server 完成注册

### yunionos 网络启动小系统

yunionos(https://github.com/yunionio/yunionos) 是我们使用 [Buildroot](https://buildroot.org/) 工具定制的用于 PXE 启动和管理物理机的小型 Linux 系统，作用如下:

1. 运行 sshd 服务，提供 Baremetal Agent 远程执行命令
2. 包含 LSI MegaRaid, HP Smart Array, LSI MPT2SAS, LSI MPT3SAS, Mrarvell RAID等驱动和工具，用于制作 RAID
3. 包含 ipmitool 和相关 driver，用于配置和调用 IPMI BMC 管理物理机
4. 包含 qemu-img, sgdisk, parted 等磁盘分区工具，用于创建操作系统

### SSH 管理

当物理机通过 PXE 进入 yunionos 小系统后会启动 sshd 服务，并将 ssh login 信息通知给 Baremetal Agent，Baremetal Agent 会更新 ssh 相关的登录信息

### RAID 配置

RAID 配置由 Baremetal Agent 根据用户的配置，生成 raid 配置命令，通过 ssh 远程控制 yunionos 在物理机上制作 RAID

### 安装操作系统

RAID 做完后，Baremetal Agent 会通过 ssh 远程控制 yunionos 安装操作系统和分区，流程如下:

1. 调用 [/lib/mos/rootcreate.sh](https://github.com/yunionio/yunionos/blob/master/src/lib/mos/rootcreate.sh) 将系统创建到磁盘:
  - 通过 wget 从 Glance Server 下载用户指定的 image 镜像
  - 通过 qemu-img convert 命名将 image 写入到磁盘

2. 创建好系统后，会根据用户的配置将系统盘 resize 分区
3. 创建其它分区并格式化
4. Baremetal Agent 进行一些网络，磁盘配置的设置：比如 bonding，ip 设置, /etc/fstab, 改变 hostname 等

### 开关机

注册好的的物理机会配置好 IPMI, IPMI 相关的信息会记录在数据库，Baremetal Agent 通过 ipmitool 控制开关机

### 重装操作系统

类似于安装操作系统，流程上会让安装了操作系统的物理机重新进入 yunionos 小系统，然后重新安装操作系统

### 远程访问

Baremetal Agent 通过 ipmitool sol 接口提供串口控制界面

### 删除操作系统

对正在运行操作系统的物理机重启进入 PXE 网络启动，进入 yunionos 小系统，调用 [/lib/mos/partdestory.sh](https://github.com/yunionio/yunionos/blob/master/src/lib/mos/partdestroy.sh) 销毁磁盘分区和相应的 raid 命令销毁 raid 配置

# 接口使用

## 物理机相关

### 查询物理机

```bash
# list baremetal 记录
climc host-list --baremetal true

# list 已经安装系统的物理机
climc host-list --baremetal true --occupied

# list 未安装系统的物理机
climc host-list --baremetal true --empty

# 查询物理机详情，包括硬件信息，机房信息
climc host-show <host_id>
```

### 注册物理机

```bash
climc host-create <host_id>
```

### 重新准备物理机

```bash
climc host-prepare <host_id>
```

### 获取物理机登录信息

```bash
climc host-logininfo <host_id>
```

### 获取串口登录控制台

```bash
climc webconsole-baremetal <host_id>
```

### 开/关机

```bash
climc host-start/host-stop <host_id>
```

### 进入/退出维护模式

```bash
climc host-maintenance/host-unmaintenance <host_id>
```

### 删除物理机

```bash
climc host-delete <host_id>
```

### 转换/回收宿主机

```bash
climc host-convert-hypervisor
climc host-undo-convert <host_id>
```

## 裸金属服务器相关

### 安装操作系统

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

### 查询裸金属服务器

```bash
climc server-list --hypervisor baremetal
climc server-show <server_id>
```

### 重装操作系统

```bash
climc server-rebuild --image <image_id> <server_id>
```

### 开/关机

```bash
climc server-start <server_id>
climc server-stop <server_id>
```

### 删除裸金属服务器

删除 server 裸金属服务器会销毁物理机上的操作系统和 raid 配置，对应的 baremetal 重新进入未分配状态

```bash
climc server-delete <server_id>
```
