extends Control


var _main_menu = preload("res://menu/MainMenu.tscn")
var _credits = preload("res://menu/Credits.tscn")




func _ready() -> void:
	_clear_children()
	_load_main_menu()



func _clear_children() -> void:
	for child in $Menus.get_children():
		child.queue_free()



func _load_main_menu() -> void:
	_clear_children()
	var menu = _main_menu.instance()
	$Menus.add_child(menu)


func _load_credits() -> void:
	_clear_children()
	var menu = _credits.instance()
	$Menus.add_child(menu)
