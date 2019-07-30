---
title: "其他操作"
date: 2019-07-19T17:32:09+08:00
weight: 30
---

### 开关机

```bash
# 开机
$ climc server-start <server_id>

# 关机
$ climc server-stop <server_id>

# 强制关机
$ climc server-stop --is-force <server_id>

# 重启
$ climc server-restart <server_id>
```

### 删除

```bash
# 删除至回收站
$ climc server-delete <server_id>

# 彻底删除
$ climc server-delete -f <server_id>
```

### 重装密码

```bash
$ climc server-deploy --reset-password --password <your_password> <server_id>
```

TODO
