import { mkdir } from "node:fs/promises";
import { dirname, join } from "node:path";
import { parseArgs } from "node:util";
import { log } from "../shared/log";
import { isGameModule, originalPath, RELEASE, responseBody, sha256, splitPageSpeed, type HarEntry } from "./har";

const { positionals } = parseArgs({ args: Bun.argv.slice(2), allowPositionals: true, options: {} });
if (positionals.length !== 1) throw new Error("用法: bun tools/assets/import-har.ts <archive.har>");
const root = join(import.meta.dir, "../..");
const input = Bun.file(positionals[0]);
const archive = await input.json() as { log: { entries: HarEntry[] } };
if (!Array.isArray(archive.log?.entries)) throw new Error("HAR 缺少 log.entries");
const manifest: { path: string; origin: string; sha256: string; bytes: number; kind: string }[] = [];
const written = new Set<string>();
let aiCount = 0;
log.info({ entries: archive.log.entries.length }, "开始提取游戏源码和资源");

async function save(path: string, bytes: Uint8Array | string, origin: string, kind: string) {
  if (written.has(path)) return;
  const target = join(root, path);
  await mkdir(dirname(target), { recursive: true });
  await Bun.write(target, bytes);
  written.add(path);
  manifest.push({ path, origin, kind, sha256: sha256(bytes), bytes: typeof bytes === "string" ? Buffer.byteLength(bytes) : bytes.length });
}

for (const [index, entry] of archive.log.entries.entries()) {
  const path = originalPath(entry.request.url);
  if (!path) continue;
  const body = responseBody(entry);
  if (!body) continue;
  const origin = `https://cdn.tanktrouble.com/${RELEASE}/${path}`;
  if (path.startsWith("js/")) {
    for (const module of splitPageSpeed(path, body.toString("utf8"))) {
      if (isGameModule(module.path)) await save(`vendor/original/${module.path}`, module.source, origin, "source");
    }
  } else if (/^assets\/(images|audio|fonts)\//.test(path) && /\.(png|json|atlas|ttf|m4a|mp3)$/.test(path)) {
    await save(`assets/original/${path.slice(7)}`, body, origin, "asset");
  } else if (path === "ajax/") {
    let method: string | undefined;
    try { method = JSON.parse(entry.request.postData?.text ?? "{}").method; } catch {}
    if (method !== "tanktrouble.getAIs") continue;
    const data = JSON.parse(body.toString("utf8")).result?.data;
    if (!Array.isArray(data)) throw new Error("HAR 中的 AI 参数格式不正确");
    const ais = data.map((ai) => ({
      id: String(ai.playerId),
      name: String(ai.config.name),
      ...Object.fromEntries(["dexterity", "cleverness", "boldness", "greediness", "determination", "aggressiveness", "vengefulness"].map((key) => {
        const value = Number(ai.config[key]);
        if (!Number.isFinite(value)) throw new Error(`AI 参数不是数值: ${key}`);
        return [key, value];
      })),
    }));
    aiCount = ais.length;
    await save("assets/data/ais.json", JSON.stringify({ schema_version: 1, ais }, null, 2) + "\n", "HAR: tanktrouble.getAIs", "data");
  }
  if (index % 40 === 0) log.info({ processed: index + 1, total: archive.log.entries.length, files: written.size }, "资源提取进度");
}

if (!aiCount) throw new Error("没有找到原版 AI 参数");
manifest.sort((a, b) => a.path.localeCompare(b.path));
await mkdir(join(root, "assets/data"), { recursive: true });
await Bun.write(join(root, "assets/data/source-manifest.json"), JSON.stringify({ schema_version: 1, release: RELEASE, files: manifest }, null, 2) + "\n");
log.info({ files: written.size, sourceModules: manifest.filter((x) => x.kind === "source").length, ais: aiCount }, "HAR 导入完成");
