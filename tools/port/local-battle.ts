import { classDefinition } from "./compiler";

// BootCamp 不会产生在线奖励, 聊天, 区域, 加时或奖杯事件.
const removedFields = new Set([
  "waitingIconGroup", "celebrationTrophyGroup", "overtimeGroup", "counterTimerGroup",
  "spawnZoneGroup", "stormZoneGroup", "goldGroup", "diamondGroup", "diamondShineGroup", "sparkleGroup", "chatSymbolGroup", "chatSymbolSprites", "debugGraphics",
]);
const removedModules = new Set(["ClientManager", "Users", "UIPlayerPanel", "IFrameManager", "OverlayManager"]);
const removedCalls = new Set(["sendVictoryGoldToTank", "showXPChange", "showRankChanges", "sendGoldToTank", "sendDiamondToTank", "_removeCounters"]);

export function localBattle(source: string) {
  const definition = classDefinition(source);
  definition.base = "Phaser.Group";
  definition.fields = definition.fields.filter(field => !removedFields.has(field.key.name));
  definition.methods = definition.methods.filter(method => ![
    "preload", "render", "_onFocusHandler", "_onBlurHandler", "_clientEventHandler", "_clientStateChangeHandler", "_authenticationEventHandler", "_leaveState", "_spawnCelebration", "_createZone", "_removeZone", "_destabilizeZone", "_createCounter", "_removeCounter", "_removeCounters", "_showChatSymbol", "_hideChatSymbol", "_removeChatSymbol", "_startCollectibleAnimation", "_mazeLocalBoundsUpdated",
  ].includes(method.key.name) && !method.key.name.startsWith("_debugDraw"));
  const contains = (node: any): boolean => {
    if (!node || typeof node !== "object") return false;
    if (node.type === "Identifier" && removedModules.has(node.name)) return true;
    if (node.type === "MemberExpression" && (removedFields.has(node.property?.name) || removedCalls.has(node.property?.name) || ["onSizeChange", "onFocus", "onBlur", "_mazeLocalBoundsUpdated", "_startCollectibleAnimation", "_removeChatSymbol"].includes(node.property?.name))) return true;
    return Object.values(node).some(value => Array.isArray(value) ? value.some(contains) : contains(value));
  };
  const transform = (node: any): any => {
    if (!node || typeof node !== "object") return node;
    if (node.type === "BinaryExpression" && node.left?.callee?.property?.name === "getMode" && node.right?.object?.name === "Constants") {
      if (["MODE_CLIENT_LOCAL", "MODE_CLIENT_ONLINE"].includes(node.right.property.name)) return { type: "Literal", value: node.right.property.name === "MODE_CLIENT_LOCAL" };
    }
    if (node.type === "CallExpression" && node.callee?.object?.name === "Users" && node.callee.property.name === "isAnyUser") return { type: "Literal", value: true };
    for (const [key, value] of Object.entries(node)) {
      if (Array.isArray(value)) node[key] = value.map(transform).filter(Boolean);
      else if (value && typeof value === "object") node[key] = transform(value);
    }
    if (node.type === "IfStatement" && node.test?.type === "Literal") return node.test.value ? node.consequent : node.alternate;
    if (["ExpressionStatement", "VariableDeclaration", "ForStatement"].includes(node.type) && contains(node)) return null;
    if (node.type === "IfStatement" && (!node.consequent || contains(node.test))) return null;
    if (node.type === "SwitchCase" && ["GOLD", "DIAMOND", "COUNTER_CREATED", "COUNTER_DESTROYED", "ZONE_CREATED", "ZONE_DESTROYED", "ZONE_DESTABILIZED", "CELEBRATION_STARTED"].includes(node.test?.property?.name)) return null;
    return node;
  };
  definition.methods.forEach(method => transform(method.value.body));
  return definition;
}
