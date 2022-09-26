---
title: "重置密码失败问题汇总"
date: 2021-09-28T08:22:33+08:00
weight: 200
---

## 查看虚拟机日志
- 如图点击结果为失败的日志
   ![](../images/vm_log.png)

## 常见错误整理
{{< tabs >}}

{{% tab name="ZStack" %}}
- operation error, because:qemu-agent service is not ready in vm
    - ZStack重置密码依赖于qemu-agent, 请确保虚拟机中qemu-agent是否正常运行
{{% /tab %}}

{{< /tabs >}}

