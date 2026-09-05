extends RefCounted

static var module_paths: Dictionary = {}
static var loaded_modules: Dictionary = {}
static var random_tape: Array = []
static var random_index := 0
static var strict_random := false
static var global_fields: Dictionary = {}
static var clock_milliseconds = null
static var callback_receivers: Array = []
static var scalar_bridge

static func callback_receiver(fallback):
	return callback_receivers.back() if not callback_receivers.is_empty() else fallback

static func invoke_context(callback, receiver, arguments):
	callback_receivers.append(receiver)
	var result = invoke(callback, arguments)
	callback_receivers.pop_back()
	return result

static func module(name):
	if loaded_modules.has(name): return loaded_modules[name]
	if module_paths.is_empty():
		module_paths = JSON.parse_string(FileAccess.get_file_as_string("res://game/ported/module-index.json"))
	assert(module_paths.has(name), "缺少原版模块: " + str(name))
	var script = load(module_paths[name])
	assert(script != null, "无法加载原版模块: " + str(name))
	loaded_modules[name] = script
	if script.has_method("initialize_original_static"): script.initialize_original_static()
	return script

static func set_random_tape(tape: Array):
	random_tape = tape
	random_index = 0
	strict_random = true

static func random_value():
	if strict_random:
		assert(random_index < random_tape.size(), "随机数对照序列已耗尽")
		var result = random_tape[random_index]
		random_index += 1
		return result
	return randf()

static func truthy(value):
	if value == null: return false
	if value is bool: return value
	if value is int or value is float: return value != 0 and not is_nan(float(value))
	if value is String: return not value.is_empty()
	return true

static func type_of(value):
	if value == null: return "undefined"
	if value is bool: return "boolean"
	if value is int or value is float: return "number"
	if value is String: return "string"
	if value is Callable or value is Script: return "function"
	return "object"

static func number(value):
	if value == null: return 0.0
	if value is bool: return 1.0 if value else 0.0
	if value is String:
		if value.is_empty(): return 0.0
		return value.to_float() if value.is_valid_float() else NAN
	if value is Array: return number(text(value))
	if value is Dictionary: return NAN
	if value is Object and value.get_script() == load("res://game/runtime/original_date.gd"): return value.milliseconds
	return float(value)

static func logical(operation, left: Callable, right: Callable):
	var first = left.call()
	if operation == "&&": return right.call() if truthy(first) else first
	return first if truthy(first) else right.call()

static func sequence(values: Array):
	return values.back() if values.size() else null

static func text(value):
	if value == null: return "undefined"
	if value is bool: return "true" if value else "false"
	if value is Array: return ",".join(value.map(func(item): return "" if item == null else text(item)))
	if value is Dictionary: return "[object Object]"
	if value is float:
		if scalar_bridge == null: scalar_bridge = ClassDB.instantiate("TTJavaScriptValues")
		return scalar_bridge.number_to_string(value)
	return str(value)

static func equal(a, b, strict = false):
	if a == null or b == null: return a == null and b == null
	if a is Array or a is Dictionary or a is Object: return is_same(a, b)
	if type_of(a) != type_of(b):
		return false if strict else number(a) == number(b)
	return a == b

static func add(a, b):
	if a is String or b is String: return text(a) + text(b)
	return number(a) + number(b)

static func compare(operation, a, b):
	var left = a if a is String and b is String else number(a)
	var right = b if a is String and b is String else number(b)
	match operation:
		"<": return left < right
		"<=": return left <= right
		">": return left > right
		">=": return left >= right
	return false

static func bitwise(operation, a, b):
	var left := int(number(a)) & 0xffffffff
	var right := int(number(b)) & 0xffffffff
	var signed_left := left if left < 0x80000000 else left - 0x100000000
	match operation:
		"&": return signed_int(left & right)
		"|": return signed_int(left | right)
		"^": return signed_int(left ^ right)
		"<<": return signed_int((left << (right & 31)) & 0xffffffff)
		">>": return signed_left >> (right & 31)
		">>>": return left >> (right & 31)
	assert(false, "未知位运算")
	return 0

static func signed_int(value):
	return value if value < 0x80000000 else value - 0x100000000

static func weak(value):
	return weakref(value) if value is Object and not value is Script else value

static func dereference(value):
	return value.get_ref() if value is WeakRef else value

static func get_property(object, key):
	if object == null: return null
	if object is Dictionary:
		if object.has("@set") and key == "size": return object["@set"].size()
		return dereference(object.get(text(key)))
	if object is Array:
		if key is String and key == "length": return object.size()
		var index = int(key)
		return object[index] if index >= 0 and index < object.size() else null
	if object is String:
		if object == "@Math":
			match key:
				"PI": return PI
				"E": return exp(1.0)
				"SQRT2": return sqrt(2.0)
		if object == "@Number":
			match key:
				"MAX_VALUE": return 1.7976931348623157e308
				"MIN_VALUE": return pow(2.0, -1074)
		if key is String and key == "length": return object.length()
		return null
	if object is Script:
		if object.has_method("original_" + str(key)): return Callable(object, "original_" + str(key))
		if object.has_method(str(key)): return Callable(object, str(key))
		return object.original_static_get(key) if object.has_method("original_static_get") else null
	if object is Object:
		if object.has_method("original_" + str(key)): return Callable(object, "original_" + str(key))
		if object.has_method(str(key)): return Callable(object, str(key))
		return dereference(object.get(str(key)))
	return null

static func set_property(object, key, value):
	if object is Dictionary: object[text(key)] = value
	elif object is Array:
		if key is String and key == "length": object.resize(int(value))
		else:
			var index := int(key)
			if index >= object.size(): object.resize(index + 1)
			object[index] = value
	elif object is Script: object.original_static_set(key, value)
	elif object is Object:
		object.set(str(key), weak(value) if object.has_method("original_is_weak_field") and object.original_is_weak_field(key) else value)
	else: assert(false, "不能设置属性: " + str(key))
	return value

static func has_property(object, key):
	if object is Dictionary: return object.has(text(key))
	if object is Array: return int(key) >= 0 and int(key) < object.size()
	return get_property(object, key) != null

static func delete_property(object, key):
	if object is Dictionary: object.erase(text(key))
	return true

static func keys(object):
	if object is Dictionary:
		var indices: Array = []
		var others: Array = []
		for key in object.keys():
			var name = text(key)
			if name.is_valid_int() and int(name) >= 0 and int(name) < 4294967295 and str(int(name)) == name: indices.append(name)
			else: others.append(name)
		indices.sort_custom(func(a, b): return int(a) < int(b))
		return indices + others
	if object is Array: return range(object.size())
	return []

static func increment(object, key, amount, postfix):
	var before = get_property(object, key)
	var after = number(before) + amount
	set_property(object, key, after)
	return before if postfix else after

static func invoke(callable, args: Array):
	if callable is Callable: return callable.callv(args.slice(0, callable.get_argument_count()))
	if callable is Script: return callable.callv("create", args)
	assert(false, "对象不可调用: " + str(callable))
	return null

static func invoke_method(object, method, args: Array):
	if object is Object and object.has_method("native_invoke"): return object.native_invoke(method, args)
	if object is Callable and method == "call": return invoke_context(object, args[0], args.slice(1))
	if object is Callable and method == "apply": return invoke_context(object, args[0], args[1] if args.size() > 1 else [])
	if object is String and object.begins_with("@"):
		return builtin_call(object, method, args)
	if object is Array: return array_call(object, method, args)
	if method == "hasOwnProperty": return has_property(object, args[0])
	if method == "classs": return {"@class": object}
	if object is Dictionary and object.has("@class"):
		var fields = object["@class"].original_own_fields()
		if method == "listOwnFields": return fields
		if method == "hasOwnField": return fields.has(args[0])
	if method == "toString":
		if args.size() and int(args[0]) == 16: return "%x" % int(object)
		return text(object)
	if object is String:
		match method:
			"charCodeAt": return object.unicode_at(int(args[0]))
			"indexOf": return object.find(str(args[0]))
			"substr", "substring": return object.substr(int(args[0]), int(args[1]) if args.size() > 1 else -1)
			"split": return Array(object.split(str(args[0])))
	if object is Dictionary: return invoke(object[method], args)
	if object is Object and object.has_method("original_" + str(method)):
		return invoke(Callable(object, "original_" + str(method)), args)
	if object is Object:
		var member = get_property(object, method)
		if member is Callable: return invoke(member, args)
	assert(object is Object and object.has_method(str(method)), "缺少方法: " + str(method))
	return invoke(Callable(object, str(method)), args)

static func array_call(array: Array, method, args: Array):
	match method:
		"removeAll":
			for item in array:
				if item is Object and item.has_method("original_stop"): item.original_stop()
			array.clear()
			return null
		"map", "filter", "some", "every", "forEach":
			var result := []
			for i in range(array.size()):
				var value = invoke(args[0], [array[i], i, array])
				if method == "map": result.append(value)
				if method == "filter" and truthy(value): result.append(array[i])
				if method == "some" and truthy(value): return true
				if method == "every" and not truthy(value): return false
			if method == "some": return false
			if method == "every": return true
			return result
		"push": array.append_array(args); return array.size()
		"pop": return array.pop_back()
		"shift": return array.pop_front()
		"unshift":
			for i in range(args.size() - 1, -1, -1): array.push_front(args[i])
			return array.size()
		"indexOf":
			for i in range(int(args[1]) if args.size() > 1 else 0, array.size()):
				if equal(array[i], args[0], true): return i
			return -1
		"slice": return array.slice(int(args[0]) if args.size() else 0, int(args[1]) if args.size() > 1 else array.size())
		"splice":
			var start := int(args[0])
			if start < 0: start = maxi(array.size() + start, 0)
			start = mini(start, array.size())
			var count := mini(int(args[1]) if args.size() > 1 else array.size() - start, array.size() - start)
			var removed := array.slice(start, start + maxi(count, 0))
			for i in range(count): array.remove_at(start)
			for i in range(2, args.size()): array.insert(start + i - 2, args[i])
			return removed
		"reverse": array.reverse(); return array
		"concat":
			var result := array.duplicate()
			for arg in args:
				if arg is Array: result.append_array(arg)
				else: result.append(arg)
			return result
		"sort":
			var decorated := []
			for i in range(array.size()): decorated.append({"value": array[i], "index": i})
			decorated.sort_custom(func(a, b):
				var result = invoke(args[0], [a.value, b.value]) if args.size() else (-1 if text(a.value) < text(b.value) else 1)
				return a.index < b.index if result == 0 else result < 0
			)
			for i in range(array.size()): array[i] = decorated[i].value
			return array
	assert(false, "未移植的数组方法: " + str(method))
	return null

static func builtin_call(object, method, args: Array):
	if object == "@Date" and method == "now": return load("res://game/runtime/original_date.gd").new().getTime()
	if object == "@Math":
		var x = args[0] if args.size() else 0
		match method:
			"random": return random_value()
			"floor": return floor(x)
			"ceil": return ceil(x)
			"round": return floor(x + 0.5)
			"abs": return abs(x)
			"sqrt": return sqrt(x)
			"sin": return sin(x)
			"cos": return cos(x)
			"tan": return tan(x)
			"atan2": return atan2(x, args[1])
			"atan": return atan(x)
			"acos": return acos(x)
			"pow": return pow(x, args[1])
			"exp": return exp(x)
			"log": return log(x)
			"min": return args.min()
			"max": return args.max()
	if object == "@Object" and method == "keys": return keys(args[0])
	if object == "@Array" and method == "isArray": return args[0] is Array
	if object == "@JSON":
		if method == "stringify": return JSON.stringify(args[0], "", false, true)
		if method == "parse": return JSON.parse_string(args[0])
	assert(false, "未移植的内建方法: " + str(object) + "." + str(method))
	return null

static func construct(type, args: Array):
	if type is Callable: return invoke(type, args)
	if type is String:
		if type == "@Set":
			var unique := []
			for value in args[0]:
				var found := false
				for other in unique:
					if equal(value, other, true): found = true; break
				if not found: unique.append(value)
			return {"@set": unique}
		if type == "@Array":
			if args.size() == 1 and (args[0] is int or args[0] is float):
				var result: Array = []
				result.resize(int(args[0]))
				return result
			return args.duplicate()
		if type == "@Date": return load("res://game/runtime/original_date.gd").new(args[0] if args.size() else null)
	if type is Script: return type.callv("create" if type.has_method("create") else "new", args)
	assert(false, "未移植的构造类型: " + str(type))
	return null

static func instance_of(object, type):
	if object is Object and type is Script: return object.get_script() == type
	return false

static func global_call(name, args: Array):
	match name:
		"setTimeout": return module("GameManager").original_getGame().time.events.original_add(args[1], args[0])
		"clearTimeout": return module("GameManager").original_getGame().time.events.original_remove(args[0])
		"parseFloat": return number(args[0])
		"parseInt": return str(args[0]).hex_to_int() if args.size() > 1 and args[1] == 16 else int(number(args[0]))
		"isNaN": return is_nan(number(args[0]))
	return null
