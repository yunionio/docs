---
title: "网卡流量限制"
weight: 900
description: >
  介绍如何设置网卡流量限制
---

本节介绍设置网卡流量限制。网卡流量限制分为上行下行流量，只要有一边的流量超标将会切断网卡。网卡流量限制是通过采集网卡收发包监控数据来实现的，采集周期为一分钟，所以可能流量超标了但是还是需要等到流量采集周期到了才会切断网卡。

## 设置流量限制

### 创建虚机时设置流量限制
```bash
$ climc server-create --network rx-traffic-limit=102400000,tx-traffic-limit=102400000 ...

# tx-traffic-limit为上行，rx-traffic-limit为下行单位均为字节 byte

# 查看网卡详细信息
$ climc server-network-show <SERVER_ID> <NETWORK_ID>
| rx_traffic_limit | 102400000                            |
| rx_traffic_used  | 0                                    |
......
| tx_traffic_limit | 102400000                            |
| tx_traffic_used  | 0                                    |

# rx_traffic_used/tx_traffic_used 是已使用的网卡流量信息，单位均为字节 byte
```

### 为网卡单独设置流量限制

```bash
#设置流量限制的接口有两个：
$ server-set-nic-traffic-limit
Usage: climc server-set-nic-traffic-limit [--tx-traffic-limit TX_TRAFFIC_LIMIT] [--help] [--rx-traffic-limit RX_TRAFFIC_LIMIT] <ID> <MAC>
$ server-reset-nic-traffic-limit
Usage: climc server-reset-nic-traffic-limit [--tx-traffic-limit TX_TRAFFIC_LIMIT] [--help] [--rx-traffic-limit RX_TRAFFIC_LIMIT] <ID> <MAC>

# server-set-nic-traffic-limit 设置网卡流量上限，不重置已使用的流量
# server-reset-nic-traffic-limit 设置网卡流量上限的同时重置已使用的流量
# 参数中 MAC 为网卡的 mac 地址

# 设置完成查看网卡信息
$ climc server-network-show <SERVER_ID> <NETWORK_ID>
```

网卡流量到达上限后会切断网卡，需要调用这两个接口设置更高的流量上限或者重置网卡已使用的流量来恢复网卡。
