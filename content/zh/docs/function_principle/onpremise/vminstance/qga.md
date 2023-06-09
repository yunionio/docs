---
title: "qga 使用介绍"
weight: 30
description: >
  qemu guest agent 使用介绍。
---

## 功能介绍

  使用 [qemu guest agent](https://wiki.qemu.org/Features/GuestAgent) 来操作虚拟机或者查看虚拟机的信息。


## 安装部署

  不同版本的操作系统安装方式不同，启动方式不同，以下列出一些操作系统安装方式。

### linux 安装启动

```
安装：
Debian     : apt-get install qemu-guest-agent
Ubuntu     : apt-get install qemu-guest-agent
Alpine     : apk add qemu-guest-agent
Arch Linux : pacman -S qemu-guest-agent
Kali Linux : apt-get install qemu-guest-agent
Fedora     :dnf install qemu-guest-agent-2
Raspbian   : apt-get install qemu-guest-agent

systemd 启动或其他启动方式:
systemctl enable --now qemu-guest-agent

启动完成后可以在虚机内查看到 qemu-ga 的进程
例如 centos7 下，ps 可以看到 qemu-ga进程启动，并且禁用了一下命令:
/usr/bin/qemu-ga --method=virtio-serial --path=/dev/virtio-ports/org.qemu.guest_agent.0 --blacklist=guest-file-open,guest-file-close,guest-file-read,guest-file-write,guest-file-seek,guest-file-flush,guest-exec,guest-exec-status -F/etc/qemu-ga/fsfreeze-hook

centos7 下 blacklist 配置是在 /etc/sysconfig/qemu-ga 下面
$ cat /etc/sysconfig/qemu-ga | grep BLACKLIST_RPC
BLACKLIST_RPC=guest-file-open,guest-file-close,guest-file-read,guest-file-write,guest-file-seek,guest-file-flush,guest-exec,guest-exec-status
```

### windows 安装启动

  windows 需要挂载 [virtio-win](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/) 的 iso, 打开 iso 找到 guest-agent 目录 安装对应的 guest-agent.

## 使用介绍

执行 qga 命令需要确保虚机为 running(运行中) 的状态。若虚机内 guest-agent 未安装，则执行的命令会超时失败。

### 执行任意 qga 命令
```bash
$ climc server-qga-command  --help
Usage: climc server-qga-command [--help] <ID> <COMMAND>

Qga-Command server

Positional arguments:
    <ID>
        ID or name of the server
    <COMMAND>
        qga command

Optional arguments:
    [--help]
        Print usage and this help message and exit.

# 例如执行 guest-info 命令来获取 qga 的信息，包括 qga 版本，qga 支持的命令信息。
# 这是一个有用的命令来获取虚机内的 qga 支持和禁用了哪些操作。
$ climc server-qga-command test-server '{"execute": "guest-info"}'
supported_commands:
- enabled: true
  name: guest-sync-delimited
  success-response: true
- enabled: true
  name: guest-sync
  success-response: true
- enabled: true
  name: guest-suspend-ram
  success-response: false
- enabled: true
  name: guest-suspend-hybrid
  success-response: false
- enabled: true
  name: guest-suspend-disk
  success-response: false
- enabled: true
  name: guest-shutdown
  success-response: false
- enabled: true
  name: guest-set-vcpus
  success-response: true
- enabled: true
  name: guest-set-user-password
  success-response: true
- enabled: true
  name: guest-set-time
  success-response: true
- enabled: true
  name: guest-set-memory-blocks
  success-response: true
- enabled: true
  name: guest-ping
  success-response: true
- enabled: true
  name: guest-network-get-interfaces
  success-response: true
- enabled: true
  name: guest-info
  success-response: true
- enabled: true
  name: guest-get-vcpus
  success-response: true
- enabled: true
  name: guest-get-users
  success-response: true
- enabled: true
  name: guest-get-timezone
  success-response: true
- enabled: true
  name: guest-get-time
  success-response: true
- enabled: true
  name: guest-get-osinfo
  success-response: true
- enabled: true
  name: guest-get-memory-blocks
  success-response: true
- enabled: true
  name: guest-get-memory-block-info
  success-response: true
- enabled: true
  name: guest-get-host-name
  success-response: true
- enabled: true
  name: guest-get-fsinfo
  success-response: true
- enabled: true
  name: guest-fstrim
  success-response: true
- enabled: true
  name: guest-fsfreeze-thaw
  success-response: true
- enabled: true
  name: guest-fsfreeze-status
  success-response: true
- enabled: true
  name: guest-fsfreeze-freeze-list
  success-response: true
- enabled: true
  name: guest-fsfreeze-freeze
  success-response: true
- enabled: true
  name: guest-file-write
  success-response: true
- enabled: true
  name: guest-file-seek
  success-response: true
- enabled: true
  name: guest-file-read
  success-response: true
- enabled: true
  name: guest-file-open
  success-response: true
- enabled: true
  name: guest-file-flush
  success-response: true
- enabled: true
  name: guest-file-close
  success-response: true
- enabled: true
  name: guest-exec-status
  success-response: true
- enabled: true
  name: guest-exec
  success-response: true
version: 2.11.1
```

## qga 设置密码

cloudpods 封装了 qga 设置密码的操作。
云平台会对密码的强度校验，并且会将设置完的密码加密后保存在元数据中以供后续查询。

```bash
$ climc server-qga-set-password  --help
Usage: climc server-qga-set-password [--help] <ID> <USERNAME> <PASSWORD>

Qga-Set-Password server

Positional arguments:
    <ID>
        ID or name of the server
    <USERNAME>
        Which user to set password
    <PASSWORD>
        Password content

Optional arguments:
    [--help]
        Print usage and this help message and exit.

# eg:
climc server-qga-set-password test-server root testPassword@1234
```

