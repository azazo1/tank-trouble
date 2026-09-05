[private]
default:
    @just --list

# just import-har archive.har
# 从 HAR 提取固定版本的游戏源码和原素材.
import-har archive:
    bun tools/assets/import-har.ts "{{archive}}"

# 补齐原站同版本素材并转换音效.
complete-assets:
    bun tools/assets/complete.ts
    bun tools/assets/convert-audio.ts

# 从原版 AST 生成游戏逻辑和表现脚本.
port:
    bun tools/port/generate.ts
    bun tools/port/generate-ui.ts
    bun tools/port/generate-input.ts
    bun tools/port/generate-battle.ts
    bun tools/port/generate-panel.ts

# 编译 HAR 中的 Box2D, Spine 和 P2 原函数.
native:
    bun tools/native/compile-box2d.ts
    bun tools/native/compile-box2d.ts --module spine
    bun tools/native/compile-box2d.ts --module p2
    cmake -S native -B build/native -DCMAKE_BUILD_TYPE=Release
    cmake --build build/native --parallel

# 运行 Godot 原生主场景.
run:
    godot --path .

# 导出 macOS Apple Silicon 应用包.
export-macos:
    cmake --build build/native --parallel
    bun tools/package/export-macos.ts

# 校验资源提取和原版对照环境.
test-tools:
    bun test

# 校验三种主题的迷宫结构和物理接触顺序.
check-world:
    bun tools/port/check-maze.ts
    bun tools/port/check-physics.ts

# just check-match combat-2
# 对照本地对局或指定武器场景的逐帧状态.
check-match scenario="match-17":
    bun tools/port/check-match.ts "{{scenario}}"

# 对照普通炮弹, 六种特殊武器, 护盾和 Laika 决策.
check-weapons:
    bun tools/port/check-match.ts match-17
    bun tools/port/check-match.ts combat-0
    bun tools/port/check-match.ts combat-1
    bun tools/port/check-match.ts combat-2
    bun tools/port/check-match.ts combat-3
    bun tools/port/check-match.ts combat-4
    bun tools/port/check-match.ts combat-5
    bun tools/port/check-match.ts combat-6
    bun tools/port/check-match.ts laika

# 对照原版角色动画的骨骼矩阵和网格顶点.
check-spine:
    bun tools/port/check-spine.ts

# 对照原版 P2 的碎片轨迹, 摩擦和接触事件.
check-p2:
    bun tools/port/check-p2.ts

# 校验一至三名玩家的输入和多回合生命周期.
check-local:
    godot --headless --path . --script tests/godot/local_session.gd --quit-after 120

# 校验原版菜单布局与鼠标点击.
check-menu:
    godot --headless --path . --script tests/godot/menu_port.gd --quit-after 120

# 校验原图集地图, 坦克分层和履带动画.
check-battle:
    bun tools/port/check-godot.ts battle

# 校验特殊武器与护盾的拾取, 开火和原版战斗表现.
check-battle-weapons:
    bun tools/port/check-godot.ts battle-weapons

# 校验原版战斗事件, 动画, 音效和连续回合.
check-flow:
    bun tools/port/check-godot.ts flow

# 校验人数菜单, 三种操作分配, 本地对局和返回菜单.
check-application:
    bun tools/port/check-godot.ts application

# 校验窗口缩放后的菜单, 操作选择, 战斗布局和玩家面板.
check-resize:
    bun tools/port/check-godot.ts resize

# 校验原版发射点, 粒子坐标和 Godot 绘制坐标的对应关系.
check-particles:
    bun tools/oracle/export-particles.ts
    bun tools/port/check-godot.ts particles

# 对照原版爆炸震屏的相机边界, 取整和归位.
check-camera:
    bun tools/oracle/export-camera.ts
    bun tools/port/check-godot.ts camera

# 对照原版定时器, 游戏状态, 子对象, 补间和表现物理的执行顺序.
check-frame:
    bun tools/oracle/export-frame.ts
    bun tools/port/check-godot.ts frame

# 校验离线设置版本迁移和保存.
check-settings:
    bun tools/port/check-godot.ts settings
