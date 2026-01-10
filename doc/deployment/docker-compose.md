# Docker Compose（`docker-compose.yml`）参考

本文件聚焦于 `docker-compose.yml` 的使用与可配置项。

- 单机 AIO 部署说明（含拓扑与职责）：`aio-single.md`
- 多机集群部署说明：`cluster-multihost.md`
- 部署目录入口：`README.md`

## 快速命令

启动：

```bash
docker compose up -d
```

查看状态与日志：

```bash
docker compose ps
docker compose logs -f --tail=200 gateway backend node frontend mqtt hdf5
```

停止：

```bash
docker compose down
```

## 服务与端口（默认）

- `gateway`：`80`（统一入口，反代前端/后端/MQTT WebSocket）
- `backend`：`8000`
- `hdf5`：`5000`
- `mqtt`（EMQX）：
  - `1883`（MQTT）
  - `8083`（WebSocket）
  - `8084`（SSL WebSocket）
  - `8883`（MQTT SSL）
  - `18083`（Dashboard）

## 关键配置点

### 1) `node` 权限

`node` 在 compose 中默认启用 `privileged: true` 以方便硬件接入；生产环境建议最小化权限并用 `devices:` 显式映射设备，见 `../security.md`。

### 2) 前端配置（`NEXT_PUBLIC_*`）

`frontend` 的 `NEXT_PUBLIC_*` 同时出现在 build args 与 env：

- `NEXT_PUBLIC_API_URL`：默认 `/api`
- `NEXT_PUBLIC_MQTT_URL`：默认空（建议使用 `ws://<host>/mqtt/` 走网关）
- `NEXT_PUBLIC_MQTT_USERNAME`：默认 `admin`
- `NEXT_PUBLIC_MQTT_PASSWORD`：默认 `public`

更多见：`../configuration.md`、`../modules/frontend.md`

### 3) 网关路由

`gateway` 使用 `nginx/default.conf.template`：

- `/` → `frontend:3000`
- `/api/` → `backend:8000/`
- `/mqtt/` → `mqtt:8083/mqtt/`

更多见：`../nginx-gateway.md`
