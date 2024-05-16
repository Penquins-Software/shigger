extends SkillCard


func _accept() -> void:
	player.sideways_shovel = true
	selected.emit(self)
