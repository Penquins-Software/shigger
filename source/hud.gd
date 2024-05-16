class_name HUD
extends CanvasLayer


@export var game: Game
@export var rhythm: Rhythm
@export var pause_button: Button
@export var points: RichTextLabel
@export var skills: Skills


func set_points(value: int, multiplier: int, hits: int) -> void:
	points.text = "[center]Очков: %s\n\nСерия: %s (X%s)" % [value, hits, multiplier]
