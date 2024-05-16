extends SkillCard


func _accept() -> void:
	player.drill = true
	selected.emit(self)
