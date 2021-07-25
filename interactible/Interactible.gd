class_name Interactible extends Area2D



export(Resource) onready var _interaction = _interaction as Interaction

var value : float = 0.0
var player : PlayableCharacter


func _ready() -> void:
	set_physics_process(false)
	$Popup/Label.text = _interaction._tooltip
	$Popup/Icon.texture = _interaction._icon


func _on_Interactible_area_entered(area: Area2D) -> void:
	player = area.get_parent() as PlayableCharacter
	$Popup/Label.self_modulate = Color.white
	$Popup.show()
	$Action/ActionBar.value = 0
	value = 0
	set_physics_process(true)


func _on_Interactible_area_exited(_area: Area2D) -> void:
	player = null
	$Popup.hide()
	$Action.hide()
	$Popup/Label.self_modulate = Color.white
	$Action/ActionBar.value = 0
	value = 0
	$Popup/Icon.texture = _interaction._icon
	set_physics_process(false)


func _interact() -> void:
	pass


func interact() -> void:
	_interact()


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("INTERACT"):
		$Popup/Icon.texture = _interaction._icon_pressed
		$Popup/Label.self_modulate = Color("822e24")
		$Action.show()
		$Action/ActionBar.value = 0
		value = 0
		return
	if Input.is_action_just_released("INTERACT"):
		$Popup/Icon.texture = _interaction._icon
		$Popup/Label.self_modulate = Color.white
		$Action.hide()
		$Action/ActionBar.value = 0
		value = 0
		return
	if Input.is_action_pressed("INTERACT"):
		$Popup/Icon.texture = _interaction._icon_pressed
		$Popup/Label.self_modulate = Color("822e24")
		$Popup.show()
		$Action.show()
		value += 20 * delta
		$Action/ActionBar.value = value




func _on_ActionBar_value_changed(new_value: float) -> void:
	if new_value >= 100:
		interact()
