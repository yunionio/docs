---
title: "修改OC更新集群状态"
weight: 95
oem_ignore: true
description: >
    介绍通过修改OC（cloudpods-operator的CRD资源）来更新集群的状态
---

cloudpods-operator会在Kubernetes集群中注入CRD资源oc，该CRD定义了一个服务集群的状态，可以通过修改oc来更改集群的状态，达到IaC的效果。

1、修改集群整体状态

主要几个参数：

* disableResourceManagement: true|false

是否关闭cgroup v1的资源限制，该选项默认关闭。对于一些较新操作系统，如CentOS 8等，只能支持cgroup v2 API，如果开启了资源限制，会导致容器无法启动。此时需要关闭cgroup v1资源限制。

* disableLocalVpc: true|false

是否关闭内置私有云的VPC功能，该选项默认关闭。

* enableCloudNet: true|false

是否开启Cloudnet组件，该选项默认关闭

* enableS3Gateway: true|false

是否开启S3网关服务，该选项默认关闭

* productVersion: CMP|Edge|FullStack

集群的部署模式，三个选项：CMP(只部署云管相关功能组件)，Edge（是部署内置私有云相关功能组件），FullStack（部署云管和内置私有云所有功能组件）

* imageRepository: <string>

指定集群的镜像repo地址，默认是 registry.cn-beijing.aliyuncs.com/yunion

* loadBalancerEndpoint: <ip>

访问集群控制服务的虚拟IP地址或者域名

* version: <string>

集群的主版本号，如v3.8.15。当组件的tag未指定时，默认用version作为镜像的tag。可以通过修该属性实现集群镜像版本的整体切换。

* region: <string>

当前区域，默认为 region0

* zone: <string>

当前可用区，默认为 zone0


2. 修改单个组件的属性

每个组件都可以设置如下属性：

* disable: true|false

该组件是否禁用，默认是false。如果设置为true，则operator不会更新对应的k8s资源（deployment或者daemonset)

* imageName: <string>

镜像的名称

* imagePullPolicy: <string>

镜像的拉取策略，默认为 IfNotPresent, 还可以设置为： Always

* repository: <string>

改组件的镜像地址，该属性override全局的 imageRepository 属性

* tag: <string>

镜像的tag，该属性override全局的 version 属性


支持的组件列表如下：

| 组件名称                 | 功能                               | 开源版 | 商业版 |
|-------------------------|-----------------------------------|-------|-------|
| ansibleserver           | ansible管理服务                    |  (x)  |  (x)  |
| apiGateway              | API网关服务                        |  (x)  |  (x)  |
| autoupdate              | 更新服务                           |       |  (x)  |
| baremetalagent          | 裸金属代理，负责裸金属服务器的API和操作 |  (x)  |  (x)  |
| climc                   | 提供climc的容器                     | (x)  | (x)   |
| cloudevent              | cloudevent服务，提供公有云日志收集    | (x)  | (x)   |
| cloudid                 | 负责CloudSSO功能组件                | (x)  | (x)   |
| cloudmon                | 监控数据采集服务                     | (x)  | (x)   |
| cloudnet                | 云间网络服务                        | (x)  | (x)   |
| cloudproxy              | ssh代理服务                        | (x)  | (x)   |
| devtool                 | 应用部署服务                        | (x)  | (x)   |
| esxiagent               | VMWare代理                         | (x)  | (x)  |
| glance                  | 镜像服务                            | (x)  | (x)  |
| hostagent               | 宿主机代理                          | (x)   | (x) |
| hostdeployer            | 磁盘数据部署服务                     | (x)   | (x) |
| hostimage               | 磁盘数据下载服务                     | (x)   | (x) |
| influxdb                | 开源监控数据库                       | (x)   | (x) |
| itsm                    | 工单流程服务                        |       | (x) |
| keystone                | 认证服务                           | (x)  | (x) |
| kubeserver              | Kubernetes集群管理代理              | (x)  | (x) |
| logger                  | 操作日志服务                        | (x)  | (x) |
| meter                   | 计费计量服务                        |      | (x) |
| monitor                 | 监控服务                           | (x)  | (x) |
| notify                  | 通知告警服务                        | (x)  | (x) |
| onecloudServiceOperator | 编排服务                           | (x)  | (x) |
| ovnNorth                | OVN控制服务                        | (x)  | (x) |
| regionDNS               | DNS服务                           | (x)  | (x) |
| regionServer            | 云资源管理服务                      | (x)  | (x) |
| report                  | 报表服务                           |      | (x) |
| s3gateway               | S3代理网关服务                      | (x)  | (x) |
| scheduledtask           | 定时任务服务                        | (x)  | (x) |
| scheduler               | 调度器                             | (x)  | (x) |
| suggestion              | 费用优化服务                        |      | (x) |
| telegraf                | 监控Agent，开源telegraf             | (x) | (x)  |
| vpcAgent                | VPC代理                            | (x) | (x)  |
| web                     | 前端nginx                          | (x) | (x)  |
| webconsole              | H5控制台服务                        | (x) | (x)  |
| yunionagent             | 企业版授权服务                       |     | (x)  |
| yunionconf              | 配置管理服务                         | (x) | (x)  |
