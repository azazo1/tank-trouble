extends RefCounted

const JS = preload("res://game/runtime/js_support.gd")
var controller
var ai_manager
var human_ids: Array = []
var assignments: Array = []
var log = preload("res://game/runtime/original_log.gd").create("LocalSession")

func initialize(input_sets: Array):
	assert(input_sets.size() >= 1 and input_sets.size() <= 3)
	assert(controller == null)
	var inputs = JS.module("Inputs")
	var available = inputs.original_getAllInputSetIds()
	for input_set in input_sets:
		assert(available.has(input_set), "操作方案重复或不存在")
		available.erase(input_set)
	var constants = JS.module("Constants")
	constants.original_setMode(JS.get_property(constants, "MODE_CLIENT_LOCAL"))
	var modes = JS.get_property(constants, "GAME_MODES")
	var info = JS.get_property(constants, "GAME_MODE_INFO")[modes.BOOT_CAMP]
	controller = JS.module("GameController").create(JS.module("BootCampGameMode").create(), false, false, false, JS.get_property(constants, "CLIENT").MAX_PLAYERS, info.DEFAULT_AVAILABLE_CRATES, false, JS.get_property(constants, "MAZE_THEMES").RANDOM)
	assignments = input_sets.duplicate()
	var session_id = Crypto.new().generate_random_bytes(16).hex_encode()
	for index in range(input_sets.size()):
		var id = "guest-%s-%d" % [session_id, index]
		JS.module("Backend").register_guest(id, index)
		human_ids.append(id)
		controller.original_addPlayer(id)
		inputs.original_addInputManager(id, input_sets[index])
	if human_ids.size() == 1:
		var data = JSON.parse_string(FileAccess.get_file_as_string("res://assets/data/ais.json"))
		var ai = data.ais[0]
		ai_manager = JS.module("AIManager").create(ai.id, ai, controller)
		controller.original_addPlayer(ai.id)
	JS.module("GameManager").original_setGameController(controller)
	controller.original_addGameEventListener(_game_event, self)
	controller.original_addRoundEventListener(_round_event, self)
	log.info("创建离线对局", {"players": human_ids.size(), "ai": ai_manager != null, "controls": assignments})

func advance(milliseconds):
	JS.module("Inputs").original_update()
	if ai_manager != null: ai_manager.original_update(milliseconds)
	controller.original_update()

func _game_event(_context, _id, event, data):
	log.debug("对局事件", {"event": event, "data": str(data)})

func _round_event(_context, _id, event, _data):
	var events = JS.get_property(JS.module("RoundModel"), "_EVENTS")
	if event == events.ROUND_STARTED:
		JS.module("Inputs").original_reset()
		if ai_manager != null: ai_manager.original_reset()
	if event in [events.ROUND_CREATED, events.ROUND_STARTED, events.ROUND_ENDED]:
		log.info("回合状态变化", {"event": event, "round": controller.original_getRoundId()})

func shutdown():
	if controller == null: return
	controller.original_removeGameEventListener(_game_event, self)
	controller.original_removeRoundEventListener(_round_event, self)
	JS.module("GameManager").original_setGameController(null)
	for id in human_ids: JS.module("Inputs").original_removeInputManager(id)
	human_ids.clear()
	if ai_manager != null: ai_manager.original_shutdown()
	ai_manager = null
	controller = null
	log.info("离线对局已释放")
