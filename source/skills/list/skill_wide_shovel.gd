extends SkillCard


func _accept() -> void:
	player.wide_shovel = true
	selected.emit(self)
