import { join } from "node:path";
import { OriginalRuntime } from "./runtime";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
const ai = (await Bun.file(join(root, "assets/data/ais.json")).json()).ais[0];
const scenarios = [
  ...Array.from({ length: 7 }, (_, crate) => ({ name: `combat-${crate}`, crate, ai: null })),
  { name: "laika", crate: null, ai },
];
for (const scenario of scenarios) {
  const runtime = new OriginalRuntime(41);
  const Constants = runtime.load("constants");
  Constants.setMode(Constants.MODE_CLIENT_LOCAL);
  const mode = runtime.load("bootcampgamemode").create();
  const crates = Constants.GAME_MODE_INFO[Constants.GAME_MODES.BOOT_CAMP].DEFAULT_AVAILABLE_CRATES;
  const game = runtime.load("gamecontroller").create(mode, false, false, false, 3, crates, false, Constants.MAZE_THEMES.STANDARD);
  const InputState = runtime.load("inputstate");
  const players = ["player-0", scenario.ai ? scenario.ai.id : "player-1"];
  for (const player of players) game.addPlayer(player);
  const manager = scenario.ai ? runtime.load("aimanager").create(scenario.ai.id, scenario.ai, game) : null;
  game._initializeRound();
  game.startRound();
  if (scenario.crate !== null) {
    const controller = game.roundController;
    controller.spawnCrate(scenario.crate, { x: -100, y: -100, rotation: 0 });
    const id = Object.keys(controller.getCollectibles())[0];
    const pickup = runtime.load("pickup").create(players[0], id);
    controller.pickUpCrate(pickup);
    controller.destroyCollectible(pickup);
  }
  const frames: any[] = [], inputs: any[] = [], decisions: any[] = [];
  for (let frame = 0; frame < 360; frame++) {
    const states = [
      [players[0], frame % 90 < 60, false, frame % 60 < 30, false, frame % 30 < 20],
      ...(!manager ? [[players[1], frame % 70 < 50, false, false, frame % 80 < 40, frame % 50 < 20]] : []),
    ];
    inputs.push(states);
    for (const state of states) game.setInputState(InputState.withState(...state));
    runtime.advance(1000 / 60);
    manager?.update(1 / 60);
    game.update();
    frames.push(JSON.parse(JSON.stringify(game.getRoundState(true).toObj())));
    if (manager) decisions.push(JSON.parse(JSON.stringify({ input: manager.ai.getInputState().toObj(), goal: manager.ai.goal, actions: manager.ai.actions })));
    if (frame % 120 === 119) log.info({ scenario: scenario.name, frame: frame + 1 }, "原版武器和 AI 基准生成中");
  }
  await Bun.write(join(root, `tests/fixtures/${scenario.name}.json`), JSON.stringify({ seed: 41, timestamp: Date.UTC(2026, 8, 5, 12), crates, players, forced_crate: scenario.crate, ai: scenario.ai, random_tape: runtime.randomTape, inputs, frames, decisions }) + "\n");
}
