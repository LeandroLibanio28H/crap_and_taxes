extends TileMap



func create_splatter(pos : Vector2, type : int = 0) -> void:
	if type == 0:
		type = (randi() % 8) + 1
	
	var sprite = Sprite.new()
	sprite.position = pos
	sprite.texture = load("res://world/splatter/textures/splatters_sangue" + str(type) + ".png")
	add_child(sprite)
