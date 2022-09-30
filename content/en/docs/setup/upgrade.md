---
title: "Upgrade"
linkTitle: "Upgrade"
edition: ce
weight: 100
description: >
  Introduction of how to upgrade the version
---

This article describes the steps and considerations for upgrading from v3.7.x to v3.8.x.

Version upgrades are recommended from adjacent versions, e.g. upgrading from v3.2.x to v3.7.x requires the following steps:

1. v3.2.x => v3.3.x
2. v3.3.x => v3.4.x
3. v3.4.x => v3.6.x
4. v3.6.x => v3.7.x

It may be a problem to upgrade directly across multiple versions, so it is recommended to refer to the following content to choose the upgrade procedure:

- [v3.1.x upgrade to v3.2.x](https://www.cloudpods.org/v3.2/docs/setup/upgrade)
- [v3.2.x upgrade to v3.3.x](https://www.cloudpods.org/v3.3/docs/setup/upgrade)
- [v3.3.x upgrade to v3.4.x](https://www.cloudpods.org/v3.4/docs/setup/upgrade)
- [v3.4.x upgrade to v3.6.x](https://www.cloudpods.org/v3.6/zh/docs/setup/upgrade)
- [v3.6.x upgrade to v3.7.x](https://www.cloudpods.org/v3.7/zh/docs/setup/upgrade)

In general, the steps for upgrading are as follows:

Use the [ocboot](https://github.com/yunionio/ocboot) tool we wrote to perform the upgrade, which essentially calls ansible to upgrade all nodes inside the cluster.

1. Use git pull [ocboot](https://github.com/yunionio/ocboot) source code and checkout to release/3.8 branch
2. Use [ocboot](https://github.com/yunionio/ocboot) to upgrade

## Get current version

You can view the current cluster version using kubectl:

```bash
# Use kubectl to get the current version of the cluster as v3.7.5
$ kubectl -n onecloud get onecloudclusters default -o=jsonpath='{.spec.version}'
v3.7.5
```

## Pull ocboot tool

If you already have the ocboot tool locally, you can skip this step and just update the code to the corresponding branch.

```bash
# Install ansible and python-paramiko locally
$ yum install -y python3-pip
$ python3 -m pip install --upgrade pip setuptools wheel
$ python3 -m pip install --upgrade ansible paramiko

# git clone ocboot
$ git clone -b release/3.8 https://github.com/yunionio/ocboot && cd ./ocboot
```

## Fetch ocboot latest source code

```bash
$ git checkout release/3.8
$ git pull
```

## Upgrade Cloudpods cluster services

The update service works by remotely logging in to the first control node of the cluster via local ssh with no password, getting information about all the nodes, and then performing playbook updates via ansible, so the following requirements need to known:

1. Local machine can ssh remotely login PRIMARY_MASTER_HOST
2. PRIMARY_MASTER_HOST can ssh password-free login to other nodes in the cluster

If you have not set password-free login, use the command *ssh-copy-id -i ~/.ssh/id_rsa.pub root@PRIMARY_MASTER_HOST* to downlink the public key to the corresponding node in your environment.

The upgrade version number can be found on the [CHANGELOG release/3.8 page](... /... /changelog/release-3.8/).

```bash
# Use ocboot upgrade version to v3.8.3
# This step will take longer because of pulling the docker image, please be patient
# PRIMARY_MASTER_HOST is the ip address of the first node of the deployed cluster
# Need to be able to log on locally with ssh key
$ ./ocboot.py upgrade <PRIMARY_MASTER_HOST> v3.8.3

# Alternatively, you can use `. /ocboot.py upgrade --help` for other optional parameters
# For example:
# --user Specify PRIMARY_MASTER_HOST ssh user
# --port Specify PRIMARY_MASTER_HOST ssh port
# --key-file Use other ssh private key
# --as-bastion Use PRIMARY_MASTER_HOST deployed as the intranet host for the bastion

# You can also log in to PRIMARY_MASTER_HOST during the upgrade process and use kubectl to view the upgrade status of the corresponding pods
$ kubectl get pods -n onecloud --watch
```

## Downgrade Related

If you encounter any problems with the upgrade, such as a feature not meeting expectations or a bug, you can downgrade and roll back with the following command.

{{% alert title="Attention" color="warning" %}}
- Usually minor version downgrades are no problem, for example, from v3.8.3 to v3.8.2
- Downgrading across major versions may be problematic, e.g. from v3.8.3 to v3.6.8

If you encounter problems, please go to [GitHub mention issue](https://github.com/yunionio/cloudpods/issues).
{{% /alert %}}

```bash
# The principle of downgrading is to modify the image version of each service
# For example, the current version is v3.8.3 and then you want to downgrade to v3.7.8
# 在第一个控制节点执行如下命令降级会 v3.7.8
$ /opt/yunion/bin/ocadm cluster update --version v3.7.8 --wait

# Downgrading will re-pull a new mirror and can open another window
# Use the following command to view the updates for each pod
$ kubectl -n onecloud get pods -w
```
