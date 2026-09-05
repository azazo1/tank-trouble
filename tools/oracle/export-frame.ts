import { parse } from "acorn";
import { createContext, runInContext } from "node:vm";
import { log } from "../shared/log";

const source = await Bun.file("vendor/original/js/phaser/phaser.min.js").text();
const methods = new Map<string, string>();
const wanted = new Set(["X.Game.prototype.updateLogic", "X.Group.prototype.preUpdate", "X.Group.prototype.update", "X.Group.prototype.postUpdate", "X.Stage.prototype.update", "X.Stage.prototype.postUpdate"]);
const visit = (node: any) => {
  if (!node || typeof node !== "object") return;
  if (node.type === "AssignmentExpression") {
    const name = source.slice(node.left.start, node.left.end);
    if (wanted.has(name)) methods.set(name, source.slice(node.right.start, node.right.end));
    if (node.right.type === "ObjectExpression") for (const property of node.right.properties) {
      const key = `${name}.${property.key.name}`;
      if (wanted.has(key)) methods.set(key, source.slice(property.value.start, property.value.end));
    }
  }
  for (const value of Object.values(node)) if (Array.isArray(value)) value.forEach(visit); else if (value && typeof value === "object") visit(value);
};
visit(parse(source, { ecmaVersion: "latest" }));
if (methods.size !== wanted.size) throw new Error("原版帧循环方法缺失");
const trace: string[] = [];
const context = createContext({});
const method = (name: string) => runInContext(`(${methods.get(name)})`, context);
const record = (name: string) => () => trace.push(name);
const noop = () => {};
const child = (name: string) => ({ exists: true, preUpdate: record(`pre:${name}`), update: record(`update:${name}`), postUpdate: record(`post:${name}`) });
const world: any = { exists: true, children: [child("a"), child("b")], preUpdate: method("X.Group.prototype.preUpdate"), update: method("X.Group.prototype.update"), postUpdate: method("X.Group.prototype.postUpdate") };
for (const item of world.children) item.parent = world;
const stage: any = { exists: true, children: [world], preUpdate() { world.preUpdate(); }, update: method("X.Stage.prototype.update"), postUpdate: method("X.Stage.prototype.postUpdate"), updateTransform: noop };
world.parent = stage;
const game = {
  time: { preUpdate: record("timer") }, scale: { preUpdate: noop }, debug: { preUpdate: noop }, camera: { preUpdate: noop, update: record("camera") },
  physics: { preUpdate: noop, update: record("physics") }, state: { preUpdate: noop, update: record("state"), postUpdate: noop },
  plugins: { preUpdate: noop, update: noop, postUpdate: noop }, stage, tweens: { update: record("tween") }, sound: { update: noop }, input: { update: noop },
};
stage.game = game;
method("X.Game.prototype.updateLogic").call(game, 1 / 60);
await Bun.write(".tmp/frame.expected.json", JSON.stringify(trace));
log.info({ trace }, "原版帧更新顺序生成完成");
