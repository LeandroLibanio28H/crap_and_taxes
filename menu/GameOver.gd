extends Control



func _on_Timer_timeout() -> void:
	get_tree().reload_current_scene()
