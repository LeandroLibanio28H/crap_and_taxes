extends KinematicBody2D


# EXPORT
export var _move_speed : float
export(NodePath) onready var _anim_player = get_node(_anim_player) as AnimationPlayer
export(NodePath) onready var _sprite = get_node(_sprite) as Sprite


# PRIVATE
var _velocity := Vector2()
var _flip := false



# GODOT CALLBACKS
func _ready() -> void:
	var npc_type : int = (randi() % 9) + 1
	var texture = load("res://character/npc/textures/npc_" + str(npc_type) + ".png")
	_sprite.texture = texture
	$IATimer.connect("timeout", self, "_handle_IA")
	$IATimer.start()
	pass #Um dia eu coloco algo aqui


func _process(_delta: float) -> void:
	_handle_animations()


func _physics_process(_delta: float) -> void:
	_velocity = move_and_slide(_velocity)


func _handle_IA() -> void:
	var x := randi()
	var y := randi()
	
	var idle : bool = randi() % 2 == 0
	
	var direction = Vector2(x, y).normalized() if not idle else Vector2()
	
	if not idle:
		var mX : bool = randi() % 2 == 0
		direction.x = -direction.x if mX else direction.x
		var mY : bool = randi() % 2 == 0
		direction.y = -direction.y if mY else direction.y
	
	if direction.x != 0:
		_flip = direction.x < 0
	_velocity = direction * _move_speed
	$IATimer.wait_time = rand_range(1.0, 4.0)
	$IATimer.start()



# CLASS METHODS
func _handle_animations() -> void:
	if (_velocity.length() > 0):
		_anim_player.play("move")
	else:
		_anim_player.play("idle")
	
	_sprite.flip_h = _flip
