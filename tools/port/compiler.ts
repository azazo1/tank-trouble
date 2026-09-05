import { parse } from "acorn";

type Node = any;
type Scope = { id: number; names: Set<string>; parent?: Scope };

export interface PortClass {
  name: string;
  reference?: string;
  base?: string;
  fields: Node[];
  staticFields: Node[];
  methods: Node[];
  staticMethods: Node[];
  constructors: { name: string; fn: Node }[];
  trailing: Node[];
}

function referenceName(node: Node): string | undefined {
  if (node?.type === "Identifier") return node.name;
  if (node?.type === "MemberExpression" && !node.computed) {
    const parent = referenceName(node.object);
    if (parent) return `${parent}.${node.property.name}`;
  }
}

export function classDefinition(source: string): PortClass {
  const ast = parse(source, { ecmaVersion: "latest" }) as Node;
  const definition: PortClass = { name: "", fields: [], staticFields: [], methods: [], staticMethods: [], constructors: [], trailing: [] };
  for (const node of ast.body) {
    const items = node.type === "VariableDeclaration" ? node.declarations : node.type === "ExpressionStatement" && node.expression.type === "AssignmentExpression" ? [{ id: node.expression.left, init: node.expression.right }] : [];
    for (const item of items) {
      let init = item.init;
      while (init?.type === "CallExpression" && init.callee?.property?.name === "name") init = init.callee.object;
      if (init?.type !== "CallExpression" || !["newClass", "subclass"].includes(init.callee?.property?.name)) continue;
      definition.reference = referenceName(item.id);
      definition.name = definition.reference!.split(".").at(-1)!;
      if (init.callee.property.name === "subclass") definition.base = referenceName(init.callee.object);
    }
  }
  if (!definition.name) {
    for (const node of ast.body) {
      const expr = node.expression;
      if (expr?.type === "AssignmentExpression" && expr.left.type === "Identifier" && expr.right.type === "FunctionExpression") {
        definition.name = definition.reference = expr.left.name;
        definition.constructors.push({ name: "create", fn: expr.right });
        break;
      }
    }
  }
  if (!definition.name) throw new Error("没有找到原版类定义");
  for (const node of ast.body) {
    if (node.type !== "ExpressionStatement") continue;
    const expr = node.expression;
    if (expr.type === "CallExpression" && referenceName(expr.callee.object) === definition.reference) {
      const method = expr.callee.property.name;
      const targets = new Map<string, Node[]>([["fields", definition.fields], ["classFields", definition.staticFields], ["methods", definition.methods], ["classMethods", definition.staticMethods]]);
      const target = targets.get(method);
      if (target) target.push(...expr.arguments[0].properties);
      else if (method === "constructor") definition.constructors.push({ name: expr.arguments.length === 1 ? "create" : expr.arguments[0].value, fn: expr.arguments.at(-1) });
      else throw new Error(`不支持的 Classy 声明: ${method}`);
    } else if (expr.type === "AssignmentExpression" && referenceName(expr.left.object) === `${definition.reference}.prototype`) {
      if (expr.left.property.name !== "constructor") definition.methods.push({ key: expr.left.property, value: expr.right });
    } else if (expr.type === "AssignmentExpression" && referenceName(expr.left) === `${definition.reference}.prototype`) {
      const prototype = expr.right.arguments?.[0];
      if (prototype?.property?.name === "prototype") definition.base = referenceName(prototype.object);
    } else if (expr.type === "AssignmentExpression" && referenceName(expr.left.object) === definition.reference) {
      const property = { key: expr.left.property, value: expr.right };
      if (expr.right.type === "FunctionExpression") definition.staticMethods.push(property);
      else definition.staticFields.push(property);
    }
  }
  for (const key of ["fields", "staticFields", "methods", "staticMethods"] as const) {
    definition[key] = [...new Map(definition[key].map((property) => [property.key.name ?? String(property.key.value), property])).values()];
  }
  return definition;
}

export class Compiler {
  private scopeId = 0;
  private tempId = 0;
  private scope: Scope | undefined;
  private loops: (Node | null)[] = [];
  private staticContext = false;
  private initializingStatic = false;
  private methodName = "_construct_create";
  private implicitGlobals = new Set<string>();
  private lines: string[] = [];
  private indentation = 0;

  constructor(private readonly definition: PortClass, private readonly modules: Record<string, string>, private readonly arities: Record<string, number> = {}) {}

  private parameters(name: string, count: number): string[] {
    const arity = name === "create" || name === "_construct_create" ? 16 : Math.max(count, this.arities[name] ?? 0);
    return Array.from({ length: arity }, (_, i) => `_arg${i}`);
  }

  compile(): string {
    const d = this.definition;
    const base = d.base ? this.modules[d.base] : "res://game/runtime/original_object.gd";
    if (!base) throw new Error(`缺少父类: ${d.base}`);
    this.line(`# 由原版 ${d.name} 的 AST 转译, 请修改转译器或单独维护的适配模块.`);
    this.line(`extends ${JSON.stringify(base)}`);
    if (!d.base) this.line("const JS = preload(\"res://game/runtime/js_support.gd\")");
    this.line("");
    for (const property of d.fields) this.line(`var ${this.key(property)} = ${this.expr(property.value)}`);
    const staticField = `_static_${d.name}`;
    this.line(`static var ${staticField}: Dictionary = {}`);
    this.line(`static var _initialized_${d.name} = false`);
    this.line("static func initialize_original_static():");
    this.indentation++;
    this.line(`if _initialized_${d.name}: return`);
    this.line(`_initialized_${d.name} = true`);
    this.staticContext = true;
    this.initializingStatic = true;
    for (const property of d.staticFields) this.line(`${staticField}[${JSON.stringify(this.key(property))}] = ${this.expr(property.value)}`);
    this.initializingStatic = false;
    if (!d.staticFields.length) this.line("pass");
    this.indentation--;
    this.line("static func original_static_get(key):");
    this.indentation++;
    this.line("initialize_original_static()");
    this.line(`if ${staticField}.has(key): return ${staticField}[key]`);
    if (d.base) this.line(`return JS.get_property(JS.module(${JSON.stringify(d.base)}), key)`);
    else this.line("return null");
    this.indentation--;
    this.line("static func original_static_set(key, value):");
    this.indentation++;
    this.line(`${staticField}[key] = value`);
    this.line("return value");
    this.indentation--;
    this.line("func original_own_fields():");
    this.indentation++;
    this.line(`return ${JSON.stringify(d.fields.map((p) => this.key(p)))}`);
    this.indentation--;
    const weakFields = d.fields.map((p) => this.key(p)).filter((key) => ["roundModel", "evtContext", "gameController"].includes(key) || d.name === "GameMode" && key === "roundController");
    if (weakFields.length) {
      this.line("func original_is_weak_field(key):");
      this.indentation++;
      this.line(`return ${JSON.stringify(weakFields)}.has(key) or super.original_is_weak_field(key)`);
      this.indentation--;
    }

    for (const item of d.constructors) {
      this.method(`_construct_${item.name}`, item.fn, false);
      this.line(`static func ${item.name}(${this.parameters(item.name, item.fn.params.length).map((name) => `${name} = null`).join(", ")}):`);
      this.indentation++;
      this.line(`var instance = load(${JSON.stringify(this.modules[d.name])}).new()`);
      this.line(`instance._construct_${item.name}(${item.fn.params.map((_: Node, i: number) => `_arg${i}`).join(", ")})`);
      this.line("return instance");
      this.indentation--;
    }
    if (!d.constructors.length) {
      const parameters = this.parameters("create", 0);
      this.line(`static func create(${parameters.map((name) => `${name} = null`).join(", ")}):`);
      this.indentation++;
      this.line(`var instance = load(${JSON.stringify(this.modules[d.name])}).new()`);
      this.line(`JS.invoke_method(instance, "_construct_create", [${parameters.join(", ")}])`);
      this.line("return instance");
      this.indentation--;
    }
    for (const property of d.methods) this.method(this.key(property), property.value, false);
    for (const property of d.staticMethods) this.method(this.key(property), property.value, true);
    return this.lines.join("\n") + "\n";
  }

  private key(property: Node): string { return property.key.name ?? String(property.key.value); }
  private line(text: string) { this.lines.push("\t".repeat(this.indentation) + text); }
  private localScope(fn: Node): Scope {
    const names = new Set<string>(fn.params.map((p: Node) => p.name));
    const visit = (n: Node) => {
      if (!n || typeof n !== "object") return;
      if (n !== fn && ["FunctionExpression", "FunctionDeclaration", "ArrowFunctionExpression"].includes(n.type)) return;
      if (n.type === "VariableDeclarator") names.add(n.id.name);
      for (const value of Object.values(n)) if (Array.isArray(value)) value.forEach(visit); else if (typeof value === "object") visit(value);
    };
    visit(fn.body);
    return { id: this.scopeId++, names, parent: this.scope };
  }
  private variable(name: string): string {
    for (let scope = this.scope; scope; scope = scope.parent) if (scope.names.has(name)) return `_scope${scope.id}[${JSON.stringify(name)}]`;
    if (name === "undefined") return "null";
    if (name === "Infinity") return "INF";
    if (name === "NaN") return "NAN";
    if (this.modules[name]) return `JS.module(${JSON.stringify(name)})`;
    if (this.implicitGlobals.has(name)) return `JS.get_property(JS.global_fields, ${JSON.stringify(name)})`;
    if (["Math", "Object", "Array", "Set", "JSON", "Number", "Date", "console"].includes(name)) return JSON.stringify(`@${name}`);
    throw new Error(`未绑定标识符: ${name}`);
  }
  private method(name: string, fn: Node, isStatic: boolean) {
    const oldScope = this.scope;
    const oldStatic = this.staticContext;
    const oldMethod = this.methodName;
    this.methodName = name;
    this.scope = this.localScope(fn);
    this.staticContext = isStatic;
    this.line("");
    this.line(`${isStatic ? "static " : ""}func ${name.startsWith("_construct_") ? name : `original_${name}`}(${this.parameters(name, fn.params.length).map((parameter) => `${parameter} = null`).join(", ")}):`);
    this.indentation++;
    this.initializeScope(fn);
    this.statements(fn.body.body);
    this.line("return null");
    this.indentation--;
    this.scope = oldScope;
    this.staticContext = oldStatic;
    this.methodName = oldMethod;
  }
  private initializeScope(fn: Node) {
    const values = [...this.scope!.names].map((name) => {
      const index = fn.params.findIndex((p: Node) => p.name === name);
      return `${JSON.stringify(name)}: ${index < 0 ? "null" : `_arg${index}`}`;
    });
    this.line(`var _scope${this.scope!.id}: Dictionary = {${values.join(", ")}}`);
  }
  private statements(nodes: Node[]) { for (const node of nodes) this.statement(node); }
  private block(node: Node) {
    this.indentation++;
    const before = this.lines.length;
    if (node.type === "BlockStatement") this.statements(node.body); else this.statement(node);
    if (this.lines.length === before) this.line("pass");
    this.indentation--;
  }
  private statement(n: Node) {
    switch (n.type) {
      case "BlockStatement": this.statements(n.body); break;
      case "EmptyStatement": break;
      case "VariableDeclaration": for (const v of n.declarations) if (v.init) this.line(`${this.variable(v.id.name)} = ${this.expr(v.init)}`); break;
      case "ExpressionStatement": this.line(this.expr(n.expression)); break;
      case "ReturnStatement": this.line(`return ${n.argument ? this.expr(n.argument) : "null"}`); break;
      case "IfStatement":
        this.line(`if JS.truthy(${this.expr(n.test)}):`); this.block(n.consequent);
        if (n.alternate) { this.line("else:"); this.block(n.alternate); } break;
      case "WhileStatement": this.line(`while JS.truthy(${this.expr(n.test)}):`); this.loops.push(null); this.block(n.body); this.loops.pop(); break;
      case "ForStatement":
        if (n.init) n.init.type === "VariableDeclaration" ? this.statement(n.init) : this.line(this.expr(n.init));
        this.line(`while ${n.test ? `JS.truthy(${this.expr(n.test)})` : "true"}:`);
        this.loops.push(n.update);
        this.indentation++;
        this.statement(n.body);
        if (n.update) this.line(this.expr(n.update));
        this.indentation--;
        this.loops.pop(); break;
      case "ForInStatement": {
        const key = `_iteration${this.tempId++}`;
        this.line(`for ${key} in JS.keys(${this.expr(n.right)}):`);
        this.indentation++;
        const left = n.left.type === "VariableDeclaration" ? n.left.declarations[0].id : n.left;
        this.line(this.assignment(left, key));
        this.loops.push(null); this.statement(n.body); this.loops.pop();
        this.indentation--; break;
      }
      case "BreakStatement": if (n.label) throw new Error("不支持带标签的 break"); this.line("break"); break;
      case "ContinueStatement": if (n.label) throw new Error("不支持带标签的 continue"); if (this.loops.at(-1)) this.line(this.expr(this.loops.at(-1))); this.line("continue"); break;
      case "SwitchStatement": {
        const value = `_switch${this.tempId++}`;
        const start = value + "_start";
        this.line(`var ${value} = ${this.expr(n.discriminant)}`);
        this.line(`var ${start} = ${n.cases.findIndex((c: Node) => c.test === null)}`);
        let first = true;
        for (const [index, branch] of n.cases.entries()) {
          if (!branch.test) continue;
          this.line(`${first ? "if" : "elif"} JS.equal(${value}, ${this.expr(branch.test)}, true): ${start} = ${index}`);
          first = false;
        }
        this.line("while true:");
        this.indentation++;
        for (const [index, branch] of n.cases.entries()) {
          if (!branch.consequent.length) continue;
          this.line(`if ${start} >= 0 and ${start} <= ${index}:`);
          this.indentation++;
          this.statements(branch.consequent);
          this.indentation--;
        }
        this.line("break");
        this.indentation--;
        break;
      }
      case "ThrowStatement": this.line(`push_error(str(${this.expr(n.argument)}))`); this.line("return null"); break;
      case "TryStatement":
        if (this.definition.name !== "RoundModel" || n.finalizer || n.handler?.param?.name !== "err") throw new Error("异常边界需要显式移植");
        this.line("# 事件回调中的 GDScript 错误由引擎报告, 调用方继续派发后续监听器.");
        this.statement(n.block);
        break;
      default: throw new Error(`不支持的语句: ${n.type}`);
    }
  }
  private assignment(target: Node, value: string): string {
    if (target.type === "Identifier") {
      let scope = this.scope;
      while (scope && !scope.names.has(target.name)) scope = scope.parent;
      if (!scope) {
        this.implicitGlobals.add(target.name);
        return `JS.set_property(JS.global_fields, ${JSON.stringify(target.name)}, ${value})`;
      }
      return `JS.set_property(_scope${scope.id}, ${JSON.stringify(target.name)}, ${value})`;
    }
    if (target.type === "MemberExpression") return `JS.set_property(${this.expr(target.object)}, ${this.property(target)}, ${value})`;
    throw new Error(`不支持的赋值目标: ${target.type}`);
  }
  private property(n: Node) { return n.computed ? this.expr(n.property) : JSON.stringify(n.property.name); }
  private expr(n: Node): string {
    switch (n.type) {
      case "Literal":
        if (n.regex) throw new Error("不支持正则表达式");
        if (n.value === null) return "null";
        if (typeof n.value === "boolean") return String(n.value);
        return JSON.stringify(n.value);
      case "Identifier": return this.variable(n.name);
      case "ThisExpression": return this.staticContext ? `JS.module(${JSON.stringify(this.definition.name)})` : "self";
      case "ArrayExpression": return `[${n.elements.map((v: Node) => v ? this.expr(v) : "null").join(", ")}]`;
      case "ObjectExpression": return `{${n.properties.map((p: Node) => `${JSON.stringify(this.key(p))}: ${this.key(p) === "ctxt" ? `JS.weak(${this.expr(p.value)})` : this.expr(p.value)}`).join(", ")}}`;
      case "MemberExpression":
        if (this.modules[referenceName(n) ?? ""]) return `JS.module(${JSON.stringify(referenceName(n))})`;
        if (this.initializingStatic && n.object.type === "Identifier" && n.object.name === this.definition.name) return `JS.get_property(_static_${this.definition.name}, ${this.property(n)})`;
        return `JS.get_property(${this.expr(n.object)}, ${this.property(n)})`;
      case "CallExpression": {
        const args = n.arguments.map((a: Node) => this.expr(a)).join(", ");
        if (n.callee.property?.name === "call" && n.arguments[0]?.type === "ThisExpression") {
          const called = referenceName(n.callee.object);
          const parent = this.definition.base;
          if (parent && (called === parent || called?.startsWith(parent + ".prototype."))) {
            const method = called === parent ? "_construct_create" : `original_${called!.slice(parent.length + 11)}`;
            return `super.${method}(${n.arguments.slice(1).map((a: Node) => this.expr(a)).join(", ")})`;
          }
        }
        if (n.callee.type === "MemberExpression" && n.callee.object.type === "ThisExpression" && n.callee.property.name === "_super") return `super.${this.methodName.startsWith("_construct_") ? this.methodName : `original_${this.methodName}`}(${args})`;
        if (this.initializingStatic && n.callee.type === "MemberExpression" && n.callee.object.name === this.definition.name && n.callee.property.name === "create") return `create(${args})`;
        if (n.callee.type === "MemberExpression") return `JS.invoke_method(${this.expr(n.callee.object)}, ${this.property(n.callee)}, [${args}])`;
        if (n.callee.type === "Identifier" && ["parseInt", "parseFloat", "isNaN"].includes(n.callee.name)) return `JS.global_call(${JSON.stringify(n.callee.name)}, [${args}])`;
        return `JS.invoke(${this.expr(n.callee)}, [${args}])`;
      }
      case "NewExpression": return `JS.construct(${this.expr(n.callee)}, [${n.arguments.map((a: Node) => this.expr(a)).join(", ")}])`;
      case "UnaryExpression": {
        const e = this.expr(n.argument);
        if (n.operator === "!") return `(not JS.truthy(${e}))`;
        if (n.operator === "typeof") return `JS.type_of(${e})`;
        if (n.operator === "delete" && n.argument.type === "MemberExpression") return `JS.delete_property(${this.expr(n.argument.object)}, ${this.property(n.argument)})`;
        if (n.operator === "void") return "null";
        if (["-", "+", "~"].includes(n.operator)) return `${n.operator}(${e})`;
        throw new Error(`不支持的一元运算: ${n.operator}`);
      }
      case "BinaryExpression": {
        const a = this.expr(n.left), b = this.expr(n.right);
        if (n.operator === "+") return `JS.add(${a}, ${b})`;
        if (["-", "*", "/"].includes(n.operator)) return `(JS.number(${a}) ${n.operator} JS.number(${b}))`;
        if (n.operator === "%") return `fmod(${a}, ${b})`;
        if (["==", "===", "!=", "!=="].includes(n.operator)) return `${n.operator.startsWith("!") ? "not " : ""}JS.equal(${a}, ${b}, ${n.operator.length === 3})`;
        if (n.operator === "in") return `JS.has_property(${b}, ${a})`;
        if (n.operator === "instanceof") return `JS.instance_of(${a}, ${b})`;
        if (["<<", ">>", ">>>", "|", "&", "^"].includes(n.operator)) return `JS.bitwise(${JSON.stringify(n.operator)}, ${a}, ${b})`;
        if (["<", "<=", ">", ">="].includes(n.operator)) return `JS.compare(${JSON.stringify(n.operator)}, ${a}, ${b})`;
        return `(${a} ${n.operator} ${b})`;
      }
      case "LogicalExpression": {
        const thunk = (value: Node) => this.expr({ type: "FunctionExpression", params: [], body: { type: "BlockStatement", body: [{ type: "ReturnStatement", argument: value }] } });
        return `JS.logical(${JSON.stringify(n.operator)}, ${thunk(n.left)}, ${thunk(n.right)})`;
      }
      case "ConditionalExpression": return `(${this.expr(n.consequent)} if JS.truthy(${this.expr(n.test)}) else ${this.expr(n.alternate)})`;
      case "SequenceExpression": return `JS.sequence([${n.expressions.map((value: Node) => this.expr(value)).join(", ")}])`;
      case "AssignmentExpression": {
        let value = this.expr(n.right);
        if (n.operator !== "=") value = this.expr({ type: "BinaryExpression", operator: n.operator.slice(0, -1), left: n.left, right: n.right });
        return this.assignment(n.left, value);
      }
      case "UpdateExpression": {
        const a = n.argument;
        if (a.type === "Identifier") {
          let s = this.scope;
          while (s && !s.names.has(a.name)) s = s.parent;
          if (!s) throw new Error(`更新未绑定变量: ${a.name}`);
          return `JS.increment(_scope${s.id}, ${JSON.stringify(a.name)}, ${n.operator === "++" ? 1 : -1}, ${!n.prefix})`;
        }
        return `JS.increment(${this.expr(a.object)}, ${this.property(a)}, ${n.operator === "++" ? 1 : -1}, ${!n.prefix})`;
      }
      case "FunctionExpression": {
        const savedLines = this.lines;
        const savedScope = this.scope;
        const savedIndent = this.indentation;
        this.lines = [];
        this.scope = this.localScope(n);
        this.line(`func(${n.params.map((_: Node, i: number) => `_arg${i} = null`).join(", ")}):`);
        this.indentation++;
        this.initializeScope(n); this.statements(n.body.body); this.line("return null");
        const result = this.lines.join("\n").trimStart();
        this.lines = savedLines;
        this.scope = savedScope;
        this.indentation = savedIndent;
        return result;
      }
      default: throw new Error(`不支持的表达式: ${n.type}`);
    }
  }
}
