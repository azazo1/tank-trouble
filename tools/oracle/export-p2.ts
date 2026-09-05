import { parse } from "acorn";
import { createContext, runInContext } from "node:vm";
import { join } from "node:path";
import { mkdir } from "node:fs/promises";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
const source = await Bun.file(join(root, "vendor/original/js/phaser/phaser.min.js")).text();
const ast = parse(source, { ecmaVersion: "latest" }) as any;
const factory = ast.body[0].expression.expressions[0].argument.arguments[0];
const context = createContext({});
const p2 = runInContext(`(${source.slice(factory.start, factory.end)})()`, context);
const scenarios = [
  { name: "free-fragment", gravity: [0, 0], floor: false, mass: 1, position: [0.25, 2], velocity: [1.25, -2], angle: 0.35, angularVelocity: 2.4, damping: 0.1, angularDamping: 0.1 },
  { name: "floor-fragment", gravity: [0, -9.78], floor: true, mass: 1, position: [0.25, 2], velocity: [1.25, -2], angle: 0.35, angularVelocity: 2.4, damping: 0.1, angularDamping: 0.1 },
  { name: "kinematic-tank", gravity: [0, -9.78], floor: true, mass: 0, type: 4, position: [0.25, 2], velocity: [1.25, -2], angle: 0.35, angularVelocity: 2.4, damping: 0, angularDamping: 0 },
];
await mkdir(join(root, ".tmp"), { recursive: true });
for (const scenario of scenarios) {
  const world = new p2.World({ gravity: scenario.gravity });
  const materialA = new p2.Material(), materialB = new p2.Material();
  const contact = new p2.ContactMaterial(materialA, materialB, { restitution: 0.35, friction: 1, relaxation: 10 });
  world.addContactMaterial(contact);
  const body = new p2.Body(scenario);
  const shape = new p2.Box({ width: 0.4, height: 0.3, material: materialA, collisionGroup: 2, collisionMask: 1 });
  body.addShape(shape);
  world.addBody(body);
  if (scenario.floor) {
    const floor = new p2.Body({ mass: 0 });
    floor.addShape(new p2.Plane({ material: materialB, collisionGroup: 1, collisionMask: 2 }));
    world.addBody(floor);
  }
  let frame = 0;
  const contacts: any[] = [];
  for (const kind of ["beginContact", "endContact"]) world.on(kind, (event: any) => contacts.push({ frame, kind, bodyA: event.bodyA === body, bodyB: event.bodyB === body }));
  const frames: any[] = [];
  for (; frame < 360; ++frame) {
    world.step(1 / 60);
    frames.push({ position: Array.from(body.position), velocity: Array.from(body.velocity), angle: body.angle, angularVelocity: body.angularVelocity });
  }
  await Bun.write(join(root, `.tmp/p2-${scenario.name}.expected.json`), JSON.stringify({ scenario, frames, contacts }));
  log.info({ scenario: scenario.name, frames: frames.length, contacts: contacts.length }, "原版 P2 对照数据生成完成");
}
