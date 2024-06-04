class_name TrapCell
extends Trap

@export var destroy_sound: AudioStream
@export var dig_sounds: Array[AudioStream]

static var destroy_color = Color(0.8, 0.2, 0.4)
static var no_damage_color = Color(0.3, 0.3, 0.3)

var bits: int = 0


func setting() -> void:
	RhythmMachine.bit_1_1.connect(bit)


func move_to() -> bool:
	if active:
		hit_no_damage()
	else:
		destroy()
	return false


func destroy() -> void:
	modulate = destroy_color
	SFXPlayer.play(destroy_sound)
	await RhythmMachine.bit_1_2
	queue_free()


func hit_no_damage() -> void:
	modulate = no_damage_color
	SFXPlayer.play(dig_sounds.pick_random())
	await RhythmMachine.bit_1_2
	modulate = Color.WHITE


func bit() -> void:
	bits += 1
	
	if bits >= 4:
		bits = 0
		
	if bits >= 2:
		active = true
	else:
		active = false
