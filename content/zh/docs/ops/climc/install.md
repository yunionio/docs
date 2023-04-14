---
title: "climc 安装"
weight: 1
description: >
    介绍如何安装部署Climc命令行工具。
---

## 安装

可以通过 yum 或者源码编译的方式安装climc。

### RPM 安装

添加 yunion 的 yum 源，如果已经添加可以忽略这一步。

```bash
$ cat <<EOF >/etc/yum.repos.d/yunion.repo
[yunion]
name=Packages for Yunion Multi-Cloud Platform
baseurl=https://iso.yunion.cn/yumrepo-3.7
sslverify=0
failovermethod=priority
enabled=1
gpgcheck=0
EOF
```

安装 climc

```bash
$ sudo yum install -y yunion-climc
$ ls -alh /opt/yunion/bin/climc
-rwxr-xr-x 1 root root 24M Jul 18 19:04 /opt/yunion/bin/climc
```

### 源码编译安装

首先需要搭建 go 的开发环境，然后 clone 代码并编译:

```bash
# 克隆代码
$ cd $GOPATH/src/yunion.io/x/
$ git clone https://github.com/yunionio/cloudpods.git

# 编译 climc
$ cd $GOPATH/src/yunion.io/x/cloudpods
$ make cmd/climc

# 等待编译完成后，climc 在 _output/bin 目录下
$ ls -alh _output/bin/climc
-rwxr-xr-x 1 lzx lzx 25M Jul 15 17:10 _output/bin/climc
```

可以根据自己的需要，将编译好的 climc 放到对应的目录，或者直接写 alias 对应到 $GOPATH/src/yunion.io/x/cloudpods/_output/bin/climc 。

### 使用

安装好 climc 后，可以将对应的可执行目录加入到 PATH 环境变量，下面假设 climc 所在的目录是 /opt/yunion/bin 。

```bash
# 根据自己的需要加到 bash 或者 zsh 配置文件里面
$ echo 'export PATH=$PATH:/opt/yunion/bin' >> ~/.bashrc && source ~/.bashrc
$ climc --help
```
