---
title: "查看宿主机列表"
date: 2022-02-07T18:24:15+08:00
weight: 2
description: >
    查看宿主机列表信息
---

### 查询宿主机

```bash
# 查询 kvm 这种类型的宿主机
$ climc host-list --hypervisor kvm

# 查询被禁用的 kvm 宿主机
$ climc host-list --hypervisor kvm --disabled

# 查询启用的 kvm 宿主机
$ climc host-list --hypervisor kvm --enabled
```
