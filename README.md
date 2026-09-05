# Tank Trouble 原生移植

以 `RELEASE-2026-08-31-01` 为基准的 Godot 4.7.1 离线游戏. 游戏逻辑从原版 JavaScript AST 转译为 GDScript, Box2D 2.1, P2 和 Spine 3.6 原函数通过 C++ GDExtension 执行. 图片, 图集, 字体和音效来自固定版本原资源.

范围是 BootCamp 本地单人对 Laika, 双人和三人同机. 不包含网站, 账号, 在线大厅和车库. 视觉一致性仍需按相同画布尺寸和像素密度逐项验收, 当前不能视为完整的 1:1 验收结果.

## 开发

需要 Godot 4.7.1, Bun, CMake, FFmpeg 和 just. 各平台导出模板仅在生成发布包时需要.

```shell
bun install
just native
just run
```

原始 HAR 不进入版本控制和游戏包. 重新导入及转译的方法见 [资源与移植](docs/source-port.md).

## 游戏与设置

人数菜单沿用原版入口. 操作选择包括 `WASD + Q`, 方向键 + 空格及鼠标. macOS 的 `Game` 菜单提供 `Settings...`, 使用上次操作分配的 `Play Again`, 以及 `Return to Menu`.

音量, 原版 Auto/High/Low 画质和操作分配保存在 Godot 用户数据目录内的 `tank-trouble-settings.json`. 日志写入同目录的 `tank-trouble.jsonl`, 包含启动, 资源加载, 对局生命周期和错误. 设置迁移独立于读写模块, 损坏文件或未知版本不会被自动覆盖.

## 验证与导出

```shell
just test-tools
just import-godot
just check-world
just check-weapons
just check-spine
just check-p2
just check-frame
just check-camera
just check-local
just check-application
just check-resize --headed
just check-battle-weapons
just check-flow
just check-settings
just dist
just check-package
```

导出目标包括 macOS Apple Silicon, Linux x86_64 和 Windows x86_64. `just dist` 根据当前平台生成对应归档, macOS 产物为 DMG, Linux 产物为 tar.gz, Windows 产物为 zip. `just check-package` 校验当前平台的架构和独立启动. 原生构建说明见 [构建依赖](native/dependencies.md), 导出及验证日志在 `.tmp/`.

发布工作流位于 `.github/workflows/release.yml`. 发布前先提交 `docs/changelog/VERSION.md`, 再使用同一文件创建 annotated tag:

```shell
git tag -a "v1.2.3" --cleanup=verbatim -F "docs/changelog/1.2.3.md"
git push origin "v1.2.3"
```

工作流也支持手动填写已有 tag. 留空时只运行检查并上传 Actions 构建产物.

来源和第三方组件见 [第三方来源](docs/third-party.md).
