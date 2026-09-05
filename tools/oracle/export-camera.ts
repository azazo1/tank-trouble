import { parse } from "acorn";
import { createContext, runInContext } from "node:vm";
import { log } from "../shared/log";

const source = await Bun.file("vendor/original/js/phaser/phaser.min.js").text();
const statements: string[] = [];
let setBounds = "";
const visit = (node: any) => {
  if (!node || typeof node !== "object") return;
  const target = node.type === "AssignmentExpression" ? node.left :
    node.type === "CallExpression" && node.callee.object?.name === "Object" && node.callee.property?.name === "defineProperty" ? node.arguments[0] : null;
  const name = target ? source.slice(target.start, target.end) : "";
  if (/^X\.(Camera|Rectangle)(\.|$)/.test(name)) statements.push(source.slice(node.start, node.end) + ";");
  if (name === "X.World.prototype.setBounds") setBounds = source.slice(node.right.start, node.right.end);
  for (const value of Object.values(node)) if (Array.isArray(value)) value.forEach(visit); else if (value && typeof value === "object") visit(value);
};
visit(parse(source, { ecmaVersion: "latest" }));
if (!setBounds) throw new Error("原版 World.setBounds 缺失");
const context = createContext({ X: { Point: function(x = 0, y = 0) { this.x = x; this.y = y; }, Signal: function() {} } });
runInContext(statements.join("\n"), context);
const createCamera = runInContext(`(width, height) => {
  const world = {bounds: new X.Rectangle(0, 0, width, height), position: {x: 0, y: 0}, scale: {x: 1, y: 1}};
  const game = {width, height, world, physics: {setBoundsToWorld() {}}};
  const camera = new X.Camera(game, 0, 0, 0, width, height);
  world.game = game;
  world.camera = camera;
  world.setBounds = ${setBounds};
  camera.displayObject = world;
  camera.scale = world.scale;
  return {world, camera};
}`, context);
const scenarios = [];
for (const size of [[1000, 580], [1600, 900]]) {
  const { world, camera } = createCamera(...size);
  const frames = [];
  for (let frame = 0; frame < 90; frame++) {
    const amplitude = Math.max(0, 20 - frame * 0.5);
    const x = Math.sin(frame * 2.1) * amplitude;
    const y = Math.cos(frame * 1.7) * amplitude;
    world.setBounds(x, y, size[0] + x, size[1] + y);
    camera.update();
    frames.push({ bounds: [x, y, size[0] + x, size[1] + y], camera: [camera.view.x, camera.view.y], world: [world.position.x, world.position.y] });
  }
  scenarios.push({ size, frames });
}
await Bun.write(".tmp/camera.expected.json", JSON.stringify(scenarios));
log.info({ scenarios: scenarios.length, frames: 180 }, "原版相机边界与震屏坐标生成完成");
