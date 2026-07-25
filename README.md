#按钮 - Flutter Web App + Django API

**按钮（boton）** 是一个完整的跨平台移动应用，包含 Android、 iOS、iPhone、iPad、Web 和桌面应用，同时提供 Django REST API 作为后端支持。

## 项目结构

- **lib/** - Flutter 应用核心代码 (Dart)
- **api/** - Django 后端 API (Python)
- **android/**, **ios/**, **linux/**, **macos/**, **web/** - 原生平台包装

## 设置与运行

### 1. 运行 Django API

```bash
# 在 api/ 目录下
cd /path/to/api
python manage.py migrate
# 启动服务器
python manage.py runserver 8000
```

### 2. 运行 Flutter Web 应用

```bash
cd /path/to/项目根目录
flutter run -d chrome
```

### 3. 运行 Flutter 桌面应用 (可选)

```bash
flutter run -d linux
# 或 flutter run -d windows
```

## API 文档

Django REST 框架自动生成的 API 文档将通过 `http://localhost:8000/api/` 提供访问。

## 功能

- 完整的用户认证系统（登录、注册、密码重设）
- 移动设备管理（设备注册、监控、数据收集）
- 项目管理系统（项目创建、团队协作、财务跟踪）
- 样品管理与测试结果记录
- 模具管理与生产流程追踪
- 统计与报告生成

## 技术栈

- **前端**: Flutter (Dart)
- **后端**: Django REST Framework
- **数据库**: SQLite (移动端) / PostgreSQL (服务器可选)
- **状态管理**: Bloc/Cubit (通过 flutter_bloc 实现)
- **图像**: 自定义图标，Material Design图标

## 许可

Apache 2.0