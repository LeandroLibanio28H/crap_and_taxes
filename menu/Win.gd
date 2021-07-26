extends Control



func _ready() -> void:
	if SaveSystem.save_data["GameData"].HighScore < get_tree().current_scene.current_score:
		SaveSystem.save_data["GameData"].HighScore = get_tree().current_scene.current_score
		SaveSystem.save_game()
	$Control/GridContainer/Pontuacao.text = str(get_tree().current_scene.current_score)
	$Control/GridContainer/HighScore.text = str(SaveSystem.save_data["GameData"].HighScore)
	$Timer.start()
	


func _on_Timer_timeout() -> void:
	get_tree().reload_current_scene()
