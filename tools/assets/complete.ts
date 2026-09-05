import { mkdir } from "node:fs/promises";
import { dirname, join } from "node:path";
import { log } from "../shared/log";
import { RELEASE, sha256 } from "./har";

const root = join(import.meta.dir, "../..");
const manifest = await Bun.file(join(root, "assets/data/source-manifest.json")).json();
const paths = new Set<string>();
for (const controls of ["WASDKeys", "arrowKeys", "mouse"]) for (const state of ["", "Down", "Active", "Selected"]) {
  for (const suffix of ["", "@2x"]) paths.add(`assets/original/images/inputs/${controls}${state}${suffix}.png`);
}
for (const file of manifest.files) {
  if (/assets\/original\/images\/(game|menu|playerPanel|ranks|buttons|laika|dimitri)\//.test(file.path) && file.path.includes("@2x")) paths.add(file.path.replace("@2x", ""));
}
for (const size of [140, 200, 320]) for (const part of ["turret", "barrel", "leftTread", "rightTread", "base", "turretShade", "barrelShade", "leftTreadShade", "rightTreadShade", "baseShade"]) {
  for (const suffix of ["", "@2x"]) paths.add(`assets/original/images/tankIcon/${part}-${size}${suffix}.png`);
}
const queue = [...paths];
const files: { path: string; origin: string; sha256: string; bytes: number }[] = [];
let completed = 0;
const started = performance.now();
log.info({ files: queue.length }, "开始补齐同版本原始素材");
await Promise.all(Array.from({ length: 5 }, async () => {
  for (;;) {
    const path = queue.shift();
    if (!path) return;
    const destination = join(root, path);
    const origin = `https://cdn.tanktrouble.com/${RELEASE}/assets/${path.slice("assets/original/".length)}`;
    let bytes: Uint8Array;
    if (await Bun.file(destination).exists()) bytes = new Uint8Array(await Bun.file(destination).arrayBuffer());
    else {
      const response = await fetch(origin, { signal: AbortSignal.timeout(45000) });
      if (!response.ok) throw new Error(`原始素材下载失败: ${response.status} ${origin}`);
      bytes = new Uint8Array(await response.arrayBuffer());
      await mkdir(dirname(destination), { recursive: true });
      await Bun.write(destination, bytes);
    }
    files.push({ path, origin, sha256: sha256(bytes), bytes: bytes.length });
    completed++;
    if (completed % 10 === 0 || queue.length === 0) log.info({ completed, total: paths.size }, "原始素材下载进度");
  }
}));
files.sort((a, b) => a.path.localeCompare(b.path));
await Bun.write(join(root, "assets/data/supplement-manifest.json"), JSON.stringify({ schema_version: 1, release: RELEASE, files }, null, 2) + "\n");
log.info({ files: files.length, seconds: ((performance.now() - started) / 1000).toFixed(1) }, "原始素材补齐完成");
