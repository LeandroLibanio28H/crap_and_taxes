extends Interactible


export(Resource) onready var _food = _food as Food



func _ready() -> void:
	$Sprite.texture = _food.texture
	._ready()



func _interact(area : Area2D) -> void:
	._interact(area)
