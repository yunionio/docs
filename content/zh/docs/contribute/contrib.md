---
title: "开发贡献"
weight: 2
description: >
  介绍如何搭建开发环境，编译组件以及提交代码的流程
---

## 安装 Go

Golang 版本要求 1.12 以上

安装go环境参考: [Install doc](https://golang.org/doc/install)

## 安装 ceph 依赖

On rpm based systems (dnf, yum, etc):
```sh
sudo rpm --import https://download.ceph.com/keys/release.asc
sudo yum install -y https://download.ceph.com/rpm-luminous/el7/noarch/ceph-release-1-1.el7.noarch.rpm
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install -y libcephfs-devel librbd-devel librados-devel
```

On debian systems (apt):
```sh
wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
echo deb https://download.ceph.com/debian-luminous/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
apt-get update && apt-get install -y libcephfs-dev librbd-dev librados-dev
```


## 编译 云联壹云 组件

### Fork 仓库

访问 https://github.com/yunionio/onecloud ，将仓库 fork 到自己的 github 用户下。

### Clone 源码

git clone 前确保 GOPATH 等环境变量已经设置好，clone 你自己 fork 的仓库

```sh
$ git clone  https://github.com/<your_name>/onecloud $GOPATH/src/yunion.io/x/onecloud
$ cd $GOPATH/src/yunion.io/x/onecloud
$ git remote add upstream https://github.com/yunionio/onecloud
```

### 编译

```sh
# 编译所有组件
$ make

# cmd 目录下面存放着所有的组件:
$ ls cmd
...
ansibleserver    climc      glance      keystone  qcloudcli     ucloudcli
awscli           cloudir    host        lbagent   region        webconsole

# 可以编译cmd下制定的组件，比如：编译 region 和 host 组件
$ make cmd/region cmd/host

# 查看编译好的二进制文件
$ ls _output/bin
region host
```
## 本地开发调试

3.0 版本后我们的服务都已经容器化运行在 k8s 集群中，快速开发调试并不方便。
通过Telepresence 提供远程k8s上下文，可以在本地开发调试。

### 安装

确保有一个已部署的云联壹云 k8s集群，参考[安装部署](/docs/setup/)。
这里介绍Centos7的本地环境安装，其他发行版可参考官方文档：[Installing Telepresence](https://www.telepresence.io/reference/install)。

> 不建议k8s集群的部署和开发在同一个环境，使用Telepresence会有端口冲突。

```bash
# 安装依赖
$ yum install -y python3 sshfs conntrack iptables torsocks sshuttle sudo yum-utils
# 安装 kubectl 用于连接 k8s 集群
$ cat <<EOF >/etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
$ yum install -y kubectl-1.15.8-0
# 需要自行配置kubctl config
# 测试kubctl可以访问之前部署的k8s集群
$ kubctl version
# 源码安装 telepresence 到 /usr/local/bin/telepresence
$ git clone https://github.com/telepresenceio/telepresence
$ cd telepresence
$ sudo env PREFIX=/usr/local ./install.sh
```

### 使用
利用 telepresence 本地连通远端 k8s 的特性，我们就可以做到在本地编译运行 region，keystone 等服务，同时又能访问远端 k8s 其它服务的环境。

比如以下是本地编译运行 region 服务的流程：
```bash
# 切换到 云联壹云 代码目录
$ cd $GOPATH/src/yunion.io/x/onecloud
 
# 编译 region 服务
$ make cmd/region
 
# 使用 telepresence 替换 k8s 里面的 default-region deployment
# 该命令在 k8s 集群中启动一个 deployment 替换掉原来的 default-regoin
# 然后把流量的访问导向本地
# 如果想要使用特定的 shell，比如 zsh，可以在后面加上"--run /bin/zsh"
$ telepresence --swap-deployment default-region --namespace onecloud
```
到这里已经进入到 telepresence 隔离的 namespace 里面了，
$TELEPRESENCE_ROOT 这个目录 是通过 sshfs 挂载的远端 k8s pod 的文件系统。
接下来我们就可以在这个 namespace 里面运行 region 服务了：
```bash
# 设置 max_user_namespaces
$ cat /proc/sys/user/max_user_namespaces
0
# 如果 max_user_namespaces 为 0，需要设置下 user_namespaces
$ echo 640 > /proc/sys/user/max_user_namespaces
 
# 启动一个新的 namespace , 但不共享 mount namespace，这样接下来的 mount bind 操作就不会影响到宿主机
$ unshare --map-root-user --mount
# bind k8s /var/run/secrets
$ mount --bind $TELEPRESENCE_ROOT/var/run /var/run
$ ls /var/run/
secrets
# bind 云联壹云 config
$ mkdir /etc/yunion
$ mount --bind $TELEPRESENCE_ROOT/etc/yunion /etc/yunion
$ ls /etc/yunion/
pki  region.conf
 
# 启动 region 服务
$ ./_output/bin/region --config /etc/yunion/region.conf
# 这个时候如果我们在外部调用 climc
$ climc server-list
# 就会发现相关的请求已经被转发到本地开发机启动 region 服务了
```
更多用法，以及 telepresence 的原理请参考[官方文档](https://www.telepresence.io/discussion/overview)。

## 开发流程

- 从 master checkout 出 feature 或者 bugfix 分支

```bash
# checkout 新分支
$ git fetch upstream --tags
$ git checkout -b feature/implement-x upstream/master
```

- 在新的分支上进行开发
- 开发完成后，进行提交PR前的准备操作

```bash
$ git fetch upstream         # 同步远程 upstream master 代码
$ git rebase upstream/master # 有冲突则解决冲突
$ git push origin feature/implement-x # push 分支到自己的 repo
```

- 在GitHub的Web界面完成提交PR的流程

![](../images/submitPR.png)

- 提完 PR 后请求相关开发人员 review，并设置Labels来表明提交的代码属于哪一个模块或者哪几个模块

![](../images/reviewer_label.png)

- 或者通过添加评论的方式来完成上一步；评论 "/cc" 并 @ 相关人员完成设置reviewer，评论/area 并填写label完成设置Labels

![](../images/robot_review_label.png)

​	所有Label都可以在issues——Labels下查询到，带area/前缀的Label均可以使用评论"/area"的形式添加

- 如果是 bugfix 或者需要合并到之前 release 分支的 feature PR，需要额外使用脚本将此PR cherry-pick 到对应的 release 分支

```bash
# 自行下载安装 github 的 cli 工具：https://github.com/github/hub
# OSX 使用: brew install hub
# Debian: sudo apt install hub
# 二进制安装: https://github.com/github/hub/releases

# 设置github的用户名
$ export GITHUB_USER=<your_username>

# 使用脚本自动 cherry-pick PR 到 release 分支
# 比如现在有一个提交的PR的编号为8，要把它合并到 release/2.8.0
$ ./scripts/cherry_pick_pull.sh upstream/release/2.8.0 8
 
# cherry pick 可能会出现冲突，冲突时开另外一个 terminal，解决好冲突，再输入 'y' 进行提交
$ git add xxx # 解决完冲突后
$ git am --continue
# 回到执行 cherry-pick 脚本的 terminal 输入 'y' 即可
```

去 upstream 的 [PR 页面](https://github.com/yunionio/onecloud/pulls), 就能看到自动生成的 cherry-pick PR，上面操作的PR的标题前缀就应该为：`Automated cherry pick of #8`，然后重复 PR review 流程合并到 release

