---
title: "制作镜像"
date: 2019-07-19T11:12:40+08:00
weight: 10
description: >
  介绍如何制作镜像
---

你可能需要自己定制发行版的镜像，用于给不同的业务使用。本文介绍如何制作镜像。

可以通过下载发行版操作系统的 iso , 然后本地启动虚拟机，将 iso 安装到虚拟机的磁盘，然后保存该磁盘，这个磁盘就可以作为镜像上传到 glance，但是这种方法人工参与的步骤太多，容易出错。

推荐使用 [packer](https://www.packer.io/intro/getting-started/install.html) 这个工具来自动化制作镜像，详细操作可以参考对应的文档 https://www.packer.io/docs/index.html 。


https://github.com/yunionio/service-images 仓库包含了一些我们使用 packer 制作镜像的配置，可以参考使用。

## 镜像制作流程

1. 提前准备好标准ISO镜像，支持用户从镜像市场-ISO界面导入或直接上传ISO镜像。
2. 在虚拟机列表中新建虚拟机，选择“从ISO启动”并选择对应的ISO镜像，创建成功后，并通过VNC终端进行按照界面提示安装操作系统。

{{% alert title="说明" %}}
- 推荐使用CentOS Minimal操作系统。
- Ubuntu/Debian镜像在安装过程中建议选择“No automatic updates”并安装OpenSSH Server软件。
{{% /alert %}}
    
3. 根据镜像的操作系统类型进行不同的优化配置。
    - CentOS镜像：请参考[CentOS镜像优化](#centos镜像优化)章节。
    - Ubuntu/Debian镜像：请参考[Ubuntu/Debian镜像优化](#ubuntu-debian镜像优化)章节。
    - Windows镜像：请参考[Windows镜像优化](#windows镜像优化)章节。
4. (可选)多平台通用镜像配置，如制作的镜像需要在公有云平台上使用，除上述优化配置外，还需要在[Linux系统安装配置cloud-init](#linux系统安装配置cloud-init)，[Windows系统安装配置Cloudbase-init](#windows系统安装配置cloudbase-init)。
4. 镜像优化完成后，需要将虚拟机关机。
5. 单击关机状态的虚拟机右侧操作列 **_"更多"_** 按钮，选择下拉菜单 **_"保存镜像"_** 菜单项，将虚拟机保存为系统镜像。
6. 镜像保存完成后，用户可在虚拟机列表中新建虚拟机，选择“自定义镜像”并选择上一步骤保存的镜像，使用制作好的镜像创建虚拟机，验证镜像是否制作成功。


### CentOS镜像优化

以CentOS 7 minimal镜像为例介绍镜像优化方法。

1. CentOS 7 Minimal操作系统安装完成后的虚拟机默认不能联网，需要修改/etc/sysconfig/network-scripts/ifcfg-eth0文件，将"ONBOOT=no"改为"ONBOOT=yes"。

    ```bash
    # 请根据实际网卡名称修改对应的配置文件
    $ vi /etc/sysconfig/network-scripts/ifcfg-eth0    # 请根据实际网卡名称修改对应的配置文件
    # 修改配置文件内容
    ONBOOT=yes


    # CentOS 8 和 CentOS 9 重启网卡: systemctl restart NetworkManager.service
    ```

2. 禁用selinux，修改/etc/selinux/config文件，将"SELINUX=enforcing"改为"SELINUX=disabled"。修改完成后，重启系统生效。

    ```bash
    $ vi /etc/selinux/config
    # 修改配置文件内容，修改完成后保存。
    SELINUX=disabled

    # 重启使配置生效
    $ reboot
    ```  

3. 将必要的kernel module加入启动initram.img。（centos8的内核已经安装了virtio所以需要在列表删除）
    ```bash
    $ vi /etc/dracut.conf
    # 修改配置文件，去掉add_drivers+前面#注释，并在引号中添加如下内容，修改完成后保存。
    # 以下为 x86 需要添加的内核驱动
    add_drivers+=" hpsa mptsas mpt2sas mpt3sas megaraid_sas mptspi virtio virtio_ring virtio_pci virtio_scsi virtio_blk vmw_pvscsi "
    # 以下为 arm 需要添加的内核驱动
    add_drivers+=" mptsas mpt2sas mpt3sas megaraid_sas mptspi virtio virtio_ring virtio_pci virtio_scsi virtio_blk "

    # 使配置生效
    $ dracut -f
    ```

4. 关闭网卡持久化功能，保证CentOS 7中网卡名称为“eth0，eth1”形式。修改/etc/default/grub文件，在GRUB_CMDLINE_LINUX中添加"net.ifnames=0 biosdevname=0"参数。（centos8，centos9略过）

    ```bash
    $ vi /etc/default/grub
    # 修改配置文件，修改完成后保存。
    GRUB_CMDLINE_LINUX="crashkernel=auto rd.lvm.lv=centos/root rd.lvm.lv=centos/swap rhgb quiet net.ifnames=0 biosdevname=0"
    # 使配置生效
    $ grub2-mkconfig -o /boot/grub2/grub.cfg
    ```

5. 根据需求安装常用软件。

    ```bash
    # 仅为举例，请根据实际需求安装常用软件。
    $ yum install net-tools git wget vim pcre-tools ntp epel-release -y
    ```

6. 禁用firewalld和NetworkManager服务。

    ```bash
    $ systemctl disable firewalld NetworkManager
    ```

7. 启用时间网络同步，支持使用ntp或chrony保持时间同步。

    ```bash
    # 安装ntp或chrony软件
    $ yum install ntp/chrony -y
    # 启用ntp或chronyd服务
    $ systemctl enable ntpd/chronyd
    ```

8. 修改时区为CST。

    ```bash
    $ timedatectl set-timezone Asia/Shanghai
    # 查看当前时区
    $ timedatectl status
    ```

9. ssh服务优化，修改/etc/ssh/sshd_config文件，将PermitRootLogin属性修改为yes 将UseDNS属性修改为no。

    ```bash
    $ vi /etc/ssh/sshd_config

    #分别找到PermitRootLogin属性和UseDNS属性
    PermitRootLogin yes
    UseDNS no
    ```
    systemctl restart  sshd

### Ubuntu/Debian镜像优化

以ubuntu-16.04.6-server-amd64.iso为例，介绍Ubuntu和Debian镜像的优化方法。Ubuntu系统安装完成后，默认使用普通权限用户。

1. ssh服务优化，修改/etc/ssh/sshd_config文件，将PermitRootLogin属性修改为yes 将UseDNS属性修改为no，若没有上述属性，请添加属性。

    ```bash
    $ sudo vi /etc/ssh/sshd_config
    # 分别找到PermitRootLogin属性和UseDNS属性
    PermitRootLogin yes
    UseDNS no
    ```

2. 在/etc/init.d/目录下创建一个名称为ssh-initkey的自启动脚本。

    ```bash
    $ sudo touch /etc/init.d/ssh-initkey
    $ sudo vi /etc/init.d/ssh-initkey
    # 脚本内容如下：
    #! /bin/sh
    ### BEGIN INIT INFO
    # Provides:          ssh-initkey
    # Required-Start:
    # Required-Stop:
    # X-Start-Before:    ssh
    # Default-Start:     2 3 4 5
    # Default-Stop:
    # Short-Description: Init ssh host keys
    ### END INIT INFO

    PATH=/sbin:/usr/sbin:/bin:/usr/bin
    . /lib/init/vars.sh
    . /lib/lsb/init-functions
    do_start() {
        ls /etc/ssh/ssh_host_* > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            dpkg-reconfigure openssh-server
        fi
    }
    case "$1" in
        start)
        do_start
            ;;
        restart|reload|force-reload)
            echo "Error: argument '$1' not supported" >&2
            exit 3
            ;;
        stop)
            ;;
        *)
            echo "Usage: $0 start|stop" >&2
            exit 3
            ;;
    esac
    ```

3. ssh-initkey脚本配置完成后，还需要增加可执行权限，并将脚本添加到系统启动脚本目录。

    ```bash
    $ sudo chmod +x /etc/init.d/ssh-initkey
    ```

    Ubuntu 20.04之前版本，请执行以下脚本启用脚本：

    ```bash
    $ sudo /usr/sbin/update-rc.d ssh-initkey defaults
    $ sudo /usr/sbin/update-rc.d ssh-initkey enable
    ```

    Ubuntu 20.04版本以及之后版本，请执行以下脚本启用脚本：

    ```bash
    $ sudo /lib/systemd/systemd-sysv-install enable ssh-initkey
    ```

4. （Ubuntu 16.04以上版本设置）关闭网卡持久化功能，保证网卡名称为“eth0，eth1”形式。修改/etc/default/grub文件，在GRUB_CMDLINE_LINUX中添加"net.ifnames=0 biosdevname=0"参数。

    ```bash
    $ sudo vi /etc/default/grub
    # 配置GRUB_CMDLINE_LINUX参数
    GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"
    ```

    ```bash
    # 使配置生效
    $ sudo /usr/sbin/update-grub
    ```

5. (若Ubuntu未关闭自动更新)关闭自动更新需要修改/etc/apt/apt.conf.d/10periodic文件，将文件中的"Update-Package-Lists"参数设置为0。

    ```bash
    $ sudo vi /etc/apt/apt.conf.d/10periodic
    # 配置修改
    APT::Periodic::Update-Package-Lists "0";
    ```

6. 至此，虚拟机优化完成。


### Windows镜像优化

#### 安装Virtio驱动

| 操作系统版本  | Virtio驱动中对应名称|
|----------|----------------|
| Windows XP | xp |
| Windows 7 | w7 |
| Windows 8 | w8 |
| Windows 8.1 | w8.1 |
| Windows 10 | w10 |
| Windows Server 2003 | 2k3 |
| Windows Server 2008 | 2K8 |
| Windows Server 2008 R2 | 2k8R2 |
| Windows Server 2012 | 2k12 |
| Windows Server 2012 R2 | 2k12R2 |
| Windows Server 2016 | 2k16 |

1. 上传Virtio驱动ISO并挂载到虚拟机上。Virtio驱动可以从以下URL下载：

    ```bash
    https://github.com/virtio-win/virtio-win-pkg-scripts/blob/master/README.md
    ```

如果使用的是企业版，则可以直接从镜像市场的ISO页面导入Virtio驱动。

需要注意的是，如果是Windows Server 2008及以前版本的Windows，推荐使用版本[0.1.135](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.135-2/virtio-win-0.1.135.iso) 的virtio驱动。

2. 在虚拟机中打开挂载的驱动文件夹，根据虚拟机的操作系统版本（如本例为Windows server 2016），在驱动文件夹页面的搜索框中搜索“2k16”，并将所有包含2k16的文件夹复制到虚拟机的其他文件夹中（如文档文件夹）。

   ![](../images/image/search2k16.png)
   
3. 在文档文件夹中打开“2k16>amd64”文件夹，该文件夹中包含所有Windows Server 2016中的驱动文件。在该文件夹的地址显示框中输入cmd或同时按“shift”键和鼠标右键，在此处打开命令窗口，打开命令提示符对话框。
4. 使用以下命令安装全部驱动。

    ```bash
    pnputil -i -a *.inf
    ```

#### 禁用快速启动

（可选）若是Windows 10操作系统的虚拟机需要禁用快速启动。请参考[禁用方法](https://jingyan.baidu.com/article/ca00d56c7a40e6e99febcf4f.html)。

#### 系统激活

请通过正规渠道激活Windows系统。

#### sysprep封装

运行sysprep，消除个性化信息。

1. 打开%WINDIR%/system32/sysprep目录，并在目录下创建unattend.xml文件，内容如下：

```xml
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <settings pass="generalize">
        <component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <SkipRearm>0</SkipRearm>
        </component>
        <component name="Microsoft-Windows-PnpSysprep" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <PersistAllDeviceInstalls>true</PersistAllDeviceInstalls>
            <DoNotCleanUpNonPresentDevices>true</DoNotCleanUpNonPresentDevices>
        </component>
    </settings>
    <settings pass="oobeSystem">
        <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
            <AutoLogon>
                <Password>
                    <Value>123@yunion</Value>
                    <PlainText>true</PlainText> 
                </Password>
                <Username>Administrator</Username> 
                <Enabled>true</Enabled> 
                <LogonCount>5</LogonCount> 
            </AutoLogon>
            <UserAccounts>
                <AdministratorPassword>
                    <Value>123@yunion</Value>
                    <PlainText>true</PlainText>
                </AdministratorPassword>
            </UserAccounts>
            <Display>
                <ColorDepth>32</ColorDepth>
                <HorizontalResolution>1024</HorizontalResolution>
                <RefreshRate>60</RefreshRate>
                <VerticalResolution>768</VerticalResolution>
            </Display>
            <OOBE>
                <HideEULAPage>true</HideEULAPage>
                 <NetworkLocation>Work</NetworkLocation>
                <ProtectYourPC>1</ProtectYourPC>
                <SkipMachineOOBE>true</SkipMachineOOBE>
                <SkipUserOOBE>true</SkipUserOOBE>
            </OOBE>
        </component>
    </settings>
</unattend>
```

{{% alert title="说明" %}}
由于Windows系统只支持VNC连接，无法直接将内容拷贝到虚拟机，可通过发送文字功能，在虚拟机输入法处于英文模式的时候，发送上述内容。
{{% /alert %}}

2. 在该目录的地址显示框中输入cmd或同时按“shift”键和鼠标右键，在此处打开命令窗口，打开命令提示符对话框。输入以下命令，执行sysprep封装并关闭虚拟机。

```bash
> sysprep /generalize /oobe /shutdown /unattend:unattend.xml
```

*注意*：Windows 10 1803版本之后，存在sysprep失败的情况。一般来说，失败原因主要是如果系统安装了来自Windows store的软件，sysprep卸载来自Windows store的软件时报错。需要逐个手工卸载导致报错的软件包。每个软件包卸载的方法为：

1) 每次sysprep报错后，可以查看报错日志：C:\Windows\System32\Sysprep\Panther\setupact.log 。日志有类似如下的报错信息：

```bash
2018-06-21 13:35:59, Error SYSPRP Package Microsoft.LanguageExperiencePackhu-hu_17134.2.4.0_neutral__8wekyb3d8bbwe was installed for a user, but not provisioned for all users. This package will not function properly in the sysprep image.
```

其中，Package后即为卸载失败的package名称，采用如下命令手工卸载该package：

2) 手工卸载指定的package，其中<packagefullname>替换为第一步找到的package名称。

```bash
remove-appxpackage -allusers -package '<packagefullname>'
```

如此反复尝试执行sysprep，如果失败则执行以上1)和2)步骤删除package，直到sysprep执行成功。

如果卸载软件后还无法执行sysprep，则请尝试修改unattend.xml，将 "PersistAllDeviceInstalls" 改为 "false"。


3. 至此虚拟机优化完成。

### Linux系统安装配置Cloud-init（可选）

Cloud-init用于为Linux操作系统的虚拟机做系统初始化配置。详细介绍内容请参考[cloud-init官网](https://cloudinit.readthedocs.io/en/latest/?spm=a2c4g.11186623.2.16.2aec3fcaVGJZo7)。

#### 安装cloud-init

在Linux操作系统中使用软件源上的cloud-init包安装cloud-init，命令如下：

{{< tabs name="cloudinit" >}}
{{% tab name="CentOS 7" %}}
```bash
$ yum install cloud-init
```
{{% /tab %}}

{{% tab name="Ubuntu/Debian 10" %}}
```bash
$ apt install cloud-init
```
{{% /tab %}}

{{< /tabs >}}

Linux操作系统安装Cloud-init更多请参考[腾讯云文档中心-Linux系统安装cloud-init](https://cloud.tencent.com/document/product/213/12587)或[阿里云文档中心-安装cloud-init](https://help.aliyun.com/document_detail/57803.html?spm=5176.10695662.1996646101.searchclickresult.9b2c5db8X8v4Tq&aly_as=gOLD2vtr)等。

#### 配置cloud-init

修改/etc/cloud/cloud.cfg文件，将disabled_root设置为0，ssh_pwauth设置为1。

```bash
$ vi /etc/cloud/cloud.cfg
# 修改配置文件，修改完成后保存。
disable_root: 0
ssh_pwauth:   1
```

### Windows系统安装配置Cloudbase-init（可选）

请参考[腾讯云文档中心-Windows操作系统安装Cloudbase-Init](https://cloud.tencent.com/document/product/213/30000)。

