---
title: "Quick Start"
linkTitle: "Quick Start"
weight: 2
edition: ce
IgnoreChildLink: true
oem_ignore: true
description: >
  Learn how to deploy and experience the var_oem_name service quickly
img: /images/icons/icon-quickstart.svg
---

Please select the Cloudpods service to deploy based on your functional scenario:

* Private Cloud: The private cloud deployment method includes the functionality of managing local IDC infrastructure, mainly KVM virtualization and bare metal management.

* Multi-Cloud Management: The multi-cloud management deployment method includes the functionality of managing private and public clouds, helping enterprises to uniformly manage heterogeneous IT infrastructure resources.

* Hybrid Cloud: The hybrid cloud deployment method includes the functionality of private cloud and multi-cloud management.

{{< tabs name="install" >}}

{{% tab name="Private Cloud" %}}

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">Private Cloud Installation</h5>
  <div class="section-tip-content">Build Cloudpods private cloud from scratch in CentOS 7, Debian 10 and other distributions, including underlying Kubernetes clusters and upper-layer service components. You can experience the built-in private cloud functionality. Please refer to: <a href="./allinone-virt">Private Cloud Installation</a></div>
</div>

{{% /tab %}}

{{% tab name="Multi-Cloud Management" %}}

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">Ocboot Installation</h5>
  <div class="section-tip-content">Build Cloudpods multi-cloud management service from scratch in CentOS 7, Debian 10 and other distributions, including underlying Kubernetes clusters and upper-layer service components. You can experience Cloudpods cloud management functionality. Please refer to: <a href="./cmp/allinone-multicloud">Ocboot Installation</a></div>
</div>

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">Docker Compose Installation</h5>
  <div class="section-tip-content">This solution deploys the Cloudpods multi-cloud management version through Docker Compose, allowing you to experience Cloudpods cloud management functionality quickly. Please refer to: <a href="./cmp/docker-compose">Docker Compose Installation</a></div>
</div>

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">Kubernetes Helm Installation</h5>
  <div class="section-tip-content">Deploy a set of Cloudpods CMP service instances on an existing Kubernetes cluster through Helm to experience Cloudpods cloud management functionality. Please refer to: <a href="./cmp/k8s">Kubernetes Helm Installation</a></div>
</div>

{{% /tab %}}

{{% tab name="Hybrid Cloud" %}}

<!-- <div style="border-left:solid 5px red">xxx</div> -->
<div class='section-tip'>
  <h5 class="section-tip-title">Hybrid Cloud Installation</h5><div class="section-tip-content">Build a fully functional Cloudpods service on CentOS 7, Debian 10 and other distributions from scratch, including the underlying Kubernetes cluster and upper-level service components. You can experience the functions of Cloudpods' built-in private cloud and cloud management. For details, please refer to: <a href="./allinone-full">Fusion Cloud Installation</a></div>
</div>

{{% /tab %}}

{{< /tabs >}}
