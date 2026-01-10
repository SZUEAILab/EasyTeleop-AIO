# 部署（Deployment）

本目录包含两种典型部署方式：

- **单机 AIO（推荐入门/联调）**：所有服务运行在同一台机器上
- **多机集群（推荐生产/多节点）**：控制机集中运行控制面服务，多个边缘机分别运行 `node`

## 入口文档

- 单机 AIO（Compose）：`doc/deployment/aio-single.md`
- 多机集群（控制机 + 多边缘机）：`doc/deployment/cluster-multihost.md`
- 离线 tar（导出/导入/启动）：`doc/deployment/offline-tars.md`
- `docker-compose.yml` 参考：`doc/deployment/docker-compose.md`
