extends SkillCard


func _accept() -> void:
	player.damage += 1
	selected.emit(self)
