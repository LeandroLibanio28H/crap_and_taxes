extends Node2D



var _game_scene = preload("res://game/Game.tscn")


func _ready() -> void:
	randomize()


func _load_game() -> void:
	_clear_children()
	var game = _game_scene.instance()
	add_child(game)



func _clear_children() -> void:
	for child in get_children():
		child.queue_free()
