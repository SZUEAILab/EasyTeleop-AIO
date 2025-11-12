# EasyTeleop-AIO

EasyTeleop系统一键部署解决方案，集成了所有必要的组件和服务，简化了整个系统的安装和配置过程。

## 项目概述

EasyTeleop-AIO 是一个为 EasyTeleop 系统提供一键部署功能的集成化工具，旨在简化系统的安装与配置流程。该项目包含了以下三个核心子模块：

1. [EasyTeleop-Node](https://github.com/SZUEAILab/EasyTeleop-Node) - 分布式遥操作系统的节点组件，负责直接控制硬件设备并与后端服务通信
2. [EasyTeleop-Backend-Python](https://github.com/SZUEAILab/EasyTeleop-Backend-Python) - Python后端服务，负责设备控制和状态管理
3. [EasyTeleopFrontend](https://github.com/SZUEAILab/EasyTeleopFrontend) - 基于Next.js的前端用户界面

## 系统要求

- Python 3.7+
- Node.js 16+
- pnpm 包管理器
- uv Python包管理工具
- 支持的操作系统：Windows、Linux、macOS

## 快速开始

### 1. 克隆项目

```bash
git clone --recurse-submodules https://github.com/SZUEAILab/EasyTeleop-AIO.git
cd EasyTeleop-AIO
```

注意：使用 `--recurse-submodules` 参数确保所有子模块都被正确克隆。

如果已经克隆但没有子模块内容，可以运行：
```bash
git submodule update --init --recursive
```

### 2. 部署依赖

根据您的操作系统选择相应的部署脚本：

#### Windows系统：
```cmd
deploy.bat
```

#### Linux/macOS系统：
```bash
chmod +x deploy.sh
./deploy.sh
```

### 3. 启动服务

项目包含独立的服务启动脚本：

#### Windows系统：
```cmd
start-node.bat      # 启动节点服务
start-backend.bat   # 启动后端服务
start-frontend.bat  # 启动前端服务
```

#### Linux/macOS系统：
```bash
chmod +x start-node.sh start-backend.sh start-frontend.sh
./start-node.sh      # 启动节点服务
./start-backend.sh   # 启动后端服务
./start-frontend.sh  # 启动前端服务
```

## 服务说明

1. **Node服务**：负责直接控制硬件设备，通过WebSocket与后端通信，使用MQTT同步状态
2. **Backend服务**：提供RESTful API接口，管理设备状态和数据，包括主服务和MQTT同步服务
3. **Frontend服务**：提供Web管理界面，用户可以通过浏览器访问和控制整个系统

## 访问界面

前端服务默认在 `http://localhost:3000` 运行，启动后可通过浏览器访问。

## 故障排除

1. 如果遇到权限问题，请确保脚本具有执行权限
2. 如果依赖安装失败，请检查网络连接和相关工具是否正确安装
3. 确保各服务所需的端口未被占用

## 更新子模块

要更新到最新的子模块代码：

```bash
git submodule update --remote --merge
```