import { parse } from "acorn";
import { mkdir } from "node:fs/promises";
import { join } from "node:path";
import { log } from "../shared/log";
import { parseArgs } from "node:util";

type Node = any;
type Scope = { id: number; node: Node; parent?: Scope; names: Map<string, number>; declarations: Node[] };
const root = join(import.meta.dir, "../..");
const { values } = parseArgs({ args: Bun.argv.slice(2), options: { module: { type: "string", default: "box2d" } } });
const prefix = values.module!;
if (!["box2d", "spine", "p2"].includes(prefix)) throw new Error(`未知原生模块: ${prefix}`);
const sourcePath = prefix === "box2d" ? "vendor/original/js/box2d/Box2dWeb-2.1.0-b.min.js" : prefix === "spine" ? "vendor/original/js/phaserplugins/phaser-spine.js" : "vendor/original/js/phaser/phaser.min.js";
const source = await Bun.file(join(root, sourcePath)).text();
const ast = parse(source, { ecmaVersion: "latest" }) as Node;
const omitted: { start: number; end: number; reason: string }[] = [];
if (prefix === "p2") {
  const factory = ast.body[0].expression.expressions[0].argument.arguments[0];
  ast.body = [{ type: "VariableDeclaration", kind: "var", declarations: [{ type: "VariableDeclarator", id: { type: "Identifier", name: "p2" }, init: { type: "CallExpression", callee: factory, arguments: [] } }] }];
  omitted.push({ start: factory.end, end: source.length, reason: "仅移植 P2, Phaser 与 PIXI 绘制由 Godot 提供" });
}
if (prefix === "spine") {
  ast.body = ast.body.filter((node: Node) => {
    const fn = node.expression?.callee;
    const firstName = fn?.body?.body?.[0]?.declarations?.[0]?.id?.name;
    const browserModule = ["AssetManager", "Assets", "webgl"].includes(firstName);
    const phaserAdapter = node.start >= 183866;
    if (browserModule || phaserAdapter) omitted.push({ start: node.start, end: node.end, reason: "浏览器资源管理或绘制边界由 Godot 提供" });
    return !browserModule && !phaserAdapter;
  });
}
const scopes: Scope[] = [];
const byNode = new Map<Node, Scope>();
function scopeFor(node: Node, parent?: Scope): Scope {
  const scope: Scope = { id: scopes.length, node, parent, names: new Map(), declarations: [] };
  scopes.push(scope);
  byNode.set(node, scope);
  const registerLocal = (name: string) => { if (!scope.names.has(name)) scope.names.set(name, scope.names.size); };
  if (node.type !== "Program") {
    registerLocal("arguments");
    if (node.id) registerLocal(node.id.name);
    for (const parameter of node.params) registerLocal(parameter.name);
  }
  function visit(item: Node) {
    if (!item || typeof item !== "object") return;
    if (["FunctionDeclaration", "FunctionExpression"].includes(item.type)) {
      if (item.type === "FunctionDeclaration") { registerLocal(item.id.name); scope.declarations.push(item); }
      scopeFor(item, scope);
      return;
    }
    if (item.type === "VariableDeclarator") registerLocal(item.id.name);
    for (const value of Object.values(item)) {
      if (Array.isArray(value)) {
        for (const child of value) visit(child);
      } else if (value !== null && typeof value === "object") {
        visit(value);
      }
    }
  }
  visit(node.type === "Program" ? { body: node.body } : node.body);
  return scope;
}
scopeFor(ast);

class Compiler {
  lines: string[] = [];
  private indent = 0;
  private temporary = 0;
  private loops: string[] = [];
  private labels = new Map<string, { end: string; next: string }>();
  private nextLoopLabel: string | undefined;
  constructor(private scope: Scope) {}
  line(value: string) { this.lines.push("    ".repeat(this.indent) + value); }
  block(callback: () => void) { this.line("{"); this.indent++; callback(); this.indent--; this.line("}"); }
  temp(expression: string) { const name = `v${this.temporary++}`; this.line(`Value ${name} = ${expression};`); return name; }
  variable(name: string) {
    let depth = 0;
    for (let scope: Scope | undefined = this.scope; scope; scope = scope.parent, depth++) if (scope.names.has(name)) return `env->ancestor(${depth})->slots[${scope.names.get(name)}]`;
    if (name === "undefined") return "Value()";
    if (name === "Infinity") return "Value(INFINITY)";
    if (name === "NaN") return "Value(NAN)";
    if (prefix === "p2" && ["P2_ARRAY_TYPE", "require"].includes(name)) return "Value()";
    if (!["Array", "Math", "Number", "Object", "Function", "Error", "parseInt", "parseFloat", "isFinite", "isNaN", "Float32Array", "Int16Array", "Int32Array", "Uint16Array", "Uint32Array", "Phaser", "JSON", "Date", "console", "require", "performance"].includes(name)) throw new Error(`${prefix} 未绑定标识符: ${name}, 函数 ${this.scope.id}, 局部变量 ${[...this.scope.names.keys()].join(", ")}`);
    return `r.global(${JSON.stringify(name)})`;
  }
  reference(node: Node): { read: () => string; write: (value: string) => string; remove: () => string } {
    if (node.type === "Identifier") {
      const target = this.variable(node.name);
      return { read: () => this.temp(target), write: (value) => { this.line(`${target} = ${value};`); return value; }, remove: () => "Value(false)" };
    }
    if (node.type !== "MemberExpression") throw new Error(`无法赋值: ${node.type}`);
    const object = this.expression(node.object);
    const key = node.computed ? this.expression(node.property) : `Value(${JSON.stringify(node.property.name)})`;
    return { read: () => this.temp(`r.get(${object}, ${key})`), write: (value) => this.temp(`r.set(${object}, ${key}, ${value})`), remove: () => this.temp(`r.erase(${object}, ${key})`) };
  }
  expression(node: Node): string {
    switch (node.type) {
      case "Literal": {
        if (node.regex) return `r.regexp(${JSON.stringify(node.regex.pattern)}, ${JSON.stringify(node.regex.flags)})`;
        if (node.value === null) return "Value::null()";
        if (typeof node.value === "number") return `Value(${/[.eE]/.test(String(node.value)) ? node.value : `${node.value}.0`})`;
        return `Value(${JSON.stringify(node.value)})`;
      }
      case "Identifier": return this.temp(this.variable(node.name));
      case "ThisExpression": return "self";
      case "MemberExpression": return this.reference(node).read();
      case "FunctionExpression": return this.temp(`r.function(${prefix}_function(${byNode.get(node)!.id}), env)`);
      case "ArrayExpression": {
        const elements = node.elements.map((element: Node) => element ? this.expression(element) : "Value()");
        return this.temp(`r.array({${elements.join(", ")}})`);
      }
      case "ObjectExpression": {
        const object = this.temp("r.object()");
        for (const property of node.properties) {
          const value = this.expression(property.value);
          this.line(`r.set(${object}, Value(${JSON.stringify(property.key.name ?? String(property.key.value))}), ${value});`);
        }
        return object;
      }
      case "AssignmentExpression": {
        const reference = this.reference(node.left);
        const old = node.operator === "=" ? undefined : reference.read();
        let value = this.expression(node.right);
        if (old) value = this.temp(`r.binary(${JSON.stringify(node.operator.slice(0, -1))}, ${old}, ${value})`);
        return reference.write(value);
      }
      case "UpdateExpression": {
        const reference = this.reference(node.argument);
        const old = reference.read();
        const value = this.temp(`r.binary(${JSON.stringify(node.operator === "++" ? "+" : "-")}, ${old}, Value(1.0))`);
        reference.write(value);
        return node.prefix ? value : old;
      }
      case "BinaryExpression": {
        const left = this.expression(node.left), right = this.expression(node.right);
        return this.temp(`r.binary(${JSON.stringify(node.operator)}, ${left}, ${right})`);
      }
      case "UnaryExpression": {
        if (node.operator === "delete") return this.reference(node.argument).remove();
        const value = this.expression(node.argument);
        return this.temp(`r.unary(${JSON.stringify(node.operator)}, ${value})`);
      }
      case "LogicalExpression": {
        const first = this.expression(node.left);
        const result = this.temp(first);
        this.line(`if (${node.operator === "||" ? "!" : ""}r.truthy(${first}))`);
        this.block(() => { const value = this.expression(node.right); this.line(`${result} = ${value};`); });
        return result;
      }
      case "ConditionalExpression": {
        const condition = this.expression(node.test), result = this.temp("Value()");
        this.line(`if (r.truthy(${condition}))`);
        this.block(() => { const value = this.expression(node.consequent); this.line(`${result} = ${value};`); });
        this.line("else");
        this.block(() => { const value = this.expression(node.alternate); this.line(`${result} = ${value};`); });
        return result;
      }
      case "SequenceExpression": {
        let result = "Value()";
        for (const expression of node.expressions) result = this.expression(expression);
        return result;
      }
      case "NewExpression": {
        const callable = this.expression(node.callee);
        const args = node.arguments.map((argument: Node) => this.expression(argument));
        return this.temp(`r.construct(${callable}, {${args.join(", ")}})`);
      }
      case "CallExpression": {
        let receiver = "Value()", callable: string;
        if (node.callee.type === "MemberExpression") {
          receiver = this.expression(node.callee.object);
          const key = node.callee.computed ? this.expression(node.callee.property) : `Value(${JSON.stringify(node.callee.property.name)})`;
          callable = this.temp(`r.get(${receiver}, ${key})`);
        } else callable = this.expression(node.callee);
        const args = node.arguments.map((argument: Node) => this.expression(argument));
        return this.temp(`r.invoke(${callable}, ${receiver}, {${args.join(", ")}})`);
      }
      default: throw new Error(`未移植 Box2D 表达式: ${node.type}`);
    }
  }
  statement(node: Node) {
    switch (node.type) {
      case "BlockStatement": this.block(() => node.body.forEach((item: Node) => this.statement(item))); break;
      case "ExpressionStatement": this.expression(node.expression); break;
      case "FunctionDeclaration": break;
      case "VariableDeclaration":
        for (const item of node.declarations) if (item.init) { const value = this.expression(item.init); this.line(`${this.variable(item.id.name)} = ${value};`); }
        break;
      case "ReturnStatement": { const value = node.argument ? this.expression(node.argument) : "Value()"; this.line(`return ${value};`); break; }
      case "ThrowStatement": { const value = this.expression(node.argument); this.line(`throw std::runtime_error(r.text(${value}.kind == Value::OBJECT ? r.get(${value}, "message") : ${value}));`); break; }
      case "IfStatement": {
        const condition = this.expression(node.test);
        this.line(`if (r.truthy(${condition}))`);
        this.block(() => this.statement(node.consequent));
        if (node.alternate) { this.line("else"); this.block(() => this.statement(node.alternate)); }
        break;
      }
      case "ForStatement":
      case "WhileStatement":
      case "DoWhileStatement": {
        const label = this.nextLoopLabel ?? `continue_${this.temporary++}`;
        this.nextLoopLabel = undefined;
        if (node.init) node.init.type === "VariableDeclaration" ? this.statement(node.init) : this.expression(node.init);
        this.loops.push(label);
        this.line("while (true)");
        this.block(() => {
          if (prefix === "spine") this.line(`r.checkpoint(${this.scope.id}, ${node.start});`);
          if (node.type !== "DoWhileStatement" && node.test) { const condition = this.expression(node.test); this.line(`if (!r.truthy(${condition})) break;`); }
          this.block(() => this.statement(node.body));
          this.line(`${label}:;`);
          if (node.update) this.expression(node.update);
          if (node.type === "DoWhileStatement") { const condition = this.expression(node.test); this.line(`if (!r.truthy(${condition})) break;`); }
        });
        this.loops.pop();
        break;
      }
      case "ForInStatement": {
        const object = this.expression(node.right);
        const key = `key${this.temporary++}`;
        this.line(`for (const auto &${key} : r.keys(${object}))`);
        this.block(() => {
          if (prefix === "spine") this.line(`r.checkpoint(${this.scope.id}, ${node.start});`);
          const target = node.left.type === "VariableDeclaration" ? node.left.declarations[0].id : node.left;
          this.reference(target).write(`Value(${key})`);
          const label = `continue_${this.temporary++}`;
          this.loops.push(label);
          this.block(() => this.statement(node.body));
          this.line(`${label}:;`);
          this.loops.pop();
        });
        break;
      }
      case "SwitchStatement": {
        const value = this.expression(node.discriminant), index = `branch${this.temporary++}`;
        const fallback = node.cases.findIndex((item: Node) => item.test == null);
        this.line(`int ${index} = ${fallback};`);
        const tested = node.cases.map((item: Node, i: number) => item.test ? [i, this.expression(item.test)] : null).filter(Boolean);
        tested.forEach((pair: any, i: number) => this.line(`${i ? "else " : ""}if (r.equal(${value}, ${pair[1]}, true)) ${index} = ${pair[0]};`));
        this.line(`switch (${index})`);
        this.block(() => {
          node.cases.forEach((item: Node, i: number) => { this.line(`case ${i}:`); this.block(() => item.consequent.forEach((child: Node) => this.statement(child))); });
          this.line("default: break;");
        });
        break;
      }
      case "LabeledStatement": {
        const name = node.label.name;
        const id = this.temporary++;
        const label = { end: `label_end_${id}`, next: `label_next_${id}` };
        this.labels.set(name, label);
        this.nextLoopLabel = ["ForStatement", "WhileStatement", "DoWhileStatement"].includes(node.body.type) ? label.next : undefined;
        this.block(() => this.statement(node.body));
        this.line(`${label.end}:;`);
        this.labels.delete(name);
        break;
      }
      case "BreakStatement": this.line(node.label ? `goto ${this.labels.get(node.label.name)!.end};` : "break;"); break;
      case "ContinueStatement": this.line(`goto ${node.label ? this.labels.get(node.label.name)!.next : this.loops.at(-1)};`); break;
      case "EmptyStatement": break;
      default: throw new Error(`未移植 Box2D 语句: ${node.type}`);
    }
  }
  compile() {
    const { node, id, names } = this.scope;
    this.line(`// 原版 AST 字节区间: ${node.start}-${node.end}.`);
    this.line(`Value ${prefix}_${id}(Runtime &r, Value self, const Arguments &arguments, Environment *parent, Value callee)`);
    this.block(() => {
      this.line(`auto env = r.environment(parent, ${names.size});`);
      if (node.type !== "Program") {
        this.line(`${this.variable("arguments")} = r.array(arguments);`);
        if (node.id) this.line(`${this.variable(node.id.name)} = callee;`);
        node.params.forEach((parameter: Node, i: number) => this.line(`${this.variable(parameter.name)} = arguments.size() > ${i} ? arguments[${i}] : Value();`));
      }
      for (const declaration of this.scope.declarations) this.line(`${this.variable(declaration.id.name)} = r.function(${prefix}_function(${byNode.get(declaration)!.id}), env);`);
      const body = node.type === "Program" ? node.body : node.body.body;
      body.forEach((statement: Node) => this.statement(statement));
      this.line(`return ${node.type === "Program" ? this.variable(prefix === "box2d" ? "Box2D" : prefix) : "Value()"};`);
    });
    return this.lines.join("\n");
  }
}

const target = join(root, `build/original-${prefix}`);
await mkdir(target, { recursive: true });
async function output(path: string, content: string) {
  const file = Bun.file(path);
  if (await file.exists() && await file.text() === content) return;
  await Bun.write(path, content);
}
const common = `#include "value.h"\n#include <cmath>\n#include <stdexcept>\nnamespace original {\nFunction ${prefix}_function(size_t index);\n`;
for (let start = 0; start < scopes.length; start += 32) {
  const functions = scopes.slice(start, start + 32).map((scope) => new Compiler(scope).compile());
  await output(join(target, `${prefix}-${start}.cpp`), common + functions.join("\n\n") + "\n}\n");
  log.info({ module: prefix, compiled: Math.min(start + 32, scopes.length), total: scopes.length }, "原函数已转译为 C++");
}
const declarations = scopes.map(({ id }) => `Value ${prefix}_${id}(Runtime &, Value, const Arguments &, Environment *, Value);`).join("\n");
const table = `Function ${prefix}_function(size_t index) { static Function functions[] = {${scopes.map(({ id }) => `${prefix}_${id}`).join(", ")}}; return functions[index]; }`;
await output(join(target, `${prefix}-index.cpp`), common + declarations + "\n" + table + `\nint ${prefix}_function_id(Function function) { for (int i = 0; i < ${scopes.length}; ++i) if (${prefix}_function(i) == function) return i; return -1; }` + `\nValue initialize_${prefix}(Runtime &runtime) { for (int i = 0; i < ${scopes.length}; ++i) runtime.function_names[${prefix}_function(i)] = "${prefix}:" + std::to_string(i); return ${prefix}_0(runtime, Value(), {}, nullptr, Value()); }\n}\n`);
await output(join(target, "source-map.json"), JSON.stringify({ source: sourcePath, omitted, functions: scopes.map(({ id, node }) => ({ id, start: node.start, end: node.end })) }, null, 2) + "\n");
