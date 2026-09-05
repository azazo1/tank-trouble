import { mkdir, readFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { log } from "../shared/log";
import { classDefinition, Compiler } from "./compiler";

const root = join(import.meta.dir, "../..");
const groups: Record<string, string[]> = {
  world: ["constants", "arrayutils", "mathutils", "mazethememanager", "mazemap", "maze"],
  states: ["projectilestate", "trapstate", "collectiblestate", "weaponstate", "upgradestate", "counterstate", "zonestate", "tankstate", "playerstate", "scorestate", "emblemstate", "inputstate", "gamestate", "roundstate"],
  combat: ["tank", "projectile", "shrapnel", "shotgun", "homingmissile", "trap", "mine", "collectible", "weapon", "bulletweapon", "laserweapon", "doublebarrelweapon", "shotgunweapon", "homingmissileweapon", "mineweapon", "gatlinggunweapon", "upgrade", "laseraimerupgrade", "spawnshieldupgrade", "aimerupgrade", "shieldupgrade", "speedboostupgrade"],
  match: ["player", "score", "emblem", "gamecontroller", "gamemodel", "roundcontroller", "roundmodel", "gamemode", "bootcampgamemode", "counter", "timercountdowncounter", "overtimecountupcounter", "zone", "spawnzone", "stormzone", "idgenerator"],
  events: ["kill", "trip", "pickup", "weapondeactivation", "upgradeupdate", "targetchange", "victoryaward", "playerkick", "chickenout", "shutdown", "chatpost", "systemchatpost", "achievementunlock", "playerupdate"],
  ai: ["ai", "aimanager", "aiutils"],
  physics: ["b2dutils"],
};
const definitions = [];
const index: Record<string, string> = { Log: "res://game/runtime/original_log.gd", jKstra: "res://game/runtime/original_graph.gd", Box2D: "res://game/physics/box2d.gd" };
for (const [group, files] of Object.entries(groups)) for (const file of files) {
  const definition = classDefinition(await readFile(join(root, `vendor/original/js/tt/${file}.js`), "utf8"));
  const destination = `game/ported/${group}/${file}.gd`;
  index[definition.name] = `res://${destination}`;
  definitions.push({ definition, destination, file });
}
const failures: string[] = [];
const arities: Record<string, number> = {};
for (const { definition } of definitions) {
  for (const property of [...definition.methods, ...definition.staticMethods]) {
    const name = property.key.name ?? String(property.key.value);
    arities[name] = Math.max(arities[name] ?? 0, property.value.params.length);
  }
  for (const { name, fn } of definition.constructors) {
    arities[name] = Math.max(arities[name] ?? 0, fn.params.length);
    arities[`_construct_${name}`] = arities[name];
  }
}
for (const { definition, destination, file } of definitions) {
  try {
    const source = new Compiler(definition, index, arities).compile();
    await mkdir(dirname(join(root, destination)), { recursive: true });
    await Bun.write(join(root, destination), source);
    log.info({ module: definition.name, source: `js/tt/${file}.js` }, "原版模块转译完成");
  } catch (error) {
    failures.push(`${definition.name}: ${error}`);
  }
}
if (failures.length) throw new Error(failures.join("\n"));
await Bun.write(join(root, "game/ported/module-index.json"), JSON.stringify(index, null, 2) + "\n");
