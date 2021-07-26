extends Area2D


var flatulencia : PlayableCharacter.Flatulencia


func _reaction_explosion(npc : Node) -> void:
	if not npc.exploded:
		if npc.has_method("_reaction"):
			npc._reaction(position, flatulencia)


func _on_Reaction_body_entered(body: Node) -> void:
	_reaction_explosion(body)
