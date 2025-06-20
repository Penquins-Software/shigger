class_name Monster
extends Node2D

@export var audio_player: AudioStreamPlayer2D

@export var audio_bpm75: AudioStream
@export var audio_bpm100: AudioStream
@export var audio_bpm120: AudioStream

@export var animation_player: AnimationPlayer

var world_position: Vector2

var stop_bits: int = 0
var stop: bool = false

const DEFAULT_BITS_PEF_MOVE: int = 2

var bits_per_move: int = 2
var bits_duration: int = 0
var current_bits: int = 0

var max_distance_to_player: int = 16


func _ready():
	RhythmMachine.bit_1_1.connect(move)


func place(w_pos: Vector2) -> void:
	world_position = w_pos
	position = world_position * Constants.FACTOR


func move() -> void:
	if not get_parent().process_mode == PROCESS_MODE_INHERIT:
		return
	
	if stop:
		stop_bits -= 1
		if stop_bits <= 0:
			stop_bits = 0
			stop = false
		return
	
	current_bits += 1
	if current_bits >= bits_per_move:
		current_bits = 0
		place(world_position + Vector2.DOWN)
	
	if bits_duration > 0:
		bits_duration -= 1
		if bits_duration <= 0:
			set_default_speed()


func set_difficult(biome: Biome.Biomes) -> void:
	match biome:
		Biome.Biomes.EARTH:
			max_distance_to_player = 14
			audio_player.stream = audio_bpm75
			bits_per_move = 2
		Biome.Biomes.MAGMA:
			max_distance_to_player = 12
			audio_player.stream = audio_bpm100
			bits_per_move = 2
		Biome.Biomes.CHEESE:
			max_distance_to_player = 10
			audio_player.stream = audio_bpm120
			bits_per_move = 2
		Biome.Biomes.CENTER:
			max_distance_to_player = 10
			audio_player.stream = audio_bpm120
			bits_per_move = 4
		Biome.Biomes.BACK_CHEESE:
			max_distance_to_player = 10
			audio_player.stream = audio_bpm120
			bits_per_move = 2
		Biome.Biomes.BACK_MAGMA:
			max_distance_to_player = 8
			audio_player.stream = audio_bpm100
			bits_per_move = 2
		Biome.Biomes.BACK_EARTH:
			max_distance_to_player = 6
			audio_player.stream = audio_bpm75
			bits_per_move = 2
		Biome.Biomes.SEA:
			max_distance_to_player = 6
			audio_player.stream = audio_bpm100
			bits_per_move = 2
		Biome.Biomes.SKY:
			max_distance_to_player = 6
			audio_player.stream = audio_bpm100
			bits_per_move = 2
		Biome.Biomes.SPACE:
			max_distance_to_player = 6
			audio_player.stream = audio_bpm100
			bits_per_move = 2
		_:
			max_distance_to_player = 8
			audio_player.stream = audio_bpm100
			bits_per_move = 2
	audio_player.play()


func set_speed(speed: int, bits: int) -> void:
	current_bits = 0
	bits_per_move = speed
	bits_duration = bits


func set_default_speed() -> void:
	current_bits = 0
	bits_per_move = DEFAULT_BITS_PEF_MOVE
	bits_duration = 0


func set_size(width: int) -> void:
	match width:
		3:
			animation_player.play("3")
		5:
			animation_player.play("5")
		7:
			animation_player.play("7")
		9:
			animation_player.play("9")
