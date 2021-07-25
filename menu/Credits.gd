extends Control



func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_parent().get_parent()._load_main_menu()


