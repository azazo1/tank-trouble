import { mkdir } from "node:fs/promises";
import { dirname, join } from "node:path";
import { classDefinition, Compiler } from "./compiler";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
const index = await Bun.file(join(root, "game/ported/module-index.json")).json();
Object.assign(index, {
  "Phaser.Group": "res://game/presentation/bridge/group.gd",
  "PhaserSpine.Spine": "res://game/presentation/animation/spine_actor.gd",
  "Phaser.Text": "res://game/presentation/bridge/text.gd",
  "PhaserNineSlice.NineSlice": "res://game/presentation/bridge/nine_slice.gd",
  Phaser: "res://game/presentation/bridge/phaser.gd",
  GameManager: "res://game/presentation/bridge/game_events.gd",
});
const files = ["uiconstants", "uilaikaspine", "uidimitrispine", "uibuttongroup", "game/uimenubackgroundgroup", "game/uimenustate"];
const definitions = [];
for (const file of files) {
  const source = `vendor/original/js/tt/ui/${file}.js`;
  const definition = classDefinition(await Bun.file(join(root, source)).text());
  if (definition.name === "UIMenuState") {
    definition.base = "Phaser.Group";
    definition.fields = definition.fields.filter((field) => field.key.name !== "logInButton");
    definition.methods = definition.methods.filter((method) => !["_logIn", "_addGuests", "_authenticationEventHandler", "_updateLoginButton"].includes(method.key.name));
    const excluded = (node: any): boolean => {
      if (!node || typeof node !== "object") return false;
      if (node.type === "Identifier" && ["Users", "UIPlayerPanel"].includes(node.name)) return true;
      if (node.type === "MemberExpression" && ["logInButton", "_updateLoginButton", "onSizeChange"].includes(node.property?.name)) return true;
      return Object.values(node).some(value => Array.isArray(value) ? value.some(excluded) : excluded(value));
    };
    const filter = (node: any) => {
      if (!node || typeof node !== "object") return;
      if (node.type === "BlockStatement") node.body = node.body.filter((statement: any) => !["ExpressionStatement", "VariableDeclaration"].includes(statement.type) || !excluded(statement));
      for (const value of Object.values(node)) if (Array.isArray(value)) value.forEach(filter); else filter(value);
    };
    definition.methods.forEach((method) => filter(method.value.body));
  }
  const destination = `game/ported/presentation/${file}.gd`;
  index[definition.name] = `res://${destination}`;
  if (definition.reference) index[definition.reference] = index[definition.name];
  definitions.push({ definition, source, destination });
}
index.UIUtils = "res://game/presentation/bridge/ui_utils.gd";
for (const { definition, source, destination } of definitions) {
  const compiled = new Compiler(definition, index).compile();
  await mkdir(dirname(join(root, destination)), { recursive: true });
  await Bun.write(join(root, destination), compiled);
  log.info({ module: definition.name, source }, "原版表现模块转译完成");
}
await Bun.write(join(root, "game/ported/module-index.json"), JSON.stringify(index, null, 2) + "\n");
