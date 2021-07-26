extends Node


var save_data: Dictionary = {}
const SAVE_GAME: String = "user://game.config.json"


func _ready() -> void:
	save_data = get_data()


func get_data() -> Dictionary:
	var file := File.new()
	if not file.file_exists(SAVE_GAME):
		save_data = {
			"GameData": {
				"HighScore" : 0
			}
		}
		save_game()
	file.open(SAVE_GAME, File.READ)
	var content: String = file.get_as_text()
	var data: Dictionary = parse_json(content)
	save_data = data
	file.close()
	return data


func save_game() -> void:
	var save := File.new()
	save.open(SAVE_GAME, File.WRITE)
	save.store_line(to_json(save_data))
	save.close()
