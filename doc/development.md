# 本地开发（Development）

本文描述 AIO 仓库的推荐开发方式：子模块管理、分别启动、联调与常用命令。

## 获取代码与子模块

首次克隆（推荐）：

```bash
git clone --recurse-submodules <repo>
cd EasyTeleop-AIO
```

已克隆但缺子模块：

```bash
git submodule update --init --recursive
```

更新子模块到上游最新（谨慎）：

```bash
git submodule update --remote --merge
```

## 依赖安装（脚本）

Windows：

```cmd
deploy.bat
```

Linux/macOS：

```bash
chmod +x deploy.sh
./deploy.sh
```

脚本做的事情（摘要）：

- 同步 submodules
- Python 部分使用 `uv sync`（或 `pip install -r requirements.txt`）
- 前端使用 `pnpm install --frozen-lockfile`

## 分别启动（开发/调试）

建议先启动 MQTT（Docker）：

```bash
docker compose up -d mqtt
```

后端：

```bash
cd EasyTeleop-Backend-Python
uv run backend.py
```

节点：

```bash
cd EasyTeleop-Node
uv run node.py
```

前端（开发服务器）：

```bash
cd EasyTeleopFrontend
pnpm dev
```

## 推荐的联调入口

- 单机 AIO（网关入口）：`http://localhost/`
- 仅前端开发：`http://localhost:3000/`

## 常用排查命令

查看 compose 日志：

```bash
docker compose logs -f --tail=200 gateway backend node mqtt frontend hdf5
```

查看后端 WebSocket 路由位置：

- `EasyTeleop-Backend-Python/backend.py` 中存在 `/ws/rpc` 路由定义

