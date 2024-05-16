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


#func _ready():
	#RhythmMachine.bit_1_1.connect(move)


func place(w_pos: Vector2) -> void:
	world_position = w_pos
	position = world_position * Constants.FACTOR


func move() -> void:
	if stop:
		stop_bits -= 1
		if stop_bits <= 0:
			stop_bits = 0
			stop = false
		return
	
	current_bits += 1
	if current_bits >= bits_per_move:
		current_bits = 0
		place(world_position + Vector2.UP)
	
	if bits_duration > 0:
		bits_duration -= 1
		if bits_duration <= 0:
			set_default_speed()


func set_difficult(bpm: RhythmMachine.BPM) -> void:
	match bpm:
		RhythmMachine.BPM.BPM75:
			max_distance_to_player = 16
			audio_player.stream = audio_bpm75
		RhythmMachine.BPM.BPM100:
			max_distance_to_player = 12
			audio_player.stream = audio_bpm100
		RhythmMachine.BPM.BPM120:
			max_distance_to_player = 8
			audio_player.stream = audio_bpm120
		RhythmMachine.BPM.BPM150:
			max_distance_to_player = 8
		RhythmMachine.BPM.BPM200:
			max_distance_to_player = 8
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
