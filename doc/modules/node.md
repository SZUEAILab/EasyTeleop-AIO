# 模块：Node（边缘节点）

目录：`EasyTeleop-Node/`

## 职责

- 运行在靠近硬件/设备的一侧（边缘机），负责设备接入、控制与采集
- 与 `backend` 保持 WebSocket 连接（`/ws/rpc`），接收控制命令并返回执行结果
- 通过 MQTT 发布节点/设备/遥操作组的状态，供前端订阅展示
- 负责数据后处理与 HDF5 数据产物管理（`datasets.db` 记录与 HDF5 输出目录）

## 运行方式

### 本地运行

```bash
cd EasyTeleop-Node
uv run node.py
```

### Docker（AIO/边缘机）

镜像：`easyteleop/node`（见 `EasyTeleop-Node/Dockerfile`）

## AIO（Compose）默认配置

来自 `docker-compose.yml`：

- 运行权限：`privileged: true`
- 环境变量：
  - `BACKEND_URL=http://backend:8000`
  - `WEBSOCKET_URI=ws://backend:8000/ws/rpc`
  - `MQTT_BROKER=mqtt`
  - `VIEW_HDF5_URL=http://hdf5:5000`
- 数据卷：
  - `./EasyTeleop-Node/datasets:/app/datasets`
  - `./EasyTeleop-Node/data:/app/data`

## 多机集群（边缘机）配置要点

当 `node` 不与 `backend/mqtt/hdf5` 在同一台机器时，需要改为指向控制机可访问地址：

- `BACKEND_URL=http://<backend_host>:8000`
- `WEBSOCKET_URI=ws://<backend_host>:8000/ws/rpc`
- `MQTT_BROKER=<mqtt_host>`
- `VIEW_HDF5_URL=http://<hdf5_host>:5000`

详见：`doc/deployment/cluster-multihost.md`

## 数据与目录（Node 内部）

从 `EasyTeleop-Node/node.py` 可见默认目录：

- 临时数据：`datasets/temp`
- HDF5 输出：`datasets/hdf5`
- 数据库目录：`DB_DIR`（默认 `data`）
- 数据库文件：`<DB_DIR>/datasets.db`

## 权限与硬件接入

Compose 默认 `privileged: true` 以方便硬件接入，但生产环境建议：

- 优先使用 `devices:` 显式映射设备 + 最小权限
- 将边缘机放在受控网络，限制其可访问的控制机端口

更多安全建议：`doc/security.md`

