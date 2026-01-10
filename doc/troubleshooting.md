# 故障排查（Troubleshooting）

## 基础检查

查看容器状态：

```bash
docker compose ps
```

查看日志（建议从 `gateway/backend/node/mqtt` 开始）：

```bash
docker compose logs -f --tail=200 gateway backend node mqtt frontend hdf5
```

检查端口占用：

- Windows（PowerShell）：`Get-NetTCPConnection -State Listen | Select-Object LocalAddress,LocalPort,OwningProcess | Sort-Object LocalPort`
- Linux/macOS：`ss -lntp` 或 `lsof -i :80`

## 常见问题

### 1) 网页打不开 / 访问空白

- 确认 `gateway` 在运行：`docker compose ps gateway`
- 确认 `gateway` 80 端口映射未被占用
- 查看 `gateway` 日志：`docker compose logs -f --tail=200 gateway`

### 2) `/api/` 请求失败

- 确认 `backend` 已启动：`docker compose ps backend`
- 检查网关配置：`nginx/default.conf.template` 中 `/api/` 反代到 `backend:8000`
- 直接访问后端：`http://localhost:8000/`

### 3) MQTT 连接不上（前端状态不更新）

- 确认 `mqtt` 健康：`docker compose ps mqtt`（`healthy`）
- 如果走网关：前端应连接 `ws://<host>/mqtt/`
- 如果直连 EMQX：`ws://<host>:8083/mqtt`，并确认端口未被拦截

### 4) `node` 启动失败/权限错误

- Compose 下 `node` 默认是 `privileged: true`；如果你改掉了，可能导致设备/USB/视频等访问失败
- 检查卷目录权限：`./EasyTeleop-Node/data`、`./EasyTeleop-Node/datasets`
- 查看日志：`docker compose logs -f --tail=200 node`

### 5) 离线 tar 导入后 compose 仍拉取镜像

- 确认导入的 tag 与 compose 预期一致（默认 `:latest`）
- 通过 `docker images | rg easyteleop` 确认镜像存在
- 如 tag 不一致：按 `doc/deployment/offline-tars.md` 重新 tag 或修改 compose

