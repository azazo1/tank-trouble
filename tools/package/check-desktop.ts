import { resolve } from "node:path";
import { runProcess } from "../shared/run-process";

export async function checkDesktop(platform: "linux" | "windows") {
  const executable = platform === "linux" ? resolve("build/package/TankTrouble.x86_64") : resolve("build/package/TankTrouble.exe");
  const pck = resolve("build/package/TankTrouble.pck");
  if (!(await Bun.file(executable).exists()) || !(await Bun.file(pck).exists())) {
    throw new Error(`发布包缺少可执行文件或 PCK: ${executable}`);
  }

  if (platform === "linux") {
    const header = await runProcess(["file", executable], "检查 Linux ELF 文件", resolve(".tmp/package-linux-file.log"));
    if (!header.includes("ELF") || !header.includes("x86-64")) throw new Error(`Linux 可执行文件格式无效: ${header}`);
  } else {
    const bytes = new Uint8Array(await Bun.file(executable).arrayBuffer());
    if (bytes.length < 0x40 || bytes[0] !== 0x4d || bytes[1] !== 0x5a) throw new Error(`Windows PE 文件头无效: ${executable}`);
    const peOffset = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength).getUint32(0x3c, true);
    if (peOffset + 6 > bytes.length || bytes[peOffset] !== 0x50 || bytes[peOffset + 1] !== 0x45 || bytes[peOffset + 2] !== 0 || bytes[peOffset + 3] !== 0) {
      throw new Error(`Windows PE 签名无效: ${executable}`);
    }
    const machine = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength).getUint16(peOffset + 4, true);
    if (machine !== 0x8664) throw new Error(`Windows 可执行文件必须是 x86_64: ${executable}`);
  }

  await runProcess(
    [executable, "--headless", "--max-fps", "60", "--quit-after", "60"],
    `检查 ${platform} 发布包启动`,
    resolve(`.tmp/package-${platform}-startup.log`),
    resolve("build/package"),
    60000,
  );
}

if (import.meta.main) {
  const platform = Bun.argv[2];
  if (platform !== "linux" && platform !== "windows") throw new Error(`不支持的桌面平台: ${platform ?? ""}`);
  await checkDesktop(platform);
}
