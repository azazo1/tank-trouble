import { join } from "node:path";
import { godotLogFailed } from "../shared/godot-log";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
await import("../oracle/export-p2");
log.info("开始原生 P2 逐帧对照");
const started = performance.now();
const child = Bun.spawn(["godot", "--headless", "--path", root, "--script", "tests/godot/p2_port.gd"], { stdout: "pipe", stderr: "pipe" });
const deadline = setTimeout(() => child.kill(), 90000);
const progress = setInterval(() => log.info({ seconds: Math.round((performance.now() - started) / 1000) }, "原生 P2 重放进行中"), 5000);
const [stdout, stderr, code] = await Promise.all([new Response(child.stdout).text(), new Response(child.stderr).text(), child.exited]);
clearTimeout(deadline);
clearInterval(progress);
if (code !== 0 || godotLogFailed(stdout + stderr)) throw new Error(`Godot P2 执行失败 (${code}):\n${stdout}\n${stderr.slice(0, 12000)}`);
for (const name of ["free-fragment", "floor-fragment", "kinematic-tank"]) {
  const expected = await Bun.file(join(root, `.tmp/p2-${name}.expected.json`)).json();
  const actual = await Bun.file(join(root, `.tmp/p2-${name}.actual.json`)).json();
  let maximum = 0;
  function compare(a: any, b: any, path: string): void {
    if (typeof a === "number" && typeof b === "number") {
      const error = Math.abs(a - b);
      maximum = Math.max(maximum, error);
      if (!Number.isFinite(b) || error > 1e-6) throw new Error(`${path}: ${a} != ${b}`);
    } else if (a !== null && typeof a === "object") {
      if (b === null || typeof b !== "object" || Object.keys(a).length !== Object.keys(b).length) throw new Error(`${path}: 结构不一致`);
      for (const key of Object.keys(a)) compare(a[key], b[key], `${path}.${key}`);
    } else if (a !== b) throw new Error(`${path}: ${a} != ${b}`);
  }
  compare(expected.frames, actual.frames, name);
  compare(expected.contacts, actual.contacts, name + ".contacts");
  log.info({ scenario: name, frames: actual.frames.length, contacts: actual.contacts.length, maximum }, "P2 轨迹和接触事件顺序一致");
}
