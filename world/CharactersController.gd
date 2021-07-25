extends YSort


var _npc_scene = preload("res://character/npc/NPC.tscn")


func _ready() -> void:
	for child in $Spawns.get_children():
		var nposition = child.global_position
		var npc = _npc_scene.instance()
		npc._move_speed = rand_range(35.0, 65.0)
		npc.position = nposition
		add_child(npc)
