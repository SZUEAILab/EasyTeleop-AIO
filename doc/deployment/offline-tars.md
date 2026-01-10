# 离线 tar 包（离线镜像导出/导入）

本仓库提供 `export-tars.sh` / `export-tars.bat` 用于导出离线 Docker 镜像 tar 包，默认同时导出 `amd64` 与 `arm64` 两份。

## 导出（在有网络/可构建的机器上）

Linux/macOS：

```bash
./export-tars.sh --image-repo easyteleop --tag latest --out-dir dist --arch both
```

Windows：

```cmd
export-tars.bat --image-repo easyteleop --tag latest --out-dir dist --arch both
```

产物命名（脚本规则）：

- `dist/<repo_slug>-<tag>-amd64.tar`
- `dist/<repo_slug>-<tag>-arm64.tar`

每个 tar 默认包含 6 个镜像：

- `<repo>/backend:<tag>`
- `<repo>/node:<tag>`
- `<repo>/frontend:<tag>`
- `<repo>/hdf5:<tag>`
- `nginx:1.25-alpine`
- `emqx/emqx:5.3.1`

可选参数：

- `--skip-build`：不 build（假设本地已有这些镜像 tag）
- `--skip-pull`：不 pull `nginx`/`emqx`
- `--keep-images`：导出后不清理本地镜像

## 导入（在离线目标机上）

选择与目标机 CPU 架构匹配的 tar：

```bash
docker load -i dist/easyteleop-latest-amd64.tar
```

或（arm64 设备）：

```bash
docker load -i dist/easyteleop-latest-arm64.tar
```

验证镜像是否就绪：

```bash
docker images easyteleop/backend easyteleop/node easyteleop/frontend easyteleop/hdf5
docker images nginx emqx/emqx
```

## 与 Compose 的 tag 对齐

`docker-compose.yml` 的 `image:` 未显式写 tag 时等同于 `:latest`。

- 推荐：导出时使用 `--tag latest`（默认就是 `latest`），直接可用。
- 如果你导出为其他 tag（例如 `v1.0.0`），需要：
  - 修改 `docker-compose.yml` 中 `image:` 增加对应 tag，或
  - 在目标机上把镜像重新 tag 为 `latest`

示例（把 `v1.0.0` 重新 tag 为 `latest`）：

```bash
docker tag easyteleop/backend:v1.0.0 easyteleop/backend:latest
docker tag easyteleop/node:v1.0.0 easyteleop/node:latest
docker tag easyteleop/frontend:v1.0.0 easyteleop/frontend:latest
docker tag easyteleop/hdf5:v1.0.0 easyteleop/hdf5:latest
```

## 离线启动

导入镜像后，在仓库根目录执行：

```bash
docker compose up -d
```

