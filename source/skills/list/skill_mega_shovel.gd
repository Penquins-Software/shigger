extends SkillCard


func _accept() -> void:
	player.damage += 1
	selected.emit(self, ResourceLoader.load("res://content/skills_cards/mega_shovel_plus.tscn").instantiate())
