import { join } from "node:path";
import { parseArgs } from "node:util";
import { log } from "../shared/log";
import { sha256 } from "./har";

const root = join(import.meta.dir, "../..");
const { values } = parseArgs({ args: Bun.argv.slice(2), options: { "create-guests": { type: "boolean", default: false } } });
const destination = join(root, "assets/data/player-appearances.json");
if (await Bun.file(destination).exists()) {
  log.info("已存在公开外观快照, 跳过原站调用");
  process.exit(0);
}
if (!values["create-guests"]) throw new Error("尚无游客快照. 创建游客需要使用已授权的 --create-guests 操作");

async function request(method: string, params: unknown[]) {
  const response = await fetch("https://tanktrouble.com/ajax/", {
    method: "POST", headers: { "content-type": "application/json" },
    body: JSON.stringify({ jsonrpc: "2.0", id: 1, method, params }), signal: AbortSignal.timeout(30000),
  });
  if (!response.ok) throw new Error(`原站请求失败: ${method}, HTTP ${response.status}`);
  const envelope = await response.json() as any;
  if (!envelope.result?.result) throw new Error(`原站请求未成功: ${method}, ${String(envelope.result?.message ?? envelope.error?.message ?? "没有错误说明").slice(0, 400)}`);
  return envelope.result.data;
}

function publicAppearance(data: any) {
  const result: Record<string, unknown> = { playerId: String(data.playerId), username: String(data.username) };
  for (const name of ["baseColour", "turretColour", "treadColour"]) {
    const colour = data[name];
    if (colour?.type !== "numeric") throw new Error(`外观使用了尚未捕获的颜色纹理: ${name}`);
    const numeric = Number(colour.numericValue);
    if (!Number.isInteger(numeric) || numeric < 0 || numeric > 0xffffff) throw new Error(`无效的原版颜色: ${name}`);
    result[name] = { type: "numeric", rawValue: colour.rawValue, numericValue: numeric, imageValue: "" };
  }
  for (const name of ["turretAccessory", "barrelAccessory", "frontAccessory", "backAccessory", "treadAccessory", "backgroundAccessory", "badge"]) result[name] = String(data[name]);
  return result;
}

log.info("开始捕获 Laika 的公开外观");
const ai = publicAppearance(await request("tanktrouble.getPlayerDetails", ["6148530"]));
log.info("创建已授权的 3 个匿名游客并过滤公开外观");
const response = await request("tanktrouble.account.createGuests", [3]);
if (!Array.isArray(response.playerDetails) || response.playerDetails.length !== 3) throw new Error("原站游客返回数量不是 3");
const guests = response.playerDetails.map(publicAppearance);
const publicData = { ai, guests };
await Bun.write(destination, JSON.stringify({ schema_version: 1, captured_at: new Date().toISOString(), source: "tanktrouble.getPlayerDetails / tanktrouble.account.createGuests", sha256: sha256(JSON.stringify(publicData)), ...publicData }, null, 2) + "\n");
log.info({ guests: guests.length, ais: 1 }, "公开外观快照已保存");
