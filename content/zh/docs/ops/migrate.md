---
title: "将其他KVM平台虚拟机镜像迁移到平台"
date: 2021-11-11T15:58:12+08:00
weight: 60
description: >
    将其他KVM平台虚拟机镜像迁移到平台
---

1. 通过libvirt导出虚拟机的镜像（.qcow2文件）。
2. 将镜像上传至一个http服务器中。
3. 使用{{<oem_name>}}镜像服务器导入系统镜像。
4. 通过镜像创建虚拟机。
5. 若原来的虚拟机挂载了云硬盘，可按照以下方式迁移：
   - 与上述操作类似，需要先将数据盘生成镜像，同理导入，{{<oem_name>}}使用该镜像创建数据云盘，再将云硬盘挂载到虚拟机即可。
   - 先在{{<oem_name>}}中创建一个相同大小的云硬盘，找到对应的路径，将原云盘数据直接复制到新的路径下，最后再挂载到虚拟机上。 

## Proxmox 示例
登录pve限制台，选中对于主机，在hardware 中查看当前主机hard disk id：
<img width="992" alt="image" src="https://github.com/yunionio/cloudpods/assets/1650540/eea3492e-e55d-4b95-ba95-45b9feadf41b">

以图中 local-lvm:vm-101-disk-0  为例，登录对应宿主机，执行
```
#pvesm path local-lvm:vm-101-disk-0
/dev/pve/vm-101-disk-0
```
`/dev/pve/vm-101-disk-0` 即是我们要迁移的磁盘，停止虚拟机，导出：

```
#qemu-img convert -c -p -f raw -O qcow2  /dev/pve/vm-101-disk-0 /mnt/vm-101-disk0
```

导出镜像位于 /mnt/vm-101-disk-0，由于开启压缩，文件会小一些。
>  '-c' indicates that target image must be compressed (qcow format only)

在当前目录，python3 -m http.server 9999 开启http server，或者传到nginx 等http 服务，在cloudpods 系统镜像中，导入镜像，创建虚拟机即可。

若虚拟机存在多块磁盘，按上文方式，将多个disk 导出为qcow2，再导入为系统镜像，使用`climc guest-image-create` 将多个系统镜像合并创建为主机镜像，
```
climc guest-image-create <name> --image <id_of_root_image> --image <id_of_data_image> --image ...
```

注意严格保证`--image`镜像顺序和pve 内顺序一致，ID为导入cloudpods 的系统镜像UUID。

创建主机镜像成功后，使用主机镜像创建虚拟机即可，参考：[制作主机镜像](https://www.cloudpods.org/zh/docs/function_principle/onpremise/glance/guestimage/create/)





