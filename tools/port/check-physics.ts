import { mkdir } from "node:fs/promises";
import { join } from "node:path";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
await mkdir(join(root, ".tmp"), { recursive: true });
const child = Bun.spawn(["godot", "--headless", "--path", root, "--script", "tests/godot/physics_port.gd"], { stdout: "pipe", stderr: "pipe" });
const timer = setTimeout(() => child.kill(), 30000);
const [stdout, stderr, code] = await Promise.all([new Response(child.stdout).text(), new Response(child.stderr).text(), child.exited]);
clearTimeout(timer);
if (code !== 0 || stderr.includes("ERROR:")) throw new Error(`Godot 物理对照执行失败 (${code}):\n${stdout}\n${stderr.slice(0, 10000)}`);
let failures = 0;
for await (const path of new Bun.Glob("physics-*.json").scan(join(root, "tests/fixtures"))) {
  const expected = await Bun.file(join(root, "tests/fixtures", path)).json();
  const actual = await Bun.file(join(root, `.tmp/physics-${expected.name}.actual.json`)).json();
  let maxError = 0;
  let firstDifference: any = null;
  for (let frame = 0; frame < expected.frames.length; frame++) {
    for (let body = 0; body < expected.frames[frame].length; body++) {
      for (const key of Object.keys(expected.frames[frame][body])) {
        const a = expected.frames[frame][body][key], b = actual.frames[frame][body][key];
        const error = Math.abs(a - b);
        maxError = Math.max(maxError, error);
        if ((!Number.isFinite(error) || error > 1e-6) && !firstDifference) firstDifference = { frame, body, key, original: a, port: b, error };
      }
    }
  }
  const eventDifference = expected.events.findIndex((event: any, i: number) => JSON.stringify(event) !== JSON.stringify(actual.events[i]));
  const eventsMatch = expected.events.length === actual.events.length && eventDifference === -1;
  if (firstDifference || !eventsMatch) {
    failures++;
    log.error({ scenario: expected.name, maxError, firstDifference, eventsMatch, firstEventDifference: eventDifference, originalContacts: expected.events.length, portContacts: actual.events.length }, "物理与原版不一致");
  } else log.info({ scenario: expected.name, maxError, contacts: actual.events.length }, "原版物理对照一致");
}
if (failures) process.exitCode = 1;
