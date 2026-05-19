extends Node2D

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.is_echo():
		var key_name = OS.get_keycode_string(event.get_keycode_with_modifiers())
		print("[KEY_PRESS]: ", key_name)
