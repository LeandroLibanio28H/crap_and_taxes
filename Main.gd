extends Node2D



var _game_scene = preload("res://game/Game.tscn")
var _win_scene = preload("res://menu/Win.tscn")
var _game_over = preload("res://menu/GameOver.tscn")

var current_score : int = 0


func _ready() -> void:
	randomize()


func _load_game() -> void:
	_clear_children()
	var game = _game_scene.instance()
	add_child(game)



func _clear_children() -> void:
	for child in get_children():
		child.queue_free()


func end_game() -> void:
	_clear_children()
	var win = _win_scene.instance()
	add_child(win)


func game_over() -> void:
	_clear_children()
	var game_overs = _game_over.instance()
	add_child(game_overs)
