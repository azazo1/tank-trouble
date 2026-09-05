import { mkdir } from "node:fs/promises";
import { join } from "node:path";
import { OriginalRuntime } from "./runtime";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
const original = new OriginalRuntime(1);
const Box2D = original.load("box2d");
original.load("b2dutils");
const { b2Vec2: Vec } = Box2D.Common.Math;
const { b2World: World, b2BodyDef: BodyDef, b2FixtureDef: FixtureDef } = Box2D.Dynamics;
const { b2CircleShape: Circle, b2PolygonShape: Polygon } = Box2D.Collision.Shapes;
const box = (hx: number, hy: number) => ({ kind: "box", hx, hy });
const circle = (radius: number) => ({ kind: "circle", radius });
const wall = (x: number, y: number, hx: number, hy: number) => ({ x, y, type: 0, fixtures: [{ shape: box(hx, hy), friction: 0.05 }] });
const bullet = (x: number, y: number, vx: number, vy: number) => ({ x, y, vx, vy, type: 2, bullet: true, fixedRotation: true, fixtures: [{ shape: circle(0.1), density: 0.01, restitution: 1, friction: 0 }] });
const tank = (x: number, y: number, angle = 0) => ({ x, y, angle, type: 2, allowSleep: false, fixtures: [{ shape: box(0.4, 0.6), density: 1, friction: 0.25 }, { shape: box(0.13, 0.75), density: 1, friction: 0.25 }] });
const cases = [
  { name: "free-flight", bodies: [bullet(1, 1, 3.25, -1.75)] },
  { name: "wall-bounce", bodies: [wall(4, 3, 0.15, 3), bullet(1, 1, 4, 1)] },
  { name: "corner-bounce", bodies: [wall(4, 2, 0.15, 2), wall(2, 4, 2, 0.15), bullet(1, 1, 4, 4)] },
  { name: "near-wall-fire", bodies: [wall(4, 3, 0.15, 3), bullet(3.73, 1, 4, 0)] },
  { name: "shield-bounce", bodies: [{ ...tank(4, 4), fixtures: [{ shape: circle(0.9), density: 0, restitution: 1, friction: 0 }] }, bullet(1, 3.5, 4, 0)] },
  { name: "tank-wall", bodies: [wall(4, 3, 0.15, 3), { ...tank(2, 2, 0.4), vx: 2, vy: 1, angularVelocity: 1.7 }] },
  { name: "tank-pair", bodies: [{ ...tank(1, 2, 0.2), vx: 2.5 }, { ...tank(4, 2, -0.4), vx: -1.8 }] },
  { name: "damping", bodies: [{ ...tank(1, 2, 0.2), vx: 2.5, vy: -1.2, angularVelocity: 0.9, linearDamping: 4, angularDamping: 4 }] },
];

await mkdir(join(root, "tests/fixtures"), { recursive: true });
for (const scenario of cases) {
  const world = new World(new Vec(0, 0), true);
  let fixtureId = 0;
  const bodies = scenario.bodies.map((data: any) => {
    const definition = new BodyDef();
    for (const key of ["type", "angle", "angularVelocity", "linearDamping", "angularDamping", "allowSleep", "fixedRotation", "bullet"]) if (data[key] !== undefined) definition[key] = data[key];
    definition.position.Set(data.x, data.y);
    definition.linearVelocity.Set(data.vx ?? 0, data.vy ?? 0);
    const body = world.CreateBody(definition);
    for (const item of data.fixtures) {
      const fixture = new FixtureDef();
      fixture.shape = item.shape.kind === "circle" ? new Circle(item.shape.radius) : Polygon.AsBox(item.shape.hx, item.shape.hy);
      for (const key of ["friction", "restitution", "density", "isSensor"]) if (item[key] !== undefined) fixture[key] = item[key];
      fixture.userData = ++fixtureId;
      body.CreateFixture(fixture);
    }
    return body;
  });
  const events: any[] = [];
  let frame = 0;
  world.SetContactListener(Object.fromEntries(["BeginContact", "EndContact", "PreSolve", "PostSolve"].map((kind) => [kind, (contact: any) => events.push({ frame, kind, a: contact.GetFixtureA().GetUserData(), b: contact.GetFixtureB().GetUserData() })])));
  const deltas = Array.from({ length: 240 }, (_, i) => [1 / 60, 1 / 60, 1 / 120, 1 / 30, 0.1][i % 5]);
  const frames = [];
  for (frame = 0; frame < deltas.length; frame++) {
    world.Step(deltas[frame], 10, 10);
    frames.push(bodies.map((body: any) => ({ x: body.GetPosition().x, y: body.GetPosition().y, angle: body.GetAngle(), vx: body.GetLinearVelocity().x, vy: body.GetLinearVelocity().y, angularVelocity: body.GetAngularVelocity() })));
  }
  await Bun.write(join(root, `tests/fixtures/physics-${scenario.name}.json`), JSON.stringify({ ...scenario, deltas, frames, events }) + "\n");
  log.info({ scenario: scenario.name, frames: frames.length, contacts: events.length }, "原版物理对照已导出");
}
