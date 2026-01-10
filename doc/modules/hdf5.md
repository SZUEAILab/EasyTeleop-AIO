# 模块：HDF5DataVisualize（HDF5 浏览/上传）

目录：`HDF5DataVisualize/`

## 职责

- 提供 HDF5 文件浏览与可视化页面（Flask + 模板）
- 提供 API 用于列目录、列文件、解析 HDF5 中的图像数据
- 提供分片上传与合并接口（用于上传 HDF5 到 `databases/uploaded_from_api`）
-（可选）提供 RDT server 启动/停止的 API（具体依赖该模块目录下脚本/模型文件）

## 运行与端口

- 默认端口：`5000`
- Docker 镜像：`easyteleop/hdf5`（见 `HDF5DataVisualize/Dockerfile`）
- Compose 卷挂载：`./HDF5DataVisualize/databases:/app/databases`

## Web 页面与 API

入口页面：

- `GET /`：返回 `templates/front_end.html`

目录/文件列表：

- `GET /api/database_folders`：列出 `databases/` 下子目录
- `GET /api/database_files/<folder_name>`：列出该目录下 `.hdf5` 文件

解析与回放：

- `POST /api/process_hdf5`：传入 `{"file_path": "<path>"}`，按摄像头分组返回 base64 图片序列与帧数

上传（分片）：

- `POST /api/upload_chunk`：上传单个 chunk（multipart form）
- `POST /api/merge_chunks`：合并 chunk，输出到 `databases/uploaded_from_api/<hash>_<filename>`

RDT server（可选）：

- `POST /api/start_rdt_server`
- `POST /api/stop_rdt_server`

## 与 Node 的关系

在 AIO 默认 Compose 中：

- `node` 通过 `VIEW_HDF5_URL=http://hdf5:5000` 访问该服务

