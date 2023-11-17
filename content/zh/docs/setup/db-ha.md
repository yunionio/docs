---
title: "部署 DB HA 环境"
date: 2020-02-12T12:55:46+08:00
weight: 4
description: >
  部署高可用数据库集群
---

{{<oem_name>}} 平台服务使用 Mariadb，这里使用 keepalived 和 Mariadb 的主主复制功能来实现 DB 的高可用。

## 部署

keepalived 的主要作用是为 Mariadb 提供 vip，在2个 Mariadb 实例之间切换，不间断的提供服务。

### 部署配置 Mariadb 主主复制

安装并启动 Mariadb

```bash
$ yum install -y mariadb-server
$ systemctl enable --now mariadb
```

运行 Mariadb 安全配置向导，设置密码等

```bash
$ mysql_secure_installation
 ... ...
Change the root password? [Y/n] y
New password:
Re-enter new password:
Password updated successfully!
Reloading privilege tables..
 ... Success!
 ... ...
Remove anonymous users? [Y/n] y
 ... Success!
 ... ...
Disallow root login remotely? [Y/n] y
 ... Success!
 ... ...
Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success! ... ...
Reload privilege tables now? [Y/n] y
 ... Success!
 ... ...
```

修改 Mariadb 配置文件，准备配置主主复制。

备注：主、从区别是`confserver-id`、`auto_increment_offset`两个字段。

```bash
# 主节点
$ cat <<EOF > /etc/my.cnf
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
skip_name_resolve
# auto delete binlog older than 30 days
expire_logs_days=30
innodb_file_per_table=ON
max_connections = 300
max_allowed_packet=20M

server-id = 1
auto_increment_offset = 1
auto_increment_increment = 2
log-bin = mysql-bin
binlog-format = row
log-slave-updates
max_binlog_size = 1G
replicate-ignore-db = information_schema
replicate-ignore-db = performance_schema
max_connections = 1000
max_connect_errors = 0
max_allowed_packet = 1G
slave-net-timeout=10
master-retry-count=0

slow_query_log = 1
long_query_time = 2
slow_query_log_file = /var/log/mariadb/slow-query.log

[mysql]
no-auto-rehash

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d
EOF

# 备节点
$ cat <<EOF > /etc/my.cnf
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
skip_name_resolve
# auto delete binlog older than 30 days
expire_logs_days=30
innodb_file_per_table=ON
max_connections = 300
max_allowed_packet=20M

server-id = 2
auto_increment_offset = 2
auto_increment_increment = 2
log-bin = mysql-bin
binlog-format = row
log-slave-updates
max_binlog_size = 1G
replicate-ignore-db = information_schema
replicate-ignore-db = performance_schema
max_connections = 1000
max_connect_errors = 0
max_allowed_packet = 1G
slave-net-timeout=10
master-retry-count=0

slow_query_log = 1
long_query_time = 2
slow_query_log_file = /var/log/mariadb/slow-query.log

[mysql]
no-auto-rehash

[mysqld_safe]
log-error=/var/log/mariadb/mariadb.log
pid-file=/var/run/mariadb/mariadb.pid

#
# include all files from the config directory
#
!includedir /etc/my.cnf.d
EOF

# 重启服务
$ systemctl restart mariadb
```

主节点创建只读账号，导出全部数据，导入备节点。记录binlog日志文件名和position。

```bash
# 以下命令在主节点执行

# 此密码为上面设置的 Mariadb root 密码，为了方便，只读账号也使用此密码
$ MYSQL_PASSWD='your-sql-passwd'

# 开启 Mariadb 的远程访问
$ mysql -uroot -p$MYSQL_PASSWD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_PASSWD' WITH GRANT OPTION;FLUSH PRIVILEGES"

# 创建只读账号
$ mysql -u root -p$MYSQL_PASSWD -e "GRANT REPLICATION SLAVE ON *.* TO repl@'%' IDENTIFIED BY '$MYSQL_PASSWD';FLUSH PRIVILEGES"

# 示例是全新安装的 Mariadb ，还没有使用。如果是正在使用的数据库做主主复制，需要锁表后再导出数据
$ mysql -uroot -p$MYSQL_PASSWD -e "SHOW PROCESSLIST"
+----+------+-----------+------+---------+------+-------+------------------+----------+
| Id | User | Host      | db   | Command | Time | State | Info             | Progress |
+----+------+-----------+------+---------+------+-------+------------------+----------+
|  4 | root | localhost | NULL | Query   |    0 | NULL  | SHOW PROCESSLIST |    0.000 |
+----+------+-----------+------+---------+------+-------+------------------+----------+

# 记录binlog日志文件名和position
$ mysql -u root -p$MYSQL_PASSWD -e "SHOW MASTER STATUS\G"
*************************** 1. row ***************************
            File: mysql-bin.000001
        Position: 2023
    Binlog_Do_DB:
Binlog_Ignore_DB:

# 导出全部数据
$ mysqldump --all-databases -p$MYSQL_PASSWD > alldb.db

# 拷贝 alldb.db 到备节点
$ scp alldb.db db2:/root/


# 以下命令在备节点执行

# 此密码为上面设置的 Mariadb root 密码
$ MYSQL_PASSWD='your-sql-passwd'

# 导入主节点导出的数据
mysql -u root -p$MYSQL_PASSWD < alldb.db

# 重载权限
mysql -u root -p$MYSQL_PASSWD -e "FLUSH PRIVILEGES"

# 记录binlog日志文件名和position
mysql -u root -p$MYSQL_PASSWD -e "SHOW MASTER STATUS\G"
*************************** 1. row ***************************
            File: mysql-bin.000001
        Position: 509778
    Binlog_Do_DB:
Binlog_Ignore_DB:
```

设置主主复制

```bash
# 以下命令在主节点执行

# 修改MASTER_HOST为备节点IP，修改MASTER_LOG_FILE和MASTER_LOG_POS为上面备节点记录的信息
mysql -u root -p$MYSQL_PASSWD -e "CHANGE MASTER TO MASTER_HOST='192.168.199.99',MASTER_USER='repl',MASTER_PASSWORD='$MYSQL_PASSWD',MASTER_PORT=3306,MASTER_LOG_FILE='mysql-bin.000001',MASTER_LOG_POS=509778,MASTER_CONNECT_RETRY=2;START SLAVE"


# 以下命令在备节点执行

# 修改MASTER_HOST为主节点IP，修改MASTER_LOG_FILE和MASTER_LOG_POS为上面主节点记录的信息
mysql -u root -p$MYSQL_PASSWD -e "CHANGE MASTER TO MASTER_HOST='192.168.199.98',MASTER_USER='repl',MASTER_PASSWORD='$MYSQL_PASSWD',MASTER_PORT=3306,MASTER_LOG_FILE='mysql-bin.000001',MASTER_LOG_POS=2023,MASTER_CONNECT_RETRY=2;START SLAVE"


# 主备都执行，验证同步状态，都输出2个 Yes 表示正常
mysql -u root -p$MYSQL_PASSWD -e "SHOW SLAVE STATUS\G" | grep Running
             Slave_IO_Running: Yes
            Slave_SQL_Running: Yes

# 如果这一步不成功，例如Slave_SQL_Running为 connecting，极大概率是防火墙没关闭。请执行如下命令，关闭防火墙，然后重新执行上一步的2个Yes的检测。
systemctl is-active firewalld >/dev/null && systemctl disable --now firewalld

```

至此，DB 主主复制部署完成，可以测试在任一节点进行数据库操作，另一节点验证。不过对外提供服务还是需要通过 vip，不然发生切换还需要业务端切换 ip，下面配置 keepalived 对外提供服务。

### 部署配置 keepalived

设置相关的环境变量，根据不同的环境自行配置。

```bash
# keepalived vip 地址
export DB_VIP=192.168.199.97

# keepalived auth toke
export DBHA_KA_AUTH=onecloud

# keepalived network interface
export DB_NETIF=eth0
```

设置 sysctl 选项

```bash
$ cat <<EOF >>/etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv4.ip_nonlocal_bind = 1
EOF

$ sysctl -p
```

安装 keepalived nc

```bash
$ yum install -y keepalived nc
```

添加配置

```bash
# 请确保 virtual_router_id 不会和局域网内的其他 keepalived 集群冲突
$ cat <<EOF >/etc/keepalived/keepalived.conf
global_defs {
    router_id onecloud
}

vrrp_script chk_mysql {
    script "/etc/keepalived/chk_mysql"
    interval 1
}

vrrp_instance VI_1 {
    state MASTER
    interface $DB_NETIF
    virtual_router_id 99
    priority 100
    advert_int 1
    nopreempt
    authentication {
        auth_type PASS
        auth_pass $DBHA_KA_AUTH
    }

    track_script {
        chk_mysql
    }

    virtual_ipaddress {
        $DB_VIP
    }
}
EOF

$ cat <<EOF > /etc/keepalived/chk_mysql
#!/bin/bash
echo | nc 127.0.0.1 3306 &>/dev/null
EOF

$ chmod +x /etc/keepalived/chk_mysql
```

以下为备节点的配置：

```bash
# 请确保备节点 virtual_router_id 和主节点一致
$ cat <<EOF >/etc/keepalived/keepalived.conf
global_defs {
    router_id onecloud
}

vrrp_script chk_mysql {
    script "/etc/keepalived/chk_mysql"
    interval 1
}

vrrp_instance VI_1 {
    state BACKUP
    interface $DB_NETIF
    virtual_router_id 99
    priority 99
    advert_int 1
    nopreempt
    authentication {
        auth_type PASS
        auth_pass $DBHA_KA_AUTH
    }

    track_script {
        chk_mysql
    }

    virtual_ipaddress {
        $DB_VIP
    }
}
EOF

$ cat <<EOF > /etc/keepalived/chk_mysql
#!/bin/bash
echo | nc 127.0.0.1 3306 &>/dev/null
EOF

$ chmod +x /etc/keepalived/chk_mysql
```

配置后，在主备节点分别启动 keepalived

```bash
$ systemctl enable --now keepalived
$ ip addr show $DB_NETIF
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 00:22:cf:40:1e:29 brd ff:ff:ff:ff:ff:ff
    inet 192.168.199.99/24 brd 192.168.199.255 scope global dynamic eth0
       valid_lft 100651906sec preferred_lft 100651906sec
    inet 192.168.199.97/32 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::222:cfff:fe40:1e29/64 scope link
       valid_lft forever preferred_lft forever
```

### 配置 keepalived 自动切换网卡

本方案中，`k8s` 与 `mysql`共用网卡。如果`k8s`启用了`host`功能，会自动启用`br0`网卡。在`host` 启动、网卡切换时，有一定概率影响`mysql`的高可用稳定性。以下是辅助脚本，来提升`k8s+mysql`的稳定性。

以下脚本分别在 db 的主节点、备节点执行。注意替换第一行的`node_ip`变量为本机`ip`。

```bash
node_ip=					 					# 注意替换这里的 DB_NODE_IP 为本机 Ip
[[ -z "$node_ip" ]] && echo "please export variable 'node_ip' first! "

cat <<EOF_CK1 >/etc/keepalived/check_interface.sh
#!/usr/bin/env bash

datestr="\$(date +"%F %T")"
env_interface=\$(cat /etc/keepalived/keepalived.conf| grep -w interface |awk '{print \$2}')
echo "[\$datestr] 目前keepalived监听的网卡: \$env_interface"
router_interface=\$(/usr/sbin/ip a show | grep $node_ip | awk '{ print \$NF}')
echo "[\$datestr] ip所在网卡名称: [\$router_interface]"

if [[ -n "\$router_interface" ]] && [[ "\$router_interface" != "\$env_interface" ]]; then
    echo "[\$datestr] update keepalived.conf interface"
    sed -i -e "s#\$env_interface#\$router_interface#g" /etc/keepalived/keepalived.conf
    systemctl restart keepalived
else
    echo "[\$datestr] No need to update interface. "
fi
EOF_CK1

cat <<EOF_CK2 >/etc/keepalived/check_interface2.sh
#!/usr/bin/env bash
for i in {1..3}; do
    /etc/keepalived/check_interface.sh >> /var/log/keepalived.log
    sleep 20
done
EOF_CK2

cat <<EOF_CRON >/etc/cron.d/update_keepalived_interface
* * * * * root /etc/keepalived/check_interface2.sh >/dev/null 2>&1
EOF_CRON
systemctl restart crond

chmod +x /etc/keepalived/chk_mysql
chmod +x /etc/keepalived/check_interface.sh
chmod +x /etc/keepalived/check_interface2.sh

systemctl enable --now keepalived
systemctl restart keepalived
chmod +x /etc/rc.d/rc.local
if ! grep -q /etc/keepalived/check_interface.sh /etc/rc.d/rc.local; then
    sed -i '$a bash /etc/keepalived/check_interface.sh >> /var/log/keepalived.log' /etc/rc.d/rc.local
fi

```

至此，DB 高可用部署完成，任一节点的 Mariadb 或 keepalived 服务异常，或者任一节点宕机，都不影响对外服务。
