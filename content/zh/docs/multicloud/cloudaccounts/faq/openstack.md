---
title: "Openstack"
weight: 2
description: >
    Openstack 对接常见问题。
---

## 对接 Openstack 后端使用ceph 存储的时候，云账户管理，经常同步不下相关的ceph 磁盘配置

我们需要在创建磁盘的时候指定相关的ceph 类型。首先检查一下是否指定了volume_backend_name.

1、查看cinder配置文件的ceph 指定的name,没有就添加：

```
[ceph]
volume_driver = cinder.volume.drivers.rbd.RBDDriver
rbd_pool = volumes
rbd_ceph_conf = /etc/ceph/ceph.conf
rbd_flatten_volume_from_snapshot = false
rbd_max_clone_depth = 5
rbd_store_chunk_size = 4
rados_connect_timeout = -1
glance_api_version = 2
rbd_user = cinder
rbd_secret_uuid = f4f03912-7ec7-42e9-b9ea-8735217d8cc9
volume_backend_name = ceph
```

2、添加ceph类型关联到volume_backend_name:

```bash
[root@cinder1 cinder]# cinder extra-specs-list
[root@cinder1 cinder]# cinder type-create ceph
+--------------------------------------+------+-------------+-----------+
| ID                                   | Name | Description | Is_Public |
+--------------------------------------+------+-------------+-----------+
| 00103a9a-bcf6-4c25-afb4-fd2a211cc706 | ceph | -           | True      |
+--------------------------------------+------+-------------+-----------+
[root@cinder1 cinder]# cinder type-key ceph set volume_backend_name=ceph
[root@cinder1 cinder]# cinder extra-specs-list
+--------------------------------------+------+---------------------------------+
| ID                                   | Name | extra_specs                     |
+--------------------------------------+------+---------------------------------+
| 00103a9a-bcf6-4c25-afb4-fd2a211cc706 | ceph | {'volume_backend_name': 'ceph'} |
+--------------------------------------+------+---------------------------------+
```

3、重新添加volume；指定类型为ceph即可。

4、cloudpods可以重新同步，可以看到磁盘已经同步下来。


## 纳管 Openstack 后没有资源同步下来

1、检查纳管OpenStack的账号是否以admin的角色(非admin角色可能会有权限的问题)加入项目.

2、排除账号权限后，检查cloudpods能否访问OpenStack控制节点，执行下面的命令，出现截图的内容，确实是域名解析的问题
```bash
[root@test-69-onecloud01 ~]# kubectl get pods -n onecloud |grep climc
default-climc-6fccbbfd8d-l59gg                       1/1     Running            0          4d13h
[root@test-69-onecloud01 ~]# kubectl exec -it  -n onecloud default-climc-6fccbbfd8d-l59gg bash
Welcome to Cloud Shell :-) You may execute climc and other command tools in this shell.
Please exec 'climc' to get started

bash-5.1# source <(climc cloud-provider-list --provider OpenStack | awk 'NR==4 {print $2}' | xargs climc cloud-provider-clirc)
bash-5.1# openstackcli host-list
```
![a19f70a99ed18986ac2edd60ea86be3](https://user-images.githubusercontent.com/32036395/157816747-cb7466dd-679e-4e89-bacc-c58446950bfa.png)

解决方法参考 https://www.cloudpods.org/zh/docs/multicloud/cloudaccounts/tutorial/create/

