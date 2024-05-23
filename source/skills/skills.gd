class_name Skills
extends Control

signal selected

@export var _hud: HUD
@export var _container: Control
@export var _hits_label: RichTextLabel

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

const NEED_HITS: int = 3
var _hits: int = 0
var _left_skill: SkillCard
var _right_skill: SkillCard
var _is_first: bool = true
var _is_left: bool = false
var _size_1 = Vector2.ONE
var _size_2 = Vector2(1.5, 1.5)
var _size_3 = Vector2(2.0, 2.0)


func _ready():
	RhythmMachine.hit.connect(_hit)
	RhythmMachine.miss.connect(_restore)


func _hit(event: InputEvent) -> void:
	if not visible:
		return
	
	if not event.is_action_pressed("left") and not event.is_action_pressed("right"):
		_restore()
		return
	
	if event.is_action_pressed("left"):
		if not _is_left and not _is_first:
			_is_left = true
			_restore()
			return
		else:
			_left_skill.press()
	elif event.is_action_pressed("right"):
		if _is_left and not _is_first:
			_is_left = false
			_restore()
			return
		else:
			_right_skill.press();
	
	_is_first = false
	_is_left = event.is_action_pressed("left")
	_hits -= 1
	_hits_label.text = "[center]%s" % _hits
	
	if _hits == 2:
		_hits_label.scale = _size_2
	elif _hits == 1:
		_hits_label.scale = _size_3
	elif _hits <= 0:
		if _is_left:
			_left_skill._accept()
		else:
			_right_skill._accept()


func _restore() -> void:
	_is_first = true
	_hits = NEED_HITS
	_hits_label.text = "[center]%s" % _hits
	_hits_label.scale = _size_1


func show_skills() -> void:
	show()
	_current_skills.clear()
	for child in _container.get_children():
		_container.remove_child(child)
	
	_left_skill = place_random_skill()
	_right_skill = place_random_skill()
	
	_restore()


func place_random_skill() -> SkillCard:
	var skill_card = _skill_cards.pop_at(randi_range(0, _skill_cards.size() - 1))
	_current_skills.append(skill_card)
	_container.add_child(skill_card)
	skill_card.player = _hud.game.player
	skill_card.selected.connect(skill_selected)
	return skill_card


func skill_selected(skill_card: SkillCard) -> void:
	hide()
	_left_skill = null
	_right_skill = null
	_current_skills.remove_at(_current_skills.find(skill_card))
	for skill in _current_skills:
		skill.selected.disconnect(skill_selected)
	_skill_cards.append_array(_current_skills)
	_hud.add_skill_icon(skill_card)
	selected.emit()


func get_skills_count() -> int:
	return _skill_cards.size()
