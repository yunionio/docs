---
title: "组件介绍"
date: 2021-11-10T19:02:10+08:00
weight: 10
description: >
    介绍var_oem_name平台服务组件的功能
---

{{<oem_name>}} 平台部署在Kubernetes上，平台服务将支持容器化方式部署运行在Kubernetes集群。下面将介绍下平台的组件服务。

### onecloud-operator

Onecloud-operator组件为集群控制器，实现集群服务的自动配置，部署和运行监控。


- **Deployment**： onecloud-operator
- **Pod**： onecloud-operator-xxx
- **配置**：
```bash
# 配置operator
$ kubectl edit oc -n onecloud
# 查看operator的配置
$ kubectl get oc -n onecloud -o yaml
```
- **功能**：
    - 自动部署平台服务，包括初始化配置、创建管理对应k8s资源。
    - 升级回滚：更新/回滚任意服务的版本。
    - 资源清理：当平台服务集群删除后，释放对应的资源。

### web

前端服务组件

- **Deployment**： default-web
- **Pod**： default-web-xxx
- **configmap**：default-web
- **功能**：
    - 放置前端代码
    - Nignx相关配置

### apigateway

api网关组件

- **Deployment**： default-apigateway
- **Pod**： default-apigateway-xxx
- **功能**：
    - 提供web前端API
    - 认证和权限的认证入口
    - License控制等

### keystone

- **Deployment**： default-keystone
- **Pod**： default-keystone-xxx
- **功能**：
    - 认证
    - 资源归属project和domain
    - 权限：角色（role），权限（policy）
    - 服务目录

### region

- **Deployment**： default-region
- **Pod**： default-region-xxx
- **功能**：
    - 云控制器
    - 计算、网络、存储、数据库等云资源等管理

### scheduler

资源调度组件

- **Deployment**： default-scheduler
- **Pod**： default-scheduler-xxx
- **功能**：资源调度

### glance

镜像服务组件

- **Deployment**： default-glance
- **Pod**： default-glance-xxx
- **功能**：镜像管理

### baremetal

物理机管理服务组件

- **Deployment**： default-baremetal
- **Pod**： default-baremetal-xxx
- **功能**：
    - 提裸金属管理Agent
    - 提供PXEboot
    - 提供DHCP

### host

宿主机服务组件

- **Pod**： default-host-xxx
- **Daemonset**：default-host
- **功能**：私有云宿主机上的Agent
- **容器**：host服务下有三个容器，host、ovn-controller、sdnagent 
    - host：
        - 虚拟机生命周期管理
            - 通过qemu启用停止虚拟机
            - 通过qemu monitor对虚拟机进行其他操作
        - 存储管理和磁盘生命周期管理
            - 本地盘和共享存储（ceph,nfs等）磁盘的CURD操作
            - 存储信息探测
        - DHCP Server
            - 作为DHCP Server为虚拟机分配IP
            - 作为DHCP relay server转发物理机PXE启动时候的DHCP请求
        - GPU设备探测与初始化
            - 初始化即为GPU设备绑定vfio驱动
        - 宿主机初始化与信息探测
        - 监控数据采集
    - ovn-controller：虚拟机vpc网络管理，连接southbound，将southbound中的flows转换成ovs流表规则。
    - sdnagent：虚拟机经典网络管理。
        - 流表管理
        - 虚拟机网卡QoS
        - 防火墙

### host-image

- **Pod**： default-host-image-xxx
- **功能**：提供读取镜像内容api，配合fuse可远程挂载磁盘

### host-deployer

- **Pod**： default-host-deployer-xxx
- **功能**： 虚拟机创建时部署相关操作
    - 虚拟机镜像操作系统识别、系统初始化。
    - 分区扩容、格式化文件系统等

### vpcagent

- **Deployment**： default-vpcagent
- **Pod**： default-vpcagent-xxx
- **功能**：ovn的vpc配置管理

### esxiagent

VMware管理Agent

- **Deployment**： default-esxiagent
- **Pod**： default-esxiagent-xxx
- **功能**：VMware管理Agent代理

### cloudmon

监控采集服务

- **Deployment**： default-cloudmon
- **Pod**： default-cloudmon-xxx
- **功能**：
    - ping检测：5分钟一次探测被占用的IP地址。
    - usage数据采集
    - VMware、OpenStack、公有云等平台监控数据采集


### meter

计费计量服务

- **Deployment**： default-meter
- **Pod**： default-meter-xxx
- **功能**：计费计量功能

