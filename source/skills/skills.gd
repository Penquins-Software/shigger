class_name Skills
extends Control

signal selected

@export var _hud: HUD
@export var _container: Control

var _current_skills: Array[SkillCard]
var _skill_cards: Array[SkillCard] = [
	ResourceLoader.load("res://content/skills_cards/drill.tscn").instantiate() as SkillCard,
	ResourceLoader.load("res://content/skills_cards/flashlight.tscn").instantiate() as SkillCard,
	ResourceLoader.load("res://content/skills_cards/fugu.tscn").instantiate() as SkillCard,
	ResourceLoader.load("res://content/skills_cards/mega_shovel.tscn").instantiate() as SkillCard,
	ResourceLoader.load("res://content/skills_cards/sideways_shovel.tscn").instantiate() as SkillCard,
	ResourceLoader.load("res://content/skills_cards/wide_shovel.tscn").instantiate() as SkillCard,
	ResourceLoader.load("res://content/skills_cards/multiplier.tscn").instantiate() as SkillCard,
]


func show_skills() -> void:	
	show()
	_current_skills.clear()
	for child in _container.get_children():
		_container.remove_child(child)
	
	for index in range(0, 2):
		if _skill_cards.size() <= 0:
			return
		var skill_card = _skill_cards.pop_at(randi_range(0, _skill_cards.size() - 1))
		_current_skills.append(skill_card)
		_container.add_child(skill_card)
		skill_card.player = _hud.game.player
		skill_card.selected.connect(skill_selected)


func skill_selected(skill_card: SkillCard) -> void:
	_current_skills.remove_at(_current_skills.find(skill_card))
	for skill in _current_skills:
		skill.selected.disconnect(skill_selected)
	_skill_cards.append_array(_current_skills)
	hide()
	selected.emit()


func get_skills_count() -> int:
	return _skill_cards.size()
