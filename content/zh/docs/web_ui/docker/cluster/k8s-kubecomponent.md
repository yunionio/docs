---
title: "服务组件"
weight: 10
description: 服务组件用于扩展Kubernetes集群的功能。
---

服务组件用于扩展Kubernetes集群的功能。

目前仅支持以下三种组件。

- Ceph CSI：CSI(Container Storage Interface)是Kubernetes对外开放的存储接口。通过CSI插件实现将Ceph存储集成到Kubernetes集群中，实现容器存储卷的持久化。
- Fluentbit：Fluentbit是轻量级的日志收集工具，通过Fluentbit插件可以收集Kubernetes集群的日志信息等。
- Monitor：Monitor用于监控Kubernetes集群的信息，目前支持Grafana、Loki、Promethes等收集Kubernetes集群的监控信息。


**入口**：在云管平台单击左上角![](../../../images/intro/nav.png)导航菜单，在弹出的左侧菜单栏中单击 **_"容器/集群/服务组件"_** 菜单项，进入服务组件页面。

![](../../../images/docker/kubecomponent.png)


## 新建服务组件

### 新建Ceph CSI

该功能用于通过Ceph CSI组件对接Ceph存储。后续可用于创建ceph存储类。

1. 在服务组件页面，单击Ceph CSI模块的 **_"新建"_** 按钮，进入新建Ceph CSI页面。
2. 配置以下参数：支持添加多个Ceph集群，单击 **_"添加"_** 按钮，配置多个ceph集群。
   - 集群名称：Ceph集群的名称。
   - Mon Hosts：设置ceph存储监视器地址，格式为“IP地址:6789”。指定添加多个Mon Hosts，单击 **_"添加Mon Host地址"_** 按钮，添加多个地址。
3. 单击 **_"新建"_** 按钮，完成操作。

### 新建Fluentbit

该功能用于通过Fluentbit插件搜集Kubernetes集群日志信息。

1. 在服务组件页面，单击Fluentbit模块的 **_"新建"_** 按钮，进入新建Fluentbit页面。
2. 配置以下参数。
   - 启用Elasticsearch：选择是否将日志采集到Elasticsearch。启用后需要配置以下参数。
       - Elasticsearch index名称：Elasticsearch索引名称，在Elasticsearch中存储数据的行为就叫做索引(indexing)。
       - Elasticsearch集群连接地址：设置Elasticsearch集群的连接地址。
       - 端口：设置Elasticsearch集群的的端口。
       - 类型：Document的类型，默认为flb_type。
   - 启用kafka：选择是否将日志采集到kafka，启用后需要配置以下参数。
       - kafka broker地址：设置kafka broker的地址
       - topics：Kafka处理资源的消息源(feeds of messages)的不同分类。
3. 单击 **_"确定"_** 按钮，完成操作。

### 新建Monitor

该功能用于通过Monitor插件监控Kubernetes集群资源。

1. 在服务组件页面，单击Monitor模块的 **_"新建"_** 按钮，进入新建Monitor页面。
2. 配置以下参数：
   - Grafana登录用户名：Grafana的登录用户名。
   - Grafana登录密码：Grafana的用户登录密码。
   - Grafana-是否启用持久化存储：是否启用持久化存储保存Grafana数据。启用后配置以下参数：
       - 存储大小：设置存储的容量大小。
       - Storageclass名称：设置使用的存储类。
   - Loki-是否启用持久化存储：是否启用持久化存储保存Loki数据，启用后配置以下参数：
       - 存储大小：设置存储的容量大小。
       - Storageclass名称：设置使用的存储类。
   - Prometheus-是否启用持久化存储：是否启用持久化存储保存Prometheus数据，启用后配置以下参数：
       - 存储大小：设置存储的容量大小。
       - Storageclass名称：设置使用的存储类。
3. 单击 **_"确定"_** 按钮，完成操作。

## 更新组件配置

当组件配置完成后，可以通过更新功能更新配置信息。

1. 在服务组件页面，单击“已部署”状态的组件模块右上角![](../../../images/docker/more.png)按钮，选择下拉菜单 **_"更新"_** 菜单项，进入更新页面。
2. 更新组件配置信息，单击 **_"确定"_** 按钮。

## 启用组件

该功能用于启用已部署的组件。

1. 在服务组件页面，单击“已部署”且"禁用"状态的组件模块右上角![](../../../images/docker/more.png)按钮，选择下拉菜单 **_"启用"_** 菜单项，启用组件。

## 禁用组件

该功能用于禁用已部署的组件。

1. 在服务组件页面，单击“已部署”且"启用"状态的组件模块右上角![](../../../images/docker/more.png)按钮，选择下拉菜单 **_"禁用"_** 菜单项，禁用组件。

## 删除组件

该功能用于删除组件配置信息。

1. 在服务组件页面，单击“已部署”状态的组件模块右上角![](../../../images/docker/more.png)按钮，选择下拉菜单 **_"删除"_** 菜单项，弹出操作确认对话框。
2. 单击 **_"确定"_** 按钮，删除配置信息。
