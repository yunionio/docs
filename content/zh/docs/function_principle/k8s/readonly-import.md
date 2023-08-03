---
title: "只读导入"
weight: 81
description: >
  创建只读的 kubeconfig ，导入集群
---

如果只想通过 cloudpods kubeserver 服务查看 Kubernetes 集群的资源，可以创建只读的 RBAC ，然后导入相关 ServiceAccount 的 kubeconfig ，就可以实现这种场景。

操作如下：

## 创建相关 RBAC 资源

用 `kubectl apply` 创建下面的 RBAC 资源，包括 ServiceAccount(cloudpods-reader)、ClusterRole(cloudpods-read-only)、ClusterRoleBinding(cloudpods-reader-binding)。

把下面的内容保存在 readonly-res.yaml 文件中。

```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: cloudpods-reader
  namespace: default
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
  name: cloudpods-read-only
  namespace: default
rules:
  - apiGroups:
      - "*"
    resources: ["*"]
    verbs:
      - get
      - list
      - watch
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cloudpods-reader-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cloudpods-read-only
subjects:
  - kind: ServiceAccount
    name: cloudpods-reader
    namespace: default
```

将上面的 readonly-res.yaml 内容创建到要导入的 Kubernetes 集群。

```bash
$ kubectl apply -f readonly-res.yaml
```

## 生成 kubeconfig

下面是生成 kubeconfig 的脚本，将内容保存在 readonly-config.sh 文件中。

```bash
#!/bin/bash

server=$(kubectl config view --minify --output jsonpath='{.clusters[*].cluster.server}')
name=$(kubectl get secrets --namespace=default -o json | jq -r '.items[] | select(.metadata.name | test("cloudpods-reader-token-")).metadata.name')
ca=$(kubectl get secret/$name --namespace=default -o jsonpath='{.data.ca\.crt}')
token=$(kubectl get secret/$name --namespace=default -o jsonpath='{.data.token}' | base64 --decode)
namespace=$(kubectl get secret/$name --namespace=default -o jsonpath='{.data.namespace}' | base64 --decode)

echo "
apiVersion: v1
kind: Config
clusters:
- name: default-cluster
  cluster:
    certificate-authority-data: ${ca}
    server: ${server}
contexts:
- name: default-context
  context:
    cluster: default-cluster
    namespace: default
    user: default-user
current-context: default-context
users:
- name: default-user
  user:
    token: ${token}
"
```

执行 readonly-config.sh 脚本，把输出的 kubeconfig 粘贴下来。

```bash
$ bash readonly-config.sh
```

然后把生成的 kubeconfig 内容从前端导入即可，这样只有只读的操作可以执行，其他写操作都会被 Kubernetes 集群那边拒绝。

## 更新已有集群的 kubeconfig

如果是已经导入的集群，可以通过下面的命令更新对应 Kubernetes 集群的 kubeconfig：

```bash
# 把 readonly-config.sh 生成的 kubeconfig 内容保存到文件
$ bash readonly-config.sh > kubeconfig-ro.conf

# 先列出所有的 K8s 集群
$ climc k8s-cluster-list --scope system --limit 0
+----------+--------------------------------------+---------+--------------+----------------+---------+---------------+---------+-----------+----------+-------------+
|   Name   |                  Id                  | Status  | Cluster_Type | Cloudregion_Id | Vpc_Id  | Resource_Type | Version |   Mode    | Provider | Sync_Status |
+----------+--------------------------------------+---------+--------------+----------------+---------+---------------+---------+-----------+----------+-------------+
| t3       | 66bf3f7e-5ddd-4fef-8905-b4c380942352 | running | default      | default        | default | guest         | v1.17.0 | customize | onecloud | idle        |
| test122  | 2c136bb7-aab8-42f6-89d4-ed921278456c | running | default      | default        | default | guest         | v1.22.9 | customize | onecloud | idle        |
| lzx-test | a83fdc32-586f-4fad-82c6-51af34e2be76 | running | default      | default        | default | guest         | v1.17.0 | customize | onecloud | idle        |
+----------+--------------------------------------+---------+--------------+----------------+---------+---------------+---------+-----------+----------+-------------+
***  Total: 3 Pages: 1 Limit: 2048 Offset: 0 Page: 1  ***

# 假设要更新集群 test122 的 kubeconfig
$ climc k8s-cluster-set-kubeconfig 2c136bb7-aab8-42f6-89d4-ed921278456c ./kubeconfig-ro.conf
```
