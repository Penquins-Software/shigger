extends SkillCard


func _accept() -> void:
	player.damage += 1
	player._world.game.hud.remove_skill_icon("MegaShovel")
	selected.emit(self, null)
