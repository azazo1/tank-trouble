import { mkdir } from "node:fs/promises";
import { dirname, join } from "node:path";
import { classDefinition, Compiler } from "./compiler";
import { sha256 } from "../assets/har";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
const index = await Bun.file(join(root, "game/ported/module-index.json")).json();
Object.assign(index, {
  "Phaser.Image": "res://game/presentation/bridge/image.gd",
  "Phaser.Sprite": "res://game/presentation/bridge/image.gd",
  Backend: "res://game/offline/player_catalog.gd",
  Caches: "res://game/offline/player_catalog.gd",
});
const definitions = [];
const mapping = [];
for (const file of ["qualitymanager", "tt/playerdetails", "tt/ui/game/uitanksprite", "tt/ui/game/uiprojectileimage", "tt/ui/game/uicratesprite", "tt/ui/game/uiminesprite", "tt/ui/game/uishieldsprite", "tt/ui/game/uishrapnelimage", "tt/ui/game/uimissileimage"]) {
  const source = `vendor/original/js/${file}.js`;
  const text = await Bun.file(join(root, source)).text();
  const definition = classDefinition(text);
  if (definition.name === "QualityManager") {
    definition.staticMethods = definition.staticMethods.filter(method => !["init", "loadQualitySettings", "_focusEventHandler"].includes(method.key.name));
    const setter = definition.staticMethods.find(method => method.key.name === "setQuality")!;
    setter.value.body.body = setter.value.body.body.slice(1);
  }
  const destination = file === "tt/playerdetails" ? "game/ported/states/playerdetails.gd" : `game/ported/presentation/game/${file.split("/").at(-1)}.gd`;
  index[definition.name] = `res://${destination}`;
  definitions.push({ definition, destination });
  mapping.push({ module: definition.name, source, destination, sha256: sha256(text), changes: [] });
}
const source = "vendor/original/js/tt/ui/game/uigamestate.js";
const text = await Bun.file(join(root, source)).text();
const maze = classDefinition(text);
maze.name = "UIMazeView";
maze.reference = "UIMazeView";
maze.base = "Phaser.Group";
maze.fields = maze.fields.filter(field => ["mazeFloorGroup", "mazeWallGroup", "mazeWallDecorationGroup"].includes(field.key.name));
maze.constructors = [];
maze.methods = maze.methods.filter(method => ["_createMaze", "_getMazeLocalBounds"].includes(method.key.name));
const destination = "game/ported/presentation/world/uimazeview.gd";
index.UIMazeView = `res://${destination}`;
definitions.push({ definition: maze, destination });
mapping.push({ module: "UIGameState", source, destination, sha256: sha256(text), changes: ["将 _createMaze 和 _getMazeLocalBounds 原函数分离到地图表现模块"] });
for (const { definition, destination } of definitions) {
  const compiled = new Compiler(definition, index).compile();
  await mkdir(dirname(join(root, destination)), { recursive: true });
  await Bun.write(join(root, destination), compiled);
  log.info({ module: definition.name }, "原版战斗表现模块转译完成");
}
await Bun.write(join(root, "game/ported/module-index.json"), JSON.stringify(index, null, 2) + "\n");
await Bun.write(join(root, "game/ported/presentation/battle-source-map.json"), JSON.stringify({ schema_version: 1, modules: mapping }, null, 2) + "\n");
