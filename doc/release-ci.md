# 发布与 CI（Release / CI）

本文说明离线 tar 产物的自动构建与发布流程，以及与本地脚本的差异。

## GitHub Actions：自动发布离线 tar

工作流文件：`.github/workflows/release-offline-tars.yml`

触发方式：

- 推送 tag：`v*`（例如 `v1.2.3`）
- 手动触发：`workflow_dispatch`（可输入 `tag` 与 `image_repo`）

产物：

- 每个镜像（`backend/node/hdf5/frontend`）分别导出 tar
- 每个镜像分别导出两种架构：`amd64`、`arm64`
- 为每个镜像生成校验文件：`SHA256SUMS-<image>.txt`

命名规则（工作流内）：

- `/<dist>/${repo_slug}-${image}-${release_tag}-${arch}.tar`
- `/<dist>/SHA256SUMS-${image}.txt`

说明：

- 工作流中镜像 tag 固定为 `latest`（`IMAGE_TAG="latest"`），release tag 体现在 tar 文件名中。
- `frontend` 在 CI 中会注入固定 build args（例如 `NEXT_PUBLIC_API_URL=/api`）。

## 本地脚本：导出“整包 tar（6 镜像）”

本仓库脚本：

- `export-tars.sh`
- `export-tars.bat`

特点：

- 每个架构导出 **一个** tar，里面包含 6 个镜像（`backend/node/frontend/hdf5/nginx/emqx`）
- 命名为：`dist/<repo_slug>-<tag>-<arch>.tar`

详见：`doc/deployment/offline-tars.md`

## 维护者发布建议流程

1) 确认子模块与版本（必要时更新 submodule 指针）
2) 推送 tag（例如 `v1.2.3`）触发工作流
3) 在 GitHub Release 中下载 tar 与 `SHA256SUMS-*.txt` 校验
4) 在离线目标机 `docker load` 导入后，用 compose 启动

