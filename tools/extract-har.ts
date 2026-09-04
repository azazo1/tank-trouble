import { mkdir, readFile, writeFile } from "node:fs/promises";
import { basename, dirname, extname, join } from "node:path";

type HarContent = {
  encoding?: string;
  mimeType?: string;
  text?: string;
};

type HarEntry = {
  request: { url: string };
  response: { content: HarContent; status: number };
};

type HarArchive = {
  log: { entries: HarEntry[] };
};

const harPath = process.argv[2];
if (!harPath) {
  process.stderr.write("Usage: bun tools/extract-har.ts <archive.har>\n");
  process.exit(2);
}

const log = (message: string): void => {
  process.stdout.write(`[extract-har] ${message}\n`);
};

const decode = (content: HarContent): Buffer => {
  const text = content.text ?? "";
  return content.encoding === "base64"
    ? Buffer.from(text, "base64")
    : Buffer.from(text, "utf8");
};

const safeName = (url: URL): string => {
  const raw = basename(url.pathname) || "index.html";
  return raw.replaceAll(/[^A-Za-z0-9._+-]/g, "-");
};

const outputFor = (entry: HarEntry): string | null => {
  const url = new URL(entry.request.url);
  const path = url.pathname;

  if (path.includes("/assets/fonts/")) {
    return join("assets/original/fonts", basename(path));
  }
  if (path.includes("/assets/audio/")) {
    return join("assets/original/audio", basename(path));
  }
  if (path.includes("/assets/images/game/")) {
    return join("assets/original/images/game", basename(path));
  }
  if (path.includes("/assets/images/menu/")) {
    return join("assets/original/images/menu", basename(path));
  }
  if (path.includes("/assets/images/lobby/")) {
    return join("assets/original/images/lobby", basename(path));
  }
  if (path.includes("/assets/images/buttons/")) {
    return join("assets/original/images/buttons", basename(path));
  }
  if (path.includes("/assets/images/laika/")) {
    return join("assets/original/images/laika", basename(path));
  }
  if (path.includes("/assets/images/dimitri/")) {
    return join("assets/original/images/dimitri", basename(path));
  }
  if (path.includes("/js/tt/") || path.includes("keyboardinputmanager")) {
    return join(".references/site", safeName(url));
  }
  if (path.endsWith("content.php") || path.endsWith("/game")) {
    const suffix = path.endsWith("content.php") ? "content.html" : "game.html";
    return join(".references/site", suffix);
  }
  if (extname(path) === ".css") {
    return join(".references/site", safeName(url));
  }
  return null;
};

log(`reading ${harPath}`);
const archive = JSON.parse(await readFile(harPath, "utf8")) as HarArchive;
const written = new Set<string>();
let skippedEmpty = 0;
let extracted = 0;

for (const entry of archive.log.entries) {
  const output = outputFor(entry);
  if (!output || written.has(output)) {
    continue;
  }
  if (entry.response.status < 200 || entry.response.status >= 300) {
    continue;
  }
  if (!entry.response.content.text) {
    skippedEmpty += 1;
    continue;
  }

  await mkdir(dirname(output), { recursive: true });
  await writeFile(output, decode(entry.response.content));
  written.add(output);
  extracted += 1;
  if (extracted % 25 === 0) {
    log(`extracted ${extracted} files`);
  }
}

log(`done: ${extracted} files extracted, ${skippedEmpty} empty responses skipped`);
