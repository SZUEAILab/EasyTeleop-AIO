# 服务清单与边界（Services）

本文从“职责边界/端口/状态数据/部署位置”角度描述各服务，便于运维与扩展。

## 服务一览（单机 AIO 默认）

| 服务 | 角色 | 默认端口（对外） | 状态数据/卷 | 依赖 |
|---|---|---:|---|---|
| `gateway` | 统一入口/反代 | `80` | `nginx/default.conf.template`（只读挂载） | `frontend`、`backend`、`mqtt` |
| `frontend` | Web UI | （无，走 gateway） | 无（构建产物在镜像内） | `backend`、`mqtt` |
| `backend` | API + RPC 转发 | `8000` | `./EasyTeleop-Backend-Python/data:/app/data` | `mqtt` |
| `mqtt` | 状态消息代理 | `1883`、`8083`、`8084`、`8883`、`18083` | 默认容器内（建议生产持久化） | 无 |
| `node` | 边缘设备接入/控制 | （无固定对外） | `./EasyTeleop-Node/data`、`./EasyTeleop-Node/datasets` | `backend`、`mqtt`、`hdf5` |
| `hdf5` | HDF5 可视化/读取 | `5000` | `./HDF5DataVisualize/databases:/app/databases` | 无 |

来源：`docker-compose.yml`

## 哪些是必须/可选

- 必须（最小闭环）：`backend`、`mqtt`、`node`、`frontend`、`gateway`
- 可选（按业务启用）：`hdf5`

说明：

- 如果你只需要“后端 + 节点”，可以不部署 `frontend/gateway`（但此时没有 Web UI）。
- 如果你不需要 HDF5 数据浏览能力，可以不部署 `hdf5`，同时在 `node` 侧调整/关闭相关依赖。

## 多机集群建议边界

推荐拆分：

- 控制机：`gateway + frontend + backend + mqtt (+ hdf5)`
- 边缘机：`node`（就近连接硬件，必要时使用 `privileged` 或设备映射）

多机部署要点：

- 将 `node` 的 `BACKEND_URL/WEBSOCKET_URI/MQTT_BROKER/VIEW_HDF5_URL` 指向控制机可访问地址
- 控制机对边缘机开放：`8000/tcp`、`1883/tcp`（可选 `5000/tcp`）

