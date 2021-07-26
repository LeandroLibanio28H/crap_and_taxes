extends TileMap



func create_splatter(pos : Vector2, type : int = 0) -> void:
	if type == 0:
		type = (randi() % 8) + 1
	
	var sprite = Sprite.new()
	sprite.position = pos
	if type != 100:
		sprite.texture = load("res://world/splatter/textures/splatters_sangue" + str(type) + ".png")
	
	if (type == 100):
		sprite.texture = load("res://character/playable/textures/splatter_peidomestre.png")
	add_child(sprite)
	
	var particle = Particles2D.new()
	particle.amount = 128
	particle.lifetime = 0.7
	particle.one_shot = true
	particle.randomness = 1
	particle.speed_scale = 2
	particle.process_material = load("res://data/particles/splatter.tres")
	particle.emitting = true
	
	particle.position = pos
	get_tree().get_current_scene().add_child(particle)

