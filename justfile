[private]
default:
    @just --list

# just run
# 启动本地坦克动荡游戏.
run:
    godot --path .

# just validate
# 无头校验 Godot 项目和脚本.
validate:
    godot --headless --path . --editor --quit
