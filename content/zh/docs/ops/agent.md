---
title: "手动安装监控Agent"
date: 2021-12-09T10:23:16+08:00
weight: 50
description: >
    介绍如何在平台虚拟机中手动安装监控Agent，收集监控信息
---

### 前提条件

虚拟机监控Agent采集的监控数据需要上报到平台的InfluxDB数据库中，因此需要获取InfluxDB地址的对外地址，并需要判断虚拟机是否可以直接连接到InfluxDB数据库。

- 若虚拟机可以直接连接InfluxDB数据库，则直接安装监控Agent，配置telegraf采集的监控指标即可
- 若虚拟机无法直接连接到InfluxDB数据库，需要配置SSH代理节点，建立虚拟机与InfluxDB数据库的连接后，再安装监控Agent，配置telegraf采集的监控指标。

#### 获取InfluxDB地址

```bash
# 获取InfluxDB的对外地址及端口号
$ climc endpoint-list -service Influxdb
```
![](../images/getinfluxdb.png)

#### 配置SSH代理节点

1. 查询虚拟机所在VPC或IP子网下是否存在SSH代理节点。

```bash
# 查询虚拟机所在VPC下是否存在SSH代理节点
$ climc proxy-endpoint-list --vpc-id <vpc的ID>
# 若VPC下IP子网之间网络隔离，则需要查询虚拟机所在IP子网下是否存在SSH代理节点
$ climc proxy-endpoint-list --network-id <IP子网的ID>
```
2. 若虚拟机所在网络下存在SSH代理节点，则忽略新建SSH代理节点的步骤，直接在SSH代理节点下配置到InfluxDB的remote规则，使监控数据可以上报到InfluxDB。

#### 新建SSH代理节点

若虚拟机所在网络无法直接与平台的InfluxDB数据库进行通信，则需要在虚拟机所在VPC或IP子网中选择一台Linux操作系统的虚拟机作为SSH代理节点。虚拟机需要满足以下配置要求

**虚拟机配置要求**

- 目前只支持Linux操作系统的虚拟机作为SSH代理节点。
- 请确保虚拟机处于运行中状态；
- 请确保虚拟机支持通过平台免密登录；虚拟机能被平台免密登录，则要求虚拟机与平台网络通（即通过EIP、NAT网关或SSH代理等方式使虚拟机与平台网络通）以及虚拟机中存在平台的公钥文件。
- 请检查虚拟机的sshd配置，GatewayPorts是clientspecified，若该项值为no，则只允许绑定127.0.0.1的地址，使remote forward无法正常使用，造成安装监控Agent的虚拟机无法向平台上报监控数据等。

**操作步骤**

1. 在SSH代理节点页面#，单击列表上方 **_"新建"_** 按钮，进入新建SSH代理节点页面。
2. 在选择虚拟机页面设置以下参数：
    - 域：设置SSH代理节点所属域，并通过域过滤可选的虚拟机。
    - 名称：设置SSH代理节点的名称。
    - 区域：通过平台、区域过滤VPC。
    - 网络：通过VPC、网络过滤虚拟机。
    - 虚拟机：通过上面的筛选条件过滤出符合条件的虚拟机，并支持在搜索框中通过名称和IP搜索虚拟机，，如没有合适的虚拟机，可以单击“新建”超链接，跳转到虚拟机列表页面创建符合需求的虚拟机。
3. 选择好虚拟机后，单击 **_"下一步"_** 按钮，开始探测虚拟机的免密登录状态。
    - 如虚拟机可免密登录，可直接单击 **_"确定"_** 按钮，开始创建虚拟机。
    - 如虚拟机不可免密登录，请先点击列表操作列 **_"查看"_** 按钮，查看探测免密登录失败的具体原因。
        - 如报错原因中提示“none publickey”，可通过设置免密登录功能，将虚拟机设置为免密登录状态。设置免密登录方式配置参数如下：
            - 设置方式：支持密钥、密码、脚本等方式将平台的公钥上传到虚拟机上。
            - 当设置方式为“密钥”时，请使用root用户或具有使用sudo免密权限的用户以其私钥，请确保可以通过用户名和私钥通过ssh连接到对应虚拟机，单击 **_"确定"_** 按钮，开始设置并探测虚拟机的免密登录状态是否变为免密登录。
            - 当设置方式为“密码”时，请使用root用户或具有使用sudo免密权限的用户以其密码，请确保可以通过用户名和密码通过ssh连接到对应虚拟机。单击 **_"确定"_** 按钮，开始设置并探测虚拟机的免密登录状态是否变为免密登录。
            - 当设置方式为“脚本”时，请请使用root或具有sudo权限的用户在虚拟机中执行以下脚本，执行完成后，单击 **_"确定"_** 按钮，开始设置并探测虚拟机的免密登录状态是否变为免密登录。
        - 如报错原因中提示“network error”，则需要返回上一步选择其他虚拟机，或为该虚拟机通过绑定EIP或NAT网关等方式，使其与平台网络可通。
4. 只有当虚拟机免密登录状态为“可免密登录”时，才支持单击 **_"确定"_** 按钮，开始创建SSH代理节点。
5. 在创建SSH代理节点时将会检查虚拟机的sshd配置是否符合虚拟机配置要求，若不符合将会尝试变更虚拟机的sshd配置，因此可能会造成创建ssh代理节点时间过长，若提示超时，请重新单击 **_"确定"_** 按钮，创建SSH代理节点。

#### 配置Remote规则

后续在配置telegraf文件时，需要配置的InfluxDB的地址为“ssh代理节点的地址:<映射绑定的端口号>”

```bash
# 在ssh代理节点上配置到InfluxDB的remote规则，使监控数据可以上报到平台的InfluxDB数据库。
$ climc proxy-forward-create --proxy-endpoint-id <ssh代理节点的ID> --type remote --remote-addr <influxdb的IP地址> --remote-port <InfluxDB的端口号> --bind-port-req <映射绑定的端口号> <remote规则的名称>
# 下面举例介绍如何创建对应的remote规则，即将10.127.100.2:30086地址映射为10.0.9.254:30086，后续telegraf配置中的InfluxDB地址“https://10.0.9.254:30086”
$ climc proxy-forward-create --proxy-endpoint-id dba57f12-4f9f-4d60-8789-7dc0fe4efc6a --type remote --remote-addr 10.127.100.2 --remote-port 30086 --bind-port-req 30086 remote-influxdb
+-------------------+--------------------------------------+
|       Field       |                Value                 |
+-------------------+--------------------------------------+
| bind_addr         | 10.0.9.254                           |
| bind_port         | 30086                                |
| bind_port_req     | 0                                    |
| can_delete        | true                                 |
| can_update        | true                                 |
| created_at        | 2021-12-09T06:30:32.000000Z          |
| deleted           | false                                |
| domain_id         | default                              |
| freezed           | false                                |
| id                | 3268655c-b816-4e4c-8250-88c67773ecff |
| is_emulated       | false                                |
| is_system         | false                                |
| last_seen_timeout | 117                                  |
| name              | remote-influxdb                      |
| pending_deleted   | false                                |
| project_src       | local                                |
| proxy_agent       | proxyagent0                          |
| proxy_agent_id    | 330e097e-59e4-4c65-8414-05d6d945e1c0 |
| proxy_endpoint    | helanzhu                             |
| proxy_endpoint_id | dba57f12-4f9f-4d60-8789-7dc0fe4efc6a |
| remote_addr       | 10.127.100.2                         |
| remote_port       | 30086                                |
| status            | init                                 |
| tenant_id         | 55bb511b62bf47dc86e82c731005ba10     |
| type              | remote                               |
| update_version    | 0                                    |
| updated_at        | 2021-12-09T06:30:32.000000Z          |
+-------------------+--------------------------------------+
```

### 安装监控Agent

监控Agent安装包：[下载路径](https://yunioniso.oss-cn-beijing.aliyuncs.com/rpms/telegraf/)

不同操作系统的安装包名称不同，请根据具体系统下载对应的Agent安装包。

| OS      | Arch   | Package Name                                  |
| ------- | ------ | --------------------------------------------- |
| RedHat  | x86_64 | telegraf-1.19.2-yn~fe11a96b-0.x86_64.rpm      |
| RedHat  | arm64  | telegraf-1.19.2-yn~fe11a96b-0.aarch64.rpm     |
| Debian  | x86_64 | telegraf_1.19.2-yn~fe11a96b-0_amd64.deb       |
| Debian  | arm64  | telegraf_1.19.2-yn~fe11a96b-0_arm64.deb       |
| Windows | x86_64 | telegraf-1.19.2-yn~3bc1d95c_windows_amd64.zip |
| Windows | X86    | telegraf-1.19.2-yn~3bc1d95c_windows_i386.zip  |

#### 下载监控Agent安装包

下面用 $Package 代表具体安装包名称，请在使用时进行替换。

**Linux**
```bash
# 将安装包下载到/tmp目录
$ wget https://yunioniso.oss-cn-beijing.aliyuncs.com/rpms/telegraf/$Package -P /tmp
```
**Windows**

手动下载`/$Package`并解压到指定目录，比如`C:\\telegraf`下


#### 准备配置文件

准备监控Agent的配置文件

**Linux**

```bash
# 在tmp目录下新建telegraf配置文件
$ touch /tmp/telegraf.conf
```

**Windows**

在`C:\\telegraf`目录下新建`telegraf.conf`文件。

telegraf配置文件主要包括以下内容：

##### global_tags

global_tags里包含虚拟机的ID、名称、宿主机、域、项目、区域、可用区、平台等信息，请根据虚拟机的具体信息，修改global_tags里的内容，后续返回的监控信息中也将会带上这些标签，因此在监控查询中可以通过一些条件查询虚拟机的监控信息。

```bash
[global_tags]
    zone_ext_id = ""
    os_type = "Linux"
    scaling_group_id = ""
    host_id = "3bce9607-2597-469f-8d9b-977345456739"
    vm_id = "5b966ffa-1b4a-4648-8c6a-7617bb7bb76e"
    zone_id = "3032cb4d-558a-4833-88e6-7b5bcabb47d1"
    cloudregion = "Beijing"
    domain_id = "default"
    zone = "YunionHQ"
    region_ext_id = ""
    tenant = "system"
    tenant_id = ""
    brand = "OneCloud"
    host = "office-03-host01"
    vm_name = "test-agent"
    status = "running"
    cloudregion_id = "default"
    project_domain = "Default"
```
##### agent配置信息

包括采集监控、虚拟机名称等相关配置，除虚拟机名称外，其他参数建议保持默认。
```bash
# Configuration for telegraf agent
[agent]
    interval = "10s"
    debug = false
    hostname = "test-agent.test.io"
    round_interval = true
    flush_interval = "10s"
    flush_jitter = "0s"
    collection_jitter = "0s"
    metric_batch_size = 1000
    metric_buffer_limit = 10000
    quiet = false
    logfile = ""
    omit_hostname = true
```
##### OUTPUTS

用于设置将监控数据传输到数据库地址，平台使用InfluxDB，数据库名称为telegraf，平台数据库的地址默认为“https://控制节点IP地址:30086”，具体平台InfluxDB数据库地址请参考[获取InfluxDB地址](#获取influxdb地址)步骤。

- 如果虚拟机可以直接连接到平台，urls地址可以直接设置为数据的访问地址；
- 如果虚拟机不可以直接连接到平台，则需要通过代理的方式，该urls地址为代理地址，即为: "http://<ssh代理节点的地址>:<remote规则的映射端口号>"。

```bash
#################################################################
#                          OUTPUTS                           #
##################################################################

[[outputs.influxdb]]
    urls = ["https://192.168.12.251:30086"]
    database = "telegraf"
    insecure_skip_verify = true  
```
##### INPUTS

主要用于设置采集的监控指标，建议保持默认。

```bash
  ##################################################################
#                                 INPUTS                      #
##################################################################

[[inputs.cpu]]
    name_prefix = "agent_"
    percpu = true
    totalcpu = true
    collect_cpu_time = false
    report_active = true
[[inputs.disk]]
    name_prefix = "agent_"
    ignore_fs = ["tmpfs", "devtmpfs", "overlay", "squashfs", "iso9660"]
[[inputs.diskio]]
    name_prefix = "agent_"
    skip_serial_number = false
[[inputs.kernel]]
    name_prefix = "agent_"
[[inputs.kernel_vmstat]]
    name_prefix = "agent_"
[[inputs.mem]]
    name_prefix = "agent_"
[[inputs.processes]]
    name_prefix = "agent_"
[[inputs.swap]]
    name_prefix = "agent_"
[[inputs.system]]
    name_prefix = "agent_"
[[inputs.net]]
    name_prefix = "agent_"
[[inputs.netstat]]
    name_prefix = "agent_"
[[inputs.nstat]]
    name_prefix = "agent_"
[[inputs.ntpq]]
    name_prefix = "agent_"
    dns_lookup = false
[[inputs.internal]]
    name_prefix = "agent_"
    collect_memstats = false  
```
##### telegraf配置文件举例

以下为完整的telegraf举例文件，用户可参考进行配置

```bash
### MANAGED BY ansible-telegraf ANSIBLE ROLE ###

[global_tags]
    zone_ext_id = ""
    os_type = "windows"
    scaling_group_id = ""
    host_id = "3bce9607-2597-469f-8d9b-977345456739"
    vm_id = "5b966ffa-1b4a-4648-8c6a-7617bb7bb76e"
    zone_id = "3032cb4d-558a-4833-88e6-7b5bcabb47d1"
    cloudregion = "Beijing"
    domain_id = "default"
    zone = "YunionHQ"
    region_ext_id = ""
    tenant = "system"
    tenant_id = ""
    brand = "OneCloud"
    host = "office-03-host01"
    vm_name = "test-agent"
    status = "running"
    cloudregion_id = "default"
    project_domain = "Default"


# Configuration for telegraf agent
[agent]
    interval = "10s"
    debug = false
    hostname = "test-agent.test.io"
    round_interval = true
    flush_interval = "10s"
    flush_jitter = "0s"
    collection_jitter = "0s"
    metric_batch_size = 1000
    metric_buffer_limit = 10000
    quiet = false
    logfile = ""
    omit_hostname = true

##################################################################
#                                 OUTPUTS                      #
##################################################################
# 本例中是通过SSH代理的方式将监控数据转发到INfluxDB数据库。
[[outputs.influxdb]]
    urls = ["https://192.168.12.251:50041"]
    database = "telegraf"
    insecure_skip_verify = true

##################################################################
#                                 INPUTS                       #
##################################################################

[[inputs.cpu]]
    name_prefix = "agent_"
    percpu = true
    totalcpu = true
    collect_cpu_time = false
    report_active = true
[[inputs.disk]]
    name_prefix = "agent_"
    ignore_fs = ["tmpfs", "devtmpfs", "overlay", "squashfs", "iso9660"]
[[inputs.diskio]]
    name_prefix = "agent_"
    skip_serial_number = false
[[inputs.kernel]]
    name_prefix = "agent_"
[[inputs.kernel_vmstat]]
    name_prefix = "agent_"
[[inputs.mem]]
    name_prefix = "agent_"
[[inputs.processes]]
    name_prefix = "agent_"
[[inputs.swap]]
    name_prefix = "agent_"
[[inputs.system]]
    name_prefix = "agent_"
[[inputs.net]]
    name_prefix = "agent_"
[[inputs.netstat]]
    name_prefix = "agent_"
[[inputs.nstat]]
    name_prefix = "agent_"
[[inputs.ntpq]]
    name_prefix = "agent_"
    dns_lookup = false
[[inputs.internal]]
    name_prefix = "agent_"
    collect_memstats = false


##################################################################
#                           PROCESSORS                       #
##################################################################
```

#### 手动安装监控Agent

**RedHat/CentOS**

```bash
# 安装
rpm -ivh /tmp/$Package
# 更换配置文件
mv /tmp/telegraf.conf /etc/telegraf/telegraf.conf
```
**Debian/Ubuntu**
```bash
# 安装
dpkg -i /tmp/$Package
# 更换配置文件
mv /tmp/telegraf.conf /etc/telegraf/telegraf.conf
```
**Windows**

安装Windows版本监控Agent时需要指定上面步骤的telegraf配置文件，例如`C:\\telegraf\telegraf.conf`

```bash
C:\\telegraf\telegraf.exe --config "C:\\telegraf\telegraf.conf" --service install
```

#### 启动telegraf服务

**Linux**

```bash
# 启动服务
systemctl start telegraf
# 查看服务
systemctl status telegraf
```
**Windows**
```bash
# 启动服务
sc start telegraf
# 查看服务
sc query telegraf
```