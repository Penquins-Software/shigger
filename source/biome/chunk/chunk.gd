class_name Chunk
extends Node2D


static var hit_color = Color(0.5, 0.5, 0.5)
static var destroy_color = Color(0.8, 0.2, 0.4)
static var no_damage_color = Color(0.3, 0.3, 0.3)


@export var hp: int = 1
@export var points: int = 1
@export var destructible: bool = true

@export var _area: Area2D
@export var destroy_animated_sprite: AnimatedSprite2D

@export var destroy_sound: AudioStream
@export var dig_sounds: Array[AudioStream]


func _enter_tree():
	_area.area_entered.connect(_area_entered)


func hit(play_sound: bool = true) -> void:
	modulate = hit_color
	if play_sound:
		SFXPlayer.play(dig_sounds.pick_random())
	await RhythmMachine.bit_1_2
	modulate = Color.WHITE


func destoy(explode: bool = false, play_sound: bool = true) -> void:
	modulate = destroy_color
	if explode:
		destroy_animated_sprite.play()
	elif play_sound: 
		SFXPlayer.play(destroy_sound)
	await RhythmMachine.bit_1_2
	queue_free()


func hit_no_damage() -> void:
	modulate = no_damage_color
	SFXPlayer.play(dig_sounds.pick_random())
	await RhythmMachine.bit_1_2
	modulate = Color.WHITE


func dig(player: Player, play_sound: bool = true) -> bool:
	if not destructible:
		Message.create(player, position, "[center][color=#666666]%s" % tr("Нет урона..."))
		hit_no_damage()
		return false
	
	hp -= player.damage
	if hp <= 0:
		destoy(false, play_sound)
		return true
	
	hit(play_sound)
	return false


func _area_entered(area: Area2D) -> void:
	if area is MonsterArea:
		destoy(true)
