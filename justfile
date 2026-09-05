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

# 对照原版角色动画的骨骼矩阵和网格顶点.
check-spine:
    bun tools/port/check-spine.ts

# 对照原版 P2 的碎片轨迹, 摩擦和接触事件.
check-p2:
    bun tools/port/check-p2.ts
