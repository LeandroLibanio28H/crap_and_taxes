extends Control



export var color_default : Color
export var color_selected : Color

var selected : int = 0


onready var _menu_items = $Margin/VBoxContainer/MenuItems


func _ready() -> void:
	_update_color()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("MOVE_S"):
		selected += 1
	elif event.is_action_pressed("MOVE_N"):
		selected -= 1
	
	if selected > 2:
		selected = 0
	if selected < 0:
		selected = 2
	
	if event.is_action_pressed("ui_accept"):
		$AudioStreamPlayer.connect("finished", self, "_load")
		$AudioStreamPlayer.play()
	
	_update_color()


func _load() -> void:
	if selected == 2:
		get_tree().quit()
	elif selected == 1:
		get_parent().get_parent()._load_credits()
	elif selected == 0:
		get_parent().get_parent().get_parent()._load_game()


func _update_color() -> void:
	for child in _menu_items.get_children():
		child.self_modulate = color_default
	
	_menu_items.get_child(selected).self_modulate = color_selected
