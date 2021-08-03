---
title: "监控"
date: 2019-07-19T20:59:00+08:00
weight: 10
description: >
  监控原理以及功能
---

## 监控服务架构

主要由以下几个组件构成：

- 监控Agent（telegraf）

部署在宿主机或者虚拟机内部的监控数据采集agent，目前使用开源的telegraf

- cloudmon

主动从各个平台拉取监控数据，采集一些使用量指标，以及进行ping监控

- influxdb

监控数据存储

- monitor

提供监控服务API，屏蔽后端监控的差异。同时提供报警的功能以及API。


## 监控数据采集

监控数据通过几个途径采集获得

- 私有云宿主机

通过部署在私有云宿主机的telegraf采集监控数据

- 云平台

通过cloudmon服务，周期性地调用各个平台的API，采集监控数据


- 主动部署监控代理（telegraf）
