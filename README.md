# MDTGenTool

MDTGenTool 是一款由 trr 个人开发、TrrSwLabs 出品的地形生成工具，基于钻石 Square 算法生成地形数据，并支持PNG/PGM图像文件和TXT文本文件，适用于地形模拟、游戏开发等场景。

## 功能特点

- 采用 Diamond Square 算法生成自然逼真的地形高度图
- 支持输出 TXT 格式的地形坐标与高度数据
- 可生成 PNG 或 PGM 格式的灰度图像（不同版本支持格式不同）
- 支持通过参数调整地形细节（迭代次数、范围、增益、层数等）
- 基于 Qt 框架开发，跨平台支持

## 技术细节

- **核心算法**：Diamond Square 算法（钻石方块算法），通过迭代生成具有自然分形特征的地形数据
- **输出格式**：
  - TXT：包含坐标 (x, y) 及对应高度值
  - 图像：灰度图（高度值映射为0-255灰度）
- **参数控制**：
  - 迭代次数：控制地形网格大小（大小为 2^iterations + 1）
  - 范围：控制初始高度变化范围
  - 增益：高度值缩放系数
  - 层数：多层叠加生成更复杂地形

## 版本差异

| 版本 | 主要差异 |
|------|----------|
| v1.0.1 | 输出图像格式为 PNG，依赖 QImage 处理图像 |
| 基础版 | 输出图像格式为 PGM，通过文本方式生成图像文件 |

## 项目结构

```
MDTGenTool/
├── LICENSE                  # MIT 许可证文件
├── MDTGenTool/              # 基础版本代码目录
│   ├── CMakeLists.txt       # 构建配置文件
│   ├── CMakeLists.txt.user  # 本地构建用户配置
│   ├── Main.qml             # QML 界面文件
│   ├── main.cpp             # 程序入口
│   ├── mdtgentool.cpp       # 核心功能实现（PGM输出）
│   └── mdtgentool.h         # 核心类头文件
└── MDTGenTool v1.0.1/       # v1.0.1 版本代码目录
    ├── CMakeLists.txt       # 构建配置文件
    ├── CMakeLists.txt.user  # 本地构建用户配置
    ├── Main.qml             # QML 界面文件
    ├── main.cpp             # 程序入口
    ├── mdtgentool.cpp       # 核心功能实现（PNG输出）
    └── mdtgentool.h         # 核心类头文件（含QImage依赖）
```

## 构建与使用

### 构建环境
- CMake 3.16 及以上
- Qt 6.8 及以上（需包含 Quick 和 Core 模块）

### 构建步骤
1. 克隆仓库到本地
2. 进入对应版本目录（基础版或 v1.0.1）
3. 执行 CMake 配置与构建：
   ```bash
   cmake .
   make  # 或使用对应平台的构建工具
   ```

### 使用说明
1. 配置生成参数（迭代次数、范围、增益、层数等）
2. 指定输出文件路径（TXT 和图像文件）
3. 调用生成函数，获取地形数据和图像文件

## 更新与维护状态

- **当前版本**：v1.0.1 为最新版本，主要优化了图像输出方式，采用 QImage 生成 PNG 格式图像，提升了图像处理效率和兼容性
- **维护状态**：项目目前处于持续维护阶段，主要维护方向包括：
  - 优化 Diamond Square 算法性能，提升大规模地形生成效率
  - 扩展输出格式支持（如增加 GeoTIFF 等地理信息格式）
  - 完善参数调节功能，增加更多地形特征控制选项
  - 优化 QML 界面交互体验
- **更新记录**：
  - 从基础版到 v1.0.1：将图像输出格式从 PGM 改为 PNG，引入 QImage 处理图像，简化图像生成流程并提升兼容性

## 许可证

本项目采用 MIT 许可证开源，详情参见 [LICENSE](LICENSE) 文件。

```
MIT License

Copyright (c) 2025 t-r-r

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 关于作者

由 trr 个人开发，TrrSwLabs 出品。
