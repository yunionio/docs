---
title: "组件概览"
linkTitle: "组件概览"
weight: 1
description: >
  了解各个组件的用途和部署运行方式
---

OneCloud 目前仅支持在 Centos 7 上运行，待部署组件/服务如下:

|  服务组件 |         用途        |    安装方式    |  运行方式 |
|:---------:|:-------------------:|:--------------:|:---------:|
|  mariadb  |     关系型数据库    |       rpm      |  systemd  |
|   docker  |      容器运行时     |       rpm      |  systemd  |
|  kubelet  | 管理 kubernetes pod |       rpm      |  systemd  |
|  keystone |       认证服务      | k8s deployment | container |
|   region  |      api 控制器     | k8s deployment | container |
| scheduler |       调度服务      | k8s deployment | container |
|   glance  |       镜像存储      | k8s deployment | container |
|   webconsole  |       虚拟机访问界面      | k8s deployment | container |
|   influxdb  |       监控数据库      | k8s deployment | container |
|    host   |      管理虚拟机     |       k8s daemonset      |  container  |
|  sdnagent |    管理虚拟机网络   |       rpm      |  systemd  |
| baremetal-agent |      管理物理机     | k8s deployment | container |
|   climc   |      命令行工具     |       rpm      |   shell   |
|   ocadm   |   部署服务管理工具  |       rpm      |   shell   |

其中 host 和 baremetal-agent 可以根据需求选择性部署:

- 管理 kvm 虚拟机: 部署 host 服务
- 管理物理机: 部署 baremetal-agent 服务
