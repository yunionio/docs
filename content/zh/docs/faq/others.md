---
title: "其他问题"
weight: 190
edition: ce
oem_ignore: true
description: >
  使用cloudpods过程中常见问题解答
---

## 目前支持哪些平台及哪些资源？

1. 具体查看我们[在线版文档](../../function_principle/multicloud/)

## 企业版和开源版有哪些区别？如何安装？

1. 具体功能差异可查看[在线版文档](https://www.yunion.cn/comparison-info)
2. 开源版转化为企业版可参考[在线版文档](../../setup/ce-ee-switch/)
3. 安装教程具体可参考[在线版文档](../../setup/)

## 开源版是否有付费技术支持？

1. 有的，支持订阅官方的技术支持，具体信息可查看[官方网站](https://www.yunion.cn/subscription/index.html)

## cloudpods安装后默认用户密码？

1. 默认用户名：admin、 密码admin@123

## cloudpods支持对物理机的接管吗？

1. 支持的，可以通过ipmi，或者通过物理机的SSH管理IP
2. 纳管物理机方法可参考[在线文档](../../function_principle/onpremise/baremetal/create_register_redirect/)
3. 物理机测试方法可参考[在线文档](../../function_principle/onpremise/baremetal/testcase/)

## 开源版如何开启多租户功能？

1. 需要开启三级权限，通过climc service-config-edit common且修改："non_default_domain_projects": true
2. 重启相关服务以便立即生效，在控制节点上执行 kubectl rollout restart deployment -n onecloud default-keystone default-apigateway 
3. 三级权限修改后，无法关闭。

## API 有没有详细点的调用说明？

1. 具体调用方法可参考[在线文档](../../development/apisdk/01_api/)

## Cloudpods创建vm提示磁盘不足，是必须要在宿主机根目录空间吗？

1. 虚拟机的数据都在/opt/cloud/workspace下面，可以给/opt单独挂载一个分区不可以做软链接，因为 host 服务跑在容器里，软链接在 容器里不识别或者用mount --bind方式

## 集群k8s证书过期了，如何更新？

1. 新版本会签发98年的证书。旧版本用kubeadm alpha certs renew all 续期或者升级ocadm，使用ocadm alpha certs renew all续期98年的。
2. ocadm 应该只支持 1.15 的 k8s 集群。如果是平台创建的基于虚拟机部署的 k8s 集群，是使用  kubespray 部署的，应该默认还是一年，可以参考[在线文档](https://github.com/kubernetes-sigs/kubespray/issues/5464#issuecomment-647022647)手动更新证书
