---
title: "原理介绍"
date: 2022-01-11T16:14:41+08:00
weight: 10
description: >
    介绍编排相关原理
---

Helm是Kubernetes的软件包管理工具，有点类似Linux操作系统中的“apt-get”和“yum”，更多介绍内容请参考[Helm官方文档](https://helm.sh/)。

Helm帮助应用开发者打包应用处理依赖关系，管理应用程序并发布到软件仓库。Helm使用者不需要了解Kubernetes的yaml语法编写复杂的配置文件，可以轻松的通过Helm部署Kubernetes应用等。

- Helm：Helm是一个命令行下的客户端工具。主要用于Kubernetes应用程序Chart的创建、打包、发布以及创建和管理本地和远程的Chart仓库。
- Chart：Helm的软件包，采用TAR格式。类似于APT的DEB包或者YUM的RPM包，其包含了一组定义 Kubernetes资源相关的yaml文件。
- Release：使用Helm在Kubernetes集群中部署的Chart。

{{<oem_name>}} 平台的虚拟机编排同样也采用Kubernetes容器应用的方式，提供对应的Helm的软件包部署虚拟机实例。