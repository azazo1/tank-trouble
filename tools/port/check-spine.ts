import { join } from "node:path";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
await import("../oracle/export-spine");
const started = performance.now();
log.info("开始原生 Spine 骨骼与网格对照");
const child = Bun.spawn(["godot", "--headless", "--path", root, "--script", "tests/godot/spine_port.gd"], { stdout: "pipe", stderr: "pipe" });
const progress = setInterval(async () => {
  const file = Bun.file(join(root, ".tmp/spine-progress.json"));
  const stage = await file.exists() ? await file.json().catch(() => ({})) : {};
  log.info({ ...stage, seconds: Math.round((performance.now() - started) / 1000) }, "原生 Spine 重放进行中");
}, 5000);
const deadline = setTimeout(() => child.kill(), 120000);
const [stdout, stderr, status] = await Promise.all([new Response(child.stdout).text(), new Response(child.stderr).text(), child.exited]);
clearInterval(progress);
clearTimeout(deadline);
if (status !== 0 || stderr.includes("ERROR:")) throw new Error(`Spine 重放失败 (${status}):\n${stdout}\n${stderr.slice(0, 9000)}`);
let maximum = 0;
function compare(expected: any, actual: any, path: string) {
  if (typeof expected === "number") {
    const error = Math.abs(expected - actual);
    maximum = Math.max(maximum, error);
    if (!Number.isFinite(actual) || error > 1e-6) throw new Error(`${path}: ${expected} != ${actual}`);
  } else if (expected && typeof expected === "object") {
    if (!actual || Object.keys(actual).length !== Object.keys(expected).length) throw new Error(`${path}: 字段或数组长度不同`);
    for (const key of Object.keys(expected)) compare(expected[key], actual[key], `${path}.${key}`);
  } else if (expected !== actual) throw new Error(`${path}: ${expected} != ${actual}`);
}
for (const character of ["laika", "dimitri"]) {
  const expected = await Bun.file(join(root, `.tmp/spine-${character}.expected.json`)).json();
  const actual = await Bun.file(join(root, `.tmp/spine-${character}.actual.json`)).json();
  compare(expected.frames, actual, character);
  log.info({ character, animations: expected.names.length, frames: actual.length, maximum }, "Spine 骨骼矩阵与网格顶点一致");
}
