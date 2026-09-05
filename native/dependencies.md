# 原生构建依赖

godot-cpp 提供 GDExtension 的 C++ 绑定. CMake 配置阶段通过 FetchContent 自动获取依赖, 固定为 godot-4.4.1-stable 对应的 commit e4b7c25e721ce3435a029087e3917a30aa73f06b, 并验证 SHA-256.

首次配置需要网络, 源码缓存在构建目录的 _deps/ 下, 构建产物也位于构建目录内. 后续配置复用缓存; 删除构建目录后需要重新下载.

最终游戏使用编译后的扩展动态库, 运行时无需下载依赖. godot-cpp 使用 MIT 许可证, 发布时保留其版权和许可声明.
