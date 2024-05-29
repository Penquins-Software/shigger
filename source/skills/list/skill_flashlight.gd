extends SkillCard


func _accept() -> void:
	player.get_flashlight()
	selected.emit(self, null)
