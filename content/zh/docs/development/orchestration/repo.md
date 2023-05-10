---
title: "仓库 API"
weight: 1
description:
  编排仓库相关 API
---

仓库是需要是标准的 [Helm 仓库](https://helm.sh/zh/docs/helm/helm_repo/)格式，下面是相关 API 介绍。

## 创建仓库

### 1. 命令行

```bash
# 帮助信息
$ climc k8s-repo-create --help
Usage: climc k8s-repo-create [--public] [--help] [--type {internal,external}] <NAME> <URL>

Create repo

Positional arguments:
    <NAME>
        ID or name of the repo
    <URL>
        Repository url

Optional arguments:
    [--public]
        Make repostitory public
    [--help]
        Print usage and this help message and exit.
    [--type {internal,external}] # 其中 internal 为虚拟机应用，external 为容器应用
        Repository type

# 创建容器仓库举例
$ climc --debug k8s-repo-create --type external bitnami https://charts.bitnami.com/bitnami
```

### 2. API

- 方法：POST
- 路径：/api/repos
- Body:

```javascript
{
  "name": "bitnami",
  "type": "external",
  "url": "https://charts.bitnami.com/bitnami"
}
```

- 返回结果：

```javascript
{
  "id": "22e3d2e4-9230-4380-8a6f-a378fe730625", // id
  "is_public": true, // 是否共享
  "name": "bitnami", // 名称
  "project_domain": "Default", // 所在域
  "release_count": 0, // 发布应用的数量
  "type": "external", // 类型
  "url": "https://charts.bitnami.com/bitnami" // url
}
```

## 更新仓库

### 1. 命令行

```bash
$ climc k8s-repo-update --help
Usage: climc k8s-repo-update [--url URL] [--help] [--name NAME] <NAME>

Update repo

Positional arguments:
    <NAME>
        ID or name of the repo

Optional arguments:
    [--url URL]
        Repository url to change # 更新仓库的 URL
    [--help]
        Print usage and this help message and exit.
    [--name NAME]
        Repository name to change

# 更新仓库举例
# 将 bitnami 这个仓库改名成 bitnami-new
$ climc --debug k8s-repo-update --name bitnami-new bitnami
```

2. API

- 方法：PUT
- 路径：/api/repos/$repo_id_or_name
- Body:

```javascript
{
  "name": "bitnami-new",
  "url": "https://charts.bitnami.com/bitnami"
}
```

- 返回结果：和创建的返回结果类似

## 查询仓库

### 1. 命令行

```bash
# 帮助信息
$ climc k8s-repo-list --help

List repos

Optional arguments:
    [--offset OFFSET]
        Page offset
    [--order-by ORDER_BY]
        Name of the field to be ordered by
    [--order {desc,asc}]
        List order
    [--details]
        Show more details
    [--search SEARCH]
        Filter results by a simple keyword search
    [--type {internal,external}] # 根据类型过滤
        Helm repostitory type
    [--help]
        Print usage and this help message and exit.
    [--limit LIMIT]
        Page limit

# 过滤出容器类型的应用仓库
$ climc --debug k8s-repo-list --type external
```

### 2. API

- 方法：GET
- 路径：/api/repos
- Query 参数: ?details=false&limit=20&offset=0&type=external

## 同步仓库里面的应用模版(Chart)

该操作主要用于仓库里面的应用模版更新后，需要手动同步一次模版信息。如果不执行手动同步，系统会每隔1小时周期同步一次仓库里面的应用模版(Chart)。

### 1. 命令行

```bash
# 帮助信息
$ Usage: climc k8s-repo-sync [--help] <NAME>

Not enough arguments, missing <NAME>

# 同步 bitnami 仓库
$ climc --debug k8s-repo-sync bitnami
```

### 2. API

- 方法：POST
- 路径：/api/repos/$repo_id_or_name/sync

## 删除仓库

### 1. 命令行

```bash
$ climc --debug k8s-repo-delete $repo_id_or_name
```

### 2. API

- 方法：DELETE
- 路径：/api/repos/$repo_id_or_name