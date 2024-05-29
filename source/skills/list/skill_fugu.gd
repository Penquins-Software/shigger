extends SkillCard


func _accept() -> void:
	player.fugu = true
	selected.emit(self, null)
