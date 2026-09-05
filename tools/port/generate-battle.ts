import { mkdir } from "node:fs/promises";
import { dirname, join } from "node:path";
import { classDefinition, Compiler } from "./compiler";
import { sha256 } from "../assets/har";
import { log } from "../shared/log";
import { phaserCore } from "./phaser-core";
import { localBattle } from "./local-battle";

const root = join(import.meta.dir, "../..");
const index = await Bun.file(join(root, "game/ported/module-index.json")).json();
Object.assign(index, {
  "Phaser.Image": "res://game/presentation/bridge/image.gd",
  "Phaser.Sprite": "res://game/presentation/bridge/image.gd",
  Backend: "res://game/offline/player_catalog.gd",
  Caches: "res://game/offline/player_catalog.gd",
  Utils: "res://game/offline/player_catalog.gd",
  AIs: "res://game/offline/ai_registry.gd",
  "Phaser.Graphics": "res://game/presentation/bridge/graphics.gd",
  "Phaser.Particle": "res://game/presentation/particles/particle.gd",
  "Phaser.Particles.Arcade.Emitter": "res://game/ported/presentation/engine/phaseremitter.gd",
  PhaserEmitterBase: "res://game/presentation/particles/emitter_base.gd",
  "p2.Ray": "res://game/presentation/physics/p2_ray.gd",
  "p2.RaycastResult": "res://game/presentation/physics/p2_ray_result.gd",
  X: "res://game/presentation/bridge/phaser.gd",
  "X.Group": "res://game/presentation/bridge/group.gd",
  "X.Point": "res://game/presentation/bridge/point.gd",
  "X.Rectangle": "res://game/presentation/bridge/rectangle.gd",
  "X.Particle": "res://game/presentation/particles/particle.gd",
});
const definitions = [];
const mapping = [];
const battleModules = ["uitanksprite", "uiprojectileimage", "uicratesprite", "uiminesprite", "uishieldsprite", "uishrapnelimage", "uimissileimage", "uiaimergraphics", "uilasergraphics", "uidustparticle", "uismokeparticle", "uicolouredsmokeparticle", "uiexplosionparticle", "uisparkparticle", "uidustemitter", "uismokeemitter", "uicolouredsmokeemitter", "uiexplosionemitter", "uimissilelaunchemitter", "uirubbleemitter", "uirubblefragmentsprite", "uirubblegroup", "uiexplosionfragmentsprite", "uitankexplosiongroup", "uiexplosiongroup", "uipuffsprite", "uishieldsparkgroup", "uishieldsparkemitter", "uishieldsparkboltimage", "uitankfeathersprite", "uitanknamegroup", "uiweaponsymbolgroup", "uiweaponiconimage", "uicountdownimage", "uiroundtitlegroup"];
for (const file of ["qualitymanager", "tt/playerdetails", ...battleModules.map(file => `tt/ui/game/${file}`)]) {
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
for (const definition of await phaserCore()) {
  const destination = `game/ported/presentation/engine/${definition.name.toLowerCase()}.gd`;
  index[definition.name] = `res://${destination}`;
  definitions.push({ definition, destination });
  mapping.push({ module: definition.name, source: "vendor/original/js/phaser/phaser.min.js", destination, changes: ["仅提取原版表现使用的引擎方法, 绘制和场景管理由 Godot 接入"] });
}
const source = "vendor/original/js/tt/ui/game/uigamestate.js";
const text = await Bun.file(join(root, source)).text();
const battle = localBattle(text);
const flowNames = ["init", "create", "shutdown", "update", "_onSizeChangeHandler", "_gameEventHandler", "_roundEventHandler", "_retireUI", "_cleanUp"];
const entities = { ...battle, name: "UIBattleEntities", reference: "UIBattleEntities", methods: battle.methods.filter(method => !flowNames.includes(method.key.name)) };
const flow = { ...battle, name: "UILocalBattleState", reference: "UILocalBattleState", base: "UIBattleEntities", fields: [], methods: battle.methods.filter(method => flowNames.includes(method.key.name)) };
for (const definition of [entities, flow]) {
  const destination = `game/ported/presentation/battle/${definition.name.toLowerCase()}.gd`;
  index[definition.name] = `res://${destination}`;
  definitions.push({ definition, destination });
  mapping.push({ module: "UIGameState", source, destination, sha256: sha256(text), changes: ["按对象表现和对局生命周期划分原函数, 排除 BootCamp 不可达的在线模式, 奖励和账号调用"] });
}
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
