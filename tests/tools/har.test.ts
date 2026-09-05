import { describe, expect, test } from "bun:test";
import { originalPath, responseBody, splitPageSpeed } from "../../tools/assets/har";

describe("HAR 导入", () => {
  test("按 AST 恢复合并路径和转义源码", () => {
    const result = splitPageSpeed("js/tt/ui/game,_boot.js+game,_preload.js.pagespeed.jc.hash.js", 'var mod_pagespeed_a = "var x = \\"hi\\";"; var mod_pagespeed_b = "var y = 2;\\n";'.replaceAll('\\\\"', '\\"'));
    expect(result.map((x) => x.path)).toEqual(["js/tt/ui/game/boot.js", "js/tt/ui/game/preload.js"]);
    expect(result[1].source).toBe("var y = 2;\n");
  });
  test("拒绝外站和其他版本", () => {
    expect(originalPath("https://example.com/assets/a.png")).toBeNull();
    expect(originalPath("https://cdn.tanktrouble.com/RELEASE-2020-01-01/js/a.js")).toBeNull();
    expect(originalPath("https://cdn.tanktrouble.com/RELEASE-2026-08-31-01/assets/a.png?x=1")).toBe("assets/a.png");
  });
  test("空响应不能覆盖已有资源", () => {
    expect(responseBody({ request: { url: "https://tanktrouble.com" }, response: { status: 200, content: {} } })).toBeNull();
  });
});
