---
title: "高可用部署"
edition: ee
weight: 3
description: >
    介绍如何搭建var_oem_name高可用环境。
---

## 高可用部署方案介绍

{{<oem_name>}}平台高可用至少需要3个及3个以上的节点组成高可用环境；高可用环境将会自动部署MINIO作为共享存储，MINIO默认挂载在其中一个节点，当该节点宕机后，将会自动挂载到其他的节点上。

### 3节点版

使用3个节点部署高可用环境时，需要在2个节点上部署数据库高可用以及{{<oem_name>}}平台高可用，

该方案只能保证部署高可用的2个节点中的其中一个宕机而不影响平台的使用。

#### 组网图

![](../images/3node.png)

#### 部署步骤

- 准备2个VIP，其中1个用于数据库，另1个用于平台。
- 分别在节点1、节点2上部署数据库高可用，步骤可参考[部署DB HA环境](./db-ha)。
- 在节点1、节点2上安装k8s Controlplane+Controller，并设置HA高可用，其中HA VIP设置为平台VIP；数据库IP为数据库VIP。
- 在节点3上安装k8s Controlplane+Controller，但不启用HA高可用。

{{% alert title="注意" color="warning" %}}
默认数据库高可用的Keepalived服务监听网卡为节点本身的网卡（如eth0），但是若部署数据库的节点上安装了Host服务，此时需监听网卡br0，请修改数据库高可用Keepalived的配置文件，将监听网络修改为br0。
{{% /alert %}}

### 4节点版

使用4个节点部署高可用时，可以使用3个节点部署{{<oem_name>}}平台高可用，另1个节点部署数据库。

该方案可以保证部署高可用的3个节点任意节点宕机，而不影响平台的正常使用。但是如果数据库节点宕机，则平台也不可用。

#### 组网图

![](../images/4node.png)

#### 部署步骤

- 准备1个VIP，作为平台的VIP。
- 首先在1个节点上单独安装数据库。步骤可参考[安装部署Mariadb数据库](#安装部署mariadb数据库)。
- 在另外3个节点上安装k8s Controlplane+Controller，并设置HA高可用，其中HA VIP设置为平台VIP；数据库IP为数据库节点的IP地址。

### 5节点版

使用5个节点部署高可用时，可以使用3个节点部署{{<oem_name>}}平台高可用，另外2个节点部署数据库。

该方案可以保证部署{{<oem_name>}}平台高可用的3个节点，任意一个节点可以宕机，以及部署数据库的两个节点中的任意一个节点宕机。该方案的可靠性最强。

#### 组网图

![](../images/5node.png)

#### 部署步骤

- 准备2个VIP，其中1个用于数据库，另1个用于平台。
- 分别在数据库节点1、数据库节点2上部署数据库高可用，步骤可参考[部署DB HA环境](./db-ha)。
- 在另外三台节点上安装k8s Controlplane+Controller，并设置HA高可用，其中HA VIP设置为平台VIP；数据库IP为数据库VIP。

## 典型配置举例

下面以4节点的方案介绍下如何在平台部署高可用环境。

### 组网图

![](../images/4node.png)

### 组网说明

- 三台节点都部署K8S Controlplane以及Controller&host组成Kubernetes高可用集群和{{<oem_name>}}高可用集群。
- 数据库节点单独部署，步骤可参考[安装部署Mariadb数据库](#安装部署mariadb数据库)。
- 所有节点可以访问外网，如节点不能访问外网，请联系技术人员获取帮助。

**测试节点举例**



角色 | IP地址 | 说明
---------|----------|---------
 VIP | 10.127.190.100 | 与节点处于同一网段的闲置IP，供外部访问
 节点1-控制节点| 10.127.190.251 | First Node节点，K8S Controlplane节点个数满足1、3、5即可
 节点2-控制节点 | 10.127.190.245 | 非First Node节点（K8s Controlplane+Onecloud Controller&host）
 节点3-控制节点 | 10.127.190.229 | 非First Node节点（K8s Controlplane+Onecloud Controller&host）
 数据库 | 10.127.190.254 | 数据库节点
 节点4-计算节点| …… | 计算节点 (K8s Node + OneCloud Host)

{{% alert title="注意" color="warning" %}}
如果使用{{<oem_name>}}平台上的虚拟机搭建{{<oem_name>}}高可用环境，需要注意以下内容：

- 在{{<oem_name>}}上的虚拟机默认启用源/目标检查，所以VIP无法与其它节点连通，可以在web控制台关闭虚拟机的源/目标检查，或在First Node节点上通过climc命令关闭源/目标检查：

    ```bash
    $ climc server-modify-src-check --src-mac-check off 。
    ```

- 请将VIP添加到预留IP中。
{{% /alert %}}

## 安装部署Mariadb数据库

### 安装启用Mariadb

```bash
$ MYSQL_PASSWD='your-sql-passwd'
# 安装 mariadb
$ yum install -y epel-release mariadb-server
$ systemctl enable --now mariadb
```

### 配置Mariadb

```bash
# 设置数据库root用户密码
$ mysqladmin -u root password "$MYSQL_PASSWD"
$ cat <<EOF >/etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mariadb according to the
# instructions in http://fedoraproject.org/wiki/Systemd
# skip domain name resolve
skip_name_resolve    #取消域名解析
# auto delete binlog older than 30 days
expire_logs_days=30    #设置binlog的超时时间为30天，超过30天的binglog自动删除
innodb_file_per_table=ON
max_connections = 300

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d
EOF
```

```bash
# 开启 Mariadb 的远程访问
$ mysql -uroot -p$MYSQL_PASSWD \
  -e "GRANT ALL ON *.* to 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWD' with grant option; FLUSH PRIVILEGES;"
```

### 重启服务

```bash
$ systemctl restart mariadb
```

## 控制节点部署

3.4版本后，控制节点的高可用部署仅需要在First Node节点上配置即可。

当在已安装CentOS的服务器上安装产品，需要确保服务器已已关闭selinux，且重启过服务器。若selinux未关闭，请按下面的步骤关闭selinux，并重启服务器。

```
# 关闭 selinux
$ setenforce  0
$ sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
```

### 配置ssh免密登录

该步骤用于配置First Node节点免密登录其他控制节点。

```bash
# 生成First Node节点的ssh 秘钥 (如果已有 ~/.ssh/id_rsa.pub 则跳过此步骤)
$ ssh-keygen

# 将生成的 ~/.ssh/id_rsa.pub公钥拷贝到其他控制节点
$ ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.127.190.245
$ ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.127.190.229

# 验证在First Node节点上可以免密获取到其他控制节点的主机名
$ ssh root@10.127.190.245 "hostname"
$ ssh root@10.127.190.229 "hostname"
```

### 安装部署

该章节重点介绍First Node节点执行install脚本后的配置内容，前面挂载安装包以及执行脚本的过程可参考[安装-安装方式介绍](../install/#安装方式介绍)。

1. 在配置页面，勾选“High Availability”。

    ![](../images/haenabled1.png)

2. 在High Availability Config中配置以下参数。
   - High Availability VIP：本例为10.127.190.100；
   - Using local registry：当节点不能连接外网时，必须勾选该项；建议不勾选该项。
   - High Availability Port：默认6443；
   - Controlplane IPs, seperated with comma or space：另外两个控制节点的IP地址，本例为“10.127.190.245 10.127.190.229”
   - Enable Controlplane Host Agent：启用后，另外两个控制节点也可以作为计算节点。本例勾选该项。
    ![](../images/haconfig.png)

3. 取消勾选“Install MySQL on Current host”，在Connect MySql中配置以下参数。
   - MySQL Host IP：数据库的IP地址或高可用数据库的VIP地址，本例为10.127.190.254。
   - MySQL Port Number：默认3306；
   - MySQL Username：数据库用户，默认为root用户，本例为root；
   - MySQL Password：数据库用户对应的密码，本例为123456；

  ![](../images/hamysqlconfig1.png)

4. 开始安装，安装过程较长，请耐心等待，直到安装完成。
   
{{% alert title="说明" %}}
- 当服务器当前内核（`uname -r`用于查看内核版本）与产品要求“3.10.0-1062.4.3.el7.yn20191203.x86_64”不一致时，产品安装完成后将会自动重启。
- 当服务器当前内核（`uname -r`用于查看内核版本）与产品要求“3.10.0-1062.4.3.el7.yn20191203.x86_64”一致时，则产品安装完成后不会自动重启。
{{% /alert %}}

### 配置使用kubectl命令

First Node节点默认支持使用kubectl命令，但是高可用环境中非First Node的控制节点无法直接使用kubectl命令，请通过以下命令配置：

```bash
$ mkdir -p $HOME/.kube 
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config 
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

## 计算节点部署

所有计算节点的配置相同。

**配置项**

- First Node：不勾选；
    - Role of K8S：K8s Node ；
    - Roles：Host；
- First Node IP：VIP地址，不是First Node节点的地址；
- First Node Port：默认6443；
- Join Token：为在First Node节点上使用`ocadm token create`获取的信息；

安装过程较长，请耐心等待，直到安装完成。
   
{{% alert title="说明" %}}
- 当服务器当前内核（`uname -r`用于查看内核版本）与产品要求“3.10.0-1062.4.3.el7.yn20191203.x86_64”不一致时，产品安装完成后将会自动重启。
- 当服务器当前内核（`uname -r`用于查看内核版本）与产品要求“3.10.0-1062.4.3.el7.yn20191203.x86_64”一致时，则产品安装完成后不会自动重启。
{{% /alert %}}

## 访问高可用环境

在浏览器中输入[https://VIP](https://VIP)访问{{<oem_name>}}高可用环境，进行[初始化引导](../deploy)操作。

## 高可用环境升级

支持通过命令行升级。

1. 管理员通过ssh工具以root用户远程登录到First Node节点。

2. 将用户切换成非root用户，执行升级操作不可以用root用户，挂载高版本安装包并进行升级操作。
    
    ```bash
    # 安装过程会增加yunion用户
    $ su yunion   
    # 将高版本的DVD安装包挂载到mnt目录
    $ sudo mount -o loop Yunion-x86_64-DVD-3.x-x.iso /mnt 
    # 切换到/mnt/yunion目录 
    $ cd /mnt/yunion
    $ ./upgrade.sh   
    ```
