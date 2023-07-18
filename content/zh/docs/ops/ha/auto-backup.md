---
title: "系统自动备份"
date: 2023-04-14T16:03:30+08:00
weight: 130
description: >
    介绍如何系统自动备份数据库、k8s oc/deployment、ETCD内容。
---

## 自动备份云管系统的数据库、K8s 配置、etcd 快照

本命令为指定的系统增加自动备份云管系统的数据库、K8s 配置、etcd 快照的功能。

```bash
usage: ocboot.py auto-backup [-h] [--user SSH_USER]
                             [--key-file SSH_PRIVATE_FILE] [--port SSH_PORT]
                             [--backup-path BACKUP_PATH] [--light]
                             [--max-backups MAX_BACKUPS]
                             [--max-disk-percentage MAX_DISK_PERCENTAGE]
                             TARGET_NODE_HOSTS [TARGET_NODE_HOSTS ...]

positional arguments:
  TARGET_NODE_HOSTS     target nodes

optional arguments:
  -h, --help            show this help message and exit
  --user SSH_USER, -u SSH_USER
                        target host ssh user (default: root)
  --key-file SSH_PRIVATE_FILE, -k SSH_PRIVATE_FILE
                        target host ssh private key file (default:
                        /root/.ssh/id_rsa)
  --port SSH_PORT, -p SSH_PORT
                        target host host ssh port (default: 22)
  --backup-path BACKUP_PATH
                        backup path, default: /opt/yunion/backup
  --light               ignore yunionmeter and yunionlogger database; ignore
                        tables start with 'opslog' and 'task'.
  --max-backups MAX_BACKUPS
                        how many backups to keep. default: 10
  --max-disk-percentage MAX_DISK_PERCENTAGE
                        the max usage percentage of the disk on which the
                        backup will be done allowed to perform backup. the
                        backup job will not work when the disk's usage is
                        above the threshold. default: 75(%).
```

下面介绍各个参数的作用和注意事项

- `TARGET_NODE_HOSTS`，此处填写需要部署自动备份的**控制节点**的IP。如果有多个控制节点，只需输入其中之一即可。
- `--user`, `--key-file`, `--port`这些参数是登录备份机器的ssh配置。一般默认用户名`root`、端口号`22`。如果自定义，可以在`$HOME/.ssh/config`里配置。请确保当前机器可以免密登录到所输入的`TARGET_NODE_HOSTS`。
- `--backup-path`，备份路径。默认为`/opt/yunion/backup`。
- `--max-disk-percentage`允许的最大磁盘使用率。默认为`75%`。备份过程会检测所输入的`--backup-path`所在磁盘的使用率。如果已经达到允许的最大磁盘使用率，就会停止备份，以免备份文件打满磁盘。
- `--light`是否为轻量备份。默认为`否`，即，全量备份。轻量备份与全量备份的区别是某些（通常可以自由删除的）业务日志。建议日常只选轻量备份，以节约磁盘、加速备份过程。
- `--max-backups`保留的备份次数。默认保留最新的10次备份。

## 手工恢复备份的数据库和k8s配置

ssh登陆控制节点，进入备份目录，以2023-05-28的备份为例，恢复命令如下

```bash
[root@controller ~]# cd /opt/yunion/backup/
[root@controller backup]# tar -xzvf onecloud.bkup.20230528-000001.tar.gz
[root@controller backup]# cd 20230528-000001/
[root@controller 20230528-000001]# ll
total 181548
-rw------- 1 root root 185819168 May 28 00:00 etcd_snapshot_20230528-000001.db
-rw-r--r-- 1 root root     74493 May 28 00:00 oc.20230528-000001.yml
-rw-r--r-- 1 root root      3241 May 28 00:00 onecloud-operator.20230528-000001.yml

# 恢复数据库
[root@controller 20230528-000001]# pv onecloud.sql.20230528-000001.gz | gunzip | mysql -uroot -p$MYSQL_PASSWD -h $MYSQL_HOST

# 恢复k8s各组件服务
[root@controller 20230528-000001]# kubectl apply -f oc.20230528-000001.yml
[root@controller 20230528-000001]# kubectl apply -f onecloud-operator.20230528-000001.yml
```
