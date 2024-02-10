extends Control

func _shortcut_input(event: InputEvent) -> void:
	if event.as_text() == "P" and event.is_released():
		get_window().always_on_top = not get_window().always_on_top




func _on_texture_button_toggled(toggled_on: bool) -> void:
	get_window().always_on_top = toggled_on
