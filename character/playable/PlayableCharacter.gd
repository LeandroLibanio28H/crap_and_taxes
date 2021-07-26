class_name PlayableCharacter extends KinematicBody2D


# EXPORT
export var _move_speed : float
var move_speed : float
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
	move_speed = _move_speed


func _process(delta: float) -> void:
	if state == States.DEFAULT:
		_handle_animations()
	elif state == States.ACTION:
		action_value += 120 * delta * (1 if increasing else -1)
		if action_value >= 100:
			increasing = false
		elif action_value <= 0:
			increasing = true
		
		_action_bar.get_node("ActionProgress").value = action_value


func _physics_process(_delta: float) -> void:
	if state == States.DEFAULT:
		_velocity = move_and_slide(_velocity)


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		print("distance: ", flatulencia.distance)
		print("duration: ", flatulencia.duracao)
		print("smell: ", flatulencia.smell)
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
	if anim_name == "gore":
		get_parent().get_parent().get_parent().get_node("Floor").create_splatter(position, 100)
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().get_current_scene().game_over()


func eat(dur, dis, smell) -> void:
	flatulencia.distance += dis
	flatulencia.duracao += dur
	flatulencia.smell += smell
	
	if flatulencia.distance > 10 or flatulencia.duracao > 10 or flatulencia.smell > 10:
		_move_speed *= 0.5
		$ExplosionTimer.start()
	else:
		_move_speed = move_speed
		$ExplosionTimer.stop()


func _flatulencia() -> void:
	state = States.END
	flatulencia.force = $Sprite/ActionBar/ActionProgress.value
	_action_bar.hide()
	var distance = flatulencia.distance * 10
	#var smell = flatulencia.smell * 10
	var duracao = flatulencia.duracao * 10
	var radius  = 128
	($Flatulencia/CollisionShape2D.shape as CircleShape2D).radius = radius * distance / 100
	call_deferred("_flatulencia_explosion", global_position)
	if duracao < 40:
		$FlatoMedio.play()
		$FlatoTimer.wait_time = 3.0
	else:
		$FlatoLongo.play()
		$FlatoTimer.wait_time = 5.0
	if duracao <= 0:
		$FlatoTimer.wait_time = 0.25
	
	$FlatoTimer.start()


func _flatulencia_explosion(pos : Vector2) -> void:
	var bodies = $Flatulencia.get_overlapping_bodies()
	for npc in bodies:
		if npc.has_method("_reaction"):
			npc._reaction(pos, flatulencia)


class Flatulencia:
	var smell : int = 10
	var duracao : int = 10
	var distance : int = 10
	var force : int = 0


func _on_FlatoTimer_timeout() -> void:
	get_tree().get_current_scene().end_game()


func _on_ExplosionTimer_timeout() -> void:
	state = States.DYING
	_anim_player.connect("animation_finished", self, "_end_action")
	_anim_player.play("gore")
