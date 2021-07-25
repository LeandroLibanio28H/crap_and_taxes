class_name PlayableCharacter extends KinematicBody2D


# EXPORT
export var _move_speed : float
export(NodePath) onready var _anim_player = get_node(_anim_player) as AnimationPlayer
export(NodePath) onready var _sprite = get_node(_sprite) as Sprite


# STATES
enum States {
	DEFAULT,
	INTERACT,
	ACTION
}


# PRIVATE
var _velocity := Vector2()
var _flip := false


# PUBLIC
var flatulencia := Flatulencia.new()



# GODOT CALLBACKS
func _ready() -> void:
	pass #Um dia eu coloco algo aqui


func _process(_delta: float) -> void:
	_handle_animations()


func _physics_process(_delta: float) -> void:
	_velocity = move_and_slide(_velocity)


func _unhandled_input(_event: InputEvent) -> void:
	var x = Input.get_action_strength("MOVE_E") - Input.get_action_strength("MOVE_W")
	var y = Input.get_action_strength("MOVE_S") - Input.get_action_strength("MOVE_N")
	
	var direction = Vector2(x, y).normalized()
	
	if direction.x != 0:
		_flip = direction.x < 0
	_velocity = direction * _move_speed



# CLASS METHODS
func _handle_animations() -> void:
	if (_velocity.length() > 0):
		_anim_player.play("move")
	else:
		_anim_player.play("idle")
	
	_sprite.flip_h = _flip



class Flatulencia:
	var smell : int = 0
	var duracao : int = 0
	var distance : int = 0
