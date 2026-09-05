import { readFileSync } from "node:fs";
import { join } from "node:path";
import vm from "node:vm";
import { log } from "../shared/log";

export class OriginalRuntime {
  private readonly modules = new Map<string, { exports: any }>();
  private readonly context: vm.Context;
  private timestamp = Date.UTC(2026, 8, 5, 12);
  private randomState: number;
  readonly randomTape: number[] = [];

  constructor(seed = 1) {
    this.randomState = seed >>> 0;
    const runtime = this;
    class Clock extends Date {
      constructor(...args: any[]) {
        if (args.length) super(args[0]);
        else super(runtime.timestamp);
      }
      static now() { return runtime.timestamp; }
    }
    const math = Object.create(Math);
    math.random = () => {
      this.randomState = (Math.imul(this.randomState, 1664525) + 1013904223) >>> 0;
      const value = this.randomState / 4294967296;
      this.randomTape.push(value);
      return value;
    };
    this.context = vm.createContext({ Date: Clock, Math: math });
    this.modules.set("log", { exports: { create: (target: string) => ({
      debug: (message: string) => log.debug({ target }, message),
      warn: (message: string) => log.warn({ target }, message),
      error: (message: string) => log.error({ target }, message),
    }) } });
  }

  advance(milliseconds: number) { this.timestamp += milliseconds; }

  load(name: string): any {
    name = name.replace(/^\.\//, "");
    const cached = this.modules.get(name);
    if (cached) return cached.exports;
    const paths: Record<string, string> = {
      classy: "classy/classy.js",
      box2d: "box2d/Box2dWeb-2.1.0-b.min.js",
      jkstra: "jkstra/jkstra.js",
    };
    if (!/^[a-z0-9]+$/.test(name)) throw new Error(`原版模块名不合法: ${name}`);
    const path = paths[name] ?? `tt/${name}.js`;
    const source = readFileSync(join(import.meta.dir, "../../vendor/original/js", path), "utf8");
    const module = { exports: {} as any };
    this.modules.set(name, module);
    const exportGlobal = name === "box2d" ? "\nmodule.exports = Box2D;" : "";
    const factory = new vm.Script(`(function(module, exports, require) {\n${source}${exportGlobal}\n})`, { filename: path }).runInContext(this.context);
    factory(module, module.exports, (dependency: string) => this.load(dependency));
    return module.exports;
  }
}
