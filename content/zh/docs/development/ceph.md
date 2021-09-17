---
title: "Ceph对接(废弃)"
weight: 11
description: >
  介绍如何对接非标准ceph rbd存储(启明星辰, 杉岩等存储厂商)
---

# release/3.8 说明
- release/3.8 及之后版本将使用ceph及rbd命令直接操作ceph集群
- 若使用了非开源版ceph，请在计算节点装好存储厂商提供的ceph及rbd命令，并放置在**PATH**路径里面，并重启宿主机 yunion-executor.service 服务

## 说明
- 部分厂商针对ceph存储做不同程度的优化，因此若使用开源版ceph提供的lib库，cloudpods在运行过程中可能会出现各种问题
- cloudpods涉及ceph的服务只有host和host-deployer，同时qemu相关的程序也部分依赖ceph(nbd模块)
- 此文根据各个存储厂商涉及的优化，指导如何适配各类ceph存储

## ceph对接cloudpods步骤
- 编译host、host-deployer二进制
- 打包librados、librbd库到host及host-deployer镜像
- 挂载ceph相关目录到host、host-deployer pod

## 环境准备
```bash
# 这里使用 CentOS 7.6 环境
# 安装 golang 编译器
$ yum install golang

# 安装 docker 环境
$ curl -fsSL https://get.docker.com | bash -s docker --mirror aliyun
# 启动 docker daemon
$ systemctl start docker

# 安装ceph依赖包
# 这里假设安装包分别是:
# librados2-SDS_4.1.000.2-0.el7.centos.x86_64.rpm
# librados-devel-SDS_4.1.000.2-0.el7.centos.x86_64.rpm
# librbd1-devel-SDS_4.1.000.2-0.el7.centos.x86_64.rpm
# librbd1-SDS_4.1.000.2-0.el7.centos.x86_64.2.rpm
# librbd1-SDS_4.1.000.2-0.el7.centos.x86_64.rpm
# 若存在相关依赖问题，请自行解决(或联系存储厂商)
# 这里我碰见少一个基础库，可使用 yum install libibverbs.x86_64 解决
$ rpm -ivh librados2-SDS_4.1.000.2-0.el7.centos.x86_64.rpm  librados-devel-SDS_4.1.000.2-0.el7.centos.x86_64.rpm  librbd1-devel-SDS_4.1.000.2-0.el7.centos.x86_64.rpm  librbd1-SDS_4.1.000.2-0.el7.centos.x86_64.rpm
准备中...                          ################################# [100%]
正在升级/安装...
   1:librados2-2:SDS_4.1.000.2-0.el7.c################################# [ 25%]
   2:librados-devel-2:SDS_4.1.000.2-0.################################# [ 50%]
   3:librbd1-2:SDS_4.1.000.2-0.el7.cen################################# [ 75%]
   4:librbd1-devel-2:SDS_4.1.000.2-0.e################################# [100%]
```

## 适配步骤
```bash
# 1. 克隆cloudpods代码, 可根据需要切换不同的release版本, 这里选择3.6版本
$ git clone -b release/3.6 https://github.com/yunionio/cloudpods.git

# 2. 进入cloudpods目录
$ cd cloudpods

# 3. 尝试编译host、host-deployer二进制
# 若无编译错误，可以忽略第4步
# 若出现类似 vendor/github.com/ceph/go-ceph/rados/conn.go:5:29: fatal error: rados/librados.h: No such file or directory 这样的错误，请检查rados、librbd相关的rpm包是否安装正常
$ make cmd/host cmd/host-deployer

# 4. 解决编译错误(仅用适用于厂商修改了librados、librbd等基础库)
# 说明: 修改go-ceph(vendor/github.com/ceph/go-ceph)库，需要咨询存储厂商,避免使用rbd存储时出现异常
$ make cmd/host
go build -mod vendor -ldflags "-w -X yunion.io/x/pkg/util/version.gitVersion=v3.6.19-26-g4038fdc2b1d560 -X yunion.io/x/pkg/util/version.gitCommit=4038fdc -X yunion.io/x/pkg/util/version.gitBranch=release/3.6 -X yunion.io/x/pkg/util/version.buildDate=2021-07-14T03:57:21Z -X yunion.io/x/pkg/util/version.gitTreeState=clean -X yunion.io/x/pkg/util/version.gitMajor=0 -X yunion.io/x/pkg/util/version.gitMinor=0" -o /root/cloudpods/_output/bin/host yunion.io/x/onecloud/cmd/host
# yunion.io/x/onecloud/cmd/host
/usr/lib/golang/pkg/tool/linux_amd64/link: running gcc failed: exit status 1
/tmp/go-link-681866212/000006.o：在函数‘_cgo_3262cb398845_Cfunc_rbd_trash_list_cleanup’中：
/tmp/go-build/cgo-gcc-prolog:895：对‘rbd_trash_list_cleanup’未定义的引用
collect2: 错误：ld 返回 1

# 出现如上的错误，咨询存储厂商，确认移除了开源版的rbd_trash_list_cleanup函数，因此需要移除go-ceph相应的rbd_trash_list_cleanup调用
$ git diff vendor/github.com/ceph/go-ceph/rbd/rbd.go
diff --git a/vendor/github.com/ceph/go-ceph/rbd/rbd.go b/vendor/github.com/ceph/go-ceph/rbd/rbd.go
index 6dfd249..fc19c36 100644
--- a/vendor/github.com/ceph/go-ceph/rbd/rbd.go
+++ b/vendor/github.com/ceph/go-ceph/rbd/rbd.go
@@ -945,38 +945,6 @@ func (snapshot *Snapshot) Set() error {
        return GetError(C.rbd_snap_set(snapshot.image.image, c_snapname))
 }

-// GetTrashList returns a slice of TrashInfo structs, containing information about all RBD images
-// currently residing in the trash.
-func GetTrashList(ioctx *rados.IOContext) ([]TrashInfo, error) {
-       var num_entries C.size_t
-
-       // Call rbd_trash_list with nil pointer to get number of trash entries.
-       if C.rbd_trash_list(C.rados_ioctx_t(ioctx.Pointer()), nil, &num_entries); num_entries == 0 {
-               return nil, nil
-       }
-
-       c_entries := make([]C.rbd_trash_image_info_t, num_entries)
-       trashList := make([]TrashInfo, num_entries)
-
-       if ret := C.rbd_trash_list(C.rados_ioctx_t(ioctx.Pointer()), &c_entries[0], &num_entries); ret < 0 {
-               return nil, RBDError(ret)
-       }
-
-       for i, ti := range c_entries {
-               trashList[i] = TrashInfo{
-                       Id:               C.GoString(ti.id),
-                       Name:             C.GoString(ti.name),
-                       DeletionTime:     time.Unix(int64(ti.deletion_time), 0),
-                       DefermentEndTime: time.Unix(int64(ti.deferment_end_time), 0),
-               }
-       }
-
-       // Free rbd_trash_image_info_t pointers
-       C.rbd_trash_list_cleanup(&c_entries[0], num_entries)
-
-       return trashList, nil
-}
-
 // TrashRemove permanently deletes the trashed RBD with the specified id.
 func TrashRemove(ioctx *rados.IOContext, id string, force bool) error {
        c_id := C.CString(id)

# 再次编译，报错:
$ make cmd/host
go build -mod vendor -ldflags "-w -X yunion.io/x/pkg/util/version.gitVersion=v3.6.19-26-g4038fdc2b1d560 -X yunion.io/x/pkg/util/version.gitCommit=4038fdc -X yunion.io/x/pkg/util/version.gitBranch=release/3.6 -X yunion.io/x/pkg/util/version.buildDate=2021-07-14T06:07:09Z -X yunion.io/x/pkg/util/version.gitTreeState=dirty -X yunion.io/x/pkg/util/version.gitMajor=0 -X yunion.io/x/pkg/util/version.gitMinor=0" -o /root/cloudpods/_output/bin/host yunion.io/x/onecloud/cmd/host
# github.com/ceph/go-ceph/rbd
vendor/github.com/ceph/go-ceph/rbd/rbd.go:30:28: could not determine kind of name for C.RBD_FEATURE_JOURNALING
make: *** [cmd/host] 错误 2

# 相应的需要，移除 RBD_FEATURE_JOURNALING 定义
$ git diff vendor/github.com/ceph/go-ceph/rbd/rbd.go
diff --git a/vendor/github.com/ceph/go-ceph/rbd/rbd.go b/vendor/github.com/ceph/go-ceph/rbd/rbd.go
index 6dfd249..fa40475 100644
--- a/vendor/github.com/ceph/go-ceph/rbd/rbd.go
+++ b/vendor/github.com/ceph/go-ceph/rbd/rbd.go
@@ -27,7 +27,6 @@ const (
        RbdFeatureObjectMap     = C.RBD_FEATURE_OBJECT_MAP
        RbdFeatureFastDiff      = C.RBD_FEATURE_FAST_DIFF
        RbdFeatureDeepFlatten   = C.RBD_FEATURE_DEEP_FLATTEN
-       RbdFeatureJournaling    = C.RBD_FEATURE_JOURNALING
        RbdFeatureDataPool      = C.RBD_FEATURE_DATA_POOL

        RbdFeaturesDefault = C.RBD_FEATURES_DEFAULT
@@ -945,38 +944,6 @@ func (snapshot *Snapshot) Set() error {
        return GetError(C.rbd_snap_set(snapshot.image.image, c_snapname))
 }

# 若存在其他编译错误，请咨询存储厂商对开源版ceph做出的改动，并据此更新go-ceph相应的代码, 直至 make cmd/host cmd/host-deployer 可以正常编译通过
```

## 镜像编译打包
```bash
# 找到基础so依赖库
$ whereis libsoftokn3.so libsqlite3.so.0 libfreeblpriv3.so
libsoftokn3: /usr/lib64/libsoftokn3.so /usr/lib64/libsoftokn3.chk
libsqlite3.so: /usr/lib64/libsqlite3.so.0
libfreeblpriv3: /usr/lib/libfreeblpriv3.chk /usr/lib/libfreeblpriv3.so /usr/lib64/libfreeblpriv3.chk /usr/lib64/libfreeblpriv3.so

# 查看host程序依赖ceph相关的ceph库文件位置
$ ldd _output/bin/host | egrep  '(rbd|ceph|rados)'
        librbd.so.1 => /lib64/librbd.so.1 (0x00007f3ae12dd000)
        librados.so.2 => /lib64/librados.so.2 (0x00007f3ae0fa5000)
        libceph-common.so.0 => /usr/lib64/ceph/libceph-common.so.0 (0x00007f3ad7c75000) 

# 这里需要根据链接文件找到真实的文件路径
$ readlink -f  /lib64/librbd.so.1 /lib64/librados.so.2 /usr/lib64/ceph/libceph-common.so.0 /usr/lib64/libsoftokn3.so /usr/lib64/libsqlite3.so.0 /usr/lib64/libfreeblpriv3.so
/usr/lib64/librbd.so.1.0.0
/usr/lib64/librados.so.2.0.0
/usr/lib64/ceph/libceph-common.so.0
/usr/lib64/libsoftokn3.so
/usr/lib64/libsqlite3.so.0.8.6
/usr/lib64/libfreeblpriv3.so

# 拷贝so库文件到指定目录
$ mkdir -p _output/lib/
$ cp /usr/lib64/librbd.so.1.0.0 /usr/lib64/librados.so.2.0.0 /usr/lib64/ceph/libceph-common.so.0 /usr/lib64/libsoftokn3.so /usr/lib64/libsqlite3.so.0.8.6 /usr/lib64/libfreeblpriv3.so _output/lib/

# 修改host Dockerfile
$ git diff build/docker/Dockerfile.host
diff --git a/build/docker/Dockerfile.host b/build/docker/Dockerfile.host
index 97bc60b..6450361 100644
--- a/build/docker/Dockerfile.host
+++ b/build/docker/Dockerfile.host
@@ -4,6 +4,14 @@ MAINTAINER "Yaoqi Wan wanyaoqi@yunionyun.com"

 ENV TZ Asia/Shanghai

-RUN apk add librados librbd
 RUN mkdir -p /opt/yunion/bin
-ADD ./_output/alpine-build/bin/host /opt/yunion/bin/host
+
+ADD ./_output/bin/host /opt/yunion/bin/host
+ADD ./_output/bin/.host.bin /opt/yunion/bin/.host.bin
+ADD ./_output/bin/bundles/host /opt/yunion/bin/bundles/host
+ADD ./_output/lib /usr/lib/

# 修改host-deployer Dockerfile
$ git diff build/docker/Dockerfile.host-deployer
diff --git a/build/docker/Dockerfile.host-deployer b/build/docker/Dockerfile.host-deployer
index c6d55dd..e376823 100644
--- a/build/docker/Dockerfile.host-deployer
+++ b/build/docker/Dockerfile.host-deployer
@@ -6,4 +6,12 @@ ENV TZ Asia/Shanghai

 RUN mkdir -p /opt/yunion/bin

-ADD ./_output/centos-build/bin/host-deployer /opt/yunion/bin/host-deployer
+ADD ./_output/bin/host-deployer /opt/yunion/bin/host-deployer
+ADD ./_output/bin/.host-deployer.bin /opt/yunion/bin/.host-deployer.bin
+ADD ./_output/bin/bundles/host-deployer /opt/yunion/bin/bundles/host-deployer
+ADD ./_output/lib /usr/lib/


# 切换编译方式，并且打包相关lib
$ git diff scripts/docker_push.sh
diff --git a/scripts/docker_push.sh b/scripts/docker_push.sh
index f46161e..27deda0 100755
--- a/scripts/docker_push.sh
+++ b/scripts/docker_push.sh
@@ -76,9 +76,12 @@ build_bin() {
                 env $BUILD_ARCH $BUILD_CGO make -C "$SRC_DIR" docker-alpine-build F="cmd/$1 cmd/*cli"
             fi
             ;;
-        host-deployer | telegraf-raid-plugin)
+        telegraf-raid-plugin)
             env $BUILD_ARCH $BUILD_CGO make -C "$SRC_DIR" docker-centos-build F="cmd/$1"
             ;;
+        host-deployer | host)
+            GOOS=linux make cmd/$1
+            ;;
         *)
             env $BUILD_ARCH $BUILD_CGO make -C "$SRC_DIR" docker-alpine-build F="cmd/$1"
             ;;
@@ -87,7 +90,7 @@ build_bin() {


 build_bundle_libraries() {
-    for bundle_component in 'baremetal-agent'; do
+    for bundle_component in 'baremetal-agent' 'host' 'host-deployer'; do
         if [ $1 == $bundle_component ]; then
             $CUR_DIR/bundle_libraries.sh _output/bin/bundles/$1 _output/bin/$1
             break 

# 编译host、host-deployer镜像, 需替换自己的namespace
$ TAG=v3.6-ceph REGISTRY=registry.cn-beijing.aliyuncs.com/{namespace} ./scripts/docker_push.sh host
$ TAG=v3.6-ceph REGISTRY=registry.cn-beijing.aliyuncs.com/{namespace} ./scripts/docker_push.sh host-deployer
```

## 替换计算节点ceph库文件
- 为了避免计算节点qemu-image或qemu-system连接ceph集群时卡死
- 这里需要把上面提取的ceph rbd rados相关的so文件(_output/lib/)替换到计算节点相应的文件(若已经使用存储厂商的so库，此步骤忽略)

## 替换镜像&挂载目录
```bash
# 将 image: registry.cn-beijing.aliyuncs.com/yunionio/host:v3.6.... 替换为上面打包好的镜像
# 修改 volumeMounts 相关选项,将存储厂商ceph所需要访问的目录, 挂载到相应的地方(可选)
$ kubectl edit daemonsets. -n onecloud default-host
# 将 image: registry.cn-beijing.aliyuncs.com/yunionio/host-deployer:v3.6.... 替换为上面打包好的镜像
# 修改 volumeMounts 相关选项,将存储厂商ceph所需要访问的目录, 挂载到相应的地方(可选)
$ kubectl edit daemonsets. -n onecloud default-host-deployer
```
