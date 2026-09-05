import { mkdir } from "node:fs/promises";
import { join } from "node:path";
import { log } from "../shared/log";
import { OriginalRuntime } from "./runtime";

const root = join(import.meta.dir, "../..");
const runtime = new OriginalRuntime(12345);
const constants = runtime.load("constants");
const keys: string[] = [];
for (const key in constants) if (/^[A-Z][A-Z0-9_]*$/.test(key) && typeof constants[key] !== "function") keys.push(key);
const values = Object.fromEntries(keys.map((key) => [key, constants[key]]));
if (values.PIXELS_PER_METER !== 20 || values.TANK?.WIDTH?.px !== 60) throw new Error("原版常量导出不完整");
await mkdir(join(root, "assets/data"), { recursive: true });
await Bun.write(join(root, "assets/data/constants.json"), JSON.stringify({ schema_version: 1, values }, null, 2) + "\n");
log.info({ constants: Object.keys(values).length }, "已导出原版游戏常量");

await mkdir(join(root, "tests/fixtures"), { recursive: true });
for (const [seed, width, height, players, theme] of [[1, 6, 5, 2, 0], [17, 7, 6, 3, 1], [413, 5, 5, 2, 2]]) {
  const rt = new OriginalRuntime(seed);
  const maze = rt.load("maze").createRandom(width, height, Array.from({ length: players }, (_, i) => `player-${i}`), theme);
  const data = { seed, width, height, players, theme, random_tape: rt.randomTape, maze: maze.toObj(), tanks: maze.getTankPositions(), distances: maze.distances, dead_end_penalties: maze.deadEndPenalties };
  await Bun.write(join(root, `tests/fixtures/maze-${seed}.json`), JSON.stringify(data, null, 2) + "\n");
  log.info({ seed, randomValues: rt.randomTape.length }, "原版迷宫对照数据已生成");
}
