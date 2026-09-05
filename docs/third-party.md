# 第三方来源

Tank Trouble 的源码, 图片, 字体, 音效和角色数据来自 `RELEASE-2026-08-31-01`. 具体 URL 和内容哈希见 [资源与移植](source-port.md). HAR 捕获不代表原作者授予重新分发许可.

| 组件 | 用途 | 上游 |
| --- | --- | --- |
| Tank Trouble | 游戏算法与原版资源 | https://tanktrouble.com/ |
| Godot 4.7.1 | 原生场景, 绘制, 音频与 macOS 运行时 | https://godotengine.org/license/ |
| godot-cpp | GDExtension 绑定 | https://github.com/godotengine/godot-cpp |
| Box2DWeb 2.1.0-b | 原版碰撞和求解函数 | https://github.com/hecht-software/box2dweb |
| Phaser 与 P2 | 原版粒子, 随机数, 缓动和表现物理 | https://github.com/phaserjs/phaser-ce |
| Spine 3.6 Runtime | 骨骼, 网格, IK 与动画混合 | https://github.com/EsotericSoftware/spine-runtimes |
| Classy 与 jKstra | 原版类描述和寻路参考 | `vendor/original/js/classy/`, `vendor/original/js/jkstra/` |
| Acorn | JavaScript AST 解析, 仅构建工具使用 | https://github.com/acornjs/acorn |
| Pino | 构建和验证工具日志 | https://github.com/pinojs/pino |
| FFmpeg | 原音频解码, 不随游戏运行 | https://ffmpeg.org/legal.html |

Godot 和 godot-cpp 使用 MIT 许可. godot-cpp 的固定提交和获取方式见 [原生依赖](../native/dependencies.md). 游戏原站的压缩脚本没有附带完整上游许可声明, 各组件的再分发条款需要以对应版本上游许可为准, 尤其是 Spine Runtime.

原生移植保留原版函数的来源对应关系, 不将原版算法或素材声明为本项目原创. Godot 适配, 离线设置和导入工具与原版来源分目录维护.
