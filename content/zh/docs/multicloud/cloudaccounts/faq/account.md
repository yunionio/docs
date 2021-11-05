---
title: "云账号接入问题排查"
date: 2021-07-05T08:22:33+08:00
weight: 3
description: >
    
---


可以通过对应云平台的调用接口验证接口是否可以被正常调用，AccessKey信息是否正确。

{{< tabs >}}
{{% tab name="天翼云" %}}

```
# 获取环境中命令行所在的容器名称:
kubectl get pods -n onecloud |grep climc
 
#default-climc-7bdbd9fc7c-fnmkw                      1/1     Running   0          26h
# 进入climc容器环境：
kubectl exec -n onecloud -it default-climc-7bdbd9fc7c-fnmkw sh
 
# 进入ctyuncli所在目录：
cd /opt/yunion/bin
 
# 导入环境变量CTYUN_ACCESS_KEY& CTYUN_SECRET需要分别填入aksk：
export CTYUN_ACCESS_KEY='YOUR KEY'
export CTYUN_SECRET='YOUR SECRET'
export CTYUN_REGION="cn-gzT"
 
# 执行验证命令， 如果能正常列出可用区列表，说明与天翼云连接正常。
# 如果报403错误，则可能是接入准备未就位。
# 如果报 apigateway错误， 则可能是天翼云api接口调用错误或者发生变更。请联系云管平台开发人员定位
./ctyuncli region-list

```

{{% /tab %}}
{{< /tabs >}}