---
title: "删除"
date: 2019-07-19T17:32:09+08:00
weight: 20
description: >
  介绍如何删除虚拟机。
---

## climc操作

### 解除删除保护

```bash
$ climc server-update --delete enable <server_id>
```

### 删除

```bash
# 删除至回收站
$ climc server-delete <server_id>

# 彻底删除
$ climc server-delete -f <server_id>
```
