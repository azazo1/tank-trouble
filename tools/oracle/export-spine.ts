import { createContext, runInContext } from "node:vm";
import { join } from "node:path";
import { mkdir } from "node:fs/promises";
import { log } from "../shared/log";

const root = join(import.meta.dir, "../..");
const source = await Bun.file(join(root, "vendor/original/js/phaserplugins/phaser-spine.js")).text();
const easing = (k: number) => { if ((k *= 2) < 1) return 0.5 * k * k; return -0.5 * (--k * (k - 2) - 1); };
const context = createContext({ Phaser: { Easing: { Quadratic: { InOut: easing } } } });
runInContext(source.slice(0, 183866), context);
const spine = context.spine;
await mkdir(join(root, ".tmp"), { recursive: true });
for (const character of ["laika", "dimitri"]) {
  log.info({ character }, "开始原版 Spine 骨骼与网格重放");
  const skeletonData = await Bun.file(join(root, `assets/original/images/${character}/${character}.json`)).json();
  const atlasText = await Bun.file(join(root, `assets/original/images/${character}/${character}.atlas`)).text();
  const png = new DataView(await Bun.file(join(root, `assets/original/images/${character}/${character}.png`)).arrayBuffer());
  const images = { [`${character}.png`]: { width: png.getUint32(16), height: png.getUint32(20) } };
  const atlas = new spine.TextureAtlas(atlasText, (name: string) => ({ getImage: () => images[name], setFilters() {}, setWraps() {} }));
  const data = new spine.SkeletonJson(new spine.AtlasAttachmentLoader(atlas)).readSkeletonData(skeletonData);
  const skeleton = new spine.Skeleton(data);
  skeleton.setToSetupPose();
  skeleton.updateWorldTransform();
  const stateData = new spine.AnimationStateData(data);
  const state = new spine.AnimationState(stateData);
  const names: string[] = data.animations.map((animation: any) => animation.name);
  const commands: any[] = [];
  for (let i = 0; i < names.length; ++i) {
    const from = names[(i + names.length - 1) % names.length];
    stateData.setMix(from, names[i], 0.12, easing);
    commands.push({ frame: i * 6, operation: "set", track: 0, name: names[i], loop: i % 2 === 0 });
    if (i % 3 === 0) commands.push({ frame: i * 6 + 1, operation: "add", track: 1, name: names[i], loop: false, delay: 0.01 });
    if (i % 3 === 2) commands.push({ frame: i * 6 + 2, operation: "clear", track: 1 });
  }
  const frames: any[] = [];
  commands.push({ frame: 12, operation: "flip", value: true }, { frame: 30, operation: "flip", value: false });
  for (let frame = 0; frame < names.length * 6 + 24; ++frame) {
    for (const command of commands.filter(item => item.frame === frame)) {
      if (command.operation === "set") state.setAnimation(command.track, command.name, command.loop);
      if (command.operation === "add") state.addAnimation(command.track, command.name, command.loop, command.delay);
      if (command.operation === "clear") state.clearTrack(command.track);
      if (command.operation === "flip") skeleton.flipX = command.value;
    }
    state.update(1 / 60);
    state.apply(skeleton);
    skeleton.updateWorldTransform();
    if (frame % 6 !== 0) continue;
    const geometry: any[] = [];
    for (const slot of skeleton.drawOrder) {
      const attachment = slot.attachment;
      if (!attachment) continue;
      const region = attachment instanceof spine.RegionAttachment;
      const mesh = attachment instanceof spine.MeshAttachment;
      if (!region && !mesh) continue;
      const vertices = new Array(region ? 8 : attachment.worldVerticesLength).fill(0);
      if (region) attachment.computeWorldVertices(slot.bone, vertices, 0, 2);
      else attachment.computeWorldVertices(slot, 0, attachment.worldVerticesLength, vertices, 0, 2);
      geometry.push({ slot: slot.data.name, vertices, uvs: Array.from(attachment.uvs), triangles: region ? [0, 1, 2, 2, 3, 0] : attachment.triangles, blend: slot.data.blendMode, texture: `${character}.png`, color: ["r", "g", "b", "a"].map(key => skeleton.color[key] * slot.color[key] * attachment.color[key]) });
    }
    frames.push({ frame, bones: skeleton.bones.map((bone: any) => [bone.a, bone.b, bone.c, bone.d, bone.worldX, bone.worldY]), geometry });
  }
  await Bun.write(join(root, `.tmp/spine-${character}.expected.json`), JSON.stringify({ character, images, names, commands, count: names.length * 6 + 24, frames }));
  log.info({ character, animations: names.length, frames: frames.length }, "原版 Spine 对照数据生成完成");
}
