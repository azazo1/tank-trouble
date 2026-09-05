import { resolve } from "node:path";
import { checkDesktop } from "./check-desktop";
import { checkMacosApp } from "./check-macos";

type Platform = "macos" | "linux" | "windows";

function currentPlatform(): Platform {
  if (process.platform === "darwin" && process.arch === "arm64") return "macos";
  if (process.platform === "linux" && process.arch === "x64") return "linux";
  if (process.platform === "win32" && process.arch === "x64") return "windows";
  throw new Error(`当前运行环境不支持校验: ${process.platform}/${process.arch}`);
}

const platform = (Bun.argv[2] as Platform | undefined) ?? currentPlatform();
if (!["macos", "linux", "windows"].includes(platform)) throw new Error(`不支持的校验平台: ${platform}`);
if (platform === "macos") await checkMacosApp(resolve("build/package/TankTrouble.app"));
else await checkDesktop(platform);
