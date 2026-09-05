import { join } from "node:path";
import { log } from "../shared/log";
import { parseArgs } from "node:util";

const root = join(import.meta.dir, "../..");
const { positionals } = parseArgs({ args: Bun.argv.slice(2), allowPositionals: true, strict: true });
const name = positionals[0] ?? "match-17";
if (!/^(match-17|combat-[0-6]|laika)$/.test(name)) throw new Error(`未知对照场景: ${name}`);
log.info("开始原版对局逐帧对照");
const started = performance.now();
const child = Bun.spawn(["godot", "--headless", "--path", root, "--script", "tests/godot/match_port.gd", "--", name], { stdout: "pipe", stderr: "pipe" });
const deadline = setTimeout(() => child.kill(), 90000);
const progress = setInterval(() => log.info({ seconds: Math.round((performance.now() - started) / 1000) }, "Godot 对局重放进行中"), 5000);
const [stdout, stderr, code] = await Promise.all([new Response(child.stdout).text(), new Response(child.stderr).text(), child.exited]);
clearTimeout(deadline);
clearInterval(progress);
if (code !== 0 || stderr.includes("ERROR:")) throw new Error(`Godot 对局执行失败 (${code}):\n${stdout}\n${stderr.slice(0, 12000)}`);
const expected = await Bun.file(join(root, `tests/fixtures/${name}.json`)).json();
const actual = await Bun.file(join(root, `.tmp/${name}.actual.json`)).json();
function compare(a: any, b: any, path: string): void {
  if (path.endsWith(".fieldsJSON")) return compare(JSON.parse(a), JSON.parse(b), path + ".data");
  if (typeof a === "number" && typeof b === "number") {
    if (!Number.isFinite(b) || Math.abs(a - b) > 1e-6) throw new Error(`${path}: 原版 ${a}, 移植 ${b}`);
  } else if (a !== null && typeof a === "object") {
    if (b === null || typeof b !== "object") throw new Error(`${path}: 缺少对象`);
    const keys = Object.keys(a);
    if (keys.length !== Object.keys(b).length) throw new Error(`${path}: 字段数 ${keys.length} != ${Object.keys(b).length}`);
    for (const key of keys) compare(a[key], b[key], `${path}.${key}`);
  } else if (a !== b) throw new Error(`${path}: 原版 ${a}, 移植 ${b}`);
}
compare(expected.frames, actual.frames, "frames");
if (expected.decisions) compare(expected.decisions, actual.decisions, "decisions");
compare(expected.random_tape.length, actual.random_count, "random_count");
log.info({ scenario: name, frames: actual.frames.length, randomValues: actual.random_count, seconds: (performance.now() - started) / 1000 }, "原版对局状态与随机序列一致");
