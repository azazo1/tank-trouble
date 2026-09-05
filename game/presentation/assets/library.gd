extends RefCounted

var textures: Dictionary = {}
var atlases: Dictionary = {}
var frames: Dictionary = {}
var resolution = 1
var font: FontFile
var log = preload("res://game/runtime/original_log.gd").create("Assets")

func _init():
	font = load("res://assets/original/fonts/TankTrouble.ttf").duplicate()
	font.multichannel_signed_distance_field = false
	font.hinting = TextServer.HINTING_NONE

func load_texture(path):
	if textures.has(path): return textures[path]
	var texture
	if ResourceLoader.exists(path): texture = load(path)
	if texture == null:
		var image = Image.load_from_file(path)
		assert(image != null, "图片资源不存在: " + path)
		texture = ImageTexture.create_from_image(image)
	textures[path] = texture
	log.debug("加载原图", {"path": path, "width": texture.get_width(), "height": texture.get_height()})
	return texture

func texture(key, frame = null):
	if key is Object: return key.texture
	if key == null:
		if not textures.has("@empty"):
			textures["@empty"] = ImageTexture.create_from_image(Image.create_empty(1, 1, false, Image.FORMAT_RGBA8))
		return textures["@empty"]
	if key in ["game", "playerpanel"]: return atlas_frame(key, frame)
	var path = ""
	if key == "menuBackground": path = "images/menu/background.png"
	elif key.begins_with("tankiconplaceholder-"): path = "images/tankIcon/placeholder-%d.png" % [{"small": 140, "medium": 200, "large": 320}[key.trim_prefix("tankiconplaceholder-")]]
	elif key.begins_with("button"):
		var part = key.trim_prefix("button")
		if part.begins_with("Warning"): part = "warning" + part.trim_prefix("Warning")
		elif not part.ends_with("Disabled"): part = "standard" + part
		path = "images/buttons/" + part + ".png"
	assert(not path.is_empty(), "未登记的图片: " + key)
	if resolution == 2: path = path.get_basename() + "@2x." + path.get_extension()
	return load_texture("res://assets/original/" + path)

func atlas_frame(key, frame):
	if key == "playerpanel": key = "playerPanel"
	var atlas_key = key + ("@2x" if resolution == 2 else "")
	var frame_key = atlas_key + ":" + str(frame)
	if frames.has(frame_key): return frames[frame_key]
	if not atlases.has(atlas_key):
		var definition = JSON.parse_string(FileAccess.get_file_as_string("res://assets/original/images/%s/%s.json" % [key, atlas_key]))
		var entries = {}
		for entry in definition.frames: entries[entry.filename] = entry
		atlases[atlas_key] = entries
	if frame == "" or frame == null: frame = atlases[atlas_key].keys()[0]
	assert(atlases[atlas_key].has(frame), "图集帧不存在: " + str(frame))
	var entry = atlases[atlas_key][frame]
	assert(not entry.rotated, "图集帧需要旋转适配: " + str(frame))
	var texture = AtlasTexture.new()
	texture.atlas = load_texture("res://assets/original/images/%s/%s.png" % [key, atlas_key])
	texture.region = Rect2(entry.frame.x, entry.frame.y, entry.frame.w, entry.frame.h)
	texture.margin = Rect2(entry.spriteSourceSize.x, entry.spriteSourceSize.y, entry.sourceSize.w - entry.frame.w, entry.sourceSize.h - entry.frame.h)
	texture.filter_clip = true
	frames[frame_key] = texture
	return texture
