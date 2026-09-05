import { mkdir, open } from "node:fs/promises";
import { dirname } from "node:path";
import { log } from "./log";

export async function runProcess(command: string[], label: string, logPath: string, cwd = process.cwd(), timeout = 180000) {
  await mkdir(dirname(logPath), { recursive: true });
  const started = performance.now();
  log.info({ stage: label }, "开始执行");
  const file = await open(logPath, "w+");
  const child = Bun.spawn(command, { cwd, stdout: file.fd, stderr: file.fd });
  const progress = setInterval(async () => {
    log.info({ stage: label, seconds: Math.round((performance.now() - started) / 1000) }, "执行进行中");
    if ((await file.stat()).size > 32 * 1024 * 1024) child.kill();
  }, 10000);
  const deadline = setTimeout(() => child.kill(), timeout);
  try {
    const status = await child.exited;
    const size = (await file.stat()).size;
    const buffer = Buffer.alloc(Math.min(size, 65536));
    await file.read(buffer, 0, buffer.length, Math.max(0, size - buffer.length));
    const output = buffer.toString("utf8");
    if (status !== 0 || /SCRIPT ERROR:|ERROR:|WARNING:.*leak/.test(output)) {
      throw new Error(`${label} 失败 (${status}), 日志: ${logPath}\n${output.split("\n").filter(line => /ERROR:|WARNING:|failed|Leaked instance/.test(line)).slice(0, 20).join("\n")}`);
    }
    log.info({ stage: label, milliseconds: Math.round(performance.now() - started), log: logPath }, "执行完成");
    return output;
  } finally {
    clearInterval(progress);
    clearTimeout(deadline);
    if (child.exitCode === null) {
      child.kill();
      await child.exited;
    }
    await file.close();
  }
}
