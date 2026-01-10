# 模块：Frontend（Web UI）

目录：`EasyTeleopFrontend/`

## 职责

- 提供 Web UI（设备管理、数据管理、远程教学等）
- 通过 REST API 与 `backend` 交互
- 通过 MQTT WebSocket 实时订阅状态主题

## 运行方式

### 开发模式（本机）

```bash
cd EasyTeleopFrontend
pnpm dev
```

默认访问：`http://localhost:3000/`

### Docker（AIO/控制机）

镜像：`easyteleop/frontend`（见 `EasyTeleopFrontend/Dockerfile`）

在 AIO 中推荐始终通过 `gateway` 访问前端：`http://<host>/`

## 配置项（NEXT_PUBLIC_*）

前端使用 `NEXT_PUBLIC_*` 配置后端与 MQTT 入口（会进入前端构建产物）：

- `NEXT_PUBLIC_API_URL`
  - 单机 AIO 推荐：`/api`（走 `gateway` 反代到后端）
  - 多机集群可选：
    - `https://<gateway_host>/api`（推荐，统一入口）
    - 或 `http://<backend_host>:8000`（直连，不推荐暴露）
- `NEXT_PUBLIC_MQTT_URL`
  - 单机 AIO 推荐：`ws://<gateway_host>/mqtt/`
  - 或直连：`ws://<mqtt_host>:8083/mqtt`
- `NEXT_PUBLIC_MQTT_USERNAME` / `NEXT_PUBLIC_MQTT_PASSWORD`

说明：

- Compose 中既有 build args（构建期注入）也有 env（运行期提供），以避免不同环境下的缺省值差异。
- 生产环境请避免把真实敏感凭据放进 `NEXT_PUBLIC_*`（前端可见），详见：`doc/security.md`

