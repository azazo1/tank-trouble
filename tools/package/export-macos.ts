import { chmod, mkdir, rename } from "node:fs/promises";
import { resolve } from "node:path";
import { runProcess } from "../shared/run-process";
import { log } from "../shared/log";
import { checkMacosApp } from "./check-macos";

const output = resolve("build/package/TankTrouble.app");
await mkdir("build/package", { recursive: true });
await runProcess(["godot", "--headless", "--path", ".", "--export-release", "macOS", output], "导出 macOS arm64", resolve(".tmp/export-macos.log"));
// 官方模板只包含 universal 二进制, 与原生扩展统一为 arm64 后重新签名.
const executable = `${output}/Contents/MacOS/Tank Trouble`;
await runProcess(["lipo", executable, "-thin", "arm64", "-output", `${executable}.arm64`], "提取 arm64 可执行文件", resolve(".tmp/export-architecture.log"));
await rename(`${executable}.arm64`, executable);
await chmod(executable, 0o755);
await runProcess(["codesign", "--force", "--deep", "--sign", "-", output], "签名本地应用", resolve(".tmp/export-sign.log"));
await checkMacosApp(output);
log.info({ output }, "macOS 应用已导出");
