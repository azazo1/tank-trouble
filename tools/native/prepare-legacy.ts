import { mkdir, readFile } from "node:fs/promises";
import { dirname, join } from "node:path";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
const source = join(root, "vendor/physics/Box2D_v2.1.2/Box2D/Box2D");
const target = join(root, "build/legacy-box2d/Box2D");
const replacements: Record<string, string> = { float: "double", sqrtf: "sqrt", sinf: "sin", cosf: "cos", atan2f: "atan2", fabsf: "fabs", floorf: "floor", ceilf: "ceil", FLT_MAX: "DBL_MAX", FLT_EPSILON: "DBL_TRUE_MIN" };
// 仅变换 C++ 词法单元, 保留字符串, 注释和上游源码原件.
const tokens = /\/\*[\s\S]*?\*\/|\/\/[^\r\n]*|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|0[xX][\da-fA-F]+[uUlL]*|(?:\d+\.\d*|\.\d+|\d+)(?:[eE][+-]?\d+)?[fFlL]?|[A-Za-z_]\w*|[\s\S]/g;
let count = 0;
for await (const path of new Bun.Glob("**/*.{h,cpp}").scan(source)) {
  const original = await readFile(join(source, path), "utf8");
  let transformed = original.replace(tokens, (token) => {
    if (replacements[token]) return replacements[token];
    if (token === "3.14159265359f") return "3.1415926535897932384626433832795";
    if (/^(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?[fF]$/.test(token)) return token.slice(0, -1);
    return token;
  });
  if (path === "Common/b2Math.h") {
    const start = transformed.indexOf("inline float32 b2InvSqrt(float32 x)");
    const end = transformed.indexOf("#define", start);
    if (start < 0 || end < 0) throw new Error("旧版逆平方根函数边界不匹配");
    transformed = transformed.slice(0, start) + "inline float32 b2InvSqrt(float32 x)\n{\n\treturn 1.0 / sqrt(x);\n}\n\n" + transformed.slice(end);
  }
  if (path === "Common/b2Settings.h") {
    transformed = transformed.replace(/(#define b2_maxTranslation\s+)\([^\n]+/, "$1(8.0)");
    transformed = transformed.replace(/(#define b2_velocityThreshold\s+)\([^\n]+/, "$1(0.0)");
  }
  const destination = join(target, path);
  await mkdir(dirname(destination), { recursive: true });
  await Bun.write(destination, transformed);
  count++;
}
log.info({ files: count }, "旧版 Box2D 双精度构建副本已生成, 等待与 Box2DWeb 对照");
