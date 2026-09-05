extends Window

signal volume_changed(value)
signal quality_changed(value)
signal dismissed

const QUALITIES := ["auto", "high", "low"]
var volume_slider: HSlider
var quality_selector: OptionButton

func _ready():
	title = "Settings"
	size = Vector2i(360, 190)
	unresizable = true
	transient = true
	exclusive = true
	close_requested.connect(dismiss)
	var margin = MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for edge in ["left", "right", "top", "bottom"]:
		margin.add_theme_constant_override("margin_" + edge, 20)
	add_child(margin)
	var rows = VBoxContainer.new()
	rows.add_theme_constant_override("separation", 12)
	margin.add_child(rows)
	var volume_label = Label.new()
	volume_label.text = "Volume"
	rows.add_child(volume_label)
	volume_slider = HSlider.new()
	volume_slider.max_value = 1.0
	volume_slider.step = 0.01
	volume_slider.custom_minimum_size.y = 24
	volume_slider.value_changed.connect(func(value): volume_changed.emit(value))
	rows.add_child(volume_slider)
	var quality_row = HBoxContainer.new()
	rows.add_child(quality_row)
	var quality_label = Label.new()
	quality_label.text = "Quality"
	quality_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	quality_row.add_child(quality_label)
	quality_selector = OptionButton.new()
	quality_selector.custom_minimum_size = Vector2(140, 32)
	for label in ["Auto", "High", "Low"]: quality_selector.add_item(label)
	quality_selector.item_selected.connect(func(index): quality_changed.emit(QUALITIES[index]))
	quality_row.add_child(quality_selector)
	var done = Button.new()
	done.text = "Done"
	done.size_flags_horizontal = Control.SIZE_SHRINK_END
	done.custom_minimum_size = Vector2(80, 32)
	done.pressed.connect(dismiss)
	rows.add_child(done)

func present(values):
	volume_slider.set_value_no_signal(values.volume)
	quality_selector.select(QUALITIES.find(values.quality))
	popup_centered()

func dismiss():
	hide()
	dismissed.emit()

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_cancel"):
		dismiss()
		set_input_as_handled()
