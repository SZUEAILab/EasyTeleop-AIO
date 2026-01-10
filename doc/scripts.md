# 脚本说明（Scripts）

本文说明仓库根目录的常用脚本：依赖安装、分别启动、离线打包导出。

## 依赖安装脚本：`deploy.*`

### Windows：`deploy.bat`

主要行为：

1) 同步子模块：`git submodule update --init --recursive`
2) 安装 `EasyTeleop-Node` 依赖：
   - 若未安装 `uv`：尝试 `pip install uv`
   - 执行 `uv sync`
3) 安装 `EasyTeleop-Backend-Python` 依赖：`uv sync`
4) 安装 `EasyTeleopFrontend` 依赖：
   - 若无 `pnpm`：尝试 `npm install -g pnpm`
   - 执行 `pnpm install --frozen-lockfile`

失败处理：脚本会打印错误并退出（部分步骤会 `pause`）。

### Linux/macOS：`deploy.sh`

主要行为：

1) 同步子模块：`git submodule update --init --recursive`
2) 安装 `EasyTeleop-Node` 依赖：缺 `uv` 时 `pip3 install uv`，然后 `uv sync`
3) 安装 `EasyTeleop-Backend-Python` 依赖：
   - 有 `requirements.txt` 时：`pip3 install -r requirements.txt`
   - 否则尝试 `uv sync`（同时会尝试安装 `tomli` / `tomli_w`）
4) 安装 `EasyTeleopFrontend` 依赖：
   - 缺 `pnpm` 时：`npm install -g pnpm`
   - 执行 `pnpm install --frozen-lockfile`

## 分别启动脚本：`start-*.*`

这些脚本适用于“本地开发/分别调试”，不会自动启动其它依赖服务（例如 MQTT）。

- 后端：
  - Windows：`start-backend.bat` → `uv run EasyTeleop-Backend-Python/backend.py`
  - Linux/macOS：`start-backend.sh` → `uv run EasyTeleop-Backend-Python/backend.py`
- 节点：
  - Windows：`start-node.bat` → `uv run EasyTeleop-Node/node.py`
  - Linux/macOS：`start-node.sh` → `uv run EasyTeleop-Node/node.py`
- 前端（开发服务器）：
  - Windows：`start-frontend.bat` → `npm run dev`
  - Linux/macOS：`start-frontend.sh` → `npm run dev`

建议：

- 先启动 MQTT（推荐 Compose）：`docker compose up -d mqtt`
- 再分别启动 `backend`、`node`、`frontend`

## 离线导出脚本：`export-tars.*`

用于导出离线 tar 包（默认 `amd64` + `arm64` 各一份），详见：

- `doc/deployment/offline-tars.md`

