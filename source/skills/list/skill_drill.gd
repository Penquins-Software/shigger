extends SkillCard


func _accept() -> void:
	player.drill = true
	selected.emit(self, ResourceLoader.load("res://content/skills_cards/drill_plus.tscn").instantiate())
