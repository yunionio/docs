---
title: "Kubernetes Helm Installation"
linkTitle: "Kubernetes Helm Installation"
weight: 3
description: >
  Deploying Cloudpods CMP multi-cloud management version on Kubernetes using [Helm](https://helm.sh/)
---

## Prerequisites

{{% alert title="Note" color="warning" %}}
This solution deploys Cloudpods multi-cloud management version automatically using Helm on an existing Kubernetes cluster. 

This deployment method may cause compatibility errors due to different configurations of CSI, CNI, and Ingress controller in different Kubernetes distributions. If deployment fails and you want to quickly experience the product functionality, we recommend using the [Ocboot installation](../../cmp/allinone-multicloud) method. 

Also, VMware cannot currently be managed using Docker Compose because disk management for VMware depends on the kernel nbd module, which cannot be loaded inside docker compose. If you need to manage VMware, please use the [Ocboot installation](../../cmp/allinone-multicloud) method to deploy.

The Kubernetes distribution versions that have been verified are:
- Alibaba Cloud ACK 
- Tencent Cloud TKE
- Azure AKS
- AWS ECS

This deployment method is only applicable to the use of multi-cloud management functionality, such as managing public clouds (AWS, Alibaba Cloud, Tencent Cloud, etc.) or private clouds (ZStack, OpenStack, etc.), and cannot use built-in private cloud-related functionality (because built-in private cloud requires the installation and configuration of various virtualization software such as QEMU and OpenvSwitch on the node).
{{% /alert %}}

## Environment Setup

The Cloudpods components run on top of Kubernetes, and the environment and related software dependencies are as follows:

- Kubernetes cluster configuration requirements:
    - Kubernetes version: 1.15 ~ 1.24
    - System configuration: At least 4 CPUs, 8GB of memory, storage space for nodes of 100G.
    - Nodes need to be able to access the public network.
    - Provide an ingress controller.
    - Internal coredns resolution.
    - Support Helm. To install the helm tool, refer to https://helm.sh/docs/intro/install/
- Provide a MySQL database (optional): You can choose to use the database connected in the Kubernetes cluster or an external one. In the production environment, we recommend using an externally-managed MySQL (if a public cloud RDS service is available).

## Deployment

### Clone Chart

The Cloudpods Helm Chart is located in the https://github.com/yunionio/ocboot repository. Download it locally using the following command:

```bash
$ git clone https://github.com/yunionio/ocboot
$ cd charts/cloudpods
```

{{% alert title="Note" color="warning" %}}
Next, we will use helm to install the cloudpods chart. When using `helm install`, `--namespace onecloud` must be specified, other namespaces cannot be used.

The reason is that the operator service does not yet support deploying the platform's services to other namespaces. This will be improved later.
{{% /alert %}}

### Testing Environment Installation

The method for installing the testing environment is as follows. This method will deploy mysql and local-path-provisioner CSI dependency plugins in the Kubernetes cluster and does not require connecting to mysql outside of the cluster. 

```bash
# Note that `--namespace onecloud` cannot be changed to another. It must be onecloud
$ helm install --name-template default --namespace onecloud --debug . -f values-dev.yaml --create-namespace
```

### Production Environment Installation

The previously deployed method is only for testing because of fewer dependencies and faster installation times. In the production environment, modify the parameters in `./values-prod.yaml` according to needs and use this file to create a Helm Release.

We recommend modifying the following:
```diff
--- a/charts/cloudpods/values-prod.yaml
```+++ b/charts/cloudpods/values-prod.yaml
 localPathCSI:
+  # Depending on the deployment status of CSI in the k8s cluster, choose whether to deploy the default local-path CSI
+  # If the k8s cluster already has a stable CSI, set this value to false and do not deploy this component
   enabled: true
   helperPod:
     image: registry.cn-beijing.aliyuncs.com/yunionio/busybox:1.35.0
@@ -60,11 +62,16 @@ localPathCSI:

 cluster:
   mysql:
+    # External mysql address
     host: 1.2.3.4
+    # External mysql port
     port: 3306
+    # External mysql user, a user with root permissions is needed because cloudpods operator will create a database user for other services
     user: root
+    # External mysql password
     password: your-db-password
     statefulset:
+      # For production deployment, set this to false, otherwise a mysql will be deployed in the k8s cluster and connected using this statefulset mysql
       enabled: false
       image:
         repository: "registry.cn-beijing.aliyuncs.com/yunionio/mysql"
@@ -91,15 +98,20 @@ cluster:
   # imageRepository defines default image registry
   imageRepository: registry.cn-beijing.aliyuncs.com/yunion
   # publicEndpoint is upstream ingress virtual ip address or DNS domain
+  # The DNS domain or IP address accessible from outside the cluster
   publicEndpoint: foo.bar.com
   # edition choose from:
   # - ce: community edition
   # - ee: enterprise edition
+  # Choose to deploy the ce (open source) version
   edition: ce
   # storageClass for stateful component
+  # The storageClass used by stateful components, if not set, local-path CSI will be used.
+  # This can be adjusted according to the k8s cluster condition
   storageClass: ""
   ansibleserver:
     service:
+      # Specify the nodePort exposed by the service, which can be modified if there is a conflict with an existing service in the cluster
       nodePort: 30890
   apiGateway:
     apiService:
@@ -193,6 +205,7 @@ cluster:
     service:
       nodePort: 30889

+# Set up ingress
 ingress:
   enabled: true
+  # Set the className for ingress, for example using nginx-ingress-controller in the cluster, set className to nginx
+  # className: nginx
   className: ""
```

After modifying the values-prod.yaml file, use the following command to deploy:

```bash
# Note that the `--namespace onecloud` here cannot be changed to any other namespace. It must be onecloud
$ helm install --name-template default --namespace onecloud . -f values-prod.yaml  --create-namespace
```

## Check the deployment status of services

After using `helm install` to install the cloudpods chart, use the following command to check the status of the deployed pods.

```bash
# Under normal operating conditions, there should be these pods in the onecloud namespace
$ kubectl get pods -n onecloud```
NAME                                               READY   STATUS    RESTARTS   AGE
default-cloudpods-ansibleserver-779bcbc875-nzj6k   1/1     Running   0          140m
default-cloudpods-apigateway-7877c64f5c-vljrs      1/1     Running   0          140m
default-cloudpods-climc-6f4bf8c474-nj276           1/1     Running   0          139m
default-cloudpods-cloudevent-79c894bbfc-zdqcs      1/1     Running   0          139m
default-cloudpods-cloudid-67c7894db7-86czj         1/1     Running   0          139m
default-cloudpods-cloudmon-5cd9866bdf-c27fc        1/1     Running   0          68m
default-cloudpods-cloudproxy-6679d94fc7-gm5tx      1/1     Running   0          139m
default-cloudpods-devtool-6db6f4d454-ldw69         1/1     Running   0          139m
default-cloudpods-esxi-agent-7bcc56987b-lgpnf      1/1     Running   0          139m
default-cloudpods-etcd-q8j5c29tm2                  1/1     Running   0          145m
default-cloudpods-glance-7547c455d5-fnzqq          1/1     Running   0          140m
default-cloudpods-influxdb-c9947bdc8-x8xth         1/1     Running   0          139m
default-cloudpods-keystone-6cc64bdcc7-xhh7m        1/1     Running   0          145m
default-cloudpods-kubeserver-5544d59c98-l9d74      1/1     Running   0          140m
default-cloudpods-logger-8f56cd9b5-f9kbp           1/1     Running   0          139m
default-cloudpods-monitor-746985b5cf-l8sqm         1/1     Running   0          139m
default-cloudpods-notify-dd566cfd6-hxzr4           10/10   Running   0          139m
default-cloudpods-operator-7478b6c64b-wbg26        1/1     Running   0          72m
default-cloudpods-region-7dfd9b888-hsvv8           1/1     Running   0          144m
default-cloudpods-scheduledtask-7d69b877f7-4ltm6   1/1     Running   0          139m
default-cloudpods-scheduler-8495f85798-zgvq2       1/1     Running   0          140m
default-cloudpods-web-5bc6fcf78d-4f7lw             1/1     Running   0          140m
default-cloudpods-webconsole-584cfb4796-4mtnj      1/1     Running   0          139m
``````

## Create default management user

### Create account login Web UI

If it is an enterprise version, the frontend will prompt for registration and obtaining a license. The following operations apply to the open source version:

### Enter climc command line pod

If it is a deployment of ce (community open source version), the platform's command line tool needs to be used to create a default user and perform related operations. The corresponding command is as follows, first enter the climc pod container:

```bash
# Enter climc pod
$ kubectl exec -ti -n onecloud $(kubectl get pods -n onecloud | grep climc | awk '{print $1}') -- bash
Welcome to Cloud Shell :-) You may execute climc and other command tools in this shell.
Please exec 'climc' to get started

bash-5.1#
```

### Create user

Create an admin user inside the climc pod. The command is as follows:

```bash
# Create admin user, set password to admin@123, adjust it according to your needs
[in-climc-pod]$ climc user-create --password 'admin@123' --enabled admin

# Allow web login
[in-climc-pod]$ climc user-update --allow-web-console admin

# Add admin user to system project and give administrator privileges
[in-climc-pod]$ climc project-add-user system admin admin
```

## Access frontend

Access the platform's exposed frontend based on the created ingress. View the ingress using the following command:

```bash
# My tested cluster ingress information is as follows, different k8s clusters have different implementations based on the ingress plugin
$ kubectl get ingresses -n onecloud
NAME                    HOSTS   ADDRESS                 PORTS     AGE
default-cloudpods-web   *       10.127.100.207          80, 443   7h52m
```

Visit the platform frontend at https://10.127.100.207 using a web browser and then log in using the previously created admin user.

## Upgrade

Upgrade can be done by modifying the corresponding values yaml file and then performing upgrade configuration. For example, if the 30888 port of cluster.regionServer.service.nodePort encounters a conflict, change it to another port 30001 by modifying the corresponding value in values-prod.yaml:

```diff
--- a/charts/cloudpods/values-prod.yaml
+++ b/charts/cloudpods/values-prod.yaml
@@ -170,7 +170,7 @@ cluster:
       nodePort: 30885
   regionServer:
     service:
-      nodePort: 30888
+      nodePort: 30001
   report:
     service:
       nodePort: 30967
```

Then upgrade using the helm upgrade command:

```bash
$ helm upgrade -n onecloud default . -f values-prod.yaml
```

Then view the onecloudcluster resource. You will find that the corresponding spec.regionServer.service.nodePort becomes 30001, and the corresponding service nodePort will also change:

```bash
# View the properties of regionServer in onecloudcluster
$ kubectl get oc -n onecloud default-cloudpods -o yaml | grep -A 15 regionServer
  regionServer:
    affinity: {}
    disable: false
``````
dnsDomain: cloud.onecloud.io
dnsServer: 10.127.100.207
image: registry.cn-beijing.aliyuncs.com/yunion/region:v3.9.2
imagePullPolicy: IfNotPresent
limits:
  cpu: "1.333333"
  memory: 2045Mi
replicas: 1
requests:
  cpu: 10m
  memory: 10Mi
service:
  nodePort: 30001

# View the nodePort of the default-cloudpods-region service
$ kubectl get svc -n onecloud | grep region
default-cloudpods-region          NodePort    10.110.105.228   <none>        30001:30001/TCP                   7h30m
```

Check if the cluster.regionServer.service.nodePort that was previously changed has changed in the platform endpoint:

```bash
# Use the climc pod to specify the endpoint-list command
$ kubectl exec -ti -n onecloud $(kubectl get pods -n onecloud | grep climc | awk '{print $1}') -- climc endpoint-list --search compute
+----------------------------------+-----------+----------------------------------+----------------------------------------+-----------+---------+
|                ID                | Region_ID |            Service_ID            |                  URL                   | Interface | Enabled |
+----------------------------------+-----------+----------------------------------+----------------------------------------+-----------+---------+
| c88e03490c2543a987d86d733b918a2d | region0   | a9abfdd204e9487c8c4d6d85defbfaef | https://10.127.100.207:30001           | public    | true    |
| a04e161ee71346ac88ddd04fcebfe5ce | region0   | a9abfdd204e9487c8c4d6d85defbfaef | https://default-cloudpods-region:30001 | internal  | true    |
+----------------------------------+-----------+----------------------------------+----------------------------------------+-----------+---------+
***  Total: 2 Pages: 1 Limit: 20 Offset: 0 Page: 1  ***
```

## Deleting

```bash
$ helm delete -n onecloud default
```

## Other issues

### 1. onecloud namespace is missing keystone, glance, region pod, etc.

If you execute `kubectl get pods -n onecloud` after executing `helm install` and only operator pod appears, without keystone, glance, region and other platform-related service pods, you can use the following command to check the operator pod log to troubleshoot the issue.The reason for this situation is generally caused by errors when the operator creates Keystone, Region, and other platform-related services. Common problems include the operator not being able to use the relevant MySQL user to create users and databases, or after creating the Keystone service, the Keystone pod cannot be accessed through the K8s internal service domain name, and so on.

```bash
# Redirect all logs of the operator to a file
$ kubectl logs -n onecloud $(kubectl get pods -n onecloud | grep operator | awk '{print $1}') > /tmp/operator.log
# Then check if there are any relevant errors in /tmp/operator.log

# Check if there is a requeuing keyword in the operator logs, and generally errors will be reflected here
$ kubectl logs -n onecloud $(kubectl get pods -n onecloud | grep operator | awk '{print $1}') | grep requeuing
```
