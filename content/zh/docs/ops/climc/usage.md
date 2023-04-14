---
title: "climc 使用"
weight: 3
description: >
    介绍如何使用Climc命令行工具。
---

### 参数说明

```shell
# 查看climc帮助信息
$ climc --help | head
Usage: climc [--version] [--timeout TIMEOUT] [--insecure|-k] [--cert-file CERT_FILE] [--key-file KEY_FILE] [--completion {bash,zsh}] [--use-cached-token] [--os-username OS_USERNAME] [--os-password OS_PASSWORD] [--os-project-name OS_PROJECT_NAME] [--os-project-domain OS_PROJECT_DOMAIN] [--os-domain-name OS_DOMAIN_NAME] [--os-access-key OS_ACCESS_KEY] [--os-secret-key OS_SECRET_KEY] [--os-auth-token OS_AUTH_TOKEN] [--os-auth-url OS_AUTH_URL] [--os-region-name OS_REGION_NAME] [--os-zone-name OS_ZONE_NAME] [--os-endpoint-type {publicURL,internalURL,adminURL}] [--output-format {table,kv,json,flatten-table,flatten-kv}] [--parallel-run PARALLEL_RUN] [--help] [--debug] <SUBCOMMAND> ...

Command-line interface to the API server.

Positional arguments:
    <SUBCOMMAND>
        cloud-account-sync
          Sync cloudaccount
        lbbackend-list
          List lbbackends
# [--xxx] 以中括号括起来的参数都是可选参数, 可传可不传
# [--xxx|-x] 此参数后面不需要跟任何参数,--xxx和-x效果相同, 可任意使用, 例如: --debug, -k
# [--xxx XXX] 此参数后面必须跟一个参数, 例如: --timeout 300
# [--xxx {xxx,xxx,xxx}] 此参数后面必须跟一个参数, 且参数必须是在大括号之内的一个, 例如: --os-endpoint-type publicURL
# <XXXX> 此参数属于必传参数, 若存在多个尖括号参数, 则需要根据尖括号参数顺序依次传参, 例如上面的<SUBCOMMAND> 可以指定为 cloud-account-sync
# 以上参数必须跟在climc命令之后

# 组合上面的参数命令为
$ climc --debug -k --timeout --os-endpoint-type publicURL cloud-account-sync

# 查看子命令帮助信息 climc <SUBCOMMAND> --help, 例如:
$ climc cloud-account-sync --help
Usage: climc cloud-account-sync [--full-sync] [--deep-sync] [--xor] [--region REGION] [--zone ZONE] [--host HOST] [--resources {project,compute,network,eip,loadbalancer,objectstore,rds,cache,event,cloudid,dnszone,public_ip,intervpcnetwork,saml_auth,quota,nat,nas,waf,mongodb,es,kafka,app,cdn,container,ipv6_gateway,tablestore,modelarts,vpcpeer,misc}] [--help] [--force] <ID>

Sync cloudaccount

Positional arguments:
    <ID>
        ID or Name of cloud account

Optional arguments:
    [--full-sync]

# 此时显示的所有参数都需要跟在子命令之后, 注意有个<ID>参数需要必填,这里以aliyun-account举例, 例如
$ climc cloud-account-sync --full-sync aliyun-account

# <SUBCOMMAND> 子命令列表非常多, 可以通过关键字过滤查找, 例如找可用区:
$ climc --help | grep zone

```

### 运行模式

climc 有命令行运行和交互两种运行模式。

- 命令行运行: 执行完对应的资源操作命令就退出，这种模式你知道自己在做什么，并且可以作为 bash function/script 的一部分。

```bash
# 删除 server1, server2, server3
for id in server1 server2 server3; do
	climc server-update --delete enable $id
	climc server-delete $id
done
```

- 交互模式: 在 shell 输入 climc，就会进入交互模式，这种模式下有自动补全和参数提示。
![](../images/climc-repl.png)

### 子命令语法

云平台有很多资源，对应 climc 的子命令, 比如 `climc server-list` 中的 `server-list` 就是子命令，可以查询虚拟机的列表。通用格式如下:

```bash
<Resource>-<Action>: Resource 表示资源, Action 表示行为
```

语法举例:

- server-delete: 删除虚拟机
  - server 是资源, delete 是行为
- host-list: 查询宿主机列表
  - host 是资源, list 是行为

CRUD 举例:

- *C*: server-create, disk-create 创建资源
- *R*: server-show, disk-list 查询资源
- *U*: server-update, host-update 更新资源
- *D*: server-delete, image-delete 删除资源

行为举例:

Resource-Action 中的 Action 会对应资源的操作，不同的资源会根据可进行的操作进行命名。

- server-migrate: migrate 表示迁移虚拟机
- server-change-config: change-config 表示调整虚拟机配置
- host-ipmi: ipmi 表示查询宿主机的 IPMI 信息

想要知道资源有哪些操作，可以进入交互模式补全查询。

### 高级过滤 filter

```shell
# filter 参数可参考: https://github.com/yunionio/cloudpods/blob/master/pkg/apis/list.go#L132
$ climc <Resource>-list --filter 'condition1' --filter 'condition2'
```


### Debug 模式

如果想要知道 climc 操作资源时究竟和服务端发生了哪些请求，可以在子命令前面使用 *--debug* 参数，使用方式如下:

```bash
climc --debug <Resource>-<Action>
```

加上 --debug 参数后，终端会有彩色的输出提示，比如 `climc --debug server-list` 输出如下:

![](../images/climc-debug.png)

其中 CURL 部分是可以直接粘贴出来在命令行执行的。

#### 颜色约定

- Request 使用黄色
- CURL 使用蓝绿色
- 根据状态码显示不同颜色，可参考代码: https://github.com/yunionio/pkg/blob/master/util/httputils/httputils.go#L754

#### 在bash或zsh下的命令行参数提示补全

climc支持bash或zsh的命令行参数自动提示补全。

下面以bash为例说明，在使用climc之前，执行如下命令初始化环境。

```bash
# 启用bash命令行参数自动补全
source <(climc --completion bash)
```

之后在bash中可以在输入climc命令后，通过tab获得命令行参数的提示。

为了方便使用，推荐将该命令放到$HOME/.bashrc或$HOME/.bash_profile中自动初始化环境。

