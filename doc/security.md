# 安全建议（Security）

本项目默认面向“开发/联调/演示”场景，生产环境请至少完成本文的最小加固项。

## 默认凭据与敏感端口

- EMQX Dashboard 默认：`admin/admin`（见根 `README.md`）
- 前端 MQTT 连接默认用户名/密码：`admin/public`（见 `docker-compose.yml` 与 `docker-bake.hcl`）
- 高风险端口（不要对公网直接开放）：
  - `18083`（EMQX Dashboard）
  - `1883`（MQTT 明文）
  - `8000`（backend API/WebSocket）

## 最小暴露面（推荐）

- 只对用户暴露 `gateway` 的 `80`（或在其前面加 HTTPS：`443`）
- 控制机内部/内网访问：
  - `backend:8000`、`mqtt:1883/8083`、`hdf5:5000`
- 多机集群时，仅对边缘机开放必需端口：
  - MQTT：`1883/tcp`
  - Backend：`8000/tcp`（含 `/ws/rpc` WebSocket）
  - （可选）HDF5：`5000/tcp`

## 传输加密（建议）

- 网关层：为 `gateway` 配置 HTTPS（反代 `frontend/backend/mqtt-ws`）
- MQTT：
  - 生产建议使用 TLS（EMQX 提供 `8883`/`8084`，需配套证书与配置）
  - 前端通过 WSS 连接 MQTT WebSocket（`wss://...`）

## 节点容器权限（重点）

`docker-compose.yml` 中 `node` 默认 `privileged: true`，用于硬件接入方便，但权限很大。

生产建议：

- 优先用 `devices:` + 最小化能力集替代 `privileged`
- 将边缘机与控制机隔离在受控网络
- 约束 `node` 可访问的数据目录与设备

## 凭据与配置管理

- 不要把真实 MQTT/后端凭据写死在镜像构建参数里（`NEXT_PUBLIC_*` 会进入前端构建产物）
- 使用环境变量/密钥管理系统注入运行时配置
- 修改默认密码，并限制 Dashboard 的访问源

## 日志与数据

- 后端数据默认落盘到 `./EasyTeleop-Backend-Python/data`（包含 SQLite 等），注意备份与访问权限
- 多机时，边缘机上的 `./EasyTeleop-Node/data`、`./EasyTeleop-Node/datasets` 也需要权限与生命周期管理

