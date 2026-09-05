import { chmod, mkdir, rm } from "node:fs/promises";
import { resolve } from "node:path";
import { checkMacosApp } from "./check-macos";
import { log } from "../shared/log";
import { runProcess } from "../shared/run-process";

type Platform = "macos" | "linux" | "windows";

function currentPlatform(): Platform {
  if (process.platform === "darwin" && process.arch === "arm64") return "macos";
  if (process.platform === "linux" && process.arch === "x64") return "linux";
  if (process.platform === "win32" && process.arch === "x64") return "windows";
  throw new Error(`当前运行环境不支持发布: ${process.platform}/${process.arch}`);
}

const platform = (Bun.argv[2] as Platform | undefined) ?? currentPlatform();
if (!["macos", "linux", "windows"].includes(platform)) throw new Error(`不支持的发布平台: ${platform}`);

const packageDir = resolve("build/package");
await mkdir(packageDir, { recursive: true });

if (platform === "macos") {
  const app = resolve(packageDir, "TankTrouble.app");
  const dmg = resolve(packageDir, "TankTrouble-macos-arm64.dmg");
  await runProcess(["godot", "--headless", "--path", ".", "--export-release", "macOS", app], "导出 macOS arm64 应用", resolve(".tmp/export-macos.log"));
  await runProcess(["codesign", "--force", "--deep", "--sign", "-", app], "签名 macOS 应用", resolve(".tmp/export-sign.log"));
  await checkMacosApp(app);
  await rm(dmg, { force: true });
  await runProcess(["hdiutil", "create", "-volname", "Tank Trouble", "-srcfolder", app, "-ov", "-format", "UDZO", dmg], "生成 macOS arm64 磁盘映像", resolve(".tmp/package-dmg.log"));
  if (!(await Bun.file(dmg).exists())) throw new Error(`未生成发布归档: ${dmg}`);
  log.info({ platform, output: dmg }, "发布归档已生成");
  process.exit(0);
}

const executable = platform === "linux" ? resolve(packageDir, "TankTrouble.x86_64") : resolve(packageDir, "TankTrouble.exe");
const pck = resolve(packageDir, "TankTrouble.pck");
const archive = platform === "linux" ? resolve(packageDir, "tank-trouble-linux-x86_64.tar.gz") : resolve(packageDir, "tank-trouble-windows-x86_64.zip");
const preset = platform === "linux" ? "Linux/X11" : "Windows";

await runProcess(["godot", "--headless", "--path", ".", "--export-release", preset, executable], `导出 ${platform} x86_64`, resolve(`.tmp/export-${platform}.log`));
if (!(await Bun.file(executable).exists()) || !(await Bun.file(pck).exists())) throw new Error(`导出缺少可执行文件或 PCK: ${executable}`);

if (platform === "linux") {
  await chmod(executable, 0o755);
  await runProcess(["tar", "-czf", archive, "-C", packageDir, "TankTrouble.x86_64", "TankTrouble.pck"], "打包 Linux x86_64 归档", resolve(".tmp/package-linux.log"));
} else {
  await runProcess(["powershell", "-NoProfile", "-Command", `Compress-Archive -LiteralPath '${executable}','${pck}' -DestinationPath '${archive}' -Force`], "打包 Windows x86_64 归档", resolve(".tmp/package-windows.log"));
}

if (!(await Bun.file(archive).exists())) throw new Error(`未生成发布归档: ${archive}`);
log.info({ platform, output: archive }, "发布归档已生成");
