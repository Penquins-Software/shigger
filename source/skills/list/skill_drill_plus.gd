extends SkillCard


func _accept() -> void:
	player.drill_p = true
	player._world.game.hud.remove_skill_icon("Drill")
	selected.emit(self, null)
