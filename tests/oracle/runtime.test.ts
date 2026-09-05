import { expect, test } from "bun:test";
import { OriginalRuntime } from "../../tools/oracle/runtime";

test("原版迷宫在相同时间和随机输入下可重放", () => {
  const make = () => {
    const runtime = new OriginalRuntime(7);
    const maze = runtime.load("maze").createRandom(6, 5, ["a", "b", "c"], 0);
    return { maze: maze.toObj(), tanks: maze.getTankPositions(), tape: runtime.randomTape };
  };
  const a = make();
  expect(a).toEqual(make());
  expect(a.tanks).toHaveLength(3);
});
