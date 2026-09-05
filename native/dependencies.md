# 原生构建依赖

godot-cpp 提供 GDExtension 的 C++ 绑定. CMake 配置阶段通过 FetchContent 自动获取依赖, 固定为 godot-4.4.1-stable 对应的 commit e4b7c25e721ce3435a029087e3917a30aa73f06b, 并验证 SHA-256.

首次配置需要网络, 源码缓存在构建目录的 _deps/ 下, 构建产物也位于构建目录内. 后续配置复用缓存; 删除构建目录后需要重新下载.

最终游戏使用编译后的扩展动态库, 运行时无需下载依赖. godot-cpp 使用 MIT 许可证, 发布时保留其版权和许可声明.

`just native` 在 `build/native/` 构建 `template_debug` 扩展, `just native-release` 在 `build/native-release/` 构建 `template_release` 扩展. 两者输出不同文件名, 由 GDExtension 按运行模式选择. 当前 godot-cpp 的 Debug 与 Release 内存分配约定不同, 不能在发布包中复用 Debug 动态库. 默认使用 4 个编译任务, 可通过 `CMAKE_BUILD_PARALLEL_LEVEL` 调整.

三平台发布统一使用 `just dist`: macOS arm64 生成 dylib 和 DMG, Linux x86_64 生成 so 和 tar.gz, Windows x86_64 生成 DLL 和 zip. CMake 多配置生成器也会将扩展写入同一 `game/native/bin` 目录.
