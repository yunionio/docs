---
title: "备份/恢复平台"
date: 2022-01-10T16:03:30+08:00
weight: 130
description: >
    介绍如何备份平台配置信息，并将其在新环境上进行恢复
---

### 备份平台

#### 原理

平台支持通过ocboot进行备份当前系统的配置文件（`config.yml`）以及使用mysqldump来备份数据库临时文件`onecloud.sql`并将其压缩。

**备份流程**：

- 将平台配置文件拷贝到`/opt/ocboot`；
- 明确备份目标目录；
- 在`/opt/ocboot`目录下执行备份命令；


#### 备份命令

```bash
usage: ocboot.py backup [-h] [--backup-path BACKUP_PATH] config
positional arguments:
  config                config yaml file
optional arguments:
  -h, --help            show this help message and exit
  --backup-path BACKUP_PATH
                        backup path
```

下面介绍各个参数的作用和注意事项

- `--backup-path`保存备份文件的目标目录，备份的内容包括config配置文件，通过`mysqldump`命令备份的数据库临时文件的压缩包`onecloud.sql.tgz`，请确保目标目录磁盘空间足够且可写。
- `config`是必选参数，即需要备份的配置文件名称，例如`config-allinone.yml, config-nodes.yml, config-k8s-ha.yml，`以及使用快速安装时会生成的`config-allinone-current.yml`，因此备份命令不对配置文件名称作假设，**需由使用者自行输入配置文件名称**。

{{% alert title="注意" color="warning" %}}
- 如果平台通过ocboot部署，请将用户自己配置的`config`文件或快速安装生成的`config-allinone-current.yml`文件等都拷贝到`/opt/ocboot`目录。
- 如果平台通过iso部署，请将` /opt/yunion/upgrade/config.yml`文件拷贝到`/opt/ocboot` 目录。
{{% /alert %}}

- 备份后的配置文件名称为`config.yml`。
* 备份的流程全部采用命令行参数接受输入，备份过程中无交互。因此支持 `crontab`方式自动备份。但备份程序本身不支持版本 `rotate`，用户可以使用 `logrotate` 之类的工具来做备份管理。

#### 举例说明

以iso部署的环境为例介绍如何备份节点到本地的`/opt/backup`目录。

```bash
# 将 `/opt/yunion/upgrade/config.yml`文件拷贝到`/opt/ocboot`目录
$ cp -i /opt/yunion/upgrade/config.yml /opt/ocboot
$ cd /opt/ocboot
# 在`/opt/ocboot`目录执行备份命令，将备份文件保存到`/opt/backup`目录
$ ./ocboot.py backup --backup-path /opt/backup config.yml
```

### 恢复平台

#### 原理

恢复节点即基于上面备份的配置文件和数据库文件恢复到新的节点中，主要包括解压数据库，并根据用户根据新环境生成的配置文件重新安装环境。

**恢复流程**

- 参考`config.yml`配置文件准备新环境，节点数需保持一致；
- 将备份文件拷贝到新环境。
- 在新环境中配置ocboot工具；
- 使用ocboot restore命令恢复环境。

#### 恢复命令

```bash 
usage: ocboot.py restore [-h] [--backup-path BACKUP_PATH]
                         [--install-db-to-localhost]
                         [--master-node-ips MASTER_NODE_IPS]
                         [--master-node-as-host]
                         [--worker-node-ips WORKER_NODE_IPS]
                         [--worker-node-as-host] [--mysql-host MYSQL_HOST]
                         [--mysql-user MYSQL_USER]
                         [--mysql-password MYSQL_PASSWORD]
                         [--mysql-port MYSQL_PORT]
                         primary_ip
positional arguments:
  primary_ip            primary node ip
optional arguments:
  -h, --help            show this help message and exit
  --backup-path BACKUP_PATH
                        backup path, default=/opt/backup
  --install-db-to-localhost
                        use this option when install local db
  --master-node-ips MASTER_NODE_IPS
                        master nodes ips, seperated by comma ','
  --master-node-as-host
                        use this option when use master nodes as host
  --worker-node-ips WORKER_NODE_IPS
                        worker nodes ips, seperated by comma ','
  --worker-node-as-host
                        use this option when use worker nodes as host
  --mysql-host MYSQL_HOST
                        mysql host; not needed if set --install-db-to-
                        localhost
  --mysql-user MYSQL_USER
                        mysql user, default: root; not needed if set
                        --install-db-to-localhost
  --mysql-password MYSQL_PASSWORD
                        mysql password; not needed if set --install-db-to-
                        localhost
  --mysql-port MYSQL_PORT
                        mysql port, default: 3306; not needed if set
                        --install-db-to-localhost
```

- `primary_ip`为必填项，即新环境的IP地址。
- `--backup-path` 备份文件所在目录，不填，默认值为`/opt/backup`目录。
- `--install-db-to-localhost` 如需要在本机(`primary`节点)安装数据库（`mariadb-server`稳定版），则添加该参数，并自动赋予下面参数默认值
    ```bash
    --mysql-host=127.0.0.1
    --mysql-user=root
    --mysql-password=<继承备份文件里 mysql 的密码>
    --mysql-port=3306
    ```
- `--mysql-host`及其他同类选项：如使用已有数据库则需要配置相关参数。注意`--install-db-to-localhost`参数与`--mysql-*`参数互斥。
- `--master-node-ips ` 同时安装`master` 节点，如存在多个master节点。该参数是以半角逗号分隔的 `ip` 列表。适用于多节点模式。
- `--master-node-as-host `安装控制节点`master-node`时，将其作为`host` 节点。
- `--worker-node-ips`、`--worker-node-as-host`，安装计算节点`worker-node`，将其作为`host` 节点。


#### 举例说明

以一个控制节点`master node`(IP:`10.127.190.228`)和一个计算节点`work node`(IP:`10.127.190.219`)为例，介绍如何基于备份文件恢复到新环境。

1. 根据备份文件`config.yml`文件部署新环境，节点数需保持一致。
2. 将备份文件拷贝到新环境。

```bash
# 在备份文件所在服务器将备份文件拷贝到新环境下的`/opt/backup`目录
$ scp /opt/backup/* root@<新环境IP地址>:/opt/backup

```
3. 在新环境上配置控制节点`master node`可以免密登录到计算节点`work node`。

```bash
# 在控制节点`master node`上生成ssh密钥
$ ssh-keygen
# 将生成的~/.ssh/id_rsa.pub 公钥拷贝到计算节点`work node`
$ ssh-copy-id -i ~/.ssh/id_rsa.pub root@10.127.190.219
# 在控制节点`master node`上尝试免密登录，获取计算节点的名称
$ ssh root@10.127.190.219 "hostname"
# 免密登录控制节点
$ ssh-copy-id 10.127.190.228
```
4. 根据新环境的IP信息修改`config.yml`文件，修改当前机器 ip、worker node ips、master node ips，生成新的`config.yml`配置文件。
5. 部署`ocboot`服务

```bash
# 在`master`节点上安装ansible，以centos为例
$ yum install -y ansible
# 安装pip
$ yum -y install python-pip
# 拉取ocboot代码
$ git clone https://github.com/yunionio/ocboot.git
$ cd ./ocboot & pip install -r ./requirements.txt
```

6. 通过`ocboot`工具的`restore`命令恢复节点。

```bash
# 在ocboot目录下执行`restore`命令
$ ./ocboot.py restore --backup-path /opt/backup --install-db-to-localhost --master-node-ips 10.127.190.228 --master-node-as-host --worker-node-ips 10.127.190.219 --worker-node-as-host 10.127.190.228 

```
7. 数据库恢复完成后，根据配置文件恢复平台。

```bash
$ /root/ocboot/run.py /root/ocboot/config.yml
```