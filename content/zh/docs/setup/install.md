---
title: "ISO安装"
edition: ee
weight: 3
description: >
    介绍var_oem_name产品的安装方法。
---

{{<oem_name>}} 采用基于 Kubernetes Operator技术部署运行在Kubernetes上，平台服务将支持容器化方式部署运行在Kubernetes集群中，天生具备了高可用，可弹性扩展的能力。 

## 安装准备

### 获取安装包

请在产品官网的下载中心或联系销售人员获取{{<oem_name>}}产品的DVD安装包。

{{% alert title="说明" %}}

安装包下载完成后建议使用md5工具核对MD5值，确保安装包的完整性。

{{% /alert %}}

### 配置要求

请按需准备部署环境，详细请参考[配置要求](../config)

### 安装组件介绍

- Kubernetes集群由Master(Controlplane)节点和Node节点组成。其中一套Kubernetes集群上Controlplane节点的数量必须为1，3，5个，否则可能会有问题；Node节点数量任意。
- 产品主要由Controller（控制节点）和Host（计算节点）组成。

两者关系如下图所示，一台服务器在Kubernetes集群中属于Controlplane节点或Node节点之一，在{{<oem_name>}}集群上既可以作为Controller也可以作为Host节点。服务器在Kubernetes集群和{{<oem_name>}}集群上的角色可以任意搭配组合。

![](../images/k8sonecloud1.png)

### 最简组网举例

根据上面的组件介绍，可以使用两台服务器搭建最简单的{{<oem_name>}}环境。

![](../images/k8s-network1.png)

- 服务器说明：
    - 控制节点（First Node）作为Kubernetes集群的Controlplane节点，{{<oem_name>}}集群的Controller节点和Host节点；
    - 计算节点(Not First Node)作为Kubernetes集群的Node节点，{{<oem_name>}}集群的Host节点。
- 3.0版本支持离线安装，安装过程可以不访问互联网。但是后面部署过程从镜像市场导入镜像需要访问互联网。

## 安装过程

### 安装方式介绍

根据用户服务器是否安装CentOS 7.x操作系统，使用DVD安装包安装{{<oem_name>}}的方式有以下两种，推荐使用第一种。两种仅执行脚本的方式不同，安装配置内容相同。

- [DVD安装](#dvd安装)：当用户使用未安装操作系统的服务器时，可以直接挂载下载的DVD安装包，安装CentOS以及{{<oem_name>}}。
- [脚本安装](#脚本安装)：用户使用已安装CentOS 7.x操作系统的服务器，挂载安装包后可使用里面的install脚本安装{{<oem_name>}}。

#### DVD安装

DVD安装方式会先在服务器上安装CentOS操作系统，安装完成后将会自动执行{{<oem_name>}}安装脚本。

1. 在服务器上挂载DVD安装包，并启动服务器。
    - 若需要在物理机上安装，需要将在官网下载的DVD格式的ISO安装包刻录为DVD光盘或U盘启动镜像。
      - 若刻录为DVD光盘，请将物理服务器上将BIOS中的boot方式设置为CD-ROM对应的介质。
      - 若制作U盘启动镜像，请将物理服务器上将BIOS中的boot方式设置为USB设备对应的介质。
    - 若在虚拟机上安装，可以直接将DVD格式的ISO安装包挂载到虚拟机的虚拟光驱上，设置虚拟机的启动方式为光驱即可。
2. CentOS系统安装过程中支持配置以下参数，也可保持默认值，直接开始安装CentOS系统。
    - LANGUAGE（必选）：选择CentOS 7操作系统语言，默认English即可，单击\ **_"Continue"_** 按钮。

        ![](../images/centos-language.png)

    - KEYBOARD（必选）：选择键盘布局。设置完成后，请检查当前网络配置是否可以联通网络，确保没问题后，直接单击\ **_"Begin Installation"_** 按钮，开始安装CentOS系统。

        ![](../images/centos-keyboard.png)

    - INSTALLATION DESTIONATION（可选）：设置磁盘分区，如无特殊需求，建议保持默认。也可根据需求划分磁盘分区等。

        ![](../images/centos-disk.png)

    - NETWORK&HOST NAME（必选）：请根据需求配置网络确保网络配置能使服务器网络联通，并修改默认主机名。

        ![](../images/centos-network.png) 

3. CentOS系统安装过程中，需要设置root用户密码或新建用户。推荐设置root用户密码。

    ![](../images/centossetroot.png)

4. 等待操作系统安装完成后，自动运行安装脚本，进入安装配置页面。请按照[安装配置](#安装配置)内容进行配置。

    ![](../images/k8s-config1.png)

#### 脚本安装

当在已安装CentOS的服务器上执行脚本安装产品，需要确保服务器已已关闭selinux，且重启过服务器。若selinux未关闭，请按下面的步骤关闭selinux，并重启服务器。

```
# 关闭 selinux
$ setenforce  0
$ sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
```

在CentOS 7.x服务器上执行脚本方式如下：

1. 以root用户远程连接CentOS服务器，将DVD安装包上传到服务器。
{{% alert title="说明" %}}
支持在服务器上使用wget命令下载DVD安装包，使用wget命令通过官网下载链接获取的安装包名称与直接下载获取的安装包名称可能不一致。但是解压缩后文件内容相同。如使用wget命令下载DVD安装包，请在mount安装包时，以实际下载的安装包名称为准。
{{% /alert %}}
2. 上传完成后，将安装包以硬盘分区的形式挂载到mnt目录上，进入mnt/yunion目录，并执行目录下的./install.sh脚本文件，进入安装配置页面。请按照[安装配置](#安装配置)内容进行配置。
    ```bash
    # 请以从官网下载的安装包名称为准
    $ mount -o loop Yunion-x86_64-DVD-3.0.0-20200108.0.iso /mnt  
    $ cd /mnt/yunion
    $ ./install.sh
    ```

    ![](../images/k8s-config1.png)

### 安装配置

配置内容根据服务器是否为First Node以及安装的组件不同略有不同。

配置页面常用操作说明：

  - enter键：enter键用于确认选择按钮。
  - 空格键：选中子菜单后也可按空格键进入子菜单配置页面；空格键还可以选中或取消选择具体配置项。
  - 上下方向键：用于切换上下菜单和配置项。
  - Tab键或左右方向键：用于切换底侧“Select”、“OK”和“Help”按钮，按enter键确认选择。

#### 部署控制节点

1. 在安装配置页面，如果服务器有多块网卡，需要选择作为管理网的网卡。

    ![](../images/k8s-selectnetwork1.png)

2. 保持默认勾选“First Node”和“Enable Host Agent”不变，如数据库没有其它要求，也可以保持默认勾选。

3. 保持默认不勾选“High Availability”，以及选择是否勾选“Enable MINIO as backend storage engine”，如勾选该项，则将部署MINIO。
4. 如果使用已有数据库，需要通过上下方向键将光标移动到“Install MySQL on Current host”，按空格键取消勾选该项后，并配置Connect MySql的信息。
{{% alert title="说明" %}}
3.4.12版本之后才支持使用非root用户连接MySQL数据库。
{{% /alert %}}
    - MySQL Host IP：MySQL服务器的IP地址；
    - MySQL Port Number：MySQL服务器的端口号。
    - MySQL Username：连接MySQL服务器的用户名，推荐使用root用户，如果使用其他用户，还需要为用户授权。
    ```bash
GRANT ALL PRIVILEGES ON * . * TO '<USERNAME>'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON * . * TO '<USERNAME>'@'localhost' WITH GRANT OPTION;
    ```
    - MySQL Password：连接MySQL服务器的用户密码。
    ![](../images/k8s-connectmysql1.png)
    ![](../images/k8s-configmysql1.png)
5. 本例选择将数据库安装在当前主机上，在安装配置页面将光标选中”OK“按钮，按enter键，在弹出的保存配置对话框中光标选中"Yes"，并按enter键确认选择，开始安装。
    ![](../images/k8s-confirm.png)
6. 安装过程较长，请耐心等待，直到安装完成。
{{% alert title="说明" %}}
- 当服务器当前内核（`uname -r`用于查看内核版本）与产品要求“3.10.0-1062.4.3.el7.yn20191203.x86_64”不一致时，产品安装完成后将会自动重启。
- 当服务器当前内核（`uname -r`用于查看内核版本）与产品要求“3.10.0-1062.4.3.el7.yn20191203.x86_64”一致时，则产品安装完成后不会自动重启。
{{% /alert %}}
    ![](../images/k8s-completed.png)

7. 在服务器中执行`source ~/.bashrc`命令加载kubernetes的环境变量，加载完成后，用户可通过kubectl相关命令管理{{<oem_name>}}的系统组件等。

    ```bash
    # 查看K8s节点
    $ kubectl get node
    # 查看组件pod的运行状态,runing表示正常运行
    $ kubectl get pod --namespace onecloud 
    ```

8.  在浏览器中输入[https://服务器IP地址](https://服务器IP地址)，即可打开{{<oem_name>}}平台,进行[初始化引导操作](../deploy/)。

#### 部署计算节点

本次部署在非First Node服务器上部署K8s node服务以及host服务。

1. 在安装配置页面，按空格键取消勾选“First Node”，Role of K8S默认为“K8s Node”；roles默认为“Enable Host Agent”。可根据需求更改角色，本例不修改，直接保持默认。

    ![](../images/k8s-notfirstnodeconfig.png)

2. 配置First Node IP为上一章节配置的First Node的服务器IP地址。

    ![](../images/k8s-firstnodeip1.png)

3. 配置Join Token为在控制节点上获取的Token值。

    ![](../images/k8s-jointoken1.png)
    
{{% alert title="说明" %}}

**Join Token获取方式如下：**

在控制节点上输入`ocadm token create`命令获取Token。
**注意**在刚部署成功的控制节点无法直接使用ocadm命令，需要重新登录服务器或者不断开连接直接执行`source ~/.bashrc`命令加载kubernetes的环境变量。

如下图所示，控制节点部署成功后，先断开并重连服务器。红圈中内容即为Token值

![](../images/k8s-token1.png)
{{% /alert %}}

4. 配置完成后将光标选中”OK“按钮，按enter键，在弹出的保存配置对话框中光标选中"Yes"，并按enter键确认选择，开始安装。

    ![](../images/k8s-confirm.png)

5. 安装过程较长，请耐心等待，直到安装完成。
6. 安装过程中主要进行以下配置：
```
# 一些必要的环境检测 
yun::init::step yun::checks::all 
# 初始化环境变量 
yun::init::step yun::initlocale yun::init::step yun::init::bins 
# 权限设置
yun::init::step yun::privileges::requires_sudo_nopasswd 
# 禁用防火墙
yun::init::step yun::system::require_firewalld_disabled 
# 禁用 selinux
yun::init::step yun::system::require_selinux_disabled 
# 禁用 tty 
yun::init::step yun::ist::disabletty 
# 解析传入的变量
yun::init::step yun::tui::initVarLoop 
# 解压光盘文件里的压缩包
yun::init::step yun::ist::unpack 
# 拷贝安装包到硬盘
yun::init::step yun::tui::cpiso 
# 建立本地的 rpm 仓库 
yun::init::step yun::ist::init::repo 
# 初始化安装流程
yun::init::step yun::init::pre  
# 执行 ansible 的安装脚本部署k8s集群以及OneCloud相关组件等
 yun::init::step yun::ist::install 
# 重启逻辑 
yun::init::step yun::tui::reboot
```

{{% alert title="说明" %}}
- 当服务器当前内核（`uname -r`用于查看内核版本）与产品要求“3.10.0-1062.4.3.el7.yn20191203.x86_64”不一致时，产品安装完成后将会自动重启。
- 当服务器当前内核（`uname -r`用于查看内核版本）与产品要求“3.10.0-1062.4.3.el7.yn20191203.x86_64”一致时，则产品安装完成后不会自动重启。
{{% /alert %}}
    ![](../images/k8s-reboot.png)

1. 以root用户ssh远程登录服务器,至此host节点部署完成。

2. 用户部署完成后，可在{{<oem_name>}}平台宿主机页面中查看到host节点。宿主机注册到云管平台上后默认为禁用状态，需要在界面上启用宿主机，启用状态的宿主机可以用于创建虚拟机。

## 启用Baremetal服务

{{<oem_name>}}平台安装完成后默认禁用Baremetal服务。Baremetal服务提供PXE Server、DHCP、TFTP、http等功能，用于完成纳管物理机操作并管理物理机。

用户可以按照下面命令在{{<oem_name>}}环境中的任意节点上启用Baremetal服务。

1. 通过SSH等以root用户登录到First Node节点。
2. 执行以下命令。其中$node_name是节点的名称；$listen-interface是baremetal-agent监听的网卡名称。
{{% alert title="注意" color="warning" %}}
如果需要启用Baremetal服务的节点安装了host服务，监听网卡请设置为br0，其余情况监听网卡为节点的实际网卡名称。
{{% /alert %}}
    
    ```bash
    # 在指定节点上启用Baremetal服务并监听网卡
    $ ocadm baremetal enable --node $node_name --listen-interface $listen_interface
    # 禁用Baremetal服务
    $ ocadm baremetal disable --node $node_name
    # 如在node1主机上启用baremetal服务，并监听br0网卡。
    $ ocadm baremetal enable --node node1 --listen-interface br0
    ```

3. Baremetal服务启用后，可通过以下命令查看baremetal-agent是否注册到控制节点上。

    ```bash
    $ kubectl get pods --namespace onecloud | grep baremetal
    default-baremetal-agent-fb5d4b5f7-2ld8v          1/1     Running     0          15m
    ```

4. 纳管物理机的预注册以及pxe引导注册方式需要配合DHCP Relay使用，即Baremetal-agent只会处理DHCP Relay服务器的请求，所以还需要用户事先在交换机配置DHCP Relay或者使用Host服务的DHCP Relay功能。
    
    ```bash
    # 登录到所有已经部署好计算节点的服务器上修改 /etc/yunion/host.conf，添加 dhcp_relay 配置项：
    dhcp_relay:
    - 10.168.222.198 # baremetal agent dhcp服务监听地址
    - 67             # baremetal agent dhcp服务监听端口

    # 查看host服务对应pod
    $ kubectl get pods -n onecloud -o wide | grep host
    default-host-p6d8h                       2/2     Running   0          78m    10.168.222.189   k8s-dev1   <none>           <none>
    default-host-xdc7x                       2/2     Running   0          78m    10.168.222.150   k8s-dev2   <none>           <none>
    # 删除host服务pod，重启host服务
    $ kubectl delete pods -n onecloud default-host-p6d8h default-host-xdc7x
    ```
