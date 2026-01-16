# EasyTeleop-AIO

EasyTeleop 系统一键部署解决方案，集成了必要组件与服务，简化安装与配置流程。

## 文档入口

- 文档索引：`doc/README.md`
- 部署（单机/多机）：`doc/deployment/README.md`
- 快速开始：`doc/quickstart.md`
- 配置说明：`doc/configuration.md`
- GitHub Pages 文档站：启用后见仓库 Pages

## 项目概述

EasyTeleop-AIO 是一个为 EasyTeleop 系统提供一键部署功能的集成化工具，旨在简化系统的安装与配置流程。该项目包含了以下三个核心子模块：

1. [EasyTeleop-Node](https://github.com/SZUEAILab/EasyTeleop-Node) - 分布式遥操作系统的节点组件，负责直接控制硬件设备并与后端服务通信
2. [EasyTeleop-Backend-Python](https://github.com/SZUEAILab/EasyTeleop-Backend-Python) - Python后端服务，负责设备控制和状态管理
3. [EasyTeleopFrontend](https://github.com/SZUEAILab/EasyTeleopFrontend) - 基于Next.js的前端用户界面

## 系统要求（开发/运行）

- Python 3.7+
- Node.js 16+
- pnpm 包管理器
- uv Python包管理工具
- 支持的操作系统：Windows、Linux、macOS
- Docker（用于运行服务/Compose 部署）

## 部署

部署入口：`doc/deployment/README.md`（镜像获取、单机/多机部署、拓扑与端口说明）。

- 快速开始：`doc/quickstart.md`（最短路径启动与验证）
- 部署指南：`doc/deployment/README.md`（单机 AIO / 多机集群）
- 开发/调试：`doc/development.md`（本地环境与服务启动）

## 开发

面向本地开发/调试场景，涵盖子模块克隆、依赖安装、服务启动与故障排查等内容。

- 开发指南：`doc/development.md`

## 构建

### 多架构镜像（buildx bake）

构建并推送多架构镜像（amd64+arm64）：

```powershell
$env:IMAGE_REPO="docker.io/<user>"   # 或 "ghcr.io/<org>"
$env:TAG="v1.0.0"
docker buildx bake -f docker-bake.hcl multi --push
```

### 离线部署（镜像 tar）

- 导出/导入与 tag 对齐：`doc/deployment/offline-tars.md`

导出离线 tar 包（每个架构一个 tar，每个 tar 包含全部镜像）：

Windows（CMD，使用 `.bat`）：

```cmd
export-tars.bat --image-repo easyteleop --tag latest --out-dir dist --arch both
```

Linux/macOS：

```bash
chmod +x ./export-tars.sh
./export-tars.sh --image-repo easyteleop --tag latest --out-dir dist
```

默认导出完成后会清理本地用于打包的镜像（节省磁盘空间）；如需保留，加 `--keep-images`。

每个架构的 tar 包包含 6 个镜像：

- `${IMAGE_REPO}/backend:${TAG}`
- `${IMAGE_REPO}/node:${TAG}`
- `${IMAGE_REPO}/frontend:${TAG}`
- `${IMAGE_REPO}/hdf5:${TAG}`
- `nginx:1.25-alpine`
- `emqx/emqx:5.3.1`
