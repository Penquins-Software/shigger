class_name HUD
extends CanvasLayer


@export var game: Game
@export var rhythm: Rhythm
@export var pause_button: Button
@export var points: RichTextLabel
@export var skills: Skills
@export var preparation_screen: PreparationScreen
@export var info_panel: VBoxContainer

var info_skills: Dictionary 


func _ready():
	set_points(0, 1, 0)


func set_points(value: int, multiplier: int, hits: int) -> void:
	var format_value = HelpFunctions.format_integer(value)
	var format_hits = HelpFunctions.format_integer(hits)
	points.text = "[center]%s: %s\n\n%s: %s (X%s)" % [tr("Очков"), format_value, tr("Серия"), format_hits, multiplier]


func add_skill_icon(skill_card: SkillCard) -> void:
	var texture_rect = TextureRect.new()
	texture_rect.texture = skill_card._texture
	info_panel.add_child(texture_rect)
	info_skills[skill_card] = texture_rect


func remove_skill_icon(skill_name: String) -> void:
	for skill in info_skills:
		if skill.name == skill_name:
			info_skills[skill].modulate = Color(0.2, 0.2, 0.2)
