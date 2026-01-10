# 快速开始（Quickstart）

本仓库提供两种常见启动方式：

- **方式 A：单机 AIO（Docker Compose，推荐）**：适合“一键部署/联调”，入口为 `docker-compose.yml` + `nginx` 网关。
- **方式 B：多机集群（控制机 + 多边缘机）**：适合生产/多节点部署，见 `doc/deployment/cluster-multihost.md`。
- **方式 C：本机开发启动**：适合分别开发/调试子模块（`deploy.*` + `start-*.*`）。

## 方式 A：单机 AIO（Docker Compose）启动

### 前置条件

- Docker Desktop / Docker Engine（建议包含 `docker compose`）
- 端口不冲突：`80`、`8000`、`1883`、`8083`、`8084`、`8883`、`18083`、`5000`

### 启动

在仓库根目录执行：

```bash
docker compose up -d mqtt
docker compose up -d backend hdf5 frontend node gateway
```

### 访问

- 网关入口（推荐）：`http://localhost/`
- 后端直连：`http://localhost:8000/`
- HDF5 服务：`http://localhost:5000/`
- MQTT WebSocket（经网关）：`ws://localhost/mqtt/`
- MQTT WebSocket（直连 EMQX）：`ws://localhost:8083/mqtt`
- EMQX Dashboard：`http://localhost:18083/`

### 停止

```bash
docker compose down
```

## 方式 C：本机开发启动（脚本）

### 1) 安装依赖

Windows：

```cmd
deploy.bat
```

Linux/macOS：

```bash
chmod +x deploy.sh
./deploy.sh
```

说明（脚本行为）：

- 同步子模块：`git submodule update --init --recursive`
- Python 依赖：使用 `uv sync`（Windows），或 `pip install -r requirements.txt` / `uv sync`（Unix）
- 前端依赖：`pnpm install --frozen-lockfile`（脚本会尝试安装全局 `pnpm`）

### 2) 启动各服务

MQTT（推荐用 Docker）：

```bash
docker compose up -d mqtt
```

后端：

Windows：

```cmd
start-backend.bat
```

Linux/macOS：

```bash
./start-backend.sh
```

节点：

Windows：

```cmd
start-node.bat
```

Linux/macOS：

```bash
./start-node.sh
```

前端（脚本启动的是开发服务器）：

Windows：

```cmd
start-frontend.bat
```

Linux/macOS：

```bash
./start-frontend.sh
```

前端开发默认地址：`http://localhost:3000/`

## 方式 B：多机集群（入口）

多机集群部署（控制机 + 多边缘机）请直接按文档执行：

- `doc/deployment/cluster-multihost.md`
