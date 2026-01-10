# 部署（Deployment）

本目录包含两种典型部署方式：

- **单机 AIO（推荐入门/联调）**：所有服务运行在同一台机器上
- **多机集群（推荐生产/多节点）**：控制机集中运行控制面服务，多个边缘机分别运行 `node`

## 入口文档

- 单机 AIO（Compose）：`aio-single.md`
- 多机集群（控制机 + 多边缘机）：`cluster-multihost.md`
- 离线 tar（导出/导入/启动）：`offline-tars.md`
- `docker-compose.yml` 参考：`docker-compose.md`

## GitHub Pages

如果你要在 GitHub Pages 上浏览本目录内容，本仓库已提供 MkDocs 配置与部署工作流：

- 配置：`mkdocs.yml`
- 工作流：`.github/workflows/docs-pages.yml`
