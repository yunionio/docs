---
title: "平台架构"
linkTitle: "平台架构"
edition: ce
weight: 3
description: >
  介绍 var_oem_name 平台的软件架构设计
img: /images/icons/icon-architecture.svg
---

## 应用架构

下图显示{{<oem_name>}}的应用架构，{{<oem_name>}}统一管理多云基础设施。

<img src="./app_arch.png" width="800">

**向下**：主要实现多云环境下计算、网络、存储等IaaS资源的统一管理。对于本地IDC的未云化资源，主要是裸机，KVM虚拟机（Libvirt），VMware ESXi虚拟机（vSphere），通过内置的私有云方案实现云化管理。对于私有云和公有云资源，则通过API实现统一管理。

**向上**：多云管理平台一方面通过虚拟机、裸机等形式为传统应用提供完整操作系统运行时环境，另一方面则给Kubernetes提供多云运行环境，统一管理多云Kubernetes。在Kubernetes之上则提供云原生应用的容器运行时环境。同时，基于Kubernetes和开源组件提供PaaS中间件服务。

## 系统架构

下图显示{{<oem_name>}}的系统架构，分为接入层，控制层和资源层三个主要部分。

<img src="./comp_arch.png" width="800">

### 接入层

接入层实现{{<oem_name>}}平台的访问功能，允许用户通过如下3种方式访问云管平台的功能：

API访问：通过REST API访问云管平台功能，用户可以直接通过http接口访问云管平台的REST API，也可以使用云管平台提供的SDK。目前SDK支持Java，Python和Golang等三种语言。

命令行访问：通过云管平台提供的climc命令行工具访问云管平台功能，允许用户通过脚本调用climc，实现一些自动化运维功能。Climc使用Golang语言，基于云管平台的Golang SDK开发。

Web控制台访问：通过Web UI访问云管平台的功能。允许用户通过主流web浏览器访问云管平台。Web控制台提供管理员使用的管理后台以及普通用户使用的普通功能页面，能够提供大部分的管理和使用功能。Web控制台基于Vue 2.0 JavaScript SPA框架实现。其中，API网关提供Web控制台对各个服务的统一REST API访问接口。实现Web控制台的登录验证，session 控制，以及对后端各个服务的API调用。API网关由Golang完全自主开发，完全无状态架构，具备水平扩展能力。

### 控制层

控制层实现{{<oem_name>}}的管理和控制功能。主要由Region控制器, 认证服务，镜像服务，计费计量，以及H5控制台等服务组件构成。

Region控制器是整个{{<oem_name>}}的控制中枢，负责机房网络，宿主机，网络，存储，虚拟机等各类资源的元数据信息管理，以及对虚拟机，裸机等的自动化管理操作认证的调度，协调管理。云控制器内置基于REST API接口的分布式异步任务管理框架，实现对在计算节点进行的开关机，创建删除等耗时操作任务的管理协调工作。云控制器完全自主开发，1.x版本基于Python Tornado框架开发，2.x版本开始基于Golang语言开发。云控制器采用无状态架构，可以水平扩展，通过水平拆分实现高可用。另外，Region控制器还附带了调度器组件。
调度器负责资源调度功能，是平台中资源获取决策的唯一执行者，根据用户对资源的要求，给出资源的最优提供者。调度器支持批量调度，调度性能优异，可扩展性好。调度器完全自主开发，基于Golang语言开发。

认证服务提供{{<oem_name>}}的账户管理和认证体系，并提供基于项目的多租户支持，同时提供服务目录功能。认证服务支持多种认证源，允许和企业的LDAP／AD对接，允许用户以企业统一的账户体系登入系统。认证服务2.10之前版本基于OpenStack Keystone Pika版本，开发语言为Python。在开源版本基础上，我们修正了BUG，并做了若干改进。2.10之后版本采用golang语言开发。Keystone采用无状态架构，支持水平扩展，可以水平拆分实现服务高可用。

镜像服务提供{{<oem_name>}}各种主机资源的操作系统镜像的管理功能。提供镜像存储，元数据管理等功能。镜像服务1.x版本基于OpenStack Glance Folsom版本改进而来，开发语言为Python。在开源版本基础上，我们修正了BUG，并做了若干改进。2.x版本采用golang语言开发。Glance采用无状态架构，支持水平扩展，可以水平拆分实现服务高可用。

### 资源层

资源层实现对KVM虚拟机，裸机，VMWare虚拟机等计算资源的管理和控制功能，以及对阿里云，Azure，腾讯云，AWS等公有云资源的管理。

## 组件概览

Cloudpods目前支持在 CentOS 7 (x86_64 或 arm64) 和 Debian 10 (x86_64 或 arm64) 上运行，待部署组件/服务如下:

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
