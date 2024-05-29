extends SkillCard


func _accept() -> void:
	player.sideways_shovel_p = true
	player._world.game.hud.remove_skill_icon("SidewaysShovel")
	selected.emit(self, null)
