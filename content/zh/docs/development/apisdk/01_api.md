---
title: "API调用方法"
date: 2019-07-11T20:39:39+08:00
weight: 1
description: >
  介绍var_oem_name API调用方法
---

本章节介绍{{<oem_name>}} API的调用方法。

[详细的API内容请参考API](../../../swagger/)。

1. 使用climc先创建aksk
```
$climc credential-create-aksk
+--------+----------------------------------------------+
| Field  |                    Value                     |
+--------+----------------------------------------------+
| expire | 0                                            |
| secret | OGVmTXNKQWpBWHpUejZTWDNKcndSdXlHQUNFeXhLVWI= |
+--------+----------------------------------------------+
```

2. 使用climc查询刚创建出来的aksk
```
$climc credential-get-aksk
+--------+----------------------------------+----------------------------------+----------------------------------------------+----------------------+
| expire |              key_id              |            project_id            |                    secret                    |      time_stamp      |
+--------+----------------------------------+----------------------------------+----------------------------------------------+----------------------+
| 0      | ba92f912922044268d4ad1dc70aafe57 | 0e4416c837644f5a8f0d67c9930ff228 | OGVmTXNKQWpBWHpUejZTWDNKcndSdXlHQUNFeXhLVWI= | 2022-02-20T17:12:26Z |
+--------+----------------------------------+----------------------------------+----------------------------------------------+----------------------+
```

3. 获取认证地址
```
$ocadm cluster rcadmin
export OS_AUTH_URL=https://10.211.55.9:30500/v3
export OS_USERNAME=sysadmin
export OS_PASSWORD=qNVaPTw9fCCMJ7eJ
export OS_PROJECT_DOMAIN=default
export OS_PROJECT_NAME=system
export YUNION_INSECURE=true
export OS_REGION_NAME=region0
export OS_ENDPOINT_TYPE=publicURL
```

4. 通过climc获取各个服务的endpoint
```
// 可以看到认证地址是https://10.211.55.9:30500/v3, 在通过上面创建出来的aksk进行认证(同样可以用用户密码认证，不过需要传的参数多一些，认证也比较慢，不推荐使用), 使用climc命令时，可以通过--debug来查看传参
// 这里aksk认证加密算法可以参考 https://github.com/yunionio/cloudpods/blob/10b1d9bdd35776cf8cb597d918fa571fbc356238/pkg/mcclient/aksk.go#L80
$climc --debug --os-access-key ba92f912922044268d4ad1dc70aafe57 --os-secret-key 'OGVmTXNKQWpBWHpUejZTWDNKcndSdXlHQUNFeXhLVWI=' region-list
POST /v3/auth/tokens HTTP/1.1
Host: 10.211.55.9:30500
User-Agent: yunioncloud-go/201708
Content-Length: 573
Accept: */*
Accept-Encoding: *
Content-Type: application/json


CURL: curl -X 'POST' -d '{"auth":{"context":{"source":"cli"},"identity":{"access_key_secret":"{\"access_key\":\"ba92f912922044268d4ad1dc70aafe57\",\"algorithm\":\"AWS4-HMAC-SHA256\",\"location\":\"cn-beijing\",\"request\":\"AWS4-HMAC-SHA256\\n20220220T172931Z\\n20220220/cn-beijing/s3/aws4_request\\n5ff6dad4605ea24e0f0be6c6885eddbbe1a5619c89f682b21d719aa50dcb9264\",\"sign_date\":\"2022-02-20T17:29:31.000000Z\",\"signature\":\"4c92b91266168fc650fec9303a9dc3309f12d0fe66c5b0a605082e0260c70ce2\",\"signed_headers\":[\"date\",\"host\",\"x-amz-content-sha256\",\"x-amz-date\"]}","methods":["aksk"]}}}' -H 'Accept: */*' -H 'Accept-Encoding: *' -H 'Content-Length: 573' -H 'Content-Type: application/json' -H 'User-Agent: yunioncloud-go/201708' 'https://10.211.55.9:30500/v3/auth/tokens'

HTTP/1.1 200 OK
Content-Length: 11253
Content-Type: application/json;charset=utf-8
Date: Sun, 20 Feb 2022 17:29:31 GMT
Server: Yunion AppServer/Go/2018.4
Vary: Origin
X-Frame-Options: SAMEORIGIN
X-Request-Host-Id: E1-kuT8w8_MRxLW1dXWRr9NPrGw=
X-Request-Id: 51fde4
X-Subject-Token: gAAAAABiEnp7Z3hP_xecU36DvRzu8Y67m2mDM9JfFip6NMcH2BjI8FT3-vaJ6JztgdGJaztXQDj1mDno-X-fHU0AvG-s56Yb-kXQj8dwo9g56EutyqVFgZ77FAdjvZNfcfEKt_sgrBbsPaVTqLOrrqHiu6UQckEJDKIp744zQOsZii66_CXwnc9MKQZO9sCw91BFDZMUrghj
X-Yunion-Peer-Service-Name: identity
X-Yunion-Remote-Addr: 10.211.55.9:43648
X-Yunion-Span-Name: auth_tokens_v3


Response body: {"id":"gAAAAABiEnp7Z3hP_xecU36DvRzu8Y67m2mDM9JfFip6NMcH2BjI8FT3-vaJ6JztgdGJaztXQDj1mDno-X-fHU0AvG-s56Yb-kXQj8dwo9g56EutyqVFgZ77FAdjvZNfcfEKt_sgrBbsPaVTqLOrrqHiu6UQckEJDKIp744zQOsZii66_CXwnc9MKQZO9sCw91BFDZMUrghj","token":{"access_key":{"access_key":"ba92f912922044268d4ad1dc70aafe57","expire":0,"secret":"OGVmTXNKQWpBWHpUejZTWDNKcndSdXlHQUNFeXhLVWI="},"audit_ids":["58076f50591e288d4aa4fdc76b946f7b"],"catalog":[{"endpoints":[{"id":"0d81a11591584b958a04804dd5abbabc","interface":"internal","name":"yunionconf-internal","region":"region0","region_id":"region0","url":"https://default-yunionconf:30889"},{"id":"9cfa500c785c4195831bd70161133802","interface":"public","name":"yunionconf-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30889"}],"id":"87217758659c4cb18ba26bf0577e3427","name":"yunionconf","type":"yunionconf"},{"endpoints":[{"id":"0dd167cc3194438e88467a0a7bd6ef3c","interface":"public","name":"notify-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30777"},{"id":"68f22940bccc47eb8666cfe1cbc6d256","interface":"internal","name":"notify-internal","region":"region0","region_id":"region0","url":"https://default-notify:30777"}],"id":"0db18c12231c4f16895f9c562128118e","name":"notify","type":"notify"},{"endpoints":[{"id":"264468c6e2b14ccc80a3dc174be14124","interface":"internal","name":"autoupdate-internal","region":"region0","region_id":"region0","url":"https://default-autoupdate:30981"},{"id":"de136a3d766d4c178b84cf10e0740592","interface":"public","name":"autoupdate-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30981"}],"id":"cd7482a6ffa042b789185c5c1f4ab020","name":"autoupdate","type":"autoupdate"},{"endpoints":[{"id":"4ce974d81f494bef85b9e4f8e7654632","interface":"public","name":"log-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30999"},{"id":"87f433df2d624ce28c1143f4d5db238e","interface":"internal","name":"log-internal","region":"region0","region_id":"region0","url":"https://default-logger:30999"}],"id":"60cf87cd573749b58250fa6c0d6794af","name":"log","type":"log"},{"endpoints":[{"id":"5123f3dab82b47f780f284637a18a518","interface":"admin","name":"identity-admin","region":"region0","region_id":"region0","url":"https://10.211.55.9:30357/v3"},{"id":"885a45a04af2419783906d069c737465","interface":"public","name":"identity-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30500/v3"},{"id":"b453e1ca7dfc4595884fed16011d1717","interface":"internal","name":"identity-internal","region":"region0","region_id":"region0","url":"https://default-keystone:30500/v3"}],"id":"55e14f71e0c34a8682dbeaef10a7cbb4","name":"keystone","type":"identity"},{"endpoints":[{"id":"67f79d211c284bc08afe707cdc81106e","interface":"internal","name":"websocket-internal","region":"region0","region_id":"region0","url":"https://default-apigateway:30443"},{"id":"d5d5962163c148068bf44a3341898e73","interface":"public","name":"websocket-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30443"}],"id":"0185442fc0f040d2815a83ded61bb009","name":"websocket","type":"websocket"},{"endpoints":[{"id":"202b6def24134ce7813062c850e40850","interface":"internal","name":"s3gateway-internal","region":"region0","region_id":"region0","url":"https://default-s3gateway:30884"},{"id":"8c931e66bb874e8e80d71a509ef0fef8","interface":"public","name":"s3gateway-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30884"}],"id":"f46030569f6e4de58c04bbbe017f0ca5","name":"s3gateway","type":"s3gateway"},{"endpoints":[{"id":"47226520bc0d45a6838a3e51fa29b6e4","interface":"public","name":"image-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30292/v1"},{"id":"c1646e81c8944be98683a3d3b0c798be","interface":"internal","name":"image-internal","region":"region0","region_id":"region0","url":"https://default-glance:30292/v1"}],"id":"f22c933cdf37427d88ea6e9d98b4a221","name":"glance","type":"image"},{"endpoints":[{"id":"731c5e0a9918439683ff5467fbbc5dde","interface":"public","name":"monitor-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30093"},{"id":"e2e88b11e60f42df80ac3d4d4b076000","interface":"internal","name":"monitor-internal","region":"region0","region_id":"region0","url":"https://default-monitor:30093"}],"id":"e42a56482f67437a8a8e213386da07d7","name":"monitor","type":"monitor"},{"endpoints":[{"id":"a9c1b32c54fb4a028803d52180e8b5a3","interface":"internal","name":"compute_v2-internal","region":"region0","region_id":"region0","url":"https://default-region:30888"},{"id":"adecd09b5e20436e8651b4a66d4326c8","interface":"public","name":"compute_v2-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30888"}],"id":"efd8e0bed6cc43bf8b2c7ef0a5e1803b","name":"region2","type":"compute_v2"},{"endpoints":[{"id":"19f2eadbf2b9406b8e2e3aa2684ad7e5","interface":"internal","name":"offlinecloudmeta-internal","region":"region0","region_id":"region0","url":"https://yunionmeta.oss-cn-beijing.aliyuncs.com"},{"id":"7ba10412dfbc42ee82dada7eda7a1014","interface":"public","name":"offlinecloudmeta-public","region":"region0","region_id":"region0","url":"https://yunionmeta.oss-cn-beijing.aliyuncs.com"}],"id":"a8f6bc5429af48228d0da5dd520af0a7","name":"offlinecloudmeta","type":"offlinecloudmeta"},{"endpoints":[{"id":"25df9d4db3964d158d3201eb33118e09","interface":"internal","name":"influxdb-internal","region":"region0","region_id":"region0","url":"https://default-influxdb:30086"},{"id":"31551be071934bec8e41e15c2e7d2b45","interface":"public","name":"influxdb-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30086"}],"id":"0b2b9c3d45e742e38fcce3063b00b2d7","name":"influxdb","type":"influxdb"},{"endpoints":[{"id":"3924af6d9ccd4dd28d0d5627d0f916dd","interface":"public","name":"webconsole-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30899"},{"id":"403d0d9f349e447f809752ce1c8a2c0e","interface":"internal","name":"webconsole-internal","region":"region0","region_id":"region0","url":"https://default-webconsole:30899"}],"id":"017d07de150a435180f12931272ad286","name":"webconsole","type":"webconsole"},{"endpoints":[{"id":"650d0a29ac534d36852efeaec12ecb7b","interface":"internal","name":"k8s-internal","region":"region0","region_id":"region0","url":"https://default-kubeserver:30442/api"},{"id":"c9b157c4bf7b47258b17d2b9dccfc609","interface":"public","name":"k8s-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30442/api"}],"id":"00aa0118f4bc40f38b12576675db9922","name":"k8s","type":"k8s"},{"endpoints":[{"id":"9361347388bf461a8a88543aa6df0af1","interface":"public","name":"cloudid-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30893"},{"id":"dd5f11acb719481380c7e7fcc2c57fe2","interface":"internal","name":"cloudid-internal","region":"region0","region_id":"region0","url":"https://default-cloudid:30893"}],"id":"a5bc5f118c484d6b812c8f807c5e5981","name":"cloudid","type":"cloudid"},{"endpoints":[{"id":"b61f4332c4594d05866634b9e7e87319","interface":"internal","name":"torrent-tracker-internal","region":"region0","region_id":"region0","url":"https://tracker.yunion.cn"},{"id":"e543ab98873c4d838a2d1950e5fc2cb6","interface":"public","name":"torrent-tracker-public","region":"region0","region_id":"region0","url":"https://tracker.yunion.cn"}],"id":"29a4f2e4fd8b4e6c876ac3c41fdad610","name":"torrent-tracker","type":"torrent-tracker"},{"endpoints":[{"id":"48e06ade707040d38a2c81054d916772","interface":"internal","name":"etcd-internal","region":"region0","region_id":"region0","url":"http://default-etcd-client.onecloud.svc:2379"}],"id":"012622a60c814d478d180ee28107caf0","name":"etcd","type":"etcd"},{"endpoints":[{"id":"84293895e9db410e8c8584afc3fde39b","interface":"internal","name":"ansible-internal","region":"region0","region_id":"region0","url":"https://default-ansibleserver:30890"},{"id":"a9e5c8be89254bb98c444bb04344e1f7","interface":"public","name":"ansible-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30890"}],"id":"1313597e674a4bfc8f7dcf06f3033280","name":"ansible","type":"ansible"},{"endpoints":[{"id":"022b48ad6b6640858471aa2074f600ee","interface":"public","name":"devtool-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30997"},{"id":"5ed574340c40491f8506b6aa48b2be8b","interface":"internal","name":"devtool-internal","region":"region0","region_id":"region0","url":"https://default-devtool:30997"}],"id":"c239df97fd0148e78ce143e7017f3859","name":"devtool","type":"devtool"},{"endpoints":[{"id":"05655d3ea1da4aca8b4441c2597a4a73","interface":"public","name":"cloudevent-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30892"},{"id":"87b37bf1dea940208d9e5731baabb4b9","interface":"internal","name":"cloudevent-internal","region":"region0","region_id":"region0","url":"https://default-cloudevent:30892"}],"id":"6b78e4f08c68421d8497591c44f53965","name":"cloudevent","type":"cloudevent"},{"endpoints":[{"id":"0ae9af784f2a4c35865fbf94f5e371eb","interface":"public","name":"cloudnet-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30891"},{"id":"18234fdf11fb453e8aeb27f5ce1a4a09","interface":"internal","name":"cloudnet-internal","region":"region0","region_id":"region0","url":"https://default-cloudnet:30891"}],"id":"0164ae489d50476382544fa82d35c651","name":"cloudnet","type":"cloudnet"},{"endpoints":[{"id":"10714444f63d460f89b42872c7b8a2e4","interface":"public","name":"cloudmeta-public","region":"region0","region_id":"region0","url":"https://meta.yunion.cn"},{"id":"cd3f9d63e5f3486d8d6ef1a2e5de240b","interface":"internal","name":"cloudmeta-internal","region":"region0","region_id":"region0","url":"https://meta.yunion.cn"}],"id":"5ffa814de268402d82e709e6e43c8a27","name":"cloudmeta","type":"cloudmeta"},{"endpoints":[{"id":"1ae5a40781a542b284f4058e7fa57819","interface":"public","name":"cloudproxy-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30882"},{"id":"c4f1d6c3241c466181102cfa04db5a48","interface":"internal","name":"cloudproxy-internal","region":"region0","region_id":"region0","url":"https://default-cloudproxy:30882"}],"id":"c166b15b68384f6b8d79c625a2a4d6e4","name":"cloudproxy","type":"cloudproxy"},{"endpoints":[{"id":"33dd58d495484d7885ac3ef6766b5cd6","interface":"public","name":"scheduler-public","region":"region0","region_id":"region0","url":"https://10.211.55.9:30887"},{"id":"36cb905a8f284bb2840d38c3af1ebab8","interface":"internal","name":"scheduler-internal","region":"region0","region_id":"region0","url":"https://default-scheduler:30887"}],"id":"8155088ac46c4bd1816adf5537ccaedf","name":"scheduler","type":"scheduler"}],"context":{"ip":"10.211.55.9","source":"cli"},"expires_at":"2022-02-21T17:29:31.370591Z","is_domain":false,"issued_at":"2022-02-20T17:29:31.370591Z","methods":["aksk"],"policies":{"system":["sysadmin"]},"project":{"domain":{"id":"default","name":"Default"},"id":"0e4416c837644f5a8f0d67c9930ff228","name":"system"},"roles":[{"id":"2c85811d739d4fca892b41df6bc0484b","name":"admin"}],"user":{"domain":{"id":"default","name":"Default"},"id":"a09dbd66f37245518bb2b7984dca46bf","name":"sysadmin"}}}

从上面的请求可以看到, 第一次请求的是https://10.211.55.9:30500/v3/auth/tokens, 并且使用了刚才创建的aksk进行认证, 认证通过后返回了一个很大的json结果, 下面将对json结果做进一步说明
{
    "id":"gAAAAABiEnp7Z3hP_xecU36DvRzu8Y67m2mDM9JfFip6NMcH2BjI8FT3-vaJ6JztgdGJaztXQDj1mDno-X-fHU0AvG-s56Yb-kXQj8dwo9g56EutyqVFgZ77FAdjvZNfcfEKt_sgrBbsPaVTqLOrrqHiu6UQckEJDKIp744zQOsZii66_CXwnc9MKQZO9sCw91BFDZMUrghj", // 这个Id是认证返回的token, 和返回header中的X-Subject-Token是一样的，后面可以用这个id作为请求的header(X-Auth-Token)进行认证
    "token":{
        "access_key":{
            "access_key":"ba92f912922044268d4ad1dc70aafe57",
            "expire":0,
            "secret":"OGVmTXNKQWpBWHpUejZTWDNKcndSdXlHQUNFeXhLVWI="
        },
        "audit_ids":[
            "58076f50591e288d4aa4fdc76b946f7b"
        ],
        "catalog":[ // 这个是各个服务的endpoint, 商业版会多一些服务
            {
                "endpoints":[
                    {
                        "id":"0d81a11591584b958a04804dd5abbabc",
                        "interface":"internal",
                        "name":"yunionconf-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-yunionconf:30889"
                    },
                    {
                        "id":"9cfa500c785c4195831bd70161133802",
                        "interface":"public",
                        "name":"yunionconf-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30889"
                    }
                ],
                "id":"87217758659c4cb18ba26bf0577e3427",
                "name":"yunionconf", // 这个是配置服务
                "type":"yunionconf"
            },
            {
                "endpoints":[
                    {
                        "id":"0dd167cc3194438e88467a0a7bd6ef3c",
                        "interface":"public",
                        "name":"notify-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30777"
                    },
                    {
                        "id":"68f22940bccc47eb8666cfe1cbc6d256",
                        "interface":"internal",
                        "name":"notify-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-notify:30777"
                    }
                ],
                "id":"0db18c12231c4f16895f9c562128118e",
                "name":"notify", // 这个是通知服务
                "type":"notify"
            },
            {
                "endpoints":[
                    {
                        "id":"264468c6e2b14ccc80a3dc174be14124",
                        "interface":"internal",
                        "name":"autoupdate-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-autoupdate:30981"
                    },
                    {
                        "id":"de136a3d766d4c178b84cf10e0740592",
                        "interface":"public",
                        "name":"autoupdate-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30981"
                    }
                ],
                "id":"cd7482a6ffa042b789185c5c1f4ab020",
                "name":"autoupdate", // 这个是自动更新服务
                "type":"autoupdate"
            },
            {
                "endpoints":[
                    {
                        "id":"4ce974d81f494bef85b9e4f8e7654632",
                        "interface":"public",
                        "name":"log-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30999"
                    },
                    {
                        "id":"87f433df2d624ce28c1143f4d5db238e",
                        "interface":"internal",
                        "name":"log-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-logger:30999"
                    }
                ],
                "id":"60cf87cd573749b58250fa6c0d6794af",
                "name":"log", // 这个是日志服务
                "type":"log"
            },
            {
                "endpoints":[
                    {
                        "id":"5123f3dab82b47f780f284637a18a518",
                        "interface":"admin",
                        "name":"identity-admin",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30357/v3"
                    },
                    {
                        "id":"885a45a04af2419783906d069c737465",
                        "interface":"public",
                        "name":"identity-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30500/v3"
                    },
                    {
                        "id":"b453e1ca7dfc4595884fed16011d1717",
                        "interface":"internal",
                        "name":"identity-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-keystone:30500/v3"
                    }
                ],
                "id":"55e14f71e0c34a8682dbeaef10a7cbb4",
                "name":"keystone", // 这个是认证服务
                "type":"identity"
            },
            {
                "endpoints":[
                    {
                        "id":"67f79d211c284bc08afe707cdc81106e",
                        "interface":"internal",
                        "name":"websocket-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-apigateway:30443"
                    },
                    {
                        "id":"d5d5962163c148068bf44a3341898e73",
                        "interface":"public",
                        "name":"websocket-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30443"
                    }
                ],
                "id":"0185442fc0f040d2815a83ded61bb009",
                "name":"websocket", // 这个是websocket服务
                "type":"websocket"
            },
            {
                "endpoints":[
                    {
                        "id":"202b6def24134ce7813062c850e40850",
                        "interface":"internal",
                        "name":"s3gateway-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-s3gateway:30884"
                    },
                    {
                        "id":"8c931e66bb874e8e80d71a509ef0fef8",
                        "interface":"public",
                        "name":"s3gateway-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30884"
                    }
                ],
                "id":"f46030569f6e4de58c04bbbe017f0ca5",
                "name":"s3gateway", // s3网关服务
                "type":"s3gateway"
            },
            {
                "endpoints":[
                    {
                        "id":"47226520bc0d45a6838a3e51fa29b6e4",
                        "interface":"public",
                        "name":"image-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30292/v1"
                    },
                    {
                        "id":"c1646e81c8944be98683a3d3b0c798be",
                        "interface":"internal",
                        "name":"image-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-glance:30292/v1"
                    }
                ],
                "id":"f22c933cdf37427d88ea6e9d98b4a221",
                "name":"glance", // 这个是镜像服务
                "type":"image"
            },
            {
                "endpoints":[
                    {
                        "id":"731c5e0a9918439683ff5467fbbc5dde",
                        "interface":"public",
                        "name":"monitor-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30093"
                    },
                    {
                        "id":"e2e88b11e60f42df80ac3d4d4b076000",
                        "interface":"internal",
                        "name":"monitor-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-monitor:30093"
                    }
                ],
                "id":"e42a56482f67437a8a8e213386da07d7",
                "name":"monitor", // 这个是监控服务
                "type":"monitor"
            },
            {
                "endpoints":[
                    {
                        "id":"a9c1b32c54fb4a028803d52180e8b5a3",
                        "interface":"internal",
                        "name":"compute_v2-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-region:30888"
                    },
                    {
                        "id":"adecd09b5e20436e8651b4a66d4326c8",
                        "interface":"public",
                        "name":"compute_v2-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30888"
                    }
                ],
                "id":"efd8e0bed6cc43bf8b2c7ef0a5e1803b",
                "name":"region2", // 这个是计算服务(控制节点)
                "type":"compute_v2"
            },
            {
                "endpoints":[
                    {
                        "id":"19f2eadbf2b9406b8e2e3aa2684ad7e5",
                        "interface":"internal",
                        "name":"offlinecloudmeta-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://yunionmeta.oss-cn-beijing.aliyuncs.com"
                    },
                    {
                        "id":"7ba10412dfbc42ee82dada7eda7a1014",
                        "interface":"public",
                        "name":"offlinecloudmeta-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://yunionmeta.oss-cn-beijing.aliyuncs.com"
                    }
                ],
                "id":"a8f6bc5429af48228d0da5dd520af0a7",
                "name":"offlinecloudmeta", // 这个是套餐同步的服务
                "type":"offlinecloudmeta"
            },
            {
                "endpoints":[
                    {
                        "id":"25df9d4db3964d158d3201eb33118e09",
                        "interface":"internal",
                        "name":"influxdb-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-influxdb:30086"
                    },
                    {
                        "id":"31551be071934bec8e41e15c2e7d2b45",
                        "interface":"public",
                        "name":"influxdb-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30086"
                    }
                ],
                "id":"0b2b9c3d45e742e38fcce3063b00b2d7",
                "name":"influxdb",
                "type":"influxdb"
            },
            {
                "endpoints":[
                    {
                        "id":"3924af6d9ccd4dd28d0d5627d0f916dd",
                        "interface":"public",
                        "name":"webconsole-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30899"
                    },
                    {
                        "id":"403d0d9f349e447f809752ce1c8a2c0e",
                        "interface":"internal",
                        "name":"webconsole-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-webconsole:30899"
                    }
                ],
                "id":"017d07de150a435180f12931272ad286",
                "name":"webconsole", // 这个是webconsole服务
                "type":"webconsole"
            },
            {
                "endpoints":[
                    {
                        "id":"650d0a29ac534d36852efeaec12ecb7b",
                        "interface":"internal",
                        "name":"k8s-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-kubeserver:30442/api"
                    },
                    {
                        "id":"c9b157c4bf7b47258b17d2b9dccfc609",
                        "interface":"public",
                        "name":"k8s-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30442/api"
                    }
                ],
                "id":"00aa0118f4bc40f38b12576675db9922",
                "name":"k8s", // k8s服务
                "type":"k8s"
            },
            {
                "endpoints":[
                    {
                        "id":"9361347388bf461a8a88543aa6df0af1",
                        "interface":"public",
                        "name":"cloudid-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30893"
                    },
                    {
                        "id":"dd5f11acb719481380c7e7fcc2c57fe2",
                        "interface":"internal",
                        "name":"cloudid-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-cloudid:30893"
                    }
                ],
                "id":"a5bc5f118c484d6b812c8f807c5e5981",
                "name":"cloudid", // 这个是公有云iam免密认证服务
                "type":"cloudid"
            },
            {
                "endpoints":[
                    {
                        "id":"b61f4332c4594d05866634b9e7e87319",
                        "interface":"internal",
                        "name":"torrent-tracker-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://tracker.yunion.cn"
                    },
                    {
                        "id":"e543ab98873c4d838a2d1950e5fc2cb6",
                        "interface":"public",
                        "name":"torrent-tracker-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://tracker.yunion.cn"
                    }
                ],
                "id":"29a4f2e4fd8b4e6c876ac3c41fdad610",
                "name":"torrent-tracker",
                "type":"torrent-tracker"
            },
            {
                "endpoints":[
                    {
                        "id":"48e06ade707040d38a2c81054d916772",
                        "interface":"internal",
                        "name":"etcd-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"http://default-etcd-client.onecloud.svc:2379"
                    }
                ],
                "id":"012622a60c814d478d180ee28107caf0",
                "name":"etcd", // etcd
                "type":"etcd"
            },
            {
                "endpoints":[
                    {
                        "id":"84293895e9db410e8c8584afc3fde39b",
                        "interface":"internal",
                        "name":"ansible-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-ansibleserver:30890"
                    },
                    {
                        "id":"a9e5c8be89254bb98c444bb04344e1f7",
                        "interface":"public",
                        "name":"ansible-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30890"
                    }
                ],
                "id":"1313597e674a4bfc8f7dcf06f3033280",
                "name":"ansible", // ansible
                "type":"ansible"
            },
            {
                "endpoints":[
                    {
                        "id":"022b48ad6b6640858471aa2074f600ee",
                        "interface":"public",
                        "name":"devtool-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30997"
                    },
                    {
                        "id":"5ed574340c40491f8506b6aa48b2be8b",
                        "interface":"internal",
                        "name":"devtool-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-devtool:30997"
                    }
                ],
                "id":"c239df97fd0148e78ce143e7017f3859",
                "name":"devtool", // 运维工具服务
                "type":"devtool"
            },
            {
                "endpoints":[
                    {
                        "id":"05655d3ea1da4aca8b4441c2597a4a73",
                        "interface":"public",
                        "name":"cloudevent-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30892"
                    },
                    {
                        "id":"87b37bf1dea940208d9e5731baabb4b9",
                        "interface":"internal",
                        "name":"cloudevent-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-cloudevent:30892"
                    }
                ],
                "id":"6b78e4f08c68421d8497591c44f53965",
                "name":"cloudevent", // 公有云日志服务
                "type":"cloudevent"
            },
            {
                "endpoints":[
                    {
                        "id":"0ae9af784f2a4c35865fbf94f5e371eb",
                        "interface":"public",
                        "name":"cloudnet-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30891"
                    },
                    {
                        "id":"18234fdf11fb453e8aeb27f5ce1a4a09",
                        "interface":"internal",
                        "name":"cloudnet-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-cloudnet:30891"
                    }
                ],
                "id":"0164ae489d50476382544fa82d35c651",
                "name":"cloudnet",
                "type":"cloudnet"
            },
            {
                "endpoints":[
                    {
                        "id":"10714444f63d460f89b42872c7b8a2e4",
                        "interface":"public",
                        "name":"cloudmeta-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://meta.yunion.cn"
                    },
                    {
                        "id":"cd3f9d63e5f3486d8d6ef1a2e5de240b",
                        "interface":"internal",
                        "name":"cloudmeta-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://meta.yunion.cn"
                    }
                ],
                "id":"5ffa814de268402d82e709e6e43c8a27",
                "name":"cloudmeta", 
                "type":"cloudmeta"
            },
            {
                "endpoints":[
                    {
                        "id":"1ae5a40781a542b284f4058e7fa57819",
                        "interface":"public",
                        "name":"cloudproxy-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30882"
                    },
                    {
                        "id":"c4f1d6c3241c466181102cfa04db5a48",
                        "interface":"internal",
                        "name":"cloudproxy-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-cloudproxy:30882"
                    }
                ],
                "id":"c166b15b68384f6b8d79c625a2a4d6e4",
                "name":"cloudproxy",
                "type":"cloudproxy"
            },
            {
                "endpoints":[
                    {
                        "id":"33dd58d495484d7885ac3ef6766b5cd6",
                        "interface":"public",
                        "name":"scheduler-public",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://10.211.55.9:30887"
                    },
                    {
                        "id":"36cb905a8f284bb2840d38c3af1ebab8",
                        "interface":"internal",
                        "name":"scheduler-internal",
                        "region":"region0",
                        "region_id":"region0",
                        "url":"https://default-scheduler:30887"
                    }
                ],
                "id":"8155088ac46c4bd1816adf5537ccaedf",
                "name":"scheduler", //调度服务
                "type":"scheduler"
            }
        ],
        "context":{
            "ip":"10.211.55.9",
            "source":"cli"
        },
        "expires_at":"2022-02-21T17:29:31.370591Z", // 认证失效时间，如果超过这个时间上面的id认证就失效了，需要重新认证获取新的id
        "is_domain":false,
        "issued_at":"2022-02-20T17:29:31.370591Z",
        "methods":[
            "aksk"
        ],
        "policies":{
            "system":[
                "sysadmin"
            ]
        },
        "project":{
            "domain":{
                "id":"default",
                "name":"Default"
            },
            "id":"0e4416c837644f5a8f0d67c9930ff228",
            "name":"system"
        },
        "roles":[
            {
                "id":"2c85811d739d4fca892b41df6bc0484b",
                "name":"admin"
            }
        ],
        "user":{
            "domain":{
                "id":"default",
                "name":"Default"
            },
            "id":"a09dbd66f37245518bb2b7984dca46bf",
            "name":"sysadmin"
        }
    }
}
```

4. 以获取虚拟机列表举例
```
通过步骤3获取到了认证的token，并且也知道了计算服务的endpoint是 https://10.211.55.9:30888
虚拟机列表的api是 GET /servers, 因此可以构造出curl:
$curl -k -X 'GET' -d '' -H 'Accept: */*' -H 'Accept-Encoding: *' -H 'Content-Length: 0' -H 'Content-Type: application/json' -H 'User-Agent: yunioncloud-go/201708' -H 'X-Auth-Token: gAAAAABiEn7_nBvGcZX-XeHRcm5oQjI6Vxz66atfQIXPCu0OEUmpkTBX4yjIz2CIVtuWuUfjTpExAxzuNybZzRf6bHnlgDdKOBJmxzvrikbTGBkltQJAi7bKzIs3MC0pmAFrULm306izk-z1AKjRIVD4x2njfriPuH9KAs3ToHzfatPi18xx3GRWpngFTQ3xJa6n4Gzigilh' 'https://10.211.55.9:30888/servers'
{"servers":[]}

同样这一步也可以通过climc命令进行调试: climc --debug --os-auth-token gAAAAABiEnp4SlVCjoLmRdLbuaskbHUJIMDnwZcURyEp-5REXZ-ePPd0H4ZQj7GA8-9UEs1ALuDaXklu1dYdv51AWt7UoemvHiS0_hl_rJYOgKUKZQ4RNqsdIpfNsq-9qkjmo2YvFLMrTf2Z1oxrm9WASSGPeGtGSIoJC_X6XbbxIMC4oW26Z4GJaFe1NJaw5JkmpoErA45Q server-list
```

5. 总结
```
1. 通过认证拿到token id, 和各个服务的endpoint
2. 通过组合endpoint和各个资源，并且指定X-Auth-Token header为token id,即可发送api操作资源
```
