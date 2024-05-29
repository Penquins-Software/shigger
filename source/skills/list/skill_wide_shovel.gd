extends SkillCard


func _accept() -> void:
	player.wide_shovel = true
	selected.emit(self, ResourceLoader.load("res://content/skills_cards/wide_shovel_plus.tscn").instantiate())
