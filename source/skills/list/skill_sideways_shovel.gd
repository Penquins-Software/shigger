extends SkillCard


func _accept() -> void:
	player.sideways_shovel = true
	selected.emit(self, ResourceLoader.load("res://content/skills_cards/sideways_shovel_plus.tscn").instantiate())
