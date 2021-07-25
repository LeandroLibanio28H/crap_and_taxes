extends Interactible


export(Resource) onready var _food = _food as Food



func _ready() -> void:
	$Sprite.texture = _food.texture
	._ready()



func _interact() -> void:
	
	player.flatulencia.duracao += _food.density
	player.flatulencia.distance += _food.gasification
	player.flatulencia.smell += _food.acidity
	
	queue_free()
	._interact()
