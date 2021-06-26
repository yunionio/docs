---
title: "ROADMAP"
weight: 101
description: >
  Roadmap
---

## Architecture

Optimize the general architecture of cloudpods

- [ ] Seperate on-premise cloud (Cloudpods native cloud, i.e. KVM, Baremetal, VMware) and Cloud Management (Management of other clouds) into different service components
- [ ] On-premise cloud: seperate storage agent to do storage management tasks
- [ ] On-premise cloud: integrate Rook for shared storage
- [ ] On-premise cloud: store state of baremetal agent in DB
- [ ] Cloud management: allow managing multiple instance of cloudpods native cloud
- [ ] Cloud management: recode resource synchronization, better code structure and finer grain synchronization resource

## Mutli-cloud Resource Management

Further broaden the coverage of cloud products and providers.

- [ ] Support more kinds of resources, such as Azure RDS，Redis，LoadBalance，WebApp, AWS redis 
- [ ] Support more cloud providers, such as QingCloud
- [ ] Support read-only mode of cloud account

## Unified Monitoring and Alerting

A unified Multi-cloud monitoring and alerting solution.

- [ ] Adopts Prometheus as the core monitoring solution.
- [ ] Automate monitoring agent installation
- [ ] Secure communication channel for collecting monitoring metrics across multi-cloud boundaries
- [ ] Integrating native alerting on cloud providers

## Multi-cloud Application Delivery and Orchastration

Based on container technology, develop the capability to deliver applications across multi-cloud.

- [ ] Unified management of multiple Kubernetes clusters
- [ ] Deployment of Kubernetes Clusters over multi-cloud environment
- [ ] Multi-cloud application delivery
- [ ] Multi-cloud application migration

