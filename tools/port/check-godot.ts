import { mkdir, unlink } from "node:fs/promises";
import { resolve } from "node:path";
import { parseArgs } from "node:util";
import { log } from "../shared/log";

const name = process.argv[2];
const { values: options } = parseArgs({ args: process.argv.slice(3), options: { headed: { type: "boolean" }, verbose: { type: "boolean" } } });
const scripts: Record<string, { script: string; result: string }> = {
  menu: { script: "menu_port", result: "menu-port" },
  local: { script: "local_session", result: "local-session" },
  battle: { script: "battle_view", result: "battle-view" },
  flow: { script: "battle_flow", result: "battle-flow" },
  application: { script: "application_flow", result: "application-flow" },
  particles: { script: "emitter_coordinates", result: "emitter-coordinates" },
  "battle-particles": { script: "battle_particles", result: "battle-particles" },
  "battle-weapons": { script: "battle_weapons", result: "battle-weapons" },
  settings: { script: "settings_store", result: "settings-store" },
  camera: { script: "camera_port", result: "camera" },
  frame: { script: "frame_order", result: "frame" },
  resize: { script: "resize_layout", result: "resize-layout" },
  shield: { script: "shield_follow", result: "shield-follow" },
};
if (!scripts[name]) throw new Error(`未知检查: ${name}`);
await mkdir(".tmp", { recursive: true });
const output = resolve(`.tmp/${scripts[name].result}.actual.json`);
await unlink(output).catch(error => { if (error.code !== "ENOENT") throw error; });
const started = performance.now();
log.info({ check: name, headed: !!options.headed }, "开始 Godot 集成检查");
const processHandle = Bun.spawn(["godot", ...(!options.headed ? ["--headless"] : []), ...(options.verbose ? ["--verbose"] : []), "--path", ".", "--script", `tests/godot/${scripts[name].script}.gd`, "--quit-after", "120"], { stdout: "pipe", stderr: "pipe" });
const progress = setInterval(() => log.info({ check: name, seconds: Math.round((performance.now() - started) / 1000) }, "Godot 检查进行中"), 10000);
const [code, stdout, stderr] = await Promise.all([processHandle.exited, new Response(processHandle.stdout).text(), new Response(processHandle.stderr).text()]);
clearInterval(progress);
await Bun.write(`.tmp/${name}.log`, stdout + stderr);
if (code !== 0 || /SCRIPT ERROR:|ERROR:|WARNING:.*leak/.test(stdout + stderr)) throw new Error(`Godot ${name} 检查失败, 详见 .tmp/${name}.log\n${(stdout + stderr).slice(0, 6500)}`);
if (!await Bun.file(output).exists()) throw new Error(`Godot 未生成完成记录: ${output}`);
const result = await Bun.file(output).json();
log.info({ check: name, milliseconds: Math.round(performance.now() - started), result }, "Godot 集成检查通过");
