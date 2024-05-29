class_name HUD
extends CanvasLayer


@export var game: Game
@export var rhythm: Rhythm
@export var pause_button: Button
@export var points: RichTextLabel
@export var multiplier_label: RichTextLabel
@export var series_label: RichTextLabel
@export var series_texture_bar: TextureProgressBar
@export var skills: Skills
@export var preparation_screen: PreparationScreen
@export var info_panel: VBoxContainer

var info_skills: Dictionary 


func _ready():
	set_points(0, 1, 0, 1)
	RhythmMachine.miss.connect(miss)


func set_points(value: int, multiplier: int, hits: int, series_part: int) -> void:
	var format_value = HelpFunctions.format_integer(value)
	var format_hits = HelpFunctions.format_integer(hits)
	#points.text = "[center]%s: %s\n\n%s: %s (X%s)" % [tr("Очков"), format_value, tr("Серия"), format_hits, multiplier]
	points.text = "[center]%s: %s" % [tr("Очков"), format_value]
	multiplier_label.text = "[center]x%s" % multiplier
	series_label.text = "[center]%s" % format_hits
	series_texture_bar.value = series_part * 25


func add_skill_icon(skill_card: SkillCard) -> void:
	var texture_rect = TextureRect.new()
	texture_rect.texture = skill_card._texture
	info_panel.add_child(texture_rect)
	info_skills[skill_card] = texture_rect


func darker_skill_icon(skill_name: String) -> void:
	for skill in info_skills:
		if skill.name == skill_name:
			info_skills[skill].modulate = Color(0.2, 0.2, 0.2)
			return


func remove_skill_icon(skill_name: String) -> void:
	for skill in info_skills:
		if skill.name == skill_name:
			info_skills[skill].queue_free()
			return


func set_add_info(value: bool) -> void:
	multiplier_label.visible = value
	series_label.visible = value


func miss() -> void:
	#multiplier_label.text = "[center]x%s" % multiplier
	#series_label.modulate = Color.BLACK
	#await  RhythmMachine.bit_1_2
	#series_label.modulate = Color.WHITE
	pass
