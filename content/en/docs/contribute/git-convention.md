---
title: "Git Commit Message Convention"
weight: 3
description: >
  git commit message convention
---

For the purpose of word-processing the code change history, and statistics, we compile the following Git Commit Message Convention to regulate the format of Git Commit Message.

## Git Commit Message Convention

Conform to the following format:

```bash
<type>(<scope>): <subject>

<body>

<footer>
```

The message is composed of three parts (part is separated by an empty line):

- Title: required, describing the type of modification and a concise summary of changes
- Content: optional, describing in details why the modification is need, how to change, the basic outline of codes, how to make the change take effect, etc.
- Notes: optional, some additional notes

The descriptions of tokens of each part are explained as following:

- type(type of PR:
    - feat: new feature
    - fix: bug fix
    - refactor: recode, refactoring of codes
    - test: test cases
    - chore: modifications of helping scripts, such as Makefile, Dockerfile, etc.

- scope(components of impact): such as region, scheduler, cloudcommon, etc.，use comma ',' as separator if impacting multiple components, e.g. (region,scheduler,monitor)

- subject(concise summary of commit): no more than 50 characters

- body(detailed description of commit, optional): can be multiple lines, each line contains no more than 72 characters

- footer(some notes, optional): some notes, e.g. references, breaking change, upgrading suggestions or url of related tasks or issue

## Commit Examples

---

```bash
fix(region): compute NextSyncTime for snapshotpolicydisk

1. If calculated NextSyncTime equals to base, increase base by 1 hour to process recusively.
2. For snapshotpolicies with effective retentionday, e.g. a snapshotpolicy
   takes effect on every Monday and the snapshots are kept for 3 days automatically,
   synchronization will be performed on every Month (for snapshoting) and Thursday 
   (for release snapshots). 
```
---

```bash
feat(scheduler): add cpu filter

Added new cpu filter to scheduler:

- filter host by cpu model
- set host capability by request cpu count
```
---

```bash
fix(apigateway,monitor,influxdb): disable influxdb service query proxy
```
---

```bash
feat(climc): support disable wrap line

Usage:
export OS_TRY_TERM_WIDTH=false
climc server-list

Closes #6710
```
---

## References

- https://docs.google.com/document/d/1QrDFcIiPjSLDn3EL15IJygNPiHORgU1_OOAqWjiDU5Y/edit#heading=h.fpepsvr2gqby

- http://www.ruanyifeng.com/blog/2016/01/commit_message_change_log.html

- https://blog.csdn.net/noaman_wgs/article/details/103429171
