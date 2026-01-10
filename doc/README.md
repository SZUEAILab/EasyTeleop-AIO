# 文档索引（EasyTeleop-AIO）

本目录用于沉淀 **EasyTeleop-AIO（AIO 一键部署仓库）** 的统一文档，覆盖：整体架构、部署/运维、各子模块使用说明、常见问题等。

## 现有文档分布（已扫描）

- 仓库根目录：`README.md`、`LICENSE`
- 后端（Python）：`EasyTeleop-Backend-Python/docs/`（含 API、MQTT、JSON-RPC、数据库等）
- 其他子模块：多为 `README.md` 简要说明，`HDF5DataVisualize/README.md` 为空

## 目录结构

- 部署：`deployment/README.md`
- 模块：`modules/README.md`

## 快速入口（P0）

- 快速开始：`quickstart.md`
- 配置说明：`configuration.md`
- 部署入口（单机/多机）：`deployment/README.md`
- 单机 AIO（Compose）：`deployment/aio-single.md`
- 多机集群：`deployment/cluster-multihost.md`
- 离线 tar 包：`deployment/offline-tars.md`
- 故障排查：`troubleshooting.md`

## 推荐入口（P1）

- 架构与数据流：`architecture.md`
- 服务清单与边界：`services.md`
- 安全建议：`security.md`
- 发布与 CI：`release-ci.md`
- 本地开发：`development.md`

## 模块与运维（P2）

- 脚本说明：`scripts.md`
- 网关与路由：`nginx-gateway.md`
- 后端（Python）：`modules/backend-python.md`
- 节点（Node）：`modules/node.md`
- Node 协议：`modules/node-protocol.md`
- 前端（UI）：`modules/frontend.md`
- HDF5 服务：`modules/hdf5.md`
