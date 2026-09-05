extends Node

signal replay_requested
signal settings_requested
signal leave_requested

var popup: PopupMenu

func _ready():
	if DisplayServer.get_name() == "headless": return
	var bar = MenuBar.new()
	bar.prefer_global_menu = true
	popup = PopupMenu.new()
	popup.name = "Game"
	popup.add_item("Play Again", 0)
	popup.add_item("Settings...", 1)
	popup.add_separator()
	popup.add_item("Return to Menu", 2)
	popup.id_pressed.connect(_selected)
	bar.add_child(popup)
	add_child(bar)
	update_state(false, false)

func update_state(in_battle: bool, selecting: bool):
	if popup == null: return
	popup.set_item_disabled(popup.get_item_index(0), in_battle or selecting)
	popup.set_item_disabled(popup.get_item_index(1), selecting)
	popup.set_item_disabled(popup.get_item_index(2), not in_battle)

func _selected(id):
	match id:
		0: replay_requested.emit()
		1: settings_requested.emit()
		2: leave_requested.emit()
