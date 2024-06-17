class_name TrapCell
extends Trap

@export var destroy_sound: AudioStream
@export var dig_sounds: Array[AudioStream]

@export var _points: int = 8

static var destroy_color = Color(0.8, 0.2, 0.4)
static var no_damage_color = Color(0.3, 0.3, 0.3)

var bits: int = 0


func setting() -> void:
	RhythmMachine.bit_1_1.connect(bit)
	RhythmMachine.bit_changed.connect(set_animation_speed)
	set_animation_speed(RhythmMachine.current_bpm)
	set_status(false)


func move_to() -> bool:
	if active:
		hit_no_damage()
		return false
	else:
		destroy()
		return true


func destroy() -> void:
	modulate = destroy_color
	SFXPlayer.play(destroy_sound)
	_world.traps.erase(_world_position)
	var result_points = _points * (1 + int(position.y) / 2048)
	result_points = _world.game.add_points(result_points, position)
	await RhythmMachine.bit_1_2
	queue_free()


func hit_no_damage() -> void:
	Message.create(_player, position, "[center][color=#666666]%s" % tr("Нет урона..."))
	modulate = no_damage_color
	SFXPlayer.play(dig_sounds.pick_random())
	await RhythmMachine.bit_1_2
	modulate = Color.WHITE


func bit() -> void:
	bits += 1
	
	if bits >= 6:
		bits = 0
		
	if bits >= 2:
		set_status(true)
	else:
		set_status(false)


func set_status(status: bool) -> void:
	active = status
	if active:
		play("on")
	else:
		play("off")


func set_animation_speed(_bpm: RhythmMachine.BPM) -> void:
	var frame_count = sprite_frames.get_frame_count("off")
	var speed = 2 * frame_count / RhythmMachine.get_current_bpm_in_seconds()
	sprite_frames.set_animation_speed("off", speed)
	sprite_frames.set_animation_speed("on", speed)
