# 资源与移植

## 重建原版来源

```shell
just import-har archive.har
just complete-assets
just port
just native
```

`archive.har` 是本地捕获文件. 导入器结构化读取响应, 通过 Acorn AST 拆分 PageSpeed 合并脚本, 只提取游戏源码, 原始资源和公开 AI 参数. 同版本缺失资源按固定发行路径补齐. 游客外观使用已捕获的公开数据, 运行时会生成独立会话 ID.

素材按原版目录保存在 `assets/original/`, 保留 1x 和 2x 资源. M4A 解码为 PCM WAV, 不改变采样率, 播放循环由原版音效调用指定.

## 来源记录

| 记录 | 内容 |
| --- | --- |
| `assets/data/source-manifest.json` | HAR 提取路径, 来源 URL, SHA-256 和内容大小 |
| `assets/data/supplement-manifest.json` | 固定版本补充资源及哈希 |
| `assets/data/audio-manifest.json` | 音频解码前后哈希及来源 |
| `game/ported/module-index.json` | 原版模块名到运行脚本的映射 |
| `game/ported/input/source-map.json` | 输入模块与离线适配 |
| `game/ported/presentation/battle-source-map.json` | 战斗表现原函数的提取与适配 |
| `game/ported/presentation/panel-source-map.json` | 玩家面板, 计分及动画的来源 |

`vendor/original/` 保留导入的原版源码. `game/ported/` 是转译结果, 修复应落在 `tools/port/` 中的转译器或独立适配模块. `game/application/` 管理原生应用生命周期和离线设置, `game/presentation/` 接入 Godot 绘制与音频, `native/` 提供原版数值运行时.

## 对照方法

`tools/oracle/` 在隔离 JavaScript 上下文中运行原版模块, 记录输入, 时间及随机数序列. `tests/godot/` 用相同数据驱动移植实现. 数值对照检查 `1e-6` 容差, 接触事件与随机数消费顺序要求一致.

`just check-weapons` 对照普通炮弹, 六种特殊武器, 护盾及 Laika 的输入, 目标和动作. Spine 对照包含动画混合, 骨骼矩阵, 网格顶点及运行时镜像.

`just check-frame` 从捕获的 `Phaser.Game.updateLogic`, `Phaser.Stage` 和 `Phaser.Group` 原函数生成执行记录, 对照定时器, 子对象, 补间, P2 和相机的先后顺序. `just check-camera` 对照 `Phaser.World.setBounds` 及 `Phaser.Camera.update` 的连续震屏坐标, 边界限制和像素取整. 相机计算位于转译模块 `PhaserCamera`, Godot 桥负责画布尺寸和场景切换时的复位.

`just check-battle-weapons` 在完整本地战斗场景中验证六种特殊武器和护盾的拾取与表现对象. `just check-application` 同时覆盖操作选择取消, 三种输入方案, 设置暂停恢复, 窗口失焦后的输入释放和自动画质采样.

自动数值和流程检查不能代替视觉验收. 菜单, 地图主题, 玩家面板, 各类战斗效果和音效还需对照同版本原游戏, 使用一致的窗口尺寸与像素密度.
