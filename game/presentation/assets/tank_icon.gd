extends RefCounted

static var cache: Dictionary = {}

# 对应 UITankIcon.drawTankIcon 的分层, destination-atop 染色和八方向轮廓.
static func texture(profile, width = 320, resolution = 1):
	var cache_key = str(profile) + ":%d:%d" % [width, resolution]
	if cache.has(cache_key): return cache[cache_key]
	var started = Time.get_ticks_msec()
	var size = Vector2i(width * resolution, int(width * 0.6) * resolution)
	var composite = Image.create_empty(size.x, size.y, false, Image.FORMAT_RGBA8)
	var suffix = "@2x" if resolution == 2 else ""
	_accessory(composite, profile, "back", width, suffix)
	for item in [["leftTread", "treadColour"], ["turret", "turretColour"], ["base", "baseColour"], ["rightTread", "treadColour"], ["barrel", "turretColour"]]:
		var path = "res://assets/original/images/tankIcon/%s-%d%s.png" % [item[0], width, suffix]
		var part = _source_image(path)
		part.convert(Image.FORMAT_RGBA8)
		var bytes = part.get_data()
		var colour = int(profile[item[1]].numericValue)
		for index in range(0, bytes.size(), 4):
			bytes[index] = (colour >> 16) & 255
			bytes[index + 1] = (colour >> 8) & 255
			bytes[index + 2] = colour & 255
		part.set_data(part.get_width(), part.get_height(), false, Image.FORMAT_RGBA8, bytes)
		composite.blend_rect(part, Rect2i(Vector2i.ZERO, size), Vector2i.ZERO)
		var shade = _source_image("res://assets/original/images/tankIcon/%sShade-%d%s.png" % [item[0], width, suffix])
		shade.convert(Image.FORMAT_RGBA8)
		composite.blend_rect(shade, Rect2i(Vector2i.ZERO, size), Vector2i.ZERO)
	for part in ["turret", "front", "barrel"]: _accessory(composite, profile, part, width, suffix)
	cache[cache_key] = ImageTexture.create_from_image(composite)
	preload("res://game/runtime/original_log.gd").create("TankIcon").debug("合成原版坦克图标", {"width": width, "milliseconds": Time.get_ticks_msec() - started})
	return cache[cache_key]

static func _accessory(composite, profile, part, width, suffix):
	var accessory = str(profile.get(part + "Accessory", "0"))
	if accessory == "0" or accessory.is_empty(): return
	var path = "res://assets/original/images/accessories/%s%s-%d%s.png" % [part, accessory, width, suffix]
	var image = _source_image(path)
	assert(image != null, "缺少原版坦克饰件: " + path)
	image.convert(Image.FORMAT_RGBA8)
	composite.blend_rect(image, Rect2i(Vector2i.ZERO, composite.get_size()), Vector2i.ZERO)

static func _source_image(path):
	if ResourceLoader.exists(path): return load(path).get_image()
	var image = Image.new()
	assert(image.load_png_from_buffer(FileAccess.get_file_as_bytes(path)) == OK, "原图解码失败: " + path)
	return image
