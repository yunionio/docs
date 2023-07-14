---
title: "快速开始"
linkTitle: "快速开始"
weight: 2
edition: ce
oem_ignore: true
description: >
  介绍如何快速部署体验 var_oem_name 服务
img: /images/icons/icon-quickstart.svg
---

   <img src="images/quickstarthomepage.png#pic_center" width="1000">

请根据功能使用场景选择要部署的Cloudpods服务：

* 企业级私有云：企业级私有云是一款简单、可靠的企业IaaS资源管理软件。帮助未云化企业全面云化IDC物理资源，提升企业IT管理效率。

* 多云管理平台：多云管理平台简称云管，帮助客户在一个地方管理所有云计算资源。统一管理异构IT基础设施资源，极大简化多云架构复杂度和难度，帮助企业轻松驾驭多云环境。

* 融合云：融合云包含了企业级私有云和多云管理平台的功能。

{{< tabs name="install" >}}
{{% tab name="企业级私有云" %}}

[All in One 私有云安装](allinone-private)：从零开始在 CentOS 或 Debian 10 系统里搭建一个全功能 Cloudpods 服务实例，包括底层 Kubernetes 集群和上层服务组件，可以体验 Cloudpods 内置私有云的功能。


{{% /tab %}}

{{% tab name="多云管理平台" %}}

[All in One 多云管理平台安装](allinone-multicloud)：从零开始在 CentOS 或 Debian 10 系统里搭建一个全功能 Cloudpods 服务实例，包括底层 Kubernetes 集群和上层服务组件，可以体验 Cloudpods 云管的功能。

[Kubernetes Helm 安装](k8s)：在已有 Kubernetes 集群上通过 Helm 部署一套 Cloudpods CMP 服务实例，可以体验 Cloudpods 云管的功能。

[Docker Compose 安装](docker-compose)：该方案通过 Docker Compose 部署 Cloudpods 多云管理版本，可以体验 Cloudpods 云管的功能。

{{% /tab %}}

{{% tab name="融合云" %}}

[All in One 融合云安装](allinone-converge)：从零开始在 CentOS 或 Debian 10 系统里搭建一个全功能 Cloudpods 服务实例，包括底层 Kubernetes 集群和上层服务组件，可以体验 Cloudpods 内置私有云和云管的功能。

{{% /tab %}}
{{< /tabs >}}

 