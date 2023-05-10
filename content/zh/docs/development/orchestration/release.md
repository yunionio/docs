---
title: "应用发布 API"
weight: 3
description:
  编排应用发布相关 API
---

发布一个应用叫做 [Release](https://helm.sh/zh/docs/glossary/#%E5%8F%91%E5%B8%83%E7%89%88%E6%9C%AC)，单个应用模版(Chart)可以在同一个集群中安装多次，并能创建多个不同的版本。

## 发布应用（创建 Release）

### 1. 命令行

```bash
# 帮助信息
$ climc k8s-release-create --help
Create release

Positional arguments:
    <CHARTNAME> # 基于哪个仓库的 chart 创建
        Helm chart name, e.g stable/etcd

Optional arguments:
    [--cluster CLUSTER] # 创建到的目标 K8s 集群
        Kubernetes cluster name
    [--values|-f VALUES] # 发布应用的参数
        Specify values in a YAML file (can specify multiple)
    [--version VERSION] # 指定发布的版本，不提供默认就用最新的
        Specify the exact chart version to install. If not specified, latest version installed
    [--dry-run]
        Simulate an install
    [--details]
        Show release deploy details, include kubernetes created resources
    [--timeout TIMEOUT]
        Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks)
    [--name NAME] # 发布的名称
        Release name, If unspecified, it will autogenerate one for you
    [--help]
        Print usage and this help message and exit.
    [--namespace NAMESPACE] # 创建到的 K8s namespace
        Namespace of this resource

# K8s 集群可以通过下面的命令查询到
$ climc --debug k8s-cluster-list

# Namespace 使用下面的命令查询
$ climc --debug k8s-namespace-list --cluster $cluster_id

# 发布 bitnami 仓库的 etcd 应用仓库到 K8s 集群 test122 的 default namespace
$ climc --debug k8s-release-create --cluster test122 --namespace default --name etcd-release bitnami-new/etcd
```

### 2. API

- 方法: POST
- 路径: /api/releases
- Body 参数:

```javascript
{
  "chart_name": "bitnami-new/etcd",
  "cluster": "test122",
  "namespace": "default",
  "release_name": "etcd-release",
}
```

## 列举发布的应用

### 1. 命令行

```bash
# 帮助信息
$ climc k8s-release-list --help

List releases

Optional arguments:
    [--limit LIMIT]
        Page limit
    [--offset OFFSET]
        Page offset
    [--details]
        Show more details
    [--search SEARCH]
        Filter results by a simple keyword search
    [--name NAME]
        List by name
    [--namespace NAMESPACE]
        Namespace of this resource
    [--deployed]
        Show deployed status releases
    [--deleting]
        Show deleting status releases
    [--failed]
        Show failed status releases
    [--superseded]
        Show superseded status releases
    [--pending]
        Show pending status releases
    [--type {internal,external}]
        Release type
    [--help]
        Print usage and this help message and exit.
    [--cluster CLUSTER]
        Kubernetes cluster name

# 查询所有的容器应用
$ climc --debug k8s-release-list --type external

# 查询发布的 etcd-release 应用
$ climc --debug k8s-release-list --type external --name etcd-release

# 查询 test122 K8s 集群下的应用
$ climc --debug k8s-release-list --cluster test122
```

### 2. API

- 方法：GET
- 路径：/api/repos
- Query 参数: ?all=true&cluster=test122?details=false&limit=20&offset=0&type=external

## 查询发布的应用详情

使用这个接口，可以列举出一个 release 下面所有创建到 K8s 集群里面的资源，以及使用创建参数等。

### 1. 命令行

```bash
# 帮助信息
$ climc --debug k8s-release-show etcd-release
Get helm release details

Positional arguments:
    <NAME>
        Name ident of the resource

Optional arguments:
    [--namespace NAMESPACE]
        Namespace of this resource
    [--help]
        Print usage and this help message and exit.
    [--cluster CLUSTER]
        Kubernetes cluster name


# 查询 etcd-release 发布
$ climc --debug k8s-release-show etcd-release
```

### 2. API

- 方法：GET
- 路径：/api/releases/$release_id_or_name
- 返回结果：

```javascript
{
  "chart": "etcd",
  "chart_version": "8.11.1",
  "cluster": "test122",
  "clusterID": "2c136bb7-aab8-42f6-89d4-ed921278456c",
  "cluster_id": "2c136bb7-aab8-42f6-89d4-ed921278456c",
  "config": {},
  "created_at": "2023-05-10T18:13:39Z",
  "external_id": "2c136bb7-aab8-42f6-89d4-ed921278456c/default/etcd-release",
  "id": "d44c4dc7-618a-4070-833a-6d6464e8ad83",
  "is_emulated": false,
  "name": "etcd-release",
  "namespace": "default",
  "namespace_id": "18f51c33-5ff4-41f6-8396-2bcb3174ffa5",
  "progress": 0,
  "project_domain": "Default",
  "repo_id": "22e3d2e4-9230-4380-8a6f-a378fe730625",
  "resources": {
    "k8s_service": [ ... ], // 对应 k8s service 资源
    "secret": [ ... ], // 对应 k8s secret 资源
    "statefulset": [ ... ] // 对应 k8s statefulset 资源
  },
  "status": "deployed", // 部署状态
  "type": "external", // 类型，external 为容器应用
  "version": 1 // 发布的版本
}
```

## 更新发布的应用

每一个发布的应用，都可以进行更新操作

### 1. 命令行操作

```bash
# 帮助信息
$ climc k8s-release-upgrade --help
Upgrade release

Positional arguments:
    <NAME>
        Release instance name
    <CHARTNAME>
        Helm chart name, e.g stable/etcd

Optional arguments:
    [--cluster CLUSTER]
        Kubernetes cluster name
    [--values|-f VALUES]
        Specify values in a YAML file (can specify multiple)
    [--version VERSION]
        Specify the exact chart version to install. If not specified, latest version installed
    [--dry-run]
        Simulate an install
    [--details]
        Show release deploy details, include kubernetes created resources
    [--timeout TIMEOUT]
        Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks)
    [--reuse-values]
        When upgrading, reuse the last release's values, and merge in any new values. If '--reset-values' is specified, this is ignored
    [--reset-values]
        When upgrading, reset the values to the ones built into the chart
    [--help]
        Print usage and this help message and exit.
    [--namespace NAMESPACE]
        Namespace of this resource

# 先查询 bitnami-new 仓库里面的 etcd 应用模版都有哪些配置，可以通过以下的操作获取 chart 的详情，找到里面的 values 关键字，对应的值就是创建 release 时的默认配置
$ climc --debug k8s-chart-show bitnami-new etcd
# 可以找到上面命令输出的 CURL 命令，然后手动执行下面的操作，就可以找出 values 默认配置，比如：
$ curl -k -X 'GET' -H 'Accept: */*' -H 'Accept-Encoding: *' -H 'Content-Length: 0' -H 'Content-Type: application/json' -H 'User-Agent: yunioncloud-go/201708' -H 'X-Auth-Token: gAAAAABkW-Y7PQ18-YtqEV6jNFXp69f6JPrLtSAW1XZ-JlXEkuQzh44kiiwa9XkpfFBnwpgoVOmMm6gr0q59YWIZZ8KV0dbuIcYTT-DHs-iRpF6kdCKb2bzl6dn10kseMKbWj0CmQWCfHBaMuLbQM36_-FDKvg0l3MsuwGlSpO-LCrrLJIHJUGXEJ2b9fsKlp9HYinHJzOlZ' 'https://10.127.100.2:30442/api/charts/etcd?repo=bitnami-new' | jq .chart.chart.values
{
  "affinity": {},
  "args": [],
  "auth": {
    "client": {
      "caFilename": "",
      "certFilename": "cert.pem",
      "certKeyFilename": "key.pem",
      "enableAuthentication": false,
      "existingSecret": "",
      "secureTransport": false,
      "useAutoTLS": false
    },
    "peer": {
      "caFilename": "",
      "certFilename": "cert.pem",
      "certKeyFilename": "key.pem",
      "enableAuthentication": false,
      "existingSecret": "",
      "secureTransport": false,
      "useAutoTLS": false
    },
    "rbac": {
      "allowNoneAuthentication": true,
      "create": true,
      "existingSecret": "",
      "existingSecretPasswordKey": "",
      "rootPassword": ""
    },
    "token": {
      "enabled": true,
      "privateKey": {
        "existingSecret": "",
        "filename": "jwt-token.pem"
      },
      "signMethod": "RS256",
      "ttl": "10m",
      "type": "jwt"
    }
  },
  "autoCompactionMode": "",
  "autoCompactionRetention": "",
  "clusterDomain": "cluster.local",
  "command": [],
  "commonAnnotations": {},
  "commonLabels": {},
  "configuration": "",
  "containerPorts": {
    "client": 2379,
    "peer": 2380
  },
  "containerSecurityContext": {
    "allowPrivilegeEscalation": false,
    "enabled": true,
    "runAsNonRoot": true,
    "runAsUser": 1001
  },
  "customLivenessProbe": {},
  "customReadinessProbe": {},
  "customStartupProbe": {},
  "diagnosticMode": {
    "args": [
      "infinity"
    ],
    "command": [
      "sleep"
    ],
    "enabled": false
  },
  "disasterRecovery": {
    "cronjob": {
      "historyLimit": 1,
      "nodeSelector": {},
      "podAnnotations": {},
      "resources": {
        "limits": {},
        "requests": {}
      },
      "schedule": "*/30 * * * *",
      "snapshotHistoryLimit": 1,
      "snapshotsDir": "/snapshots",
      "tolerations": []
    },
    "enabled": false,
    "pvc": {
      "existingClaim": "",
      "size": "2Gi",
      "storageClassName": "nfs"
    }
  },
  "existingConfigmap": "",
  "extraDeploy": [],
  "extraEnvVars": [],
  "extraEnvVarsCM": "",
  "extraEnvVarsSecret": "",
  "extraVolumeMounts": [],
  "extraVolumes": [],
  "fullnameOverride": "",
  "global": {
    "imagePullSecrets": [],
    "imageRegistry": "",
    "storageClass": ""
  },
  "hostAliases": [],
  "image": {
    "debug": false,
    "digest": "",
    "pullPolicy": "IfNotPresent",
    "pullSecrets": [],
    "registry": "docker.io",
    "repository": "bitnami/etcd",
    "tag": "3.5.8-debian-11-r8"
  },
  "initContainers": [],
  "initialClusterState": "",
  "kubeVersion": "",
  "lifecycleHooks": {},
  "livenessProbe": {
    "enabled": true,
    "failureThreshold": 5,
    "initialDelaySeconds": 60,
    "periodSeconds": 30,
    "successThreshold": 1,
    "timeoutSeconds": 5
  },
  "logLevel": "info",
  "maxProcs": "",
  "metrics": {
    "enabled": false,
    "podAnnotations": {
      "prometheus.io/port": "{{ .Values.containerPorts.client }}",
      "prometheus.io/scrape": "true"
    },
    "podMonitor": {
      "additionalLabels": {},
      "enabled": false,
      "interval": "30s",
      "namespace": "monitoring",
      "relabelings": [],
      "scheme": "http",
      "scrapeTimeout": "30s",
      "tlsConfig": {}
    },
    "prometheusRule": {
      "additionalLabels": {},
      "enabled": false,
      "namespace": "",
      "rules": []
    }
  },
  "nameOverride": "",
  "networkPolicy": {
    "allowExternal": true,
    "enabled": false,
    "extraEgress": [],
    "extraIngress": [],
    "ingressNSMatchLabels": {},
    "ingressNSPodMatchLabels": {}
  },
  "nodeAffinityPreset": {
    "key": "",
    "type": "",
    "values": []
  },
  "nodeSelector": {},
  "pdb": {
    "create": true,
    "maxUnavailable": "",
    "minAvailable": "51%"
  },
  "persistence": {
    "accessModes": [
      "ReadWriteOnce"
    ],
    "annotations": {},
    "enabled": true,
    "labels": {},
    "selector": {},
    "size": "8Gi",
    "storageClass": ""
  },
  "persistentVolumeClaimRetentionPolicy": {
    "enabled": false,
    "whenDeleted": "Retain",
    "whenScaled": "Retain"
  },
  "podAffinityPreset": "",
  "podAnnotations": {},
  "podAntiAffinityPreset": "soft",
  "podLabels": {},
  "podManagementPolicy": "Parallel",
  "podSecurityContext": {
    "enabled": true,
    "fsGroup": 1001
  },
  "priorityClassName": "",
  "readinessProbe": {
    "enabled": true,
    "failureThreshold": 5,
    "initialDelaySeconds": 60,
    "periodSeconds": 10,
    "successThreshold": 1,
    "timeoutSeconds": 5
  },
  "removeMemberOnContainerTermination": true,
  "replicaCount": 1,
  "resources": {
    "limits": {},
    "requests": {}
  },
  "runtimeClassName": "",
  "schedulerName": "",
  "service": {
    "annotations": {},
    "clientPortNameOverride": "",
    "clusterIP": "",
    "enabled": true,
    "externalIPs": [],
    "externalTrafficPolicy": "Cluster",
    "extraPorts": [],
    "headless": {
      "annotations": {}
    },
    "loadBalancerIP": "",
    "loadBalancerSourceRanges": [],
    "nodePorts": {
      "client": "",
      "peer": ""
    },
    "peerPortNameOverride": "",
    "ports": {
      "client": 2379,
      "peer": 2380
    },
    "sessionAffinity": "None",
    "sessionAffinityConfig": {},
    "type": "ClusterIP"
  },
  "serviceAccount": {
    "annotations": {},
    "automountServiceAccountToken": true,
    "create": false,
    "labels": {},
    "name": ""
  },
  "shareProcessNamespace": false,
  "sidecars": [],
  "startFromSnapshot": {
    "enabled": false,
    "existingClaim": "",
    "snapshotFilename": ""
  },
  "startupProbe": {
    "enabled": false,
    "failureThreshold": 60,
    "initialDelaySeconds": 0,
    "periodSeconds": 10,
    "successThreshold": 1,
    "timeoutSeconds": 5
  },
  "terminationGracePeriodSeconds": "",
  "tolerations": [],
  "topologySpreadConstraints": [],
  "updateStrategy": {
    "type": "RollingUpdate"
  },
  "volumePermissions": {
    "enabled": false,
    "image": {
      "digest": "",
      "pullPolicy": "IfNotPresent",
      "pullSecrets": [],
      "registry": "docker.io",
      "repository": "bitnami/bitnami-shell",
      "tag": "11-debian-11-r113"
    },
    "resources": {
      "limits": {},
      "requests": {}
    }
  }
}


# 参考默认 values 配置，比如现在只想更新 image.tag ，改成 "3.5.8-debian-11-r9"
# 写一个 values.yaml，内容如下
$ cat values.yaml
image:
  tag: "3.5.8-debian-11-r9" 

# 更新 etcd-release 里面 statefulset 的镜像
$ climc --debug k8s-release-upgrade --values ./values.yaml etcd-release bitnami-new/etcd

# 也可以根据 chart 的版本来更新
$ climc --debug k8s-release-upgrade --version 8.11.2 etcd-release bitnami-new/etcd
```

2. API

- 方法：PUT
- 路径：/api/releases/etcd-release
- Body:

```javascript
{
  "chart_name": "bitnami-new/etcd",
  "release_name": "etcd-release",
  "values_json": {
    "image": {
      "tag": "3.5.8-debian-11-r9"
    }
  }
}
```

## 查询发布历史

### 1. 命令行

```bash
# 帮助信息
$ Get release history

Positional arguments:
    <NAME>
        Release instance name

Optional arguments:
    [--cluster CLUSTER]
        Kubernetes cluster name
    [--max MAX]
        History limit size
    [--help]
        Print usage and this help message and exit.
    [--namespace NAMESPACE]
        Namespace of this resource

# 查询 etcd-release 的发布历史
$ climc --debug k8s-release-history etcd-release
```

### 2. API

- 方法：GET
- 路径：api/releases/etcd-release/history
- 返回结果：

```javascript
[
  {
    "chart": "etcd-8.11.1",
    "description": "Install complete",
    "revision": 1,
    "status": "deployed",
    "updated": "2023-05-10T18:13:41.426737434Z"
  },
  {
    "chart": "etcd-8.11.1",
    "description": "Install complete",
    "revision": 2,
    "status": "deployed",
    "updated": "2023-05-10T20:13:41.426737434Z"
  },
  {
    "chart": "etcd-8.11.2",
    "description": "Install complete",
    "revision": 3,
    "status": "deployed",
    "updated": "2023-05-10T21:13:41.426737434Z"
  }
]
```

## 回滚到某一版本

根据发布历史，可以回滚到历史的发布版本。

### 1. 命令行操作

```bash
# 帮助信息
$ climc k8s-release-rollback --help
Usage: climc k8s-release-rollback [--cluster CLUSTER] [--description DESCRIPTION] [--help] [--namespace NAMESPACE] <NAME> <REVISION>

Rollback release by history revision number

Positional arguments:
    <NAME>
        Release instance name
    <REVISION>
        Release history revision number

Optional arguments:
    [--cluster CLUSTER]
        Kubernetes cluster name
    [--description DESCRIPTION]
        Release rollback description string
    [--help]
        Print usage and this help message and exit.
    [--namespace NAMESPACE]
        Namespace of this resource

# 回顾 etcd-release 到第二个版本
$ climc --debug k8s-release-rollback etcd-release 2
```

### 2. API

- 方法：POST
- 路径: /api/releases/etcd-release/rollback
- Body:

```javascript
{
  "revision": 2
}
```

## 删除发布的应用

### 命令行

```bash
# 帮助信息
$ climc --debug k8s-release-delete --help
Usage: climc k8s-release-delete [--cluster CLUSTER] [--help] [--namespace NAMESPACE] <NAME>

Delete release

Positional arguments:
    <NAME>
        Release instance name

Optional arguments:
    [--cluster CLUSTER]
        Kubernetes cluster name
    [--help]
        Print usage and this help message and exit.
    [--namespace NAMESPACE]
        Namespace of this resource

# 删除 etcd-release
$ climc --debug k8s-release-delete etcd-release
```

### 2. API

- 方法：DELETE
- 路径：/api/releases/etcd-release