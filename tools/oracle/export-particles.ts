import { parse } from "acorn";
import { createContext, runInContext } from "node:vm";
import { log } from "../shared/log";

const source = await Bun.file("vendor/original/js/phaser/phaser.min.js").text();
const assignments: string[] = [];
const visit = (node: any) => {
  if (!node || typeof node !== "object") return;
  if (node.type === "AssignmentExpression" && source.slice(node.left.start, node.left.end).startsWith("X.RandomDataGenerator")) assignments.push(source.slice(node.start, node.end));
  for (const value of Object.values(node)) if (Array.isArray(value)) value.forEach(visit); else if (value && typeof value === "object") visit(value);
};
visit(parse(source, { ecmaVersion: "latest" }));
const context = createContext({ X: {} });
runInContext(assignments.join(";"), context);
const seed = "coordinate-test";
const random = runInContext(`new X.RandomDataGenerator([${JSON.stringify(seed)}])`, context);
const samples = Array.from({ length: 32 }, () => random.frac());
await Bun.write("tests/fixtures/particles.json", JSON.stringify({ seed, samples }, null, 2) + "\n");
log.info({ samples: samples.length }, "原版粒子随机序列生成完成");
