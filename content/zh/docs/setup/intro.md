---
title: "组件概览"
linkTitle: "组件概览"
edition: ce
weight: 1
description: >
  了解各个组件的用途和部署运行方式
---

Cloudpods目前支持在 CentOS 7 (x86_64 或 arm64) 和 Debian 10 (arm64) 上运行，待部署组件/服务如下:

|  服务组件 |         用途        |    安装方式    |  运行方式 |
|:---------:|:-------------------:|:--------------:|:---------:|
|  mariadb  |     关系型数据库    |       rpm      |  systemd  |
|   docker  |      容器运行时     |       rpm      |  systemd  |
|  kubelet  | 管理 kubernetes pod |       rpm      |  systemd  |
| ansibleserver | ansible脚本管理和执行服务 | k8s deployment | container |
| apigateway	| web前端的API网关 | k8s deployment | container	|
| baremetal-agent |      管理物理机     | k8s deployment | container |
| cloudevent	| 云上日志和裸金属日志收集服务 | k8s deployment	| container |
| cloudid       | 公有云SAML SSO服务 | k8s deployment | container |
| cloudmon      | 公有云监控指标采集服务 | k8s deployment | container |
| devtool       | 运维工具服务           | k8s deployment | container |	
| esxi-agent    | VMware ESXi管理服务代理 | k8s deployment | container |
| etcd	        | 基础服务，存储服务间推送消息，分布式锁等等信息 | k8s deployment | container |	
|   glance  |       镜像存储      | k8s deployment | container |
|    host   |      管理虚拟机     |       k8s daemonset      |  container  |
|  sdnagent |    管理虚拟机流表规则，实现网络安全组和限速等功能  |  k8s daemonset      |  container |
| ovn-controller | 实现ovn数据库到每台宿主机OVS的流表同步 | k8s daemonset | container |
| host-deployer | 虚拟机部署服务，负责挂载虚拟机镜像，进行识别和修改 | k8s daemonset | container |
| host-image    | 虚拟机本地磁盘数据传输服务 | k8s daemonset | container |
|   influxdb  |       监控数据库      | k8s deployment | container |
|  keystone |       认证服务, 提供用户认证，服务间的API认证  | k8s deployment | container |
| kubeserver    | 容器管理服务，管理多个k8s容器集群，基于主机创建k8s集群 | k8s deployment |  container |
| logger        | 操作日志服务，存储所有服务的操作日志 | k8s deployment | container |
| monitor       | 监控服务，提供监控API，提供报警服务 | k8s deployment | container |
| notify        | 消息通知服务，负责短信，邮件，以及IM的消息发送 | k8s deployment | container |
| onecloud-service-operator | 编排服务控制器 | k8s deployment | container |
| ovn-north	    | OVN虚拟网络的数据维护服务，OVN标准组件 | k8s deployment | container |
| region        | 云控制器，控制服务 | k8s deployment | container |
| region-dns    | 主机自定义域名服务 | k8s deployment | container |
| s3gateway     | 对象存储统一网关，实现对所有对象存储的统一访问 | k8s deployment | container |
| scheduler	    | 虚拟机调度服务 | k8s deployment | container |
| telegraf      | 监控代理，采集每个节点的监控数据，并存储到influxdb | k8s daemonset | container |
| vpcagent      | VPC代理网关，实现云平台和OVN的信息同步 | k8s deployment | container |
| web	| 前端服务，是一个nginx容器，内置web前端js代码 | k8s deployment | container |
| webconsole | 云主机和容器的web终端服务 | k8s deployment | container |
| yunionconf | 前端个性化配置信息的存储和管理 | k8s deployment | container |
| onecloud-operator | 整个Cloudpods服务的K8s Operator，负责服务组件的部署管理 | k8s deployment | container |
|   climc   |      命令行工具     |       rpm      |   shell   |
|   ocadm   |   部署服务管理工具  |       rpm      |   shell   |

其中 host 和 baremetal-agent 可以根据需求选择性部署:

- 管理 kvm 虚拟机: 部署 host 服务
- 管理物理机: 部署 baremetal-agent 服务
