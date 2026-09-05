import { mkdir } from "node:fs/promises";
import { join } from "node:path";
import { classDefinition, Compiler } from "./compiler";
import { sha256 } from "../assets/har";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
const index = await Bun.file(join(root, "game/ported/module-index.json")).json();
const definitions = [];
const adaptations = [];
for (const file of ["inputmanager", "keyboardinputmanager", "mouseinputmanager", "inputs"]) {
  const source = `vendor/original/js/${file}.js`;
  const text = await Bun.file(join(root, source)).text();
  const definition = classDefinition(text);
  const changes: string[] = [];
  if (definition.name === "InputManager") {
    definition.methods.find(method => method.key.name === "update")!.value.body.body = [];
    changes.push("排除网站聊天框, 子类的输入状态和发送顺序保持原版");
  }
  if (definition.name === "MouseInputManager") {
    const body = definition.constructors[0].fn.body.body;
    definition.constructors[0].fn.body.body = [body[0], body.at(-1)];
    changes.push("DOM 事件由 Godot 输入事件写入原版静态鼠标字段");
  }
  if (definition.name === "Inputs") {
    definition.staticMethods = definition.staticMethods.filter(method => !["init", "loadInputSetAssignments", "_authenticationEventHandler"].includes(method.key.name));
    definition.staticMethods.find(method => method.key.name === "_storeInputSetAssignments")!.value.body.body = [];
    changes.push("排除账号事件和 Cookie 存储, 离线会话负责操作分配和版本化持久化");
  }
  const destination = `game/ported/input/${file}.gd`;
  index[definition.name] = `res://${destination}`;
  definitions.push({ definition, destination });
  adaptations.push({ module: definition.name, source, sha256: sha256(text), destination, changes });
}
await mkdir(join(root, "game/ported/input"), { recursive: true });
for (const { definition, destination } of definitions) {
  await Bun.write(join(root, destination), new Compiler(definition, index).compile());
  log.info({ module: definition.name }, "原版输入模块转译完成");
}
await Bun.write(join(root, "game/ported/module-index.json"), JSON.stringify(index, null, 2) + "\n");
await Bun.write(join(root, "game/ported/input/source-map.json"), JSON.stringify({ schema_version: 1, modules: adaptations }, null, 2) + "\n");
