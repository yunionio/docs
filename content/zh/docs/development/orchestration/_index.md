---
title: "编排"
weight: 102
description:
  介绍编排相关 API
---

平台的编排系统使用了 Helm 这个通用工具来实现，如果不熟悉 Helm 这个工具，可以先参考[官方文档](https://helm.sh/zh/docs/intro/using_helm/)做一些了解。

其中有以下3个概念需要理解：

- Chart 代表着 Helm 包。它包含在 Kubernetes 集群内部运行应用程序，工具或服务所需的所有资源定义。你可以把它看作是 Homebrew formula，Apt dpkg，或 Yum RPM 在Kubernetes 中的等价物。

- Repository（仓库） 是用来存放和共享 charts 的地方。它就像 Perl 的 CPAN 档案库网络 或是 Fedora 的 软件包仓库，只不过它是供 Kubernetes 包所使用的。

- Release 是运行在 Kubernetes 集群中的 chart 的实例。一个 chart 通常可以在同一个集群中安装多次。每一次安装都会创建一个新的 release。以 MySQL chart为例，如果你想在你的集群中运行两个数据库，你可以安装该chart两次。每一个数据库都会拥有它自己的 release 和 release name。

## 其他说明

以下文档所有的 API 都有 climc 命令行工具对应的自命令，通过加上 '--debug' 参数可以清楚的看到 HTTP 请求以及相应，加上 '--help' 信息参数就可以查看到支持的选项。

强烈建议使用 'climc --debug' 的方式来执行步骤，然后查看相关 API 来理解相关接口。