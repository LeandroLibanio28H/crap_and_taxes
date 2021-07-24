class_name Interactible extends Area2D



export(Resource) onready var _interaction = _interaction as Interaction

var interacting := false
var interacted := false


func _ready() -> void:
	set_physics_process(false)
	$Popup/Label.text = _interaction._tooltip
	$Popup/Icon.texture = _interaction._icon


func _on_Interactible_area_entered(_area: Area2D) -> void:
	$Popup.show()
	$Action/ActionBar.value = 0
	set_physics_process(true)


func _on_Interactible_area_exited(_area: Area2D) -> void:
	$Popup.hide()
	$Action.hide()
	$Action/ActionBar.value = 0
	$Popup/Icon.texture = _interaction._icon
	interacting = false
	interacted = false
	set_physics_process(false)


func _interact(_area : Area2D) -> void:
	pass


func interact(area : Area2D) -> void:
	_interact(area)


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("INTERACT"):
		interacted = true
		interacting = true
		$Popup/Icon.texture = _interaction._icon_pressed
		$Action.show()
		$Action/ActionBar.value = 0
		return
	if Input.is_action_just_released("INTERACT"):
		interacted = false
		interacting = false
		$Popup/Icon.texture = _interaction._icon
		$Action.hide()
		$Action/ActionBar.value = 0
		return
	if Input.is_action_pressed("INTERACT"):
		interacted = true
		interacting = true
		$Popup/Icon.texture = _interaction._icon_pressed
		$Popup.show()
		$Action.show()
		$Action/ActionBar.value += 20 * delta
