extends SkillCard


func _accept() -> void:
	player.wide_shovel_p = true
	player._world.game.hud.remove_skill_icon("WideShovel")
	selected.emit(self, null)
