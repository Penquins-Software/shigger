class_name Chunk
extends Node2D


static var hit_color: Color = Color(0.5, 0.5, 0.5)
static var destroy_color: Color = Color(0.8, 0.2, 0.4)


@export var hp: int = 1
@export var points: int = 1

@export var _area: Area2D
@export var destroy_animated_sprite: AnimatedSprite2D

@export var destroy_sound: AudioStream
@export var dig_sound: AudioStream


func _enter_tree():
	_area.area_entered.connect(_area_entered)


func hit() -> void:
	modulate = hit_color
	SFXPlayer.play(dig_sound)
	await RhythmMachine.bit_1_2
	modulate = Color.WHITE


func destoy(explode: bool = false) -> void:
	modulate = destroy_color
	if explode:
		destroy_animated_sprite.play()
	else:
		SFXPlayer.play(destroy_sound)
	await RhythmMachine.bit_1_2
	queue_free()


func dig(player: Player) -> bool:
	hp -= player.damage
	if hp <= 0:
		destoy()
		return true
	
	hit()
	return false


func _area_entered(area: Area2D) -> void:
	if area is MonsterArea:
		destoy(true)
