import { join } from "node:path";
import { OriginalRuntime } from "./runtime";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
const runtime = new OriginalRuntime(17);
const Constants = runtime.load("constants");
Constants.setMode(Constants.MODE_CLIENT_LOCAL);
const mode = runtime.load("bootcampgamemode").create();
const crates = Constants.GAME_MODE_INFO[Constants.GAME_MODES.BOOT_CAMP].DEFAULT_AVAILABLE_CRATES;
const game = runtime.load("gamecontroller").create(mode, false, false, false, 3, crates, false, Constants.MAZE_THEMES.STANDARD);
const InputState = runtime.load("inputstate");
game.addPlayer("player-0");
game.addPlayer("player-1");
game._initializeRound();
game.startRound();
const frames: any[] = [];
const inputs: any[] = [];
for (let frame = 0; frame < 240; frame++) {
  const states = [
    ["player-0", frame % 90 < 60, false, frame % 60 < 30, false, frame % 30 < 15],
    ["player-1", frame % 70 < 50, false, false, frame % 80 < 40, frame % 50 < 20],
  ];
  inputs.push(states);
  for (const state of states) game.setInputState(InputState.withState(...state));
  runtime.advance(1000 / 60);
  game.update();
  frames.push(JSON.parse(JSON.stringify(game.getRoundState(true).toObj())));
  if (frame % 60 === 59) log.info({ frame: frame + 1, tanks: Object.keys(game.getTanks()).length }, "原版对局重放进行中");
}
await Bun.write(join(root, "tests/fixtures/match-17.json"), JSON.stringify({ seed: 17, timestamp: Date.UTC(2026, 8, 5, 12), crates, random_tape: runtime.randomTape, inputs, frames }) + "\n");
log.info({ frames: frames.length, randomValues: runtime.randomTape.length }, "原版对局基准已导出");
