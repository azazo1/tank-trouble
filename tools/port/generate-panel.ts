import { mkdir } from "node:fs/promises";
import { dirname } from "node:path";
import { classDefinition, Compiler } from "./compiler";
import { sha256 } from "../assets/har";
import { log } from "../shared/log";

const index = await Bun.file("game/ported/module-index.json").json();
index.UITankIcon = "res://game/presentation/assets/icon_loader.gd";
const files = ["uipool", "uitankiconimage", "uitankiconnamegroup", "playerpanel/uitankavatargroup", "playerpanel/uitankiconscoregroup", "playerpanel/uiscoreexplosionemitter", "playerpanel/uiscoreexplosionparticle", "playerpanel/uiscoreexplosionfragmentsprite", "playerpanel/uimainstate"];
const definitions = [];
const mapping = [];
for (const file of files) {
  const source = `vendor/original/js/tt/ui/${file}.js`;
  const text = await Bun.file(source).text();
  const definition = classDefinition(text);
  const remove = (node: any): boolean => {
    if (!node || typeof node !== "object") return false;
    if (node.type === "Identifier" && ["ClientManager", "TankTrouble", "UIPlayerPanel"].includes(node.name)) return true;
    if (node.type === "MemberExpression" && ["rankIconGroup", "favouriteStar", "getRankLevelFromRank"].includes(node.property?.name)) return true;
    return Object.values(node).some(value => Array.isArray(value) ? value.some(remove) : remove(value));
  };
  const filter = (node: any) => {
    if (!node || typeof node !== "object") return;
    if (node.type === "BlockStatement") node.body = node.body.filter((statement: any) => !["ExpressionStatement", "VariableDeclaration", "IfStatement"].includes(statement.type) || !remove(statement));
    for (const value of Object.values(node)) if (Array.isArray(value)) value.forEach(filter); else if (value && typeof value === "object") filter(value);
  };
  definition.methods = definition.methods.filter(method => method.key.name !== "_clientStateChangeHandler");
  if (definition.name === "UITankIconNameGroup") definition.methods.find(method => method.key.name === "_updateFavouriteStatus")!.value.body.body = [];
  if (definition.name === "UIMainState") {
    definition.name = "UILocalPanelLayout";
    definition.reference = "UILocalPanelLayout";
    definition.base = "Phaser.Group";
    definition.methods = definition.methods.filter(method => ["_onSizeChangeHandler", "_updateUI"].includes(method.key.name));
  }
  definition.constructors.forEach(item => filter(item.fn.body));
  definition.methods.forEach(method => filter(method.value.body));
  const destination = `game/ported/presentation/panel/${definition.name.toLowerCase()}.gd`;
  index[definition.name] = `res://${destination}`;
  definitions.push({ definition, destination });
  mapping.push({ module: definition.name, source, destination, sha256: sha256(text), changes: ["原版布局和计分动画, 排除账号详情, 排名和好友状态"] });
}
for (const { definition, destination } of definitions) {
  await mkdir(dirname(destination), { recursive: true });
  await Bun.write(destination, new Compiler(definition, index).compile());
  log.info({ module: definition.name }, "原版玩家面板模块转译完成");
}
await Bun.write("game/ported/module-index.json", JSON.stringify(index, null, 2) + "\n");
await Bun.write("game/ported/presentation/panel-source-map.json", JSON.stringify({ schema_version: 1, modules: mapping }, null, 2) + "\n");
