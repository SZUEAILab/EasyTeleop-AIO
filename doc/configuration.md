# 配置说明（Configuration）

本文档聚合部署场景下最常用的配置入口：Docker Compose 环境变量、构建参数、数据卷位置。

## 端口与入口（单机 AIO 默认）

- `gateway`（nginx）：`80`（统一入口，反代前端/后端/MQTT WebSocket）
- `backend`：`8000`
- `mqtt`（EMQX）：`1883`（MQTT）、`8083`（WS）、`8084`（WSS）、`8883`（MQTT TLS）、`18083`（Dashboard）
- `hdf5`：`5000`

## 数据目录（默认卷挂载）

来自 `docker-compose.yml`：

- 后端：`./EasyTeleop-Backend-Python/data` → `/app/data`
- 节点：`./EasyTeleop-Node/datasets` → `/app/datasets`
- 节点：`./EasyTeleop-Node/data` → `/app/data`
- HDF5：`./HDF5DataVisualize/databases` → `/app/databases`

## 服务环境变量

### backend（Python）

来自 `docker-compose.yml`：

- `DB_DIR=/app/data`：数据库/落盘目录（与卷挂载对应）
- `MQTT_BROKER=mqtt`
- `MQTT_PORT=1883`
- `PYTHONUNBUFFERED=1`

### node（Python）

来自 `docker-compose.yml`：

- `BACKEND_URL=http://backend:8000`
- `WEBSOCKET_URI=ws://backend:8000/ws/rpc`
- `MQTT_BROKER=mqtt`
- `VIEW_HDF5_URL=http://hdf5:5000`

说明：

- `node` 服务在 Compose 下以 `privileged: true` 运行，用于访问宿主机设备/硬件时的权限需求；如不需要硬件接入可自行调整。

## 多机集群关键配置（边缘机）

当 `node` 运行在边缘机、而 `backend/mqtt/hdf5` 在控制机时，边缘机上 `node` 需要改为指向“控制机可访问地址”：

- `BACKEND_URL=http://<backend_host>:8000`
- `WEBSOCKET_URI=ws://<backend_host>:8000/ws/rpc`
- `MQTT_BROKER=<mqtt_host>`
- `VIEW_HDF5_URL=http://<hdf5_host>:5000`

### frontend（Next.js）

构建参数（build args，来自 `docker-compose.yml` 与 `docker-bake.hcl`）：

- `NEXT_PUBLIC_API_URL`：默认 `/api`（通过 `gateway` 反代到后端）
- `NEXT_PUBLIC_MQTT_URL`：默认空（项目内可能有默认值；在 AIO 场景建议经网关或直连 EMQX）
- `NEXT_PUBLIC_MQTT_USERNAME`：默认 `admin`
- `NEXT_PUBLIC_MQTT_PASSWORD`：默认 `public`

运行时环境变量（来自 `docker-compose.yml`）：

- 同上（`NEXT_PUBLIC_*`）

### gateway（nginx）

来自 `docker-compose.yml`：

- `API_HOST=backend` / `API_PORT=8000`
- `FRONT_HOST=frontend` / `FRONT_PORT=3000`
- `MQTT_HOST=mqtt` / `MQTT_PORT=8083`

对应模板：`nginx/default.conf.template`

### mqtt（EMQX）

镜像：`emqx/emqx:5.3.1`，健康检查：`emqx ping`

## 构建与镜像命名

### compose 默认镜像名

`docker-compose.yml` 中 `image:` 默认使用：

- `easyteleop/backend`
- `easyteleop/node`
- `easyteleop/frontend`
- `easyteleop/hdf5`

### buildx bake 变量

`docker-bake.hcl` 支持：

- `IMAGE_REPO`（默认 `easyteleop`）
- `TAG`（默认 `latest`）
- 以及前端的 `NEXT_PUBLIC_*` 构建参数
