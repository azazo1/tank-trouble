import { createHash } from "node:crypto";
import { parse } from "acorn";

export const RELEASE = "RELEASE-2026-08-31-01";

export interface HarEntry {
  request: { url: string; postData?: { text?: string } };
  response: { status: number; content: { text?: string; encoding?: string; mimeType?: string } };
}

export interface SourceModule {
  path: string;
  source: string;
}

export function sha256(bytes: Uint8Array | string): string {
  return createHash("sha256").update(bytes).digest("hex");
}

export function responseBody(entry: HarEntry): Buffer | null {
  const { text, encoding } = entry.response.content;
  if (!text || entry.response.status !== 200) return null;
  if (encoding && encoding !== "base64") throw new Error(`未知 HAR 编码: ${encoding}`);
  return Buffer.from(text, encoding === "base64" ? "base64" : "utf8");
}

export function originalPath(url: string): string | null {
  const parsed = new URL(url);
  if (!["tanktrouble.com", "cdn.tanktrouble.com"].includes(parsed.hostname)) return null;
  let path = decodeURIComponent(parsed.pathname).replace(/^\//, "");
  if (path.startsWith("RELEASE-")) {
    if (!path.startsWith(`${RELEASE}/`)) return null;
    path = path.slice(RELEASE.length + 1);
  }
  if (path.split("/").some((part) => part === ".." || part === ".")) return null;
  return path;
}

export function splitPageSpeed(path: string, source: string): SourceModule[] {
  const ast = parse(source, { ecmaVersion: "latest", sourceType: "script" });
  const modules: string[] = [];
  for (const node of ast.body) {
    if (node.type !== "VariableDeclaration") continue;
    for (const declaration of node.declarations) {
      if (declaration.id.type !== "Identifier" || !declaration.id.name.startsWith("mod_pagespeed_")) continue;
      if (declaration.init?.type !== "Literal" || typeof declaration.init.value !== "string") {
        throw new Error(`PageSpeed 模块不是字符串: ${path}`);
      }
      modules.push(declaration.init.value);
    }
  }
  const cleanPath = path.replace(/\.pagespeed\.[^.]+\.[^.]+\.js$/, "");
  if (modules.length === 0) return [{ path: cleanPath.endsWith(".js") ? cleanPath : `${cleanPath}.js`, source }];
  const directory = cleanPath.slice(0, cleanPath.lastIndexOf("/") + 1);
  const parts = cleanPath.slice(directory.length).split("+");
  if (parts.length !== modules.length) throw new Error(`PageSpeed 模块数量不匹配: ${path}`);
  return parts.map((part, index) => ({ path: directory + part.replaceAll(",_", "/"), source: modules[index] }));
}

export function isGameModule(path: string): boolean {
  if (path.startsWith("js/tt/")) return true;
  return [
    "js/classy/classy.js", "js/box2d/Box2dWeb-2.1.0-b.min.js", "js/jkstra/jkstra.js",
    "js/phaser/phaser.min.js", "js/phaserplugins/phaser-spine.js", "js/phaserplugins/phaser-nineslice.min.js",
    "js/inputs.js", "js/inputmanager.js", "js/keyboardinputmanager.js", "js/mouseinputmanager.js",
    "js/gamemanager.js", "js/qualitymanager.js", "js/audiomanager.js", "js/resizemanager.js",
  ].includes(path);
}
