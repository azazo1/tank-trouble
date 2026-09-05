import { parse } from "acorn";
import { classDefinition } from "./compiler";

export async function phaserCore() {
  const source = await Bun.file("vendor/original/js/phaser/phaser.min.js").text();
  const assignments = new Map<string, any>();
  const objects = new Map<string, any>();
  const visit = (node: any) => {
    if (!node || typeof node !== "object") return;
    if (node.type === "AssignmentExpression") {
      const name = source.slice(node.left.start, node.left.end);
      assignments.set(name, node.right);
      if (node.right.type === "ObjectExpression") objects.set(name, node.right);
    }
    for (const value of Object.values(node)) if (Array.isArray(value)) value.forEach(visit); else if (value && typeof value === "object") visit(value);
  };
  visit(parse(source, { ecmaVersion: "latest" }));
  const extract = (name: string, original: string, base: string | null, methods: string[], constructor = true) => {
    const statements: string[] = [];
    const init = assignments.get(original);
    statements.push(`${name}=${constructor ? source.slice(init.start, init.end) : "function(){}"};`);
    if (base) statements.push(`${name}.prototype=Object.create(${base}.prototype);`);
    for (const method of methods) {
      const value = assignments.get(`${original}.prototype.${method}`) ?? objects.get(`${original}.prototype`)?.properties.find((p: any) => p.key.name === method)?.value;
      if (!value) throw new Error(`缺少 Phaser 原方法: ${original}.${method}`);
      statements.push(`${name}.prototype.${method}=${source.slice(value.start, value.end)};`);
    }
    return classDefinition(statements.join("\n"));
  };
  const emitter = extract("PhaserEmitter", "X.Particles.Arcade.Emitter", "X.Group", ["update", "makeParticles", "explode", "start", "emitParticle", "resetParticle", "getNextParticle", "setRotation", "setAlpha"]);
  emitter.base = "PhaserEmitterBase";
  const random = extract("PhaserRandom", "X.RandomDataGenerator", null, ["sow", "hash", "rnd", "frac", "integer", "integerInRange", "realInRange", "between", "pick"]);
  return [emitter, random];
}
