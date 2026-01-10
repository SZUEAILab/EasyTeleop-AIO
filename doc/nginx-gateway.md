# 网关与路由（Nginx Gateway）

网关模板：`nginx/default.conf.template`

`gateway` 容器使用 `nginx:1.25-alpine`，通过环境变量渲染模板并提供统一入口。

## 路由规则

```mermaid
flowchart LR
  Browser -->|HTTP :80| GW["gateway (nginx)"]
  GW -->|/| FE["frontend :3000"]
  GW -->|/api/| BE["backend :8000"]
  GW -->|/mqtt/ (WS)| MQTT["mqtt :8083/mqtt/"]
```

### `/` → 前端

```nginx
location / { proxy_pass http://$FRONT_HOST:$FRONT_PORT; }
```

默认值来自 `docker-compose.yml`：

- `FRONT_HOST=frontend`
- `FRONT_PORT=3000`

### `/api/` → 后端

```nginx
location /api/ { proxy_pass http://$API_HOST:$API_PORT/; }
```

说明：

- `/api/` 会被反代到后端根路径 `/`（注意 `proxy_pass` 末尾的 `/`）
- 默认值：`API_HOST=backend`、`API_PORT=8000`

### `/mqtt/` → MQTT WebSocket

```nginx
location /mqtt/ {
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection "upgrade";
  proxy_pass http://$MQTT_HOST:$MQTT_PORT/mqtt/;
}
```

默认值：`MQTT_HOST=mqtt`、`MQTT_PORT=8083`（EMQX WebSocket 端口）

## HTTPS 建议（生产）

本仓库默认只提供 HTTP（`80`）。生产建议二选一：

1) 在 `gateway` 前再加一层反代（Traefik/Caddy/Nginx），做 HTTPS 终止与证书管理
2) 直接将 `gateway` 改为 HTTPS 配置（需要挂载证书与更新 nginx 配置）

同时建议限制高风险端口对公网开放，详见：`doc/security.md`

