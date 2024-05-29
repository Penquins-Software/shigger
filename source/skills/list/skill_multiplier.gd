extends SkillCard


func _accept() -> void:
	player.extra_multiplier *= 2
	selected.emit(self, null)
