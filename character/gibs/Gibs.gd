extends RigidBody2D



func _ready() -> void:
	position.x += (1 if randi() % 2 == 0 else -1)
	position.y += (1 if randi() % 2 == 0 else 1)
	var index = (randi() % 12) + 1
	$Sprite.texture = load("res://character/gibs/textures/gibs" + str(index) + ".png")
