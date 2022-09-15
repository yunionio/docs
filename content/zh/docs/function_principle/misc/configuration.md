---
title: "配置管理"
date: 2019-07-19T20:58:54+08:00
weight: 100
description: >
    介绍平台服务的配置管理
---

本文介绍 {{<oem_name>}} 的服务配置的管理原理。

大部分服务的配置信息有三个来源：

* 命令行参数
* 配置文件，配置文件路径一般在 /etc/yunion/<service_name>.conf
* Keystone中保存的服务配置

如果一个参数在三个来源都有设置，则越排在后的配置来源优先级最高。

## 命令行参数

服务配置首先通过命令行参数设置，如果存在 --config 的配置，则会加载 --config 指定的配置文件的内容，根绝配置文件的内容设置参数。

以下配置项是只能通过命令行指定的参数：

| 配置项    | 类型    | 说明           |
|----------|--------|---------------|
| config   | string | 指定配置文件路径 |   
| help     | bool   | 显示帮助信息并退出 |
| version  | bool   | 显示版本信息并退出 |
| pid_file | string | pid文件路径 |

## 配置文件

配置文件格式可以是Key=Value的方式设置参数，也可以是yaml的格式。配置文件的配置项在服务器启动时由服务程序从配置文件中一次性读取，程序启动后对配置文件的修改不会被加载。

部分服务则会进一步地从keystone的服务配置中加载配置信息，并且监听keystone的服务配置的变化，动态地更新服务配置。

并不是所有配置项都能从keystone的服务配置中动态加载。以下配置项是只能通过命令行参数或者文件配置指定的参数。这些配置项主要包含服务的认证信息，数据库配置信息等。

| 配置项                             | 类型      |  说明                        |
|-----------------------------------|----------|------------------------------|
| region                            | string   | 服务实例归属区域的名称, 一般为 region0 |
| application_id                    | string   | 服务的应用名称 | 
| log_level                         | string   | 输出日志的级别，默认为info，即仅输出info|warning|error的日志，可以设置为debug |
| log_verbose_level                 | int      | 日志的冗余度 （deprecated） |
| temp_path                         | string   | 存储本地临时文件的目录 |
| address                           | string   | 服务API监听地址 |
| port                              | string   | 服务API监听端口 |
| port_v2                           | string   | v2端口 （deprecated） |
| admin_port                        | string   | 管理端口 （deprecaated）|
| session_endpoint_type             | string   | 访问其他服务的Endpoint的类型，默认为 internal |
| admin_password                    | string   | Keystone服务账号密码 |
| admin_project                     | string   | Keystone服务账号所属项目 |
| admin_project_domain              | string   | Keystone服务账号所属项目的域名称，默认为Default |
| admin_user                        | string   | Keystone服务账号用户名 |
| admin_domain                      | string   | Keystone服务账号用户所属域名称，默认为 Default |
| auth_url                          | string   | keystone的认证URL，一般为 https://<keystone>:30500/v3 |
| enable_ssl                        | string   | 是否启用TLS（https） |
| ssl_certfile                      | string   | TLS证书的证书文件路径 |    
| ssl_keyfile                       | string   | TLS证书的私钥路径 |
| ssl_ca_certs                      | string   | TLS证书的CA证书路径，该选项可选，如果certfile为包含了full chain的证书，则该选项可以为空 |
| is_slave_node                     | bool     | 该运行实例是否为SLAVE状态。每个服务的定时任务只会在MASTER实例上运行 |
| config_sync_period_seconds        | int      | 从keystoneb被动同步下拉配置的时间间隔，默认为1800秒 |
| sql_connection                    | string   | 定义通用的数据库的SQL连接字符串，默认为空 |
| clickhouse                        | string   | 定义clickhouse的SQL连接字符串，默认为空 |
| ops_log_with_clickhouse           | bool     | 是否采用clickhouse来记录操作日志（opslog），默认为false，在设置了clickhouse，并且 ops_log_with_clickhouse 为true时，opslog记录保存在clickhouse |
| db_checksum_skip_init             | bool     | 开启数据库完整性校验后，是否跳过数据库的初始化。如果不跳过，则需要等待较长的数据库 checksum 重新计算的时间 |
| db_checksum_tables                | bool     | 是否开启数据库完整性校验，如果开启，则对enable_db_checksum_tables的表做完整性校验 |
| enable_db_checksum_tables         | []string | 指定数据库完整性校验的数据库表名                                   |
| auto_sync_table                   | bool     | 自动同步数据库schema，默认为false                                 |
| exit_after_db_init                | bool     | 初始化完数据库后，服务自动退出。如果auto_sync_table=true且 exit_after_db_init=true，则执行完数据库schema同步后，服务自动退出  |
| global_virtual_resource_namespace | bool     | 是否资源使用全局名字空间，默认为true，也就是不同项目的资源名称不能重复   |
| debug_sqlchemy                    | bool     | 是否打开sqlchemy的debug模式，默认为false，也就是不输出sqlchemy的日志 |
| lockman_method                    | string   | 资源锁的实现机制，可选值为inmemory和etcd，默认为inmemory。如果服务启用多实例，则应该设置为etcd，实现分布式锁 |
| etcd_lock_prefix                  | string   | etcd分布锁的key的前缀 |
| etcd_lock_ttl                     | string   | etcd锁的过期时间，默认为5秒 |
| etcd_endpoints                    | string   | ectd的服务地址列表 |
| etcd_username                     | string   | etcd认证用户名 |
| etcd_password                     | string   | etcd认证用户密码 |
| etcd_use_tls                      | string   | ectd使用启用TLS |
| etcd_skip_tls_verify              | string   | etcd启用LTS，是否验证证书有效性 |
| etcd_cacert                       | string   | etcd启用TLS，CA证书文件的路径 |
| etcd_cert                         | string   | etcd启用TLS，证书文件的路径 |
| etcd_key                          | string   | etcd启用TLS，私钥文件的路径 |
| splitable_max_duration_hours      | string   | 日志启用自动分表，每个表保存时间的间隔，默认为一个月 30*24=720 小时 |
| ops_log_max_keep_months           | string   | 日志启用自动分表，默认保留的时间间隔，默认6个月 |

如果服务运行在Kubernetes中，配置信息以yaml形式保存在onecloud命名空间（namespace）下的configmap中，例如 region 服务的配置保存在 default-region 这个configmap中，服务启动时，该configmaps的内容被挂载到容器的 /etc/yunion/<service>.conf 文件路径上，被服务以文件配置形式加载。因此，为了修改配置文件的内容，需要修改对应的configmaps的内容。

通过如下命令修改configmap的配置：

```
kubectl -n onecloud edit configmap default-region
```

修改configmap之后，需要重启服务才能使配置生效.

## Keystone服务配置

部分服务实现了从Keystone的服务配置动态加载配置参数的能力，这些服务包括：notify, log, baremetal-agent, scheduler, keystone, glance, cloudid, region, webconsole, apigateway, meter, report。

这些服务启动后，首先加载命令行参数和配置文件的配置参数，之后会加载存储在keystone的服务配置，并且保持准实时同步。在外部更新服务配置后，Keystone通过etcd推送配置更新到各个服务。

每个服务存储在Keystone的配置又分为两部分：公共配置和个性化配置。如果一个配置项同时在公共配置和个性化配置中有效，则公共配置中的配置项优先级更高。

### 公共配置

公共配置为所有服务共享的配置，存储在一个叫"common"的服务配置中，可以通过如下climc命令访问common的服务配置。

```bash
# 按json格式查看公共配置
climc service-config-show common
# 按Yaml格式编辑公共服务配置
climc service-config-edit common
```

支持的公共配置参数如下：

| 配置项                       | 类型      |  说明                                                       |
|-----------------------------|----------|-------------------------------------------------------------|
| enable_quota_check          | bool     | 是否开启配额，默认为 false，开启后，新建资源需要检查对应项目或域的配额 |
| default_quota_value         | string   | 开启配额后，新的域或项目的默认初始配额，有三种取值：unlimit(默认无上限), zero(默认0配额), default(默认初始值，由各个服务定制每个资源配额的默认值)，默认为default |
| non_default_domain_projects | bool     | 是否允许非Default域拥有项目，也就是是否允许三级权限。如果为true，则资源按照全局，域，项目三级组织 |
| time_zone                   | string   | 平台部署的时区，默认是中国时区，即 “Asia/Shanghai”                |
| domainized_namespace        | bool     | 是否每个租户是一个独立的名字空间，默认false                       |
| api_server                  | string   | 平台对外服务的地址，浏览器打开平台web控制台的URL地址               |
| customized_private_prefixes | []string | 自定义的私有IP地址段，如果不设置，则默认为 RFC1918(https://datatracker.ietf.org/doc/html/rfc1918) 定义的私有云IP地址空间 |
| global_http_proxy           | string   | 全局http代理地址  |
| global_https_proxy          | string   | 全局https代理地址 |
| ignore_nonrunning_guests    | bool     | 是否忽略未运行的虚拟机的内存分配，默认为true，即虚拟机停机后，其内存不预留，可以被其他虚拟机占用。在资源紧张的情况，一台虚拟机关机后，不能保障是否有足够的内存允许其再次启动 |
| platform_name               | string   | 平台的缺省名称 |
| platform_names              | map[string]string | 各语言下的平台名称，例如 map[string]string{"zh_CN": "云", "en_US": "Cloud"} |


### 服务个性化配置

除了公共配置，每个服务都有各自的个性化配置。可以使用如下climc命令访问存储在keystone的指定服务的配置信息：

```bash
# 按json格式查看配置
climc service-config-show <service_name>
# 按Yaml格式编辑配置信息
climc service-config-edit <service_name>
```




## Host Agent的服务配置

和其他服务的服务配置相比，Host Agent的服务配置有一些特殊。首先，Host Agent的服务配置没有实现从keystone获取服务配置的功能，只支持从命令行参数和配置文件加载配置项。其次，Host Agent的文件配置分为两部分：一部分个是公共配置，位于/etc/yunion/common/common.conf，一部分是每台宿主机的个性化配置，位于/etc/yunion/host.conf。

对于Kubernetes中部署的HostAgent服务，公共配置存储在 onecloud 命名空间下的名称为 default-host 的 configmap 中。个性化配置存储在每台宿主机的 /etc/yunion/host.conf 的配置文件中。

常见的 HostAgent 公共配置项如下：

| 配置项                  | 类型    |  说明                                                       |
|------------------------|--------|-------------------------------------------------------------|
| ExecutorSocketPath     | string | 本宿主机yunion-executor服务的监听socket地址，默认是 /var/run/onecloud/exec.sock |
| DeployServerSocketPath | string | 本宿主机host-deployer服务的监听socket地址，默认是 /var/run/onecloud/deploy.sock |
| EnableRemoteExecutor   | bool   | 是否使用yunion-executor来执行命令，默认 false。如果host在容器中运行，必须为 true   |
| ManageNtpConfiguration | bool   | HostAgent是否管理宿主机的ntp配置，默认是 true |
| DisableSecurityGroup   | bool   | 是否在本宿主机禁用安全组功能，默认是 false |
| HostCpuPassthrough     | bool   | 是否给虚拟机透传宿主机的CPU型号，如果不透传，虚拟机的CPU型号qemu64。默认为 true，即透传宿主机CPU 到虚拟机 |
| DefaultQemuVersion     | string | 缺省的qemu版本，在3.9之后，默认版本为 4.2.0，在3.9之前，默认版本是 2.12.1 |


## 查看服务的当前配置参数

从3.9开始，部分服务增加了一个app-options的API，可以获得该服务当前生效的配置参数。

可以通过如下climc命令读取指定服务的配置参数，支持的服务有：identity, compute, image, baremetal, meter

```bash
climc app-options-show <service-type>
```

可以通过如下climc命令，获取指定宿主机的host服务的配置参数：

```bash
climc host-app-options <host-id>
```