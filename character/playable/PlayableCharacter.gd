class_name PlayableCharacter extends KinematicBody2D


# EXPORT
export var _move_speed : float
export(NodePath) onready var _anim_player = get_node(_anim_player) as AnimationPlayer
export(NodePath) onready var _sprite = get_node(_sprite) as Sprite
export(NodePath) onready var _action_bar = get_node(_action_bar) as Node2D


# STATES
enum States {
	DEFAULT,
	ACTION,
	END,
	DYING
}
var state : int = States.DEFAULT

# PRIVATE
var _velocity := Vector2()
var _flip := false

var action_value : float = 0.0
var increasing : bool = true


# PUBLIC
var flatulencia := Flatulencia.new()



# GODOT CALLBACKS
func _ready() -> void:
	pass #Um dia eu coloco algo aqui


func _process(delta: float) -> void:
	if state == States.DEFAULT:
		_handle_animations()
	elif state == States.ACTION:
		action_value += 50 * delta * (1 if increasing else -1)
		if action_value >= 100:
			increasing = false
		elif action_value <= 0:
			increasing = true
		
		_action_bar.get_node("ActionProgress").value = action_value


func _physics_process(_delta: float) -> void:
	if state == States.DEFAULT:
		_velocity = move_and_slide(_velocity)


func _unhandled_input(event: InputEvent) -> void:
	var x = Input.get_action_strength("MOVE_E") - Input.get_action_strength("MOVE_W")
	var y = Input.get_action_strength("MOVE_S") - Input.get_action_strength("MOVE_N")
	
	var direction = Vector2(x, y).normalized()
	
	if direction.x != 0:
		_flip = direction.x < 0
	_velocity = direction * _move_speed
	
	if (state != States.END and state != States.DYING):
		if event.is_action_pressed("ACTION"):
			_anim_player.play("action")
			_anim_player.connect("animation_finished", self, "_end_action")
			_action_bar.show()
			state = States.ACTION
		if event.is_action_released("ACTION"):
			_flatulencia()



# CLASS METHODS
func _handle_animations() -> void:
	if (_velocity.length() > 0):
		_anim_player.play("move")
	else:
		_anim_player.play("idle")
	
	_sprite.scale.x = -1 if _flip else 1


func _end_action(anim_name : String) -> void:
	if anim_name == "action":
		_anim_player.play("eyes")


func _flatulencia() -> void:
	state = States.END
	_action_bar.hide()
	var distance = flatulencia.distance * 10
	var smell = flatulencia.smell * 10
	var duracao = flatulencia.duracao * 10
	var radius  = 128
	($Flatulencia/CollisionShape2D.shape as CircleShape2D).radius = radius * distance / 100
	call_deferred("_flatulencia_explosion", global_position)
	if duracao < 40:
		$FlatoMedio.play()
	else:
		$FlatoLongo.play()
	


func _flatulencia_explosion(pos : Vector2) -> void:
	var bodies = $Flatulencia.get_overlapping_bodies()
	
	for npc in bodies:
		if npc is NPC:
			npc._reaction(pos, flatulencia.smell)


class Flatulencia:
	var smell : int = 0
	var duracao : int = 0
	var distance : int = 10
