extends RefCounted

var textures: Dictionary = {}
var resolution = 1
var font: FontFile
var log = preload("res://game/runtime/original_log.gd").create("Assets")

func _init():
	font = FontFile.new()
	font.data = FileAccess.get_file_as_bytes("res://assets/original/fonts/TankTrouble.ttf")
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

func texture(key):
	var path = ""
	if key == "menuBackground": path = "images/menu/background.png"
	elif key.begins_with("button"):
		var part = key.trim_prefix("button")
		if part.begins_with("Warning"): part = "warning" + part.trim_prefix("Warning")
		elif not part.ends_with("Disabled"): part = "standard" + part
		path = "images/buttons/" + part + ".png"
	assert(not path.is_empty(), "未登记的图片: " + key)
	if resolution == 2: path = path.get_basename() + "@2x." + path.get_extension()
	return load_texture("res://assets/original/" + path)
