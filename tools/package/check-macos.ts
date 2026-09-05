import { mkdtemp, rm } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";
import { parseArgs } from "node:util";
import { log } from "../shared/log";
import { runProcess } from "../shared/run-process";

export async function checkMacosApp(output: string, headed = false) {
  const executable = resolve(output, "Contents/MacOS/Tank Trouble");
  const extension = resolve(output, "Contents/Frameworks/libtank_trouble_native.template_release.dylib");
  for (const [name, path] of [["app", executable], ["native", extension]]) {
    const architectures = await runProcess(["lipo", "-archs", path], `检查 ${name} 架构`, resolve(`.tmp/package-${name}-architecture.log`));
    if (architectures.trim() !== "arm64") throw new Error(`应用包必须只包含 arm64: ${path}`);
  }
  await runProcess(["codesign", "--verify", "--deep", "--strict", output], "验证应用签名", resolve(".tmp/package-signature.log"));
  // 从项目外启动, 确认动态库和资源均由应用包提供.
  const directory = await mkdtemp(join(tmpdir(), "tank-trouble-package-"));
  try {
    await runProcess([executable, ...(!headed ? ["--headless"] : []), "--max-fps", "60", "--quit-after", "180"], "检查发布包启动", resolve(`.tmp/package-startup${headed ? "-headed" : ""}.log`), directory, 60000);
  } finally {
    await rm(directory, { recursive: true, force: true });
  }
  log.info({ output, headed }, "macOS 应用包检查通过");
}

if (import.meta.main) {
  const { values } = parseArgs({ args: Bun.argv.slice(2), options: { headed: { type: "boolean" } } });
  await checkMacosApp(resolve("build/package/TankTrouble.app"), values.headed);
}
