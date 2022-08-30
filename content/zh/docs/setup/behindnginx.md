---
title: "nginx配置"
weight: 110
description: >
  介绍通过 nginx 暴露var_oem_name的前端的配置方法
---

部署完成后，如果要通过nginx将{{<oem_name>}}的前端暴露到外网访问，nginx的推荐配置如下。注意需要专门为websocket的流量增加转发规则。

```nginx
# vi: ft=nginx
server {

    server_name {{ public_domain_name }};
    access_log /var/log/nginx/{{ public_domain_name }}.access.log;

    listen 443 http2 ssl;
    ssl_certificate /etc/ssl/yunion.io/cert.pem;
    ssl_certificate_key /etc/ssl/yunion.io/key.pem;

    client_max_body_size 10g;

    location ~ /.well-known {
        allow all;
    }

    location / {
        proxy_pass https://{{ backend_address }};
        proxy_read_timeout 3600s;
        proxy_redirect   off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location ~ ^/(websockify|wsproxy|connect) {
        proxy_pass https://{{ backend_address }};
        proxy_redirect   off;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

        proxy_read_timeout 86400;
    }

}
```
