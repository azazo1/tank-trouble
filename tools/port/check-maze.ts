import { mkdir } from "node:fs/promises";
import { join } from "node:path";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
await mkdir(join(root, ".tmp"), { recursive: true });
const child = Bun.spawn(["godot", "--headless", "--path", root, "--script", "tests/godot/maze_port.gd"], { stdout: "pipe", stderr: "pipe" });
const timer = setTimeout(() => child.kill(), 20000);
const [stdout, stderr, code] = await Promise.all([new Response(child.stdout).text(), new Response(child.stderr).text(), child.exited]);
clearTimeout(timer);
if (code !== 0 || stderr.includes("SCRIPT ERROR")) throw new Error(`Godot 对照执行失败 (${code}):\n${stdout}\n${stderr.slice(0, 10000)}`);

function compare(expected: any, actual: any, path = "root") {
  if (typeof expected === "number" && typeof actual === "number") {
    if (Math.abs(expected - actual) > 1e-9) throw new Error(`${path}: ${expected} != ${actual}`);
  } else if (expected !== null && typeof expected === "object") {
    if (actual === null || typeof actual !== "object") throw new Error(`${path}: 缺少对象`);
    const keys = Object.keys(expected);
    if (keys.length !== Object.keys(actual).length) throw new Error(`${path}: 成员数量不同`);
    for (const key of keys) compare(expected[key], actual[key], `${path}.${key}`);
  } else if (expected !== actual) throw new Error(`${path}: ${expected} != ${actual}`);
}
for (const seed of [1, 17, 413]) {
  const fixture = await Bun.file(join(root, `tests/fixtures/maze-${seed}.json`)).json();
  const actual = await Bun.file(join(root, `.tmp/maze-${seed}.actual.json`)).json();
  compare({ maze: fixture.maze, tanks: fixture.tanks, distances: fixture.distances, dead_end_penalties: fixture.dead_end_penalties, random_count: fixture.random_tape.length }, actual);
  log.info({ seed, randomValues: actual.random_count }, "Godot 迷宫与原版对照一致");
}
