---
title: "应用模版 API"
weight: 2
description:
  编排应用模版相关 API
---

一个仓库里面包含多个应用模版，应用模版也叫做 [Helm Chart](https://helm.sh/zh/docs/topics/charts/) 

## 列举出仓库下面的模版

应用模版属于某一个仓库，所以查询时必须提供仓库名称。

### 1. 命令行

```bash
# 帮助信息
$ $ climc --debug k8s-chart-list --help
--all-version         -- Get Chart all history versions
--field               -- Show only specified fields
--filter              -- Filters
--filter-any          -- If true, match if any of the filters matches; otherwise, match if all of the filters match
--help                -- Print usage and this help message and exit.
--keyword             -- Chart keyword
--limit               -- Page limit
--meta                -- Piggyback metadata information
--name                -- List by name
--offset              -- Page offset
--pending-delete      -- Show only pending deleted resources
--search              -- Filter results by a simple keyword search
--version             -- Chart semver version filter

# 查询 bitnami 仓库下面的应用模版
$ climc --debug k8s-chart-list --repo bitnami
```

### 2. API

- 方法：GET
- 路径：/api/charts
- Query 参数: ?repo=bitnami

```bash
# 查询 bitnami 仓库下所有版本的应用模版
/api/charts?repo=bitnami&all_version=true

# 查询 bitnami 仓库下的 etcd 应用模版
/api/charts?name=etcd&repo=bitnami-new

# 查询 bitnami 仓库下的 etcd 应用模版的所有版本
/api/charts?name=etcd&repo=bitnami-new&all_version=true
```

## 查询仓库下面的模版

### 1. 命令行

```bash
# 帮助信息
$ climc k8s-chart-show --help
Usage: climc k8s-chart-show [--help] [--version VERSION] <REPO> <NAME>

Show details of a chart

Positional arguments:
    <REPO>
        Repo of the chart
    <NAME>
        Chart name

Optional arguments:
    [--help]
        Print usage and this help message and exit.
    [--version VERSION]
        Chart version

# 查看 bitnami 仓库里面的 etcd 应用模版详情
$ climc --debug k8s-chart-show  bitnami etcd

# 查看 bitnami 仓库里面的 etcd 8.5.8 版本的应用模版详情
$ climc --debug k8s-chart-show  --version 8.5.8 bitnami-new etcd
```

### 2. API

- 方法：GET
- 路径：/api/charts/$chart_id_or_name
- Query 参数: ?repo=bitnami&version=x.x.x

```bash
# 查询 bitnami 仓库下 etcd 应用模版详情
/api/charts/etcd?repo=bitnami

# 查询 bitnami 仓库下 etcd 8.5.8 版本应用模版详情
/api/charts/etcd?repo=bitnami&version=8.5.8
```

- 返回结果：返回结果是标准的 helm chart 内容，包含了所有文件数据，可通过上面的 `climc --debug k8s-chart-show` 查看到。