class_name Rhythm
extends Control

@export var rhythm_button: TextureRect

@export var idle_texture: Texture2D
@export var hover_texture: Texture2D

var increased_size: Vector2 = Vector2(1.25, 1.25)


func _ready():
	RhythmMachine.bit_1_5.connect(bit_1_5)
	RhythmMachine.bit_4_5.connect(bit_4_5)


func bit_1_5() -> void:
	rhythm_button.scale = Vector2.ONE
	rhythm_button.texture = idle_texture


func bit_4_5() -> void:
	rhythm_button.scale = increased_size


func pressed_in_bit() -> void:
	rhythm_button.texture = hover_texture
