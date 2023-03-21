---
title: "一键巡检"
weight: 2
description: 使用命令行管理日志管理用于查看特定时间维度下的日志表。
---

您可以使用Web界面进行一键巡检操作，也可以使用命令行完成相应操作。本节将介绍如何通过命令行方式进行操作。

## 配置

一键巡检的服务，默认运行k8s的服务器允许使用`root` 和`sshkey`的方式登录，而且默认端口号为`22`。
如果服务器用户名不是`root`，或端口号不是`22`，需要进行配置：

```bash
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl -n onecloud edit configmap default-autoupdate
```

然后在

```yaml
apiVersion: v1
data:
  config: |
    ...
    update_check_interval_hours: 1
    update_server: https://iso.yunion.cn
    version: false
    check_ssh_user: root    # <= 这里设置执行一键巡检的 ssh 用户名; 默认 root
    check_ssh_port: 22      # <= 这里设置执行一键巡检的 ssh 端口号；默认 22
kind: ConfigMap
metadata:
  annotations:
```

此外，还需确保将一键巡检代理的公钥拷贝到每台目标机器的`$HOME/~/.ssh/authorized_keys`中，并确保该文件的读写权限为`600(-rw-------)`。

重要提示：所有目标机器的登录方式必须相同，即用户名和端口号均相同。例如，不能有的`SSH`端口号是`22`，而有的是`8022`等情况。

获取公钥的命令：

```bash
climc-ee opsrecord-pubkey-list

# 输出如下：
|                          public_key                          |
-------------------------------------------------------------- |
| ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsCKpYsS0vpMFLEaeN ... |

```

提示：如果显示找不到`climc-ee`命令，请检查`/opt/yunion/bin`路径下是否包含名为`climc-ee`的二进制文件，并确保该路径已经添加到全局变量`$PATH`中。下同，不再赘述。

## 检测登录状态

完成上述配置后，可以使用以下命令检查是否可以登录：

```bash
climc-ee do-routine-check --test-ssh
```

样例输出（只查看第一条即可）：

```bash
| name | record_type | results | created_at |
|-------------------------------------------------------------- |
| 20230321-101054.842 | ssh_check   | {"Status":"WARNING","Result":[{"Ip":"192.168.222.111","Status":"OK"},{"Ip":"192.168.222.112","Status":"OK"},{"Ip":"192.168.222.114","Status":"OK"},{"Ip":"192.168.222.102","Status":"OK"},{"Ip":"10.168.222.236","Status":"OK"},{"Ip":"10.168.222.219","Status":"OK"},{"Ip":"192.168.222.171","Status":"OK"},{"Ip":"192.168.222.172","Status":"ssh: handshake failed: ssh: unable to authenticate, attempted methods [none publickey], no supported methods remain"},{"Ip":"192.168.222.173","Status":"ssh: handshake failed: ssh: unable to authenticate, attempted methods [none publickey], no supported methods remain"},{"Ip":"192.168.222.174","Status":"OK"}],"Bad":2,"Good":8} | 2023-03-21T10:34:54.000000Z
```

其中，results部分的JSON内容中Status字段的结果说明如下：

* `OK`: 所有机器均可成功登录。
* `ERROR`: 所有机器都无法登录，具体IP地址请参见`Results`列表。
* `WARNING`: 部分机器无法登录，具体IP地址请参见`Results`列表。

## 执行巡检

执行巡检命令：`climc-ee do-routine-check`

命令行会等待后台输出，等待巡检完成后，将结果输出到终端，输出结果类似于：

```bash
| name | record_type | results | created_at |
| 20230321-101055.164 | routine_check | {"Hosts":[{"cpuLoadLast5Min":0.01,"cpuStatus":"OK","diskOptUsage":"","diskRootUsage":"50%","diskStatus":"OK","memUsage":"91%","hostStatus":"OK","nodeIp":"192.168.222.111","nodeName":"ceph-01","ntpDetails":"Tue 21 Mar 2023 06:09:56 AM EDT -0.297614 seconds","ntpStatus":"OK","qemuVersion":["yunion-qemu-4.2.0-4.2.0-20221009.el7.x86_64"],"timeStamp":"2023-03-21T06:09:55.000000Z","Roles":["host"]},{"cpuLoadLast5Min":0.21,"cpuStatus":"OK","diskOptUsage":"","diskRootUsage":"54%","diskStatus":"OK","memUsage":"25%","hostStatus":"WARNING","nodeIp":"192.168.222.174","nodeName":"office-controller04-rpi4","ntpDetails":"hwclock: Cannot access the Hardware Clock via any known method. hwclock: Use the --verbose option to see the\ndetails of our search for an access method.","ntpStatus":"ERROR","qemuVersion":[""],"timeStamp":"2023-03-21T18:10:51.000000Z","Roles":["host"]}],"K8s":{"k8sCertDetails":[{"CERTIFICATE":"admin.conf","EXPIRES":"Aug 19, 2121 08:24 UTC","RESIDUAL TIME":"98y","EXTERNALLY MANAGED":"no"}],"k8sCertStatus":"OK","k8sResult":"OK","k8sDetails":{"pods":76,"errorPods":12,"runningPods":64,"nodes":10,"runningNodes":10,"errorNodes":0},"k8sErrorPods":["calico-node-whnlh","kube-proxy-7cct2","monitor-promtail-2x9r8","default-host-759vh","default-host-deployer-4bwxj","default-host-deployer-9wpgl","default-host-deployer-bztmd","default-host-deployer-g5wk8","default-host-deployer-lxllm","default-host-deployer-wds7x","default-host-health-hk7rz","default-host-image-m49sh","default-host-r2qf7","default-suggestion-577cbd459c-b5gxs","default-telegraf-6scqz","rook-ceph-osd-11-7b6dcdbd45-5r4fw","rook-ceph-osd-prepare-ceph-02-fxvj5","rook-ceph-osd-prepare-ceph-04-2ffpw","rook-ceph-osd-prepare-ceph-05-8lzmn"],"k8sErrorNodes":[],"k8sVersion":"v3.10.0","k8sRoles":[{"Host":"192.168.222.111","Labels":["host"]},{"Host":"192.168.222.112","Labels":["host"]},{"Host":"192.168.222.114","Labels":["host"]},{"Host":"192.168.222.102","Labels":["host"]},{"Host":"10.168.222.236","Labels":["lbagent"]},{"Host":"10.168.222.219","Labels":["lbagent"]},{"Host":"192.168.222.171","Labels":["baremetal","controller"]},{"Host":"192.168.222.172","Labels":[]},{"Host":"192.168.222.173","Labels":[]},{"Host":"192.168.222.174","Labels":["host"]}]},"Mysql":{"mysqlAbortedConnectionDetails":"Aborted_connects 2","mysqlAbortedConnectionStatus":"ERROR","mysqlSlaveDetails":"","mysqlSlaveStatus":"","mysqlStatus":"OK","mysqlStatusDetails":{"Flush tables":1,"Open tables":1677,"Opens":1789,"Queries per second avg":1796.37,"Questions":126178889,"Slow queries":297,"Threads":156,"Uptime":70241}}} | 2023-03-21T10:09:55.000000Z |
```

您还可以单独执行查询命令，查询上次巡检的结果：

```bash
env OS_MAX_COLUMN_TEXT_LENGTH=-1 climc-ee opsrecord-list --record-type routine_check --limit 1
```
