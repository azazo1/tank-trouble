import { join } from "node:path";
import { mkdir } from "node:fs/promises";
import { log } from "../shared/log";
import { sha256 } from "./har";

const root = join(import.meta.dir, "../..");
const manifest = await Bun.file(join(root, "assets/data/source-manifest.json")).json();
const audio = manifest.files.filter((file: { path: string }) => file.path.endsWith(".m4a"));
const converted = [];
await mkdir(join(root, ".tmp/audio"), { recursive: true });
log.info({ files: audio.length }, "开始无损解码原版音效");
for (const [index, file] of audio.entries()) {
  const destination = file.path.replace(/\.m4a$/, ".wav");
  let source = join(root, file.path);
  let sourceHash = file.sha256;
  let stderr = "";
  let success = false;
  for (let attempt = 0; attempt < 2; attempt++) {
    const process = Bun.spawn(["ffmpeg", "-hide_banner", "-loglevel", "error", "-y", "-i", source, "-c:a", "pcm_s16le", join(root, destination)], { stdout: "ignore", stderr: "pipe" });
    stderr = await new Response(process.stderr).text();
    if (await process.exited === 0) { success = true; break; }
    if (attempt === 0) {
      log.warn({ source: file.path, diagnostic: stderr.trim() }, "HAR 音频不能解码, 正在取回同版本原文件");
      const response = await fetch(file.origin, { signal: AbortSignal.timeout(60000) });
      if (!response.ok) throw new Error(`原始音频下载失败: ${response.status} ${file.origin}`);
      const bytes = new Uint8Array(await response.arrayBuffer());
      sourceHash = sha256(bytes);
      source = join(root, ".tmp/audio", sourceHash + ".m4a");
      await Bun.write(source, bytes);
    }
  }
  if (!success) throw new Error(`音效转换失败: ${file.path}\n${stderr}`);
  const bytes = new Uint8Array(await Bun.file(join(root, destination)).arrayBuffer());
  converted.push({ path: destination, source: file.path, source_sha256: sourceHash, origin: file.origin, sha256: sha256(bytes), bytes: bytes.length });
  if ((index + 1) % 10 === 0 || index === audio.length - 1) log.info({ completed: index + 1, total: audio.length }, "音效转换进度");
}
await Bun.write(join(root, "assets/data/audio-manifest.json"), JSON.stringify({ schema_version: 1, files: converted }, null, 2) + "\n");
log.info({ files: converted.length }, "原版音效解码完成");
