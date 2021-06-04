---
title: "Multi-node Installation"
linkTitle: "Multi-node Installation"
weight: 1
description: >
  Use ocboot installation tool to deploy Cloupods in multiple nodes
---

Like the [All in One Installation](../allinone), the multi-node installation uses installation tool https://github.com/yunionio/ocboot to deploy the nodes according to the configuration by executing the ansible playbook.

## Environmental Preparation

Please refer to the [All in One Installation/Configuration Requirements](../allinone/#configuration-requirements) for environment preparation and requirements for different architecture CPU and OS.

The following is the environment for the machines to be deployed, assuming that 5 machines have been prepared with IPs 10.127.10.156-160, and that each node makes the following role plans:

- mariadb_node: This role indicates that the mariadb database service is deployed and running on that node. This role does not have to be written in the configuration if there is a database already in your environment
    - node IP: 10.127.10.156
- primary_master_node: This role indicates that the node is the first node to deploy and run the k8s master component, which must be present in the configuration, and that the role also runs the onecloud control services
    - node IP: 10.127.10.156
- master_nodes: This role indicates that these nodes are running the control service, which is optional, and is primarily used along with primary_master_node to form Kubernetes' etcd 3 node high availability cluster
    - node IP: 10.127.10.157-158
- worker_nodes: This role indicates that these nodes run private cloud computing services. This role is optional and can be unconfigured if the built-in private cloud functionality is not required
    - node IP: 10.127.10.159-160

|         IP        | Login User | Role                               |
|:-----------------:|:--------:|------------------------------------|
|   10.127.10.156   |   root   | mariadb_node & primary_master_node |
| 10.127.10.157-158 |   root   | master_nodes                       |
| 10.127.10.159-160 |   root   | worker_nodes                       |

## Start Installation

### Download ocboot

 Please refer to the [All in One Installation/Download ocboot](../allinone/#download-ocboot).

### Write deployment configuration

```bash
# Write config-nodes.yml configuration file
$ cat <<EOF >./config-nodes.yml
mariadb_node:
  hostname: 10.127.10.156
  user: root
  db_user: root
  db_password: your-sql-password
primary_master_node:
  onecloud_version: v3.7.1
  hostname: 10.127.10.156
  user: root
  db_host: 10.127.10.156
  db_user: root
  db_password: your-sql-password
  controlplane_host: 10.127.10.156
  controlplane_port: "6443"
master_nodes:
  hosts:
  - hostname: 10.127.10.157
    user: root
  - hostname: 10.127.10.158
    user: root
  controlplane_host: 10.127.10.156
  controlplane_port: "6443"
worker_nodes:
  hosts:
  - hostname: 10.127.10.159
    user: root
  - hostname: 10.127.10.160
    user: root
  controlplane_host: 10.127.10.156
  controlplane_port: "6443"
EOF
```

### Start Deployment

Once the config-nodes.yml deployment configuration file is filled in, you can execute the ocboot file `. /run.py . /config-nodes.yml` to deploy the cluster.

```bash
# Start deployment
$ ./run.py ./config-nodes.yml
```

Once the deployment is complete, you can access https://10.168.26.216 (the IP of the primary_master_node) using your browser, and enter he username `admin` and password `admin@123` to enter the Web UI.

Then you can [create private cloud virtual machines](../allinone/#create-the-first-virtual-machine) or [import public cloud or other private cloud platform resources](../allinone/#import-public-cloud-or-other-private-cloud-platform-resources).
