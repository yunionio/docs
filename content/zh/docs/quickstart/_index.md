---
title: "快速开始"
linkTitle: "快速开始"
weight: 2
edition: ce
IgnoreChildLink: true
oem_ignore: true
description: >
  介绍如何快速部署体验平台功能
img: /images/icons/icon-quickstart.svg
---

<img src="images/quickstarthomepage.png#pic_center" width="1000">

请根据功能使用场景选择要部署的Cloudpods服务：

* 私有云：私有云部署方式包含本地IDC基础设施管理的功能，主要是KVM虚拟化以及裸金属管理。

* 多云管理：多云管理部署方式包含了纳管私有云和公有云的功能，帮助企业统一管理异构IT基础设施资源。

* 融合云：融合云部署方式包含了私有云和多云管理的功能。

{{< tabs name="install" >}}

{{% tab name="私有云" %}}

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">私有云安装</h5>
  <div class="section-tip-content">从零开始在 CentOS 7 、Debian 10 等发行版里搭建 Cloudpods 私有云，包括底层 Kubernetes 集群和上层服务组件，可以体验内置私有云的功能。详情请参考：<a href="./allinone-virt">私有云安装</a></div>
</div>

{{% /tab %}}

{{% tab name="多云管理" %}}

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">Ocboot 安装</h5>
  <div class="section-tip-content">从零开始在 CentOS 7、 Debian 10 等发行版里搭建 Cloudpods 多云管理服务，包括底层 Kubernetes 集群和上层服务组件，可以体验 Cloudpods 云管的功能。详情请参考：<a href="./cmp/allinone-multicloud">Ocboot 安装</a></div>
</div>

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">Docker Compose 安装</h5>
  <div class="section-tip-content">该方案通过 Docker Compose 部署 Cloudpods 多云管理版本，可以快速体验 Cloudpods 云管的功能。详情请参考：<a href="./cmp/docker-compose">Docker Compose 安装</a></div>
</div>

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">Kubernetes Helm 安装</h5>
  <div class="section-tip-content">在已有 Kubernetes 集群上通过 Helm 部署一套 Cloudpods CMP 服务实例，可以体验 Cloudpods 云管的功能。详情请参考：<a href="./cmp/k8s">Kubernetes Helm 安装</a></div>
</div>

{{% /tab %}}

{{% tab name="融合云" %}}

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">融合云安装</h5>
  <div class="section-tip-content">从零开始在 CentOS 7、 Debian 10 等发行版里搭建全功能的 Cloudpods 服务，包括底层 Kubernetes 集群和上层服务组件，可以体验 Cloudpods 内置私有云和云管的功能。详情请参考：<a href="./allinone-full">融合云安装</a></div>
</div>

{{% /tab %}}

{{< /tabs >}}
