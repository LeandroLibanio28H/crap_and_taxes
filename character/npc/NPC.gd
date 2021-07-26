class_name NPC extends KinematicBody2D


var _gibs_scene = preload("res://character/gibs/Gibs.tscn")
var _reaction_scene = preload("res://character/npc/Reaction.tscn")

# EXPORT
export var _move_speed : float
export(NodePath) onready var _anim_player = get_node(_anim_player) as AnimationPlayer
export(NodePath) onready var _sprite = get_node(_sprite) as Sprite


# PRIVATE
var _velocity := Vector2()
var _flip := false
var _explostion_rate : int = 0


enum States {
	DEFAULT,
	REACTION
}
var state : int = States.DEFAULT
var exploded : bool = false


# GODOT CALLBACKS
func _ready() -> void:
	var npc_type : int = (randi() % 11) + 1
	_explostion_rate = randi() % 11
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
	if (state == States.DEFAULT):
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


func _reaction(pos : Vector2, flatulencia : PlayableCharacter.Flatulencia) -> void:
	get_tree().get_current_scene().current_score += (flatulencia.distance * 10 + 
			flatulencia.duracao * 10 + flatulencia.smell * 10)
	if flatulencia.smell >= _explostion_rate:
		_explode(flatulencia)
	var direction = global_position - pos
	state = States.REACTION
	_velocity = direction.normalized() * _move_speed * 1.5


func _explode(flatulencia : PlayableCharacter.Flatulencia) -> void:
	get_tree().get_current_scene().current_score += (flatulencia.distance * 10 + 
			flatulencia.duracao * 10 + flatulencia.smell * 10 + flatulencia.force)
	exploded = true
	for __ in range((randi() % 4) + 1):
		var gib = _gibs_scene.instance()
		gib.position = position
		get_parent().add_child(gib)
		get_parent().get_parent().get_parent().get_node("Floor").create_splatter(position)
	var reaction = _reaction_scene.instance()
	reaction.position = global_position
	reaction.flatulencia = flatulencia
	get_parent().add_child(reaction)
	queue_free()


# CLASS METHODS
func _handle_animations() -> void:
	if (_velocity.length() > 0):
		_anim_player.play("move")
	else:
		_anim_player.play("idle")
	_sprite.flip_h = _flip
