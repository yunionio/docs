---
title: "服务配置管理"
date: 2019-08-04T20:51:23+08:00
weight: 50
description: >
  介绍基于Keystone的服务配置管理原理
---

Keystone提供了服务配置管理的基础设施，方便管理各个服务的配置。

## 服务配置

每个服务的配置信息包含几部分：

| 配置参数位置                      | 优先级 |
|-----------------------------------|--------|
| 默认参数配置                      | 0      |
| 命令行参数                        | 100    |
| 配置文件内定义的参数              | 200    |
| 存储在keystone配置数据库里的参数  | 300    |


如果一个参数同时在以上三个地方都有定义，优先级高的优先生效。

举例： keystone服务的配置参数 password_error_lock_count 定义了本地用户连续输错密码后被锁定的最大次数。默认值为0。则在没有在任何地方设置该参数的情况下，该参数的值为 0。如果管理员设置在启动keystone服务的时候，指定启动参数 --password-error-lock-count=6，则该参数值为 6。如果管理员在 keystone 的配置文件 /etc/yunion/keystone.conf 中配置了该参数，则以配置文件的值为准。进而，如果管理员在 keystone 服务的数据库保存的配置中设置了该参数，则以数据库设置的值为准。

## 访问存储在数据库的配置

存储在keystone数据库的配置需要通过API来访问，keystone提供了对配置的查看和修改操作，以提供了对应的climc命令。

### 查看配置

查看指定服务的配置：

```bash
# 查看 keystone 服务配置
climc service-config-show keystone
# 查看 region 服务配置
climc service-config-show region2
# 查看 glance 服务配置
climc service-config-show glance
```

### 修改配置

修改指定服务的指定配置项

```bash
# 以key=value形式修改，只能修改default section的配置
climc service-config keystone --config 'password_error_lock_count=5'
# 以JSON形式修改
climc service-config keystone --config '{"default":{"password_error_lock_count":5}}'
```

### 删除配置

还是使用service-config子命令，但是加上 --remove 参数来删除指定的配置项，配置的值可以任意

```bash
climc service-config keystone --config 'password_error_lock_count=0' --remove
```

### 交互式修改

还可以调用 service-config-edit 子命令，改子命令将调用 vim，允许用户交互式地批量修改配置

```bash
climc service-config-edit keystone
```

### 不能存储在数据库的配置

出于避免循环依赖和避免误配置引起服务无法启动的风险，部分配置项无法存储在数据库，例如定义数据库配置的配置项，本地开启debug日志的配置项等，具体可查看 pkg/apis/identity/consts.go#ServiceBlacklistOptionMap

### 公共配置

有部分配置项是所有服务或者是若干服务共享的，这部分公共配置项可以通过一个特殊的虚拟服务 common 来访问：

```
# 查看公共配置项
climc service-config-show common
# 修改公共配置项
climc service-config-edit common
```

如下为一些公共配置项和含义：


## 获得服务最终生效的配置

从以上介绍可以看出，一个服务的配置项可以在多个地方配置，如何确认一个参数最终生效的配置值？这里提供了一个climc命令来查看各个服务最终生效的配置参数。

```
climc app-options-show <service>
# 查看keystone服务配置
climc app-options-show keystone
```

## 配置变更的生效

在管理员更新了数据库中的配置项后，该配置项能够自动下发到服务并生效。其原理为：所有服务在启动之后，都会监听etcd的配置变更通道，当管理员请求keystone的API更新了指定服务的配置项后，keystone会通过etcd通知对应服务，对应服务会拉取更新其配置。如果该配置生效需要重启服务，则会在没有API请求的情况下，自动重启服务，实现配置的生效。
