extends Area2D



export(Resource) onready var _interaction = _interaction as Interaction


func _ready() -> void:
	$Popup/Label.text = _interaction._tooltip
	$Popup/Icon.texture = _interaction._icon


func _on_Interactible_area_entered(area: Area2D) -> void:
	area.monitoring = false
	area.monitorable = false
	$Popup.show()


func _on_Interactible_area_exited(area: Area2D) -> void:
	area.monitoring = true
	area.monitorable = true
	$Popup.hide()


func _interact(area : Area2D) -> void:
	pass


func interact(area : Area2D) -> void:
	_interact(area)
