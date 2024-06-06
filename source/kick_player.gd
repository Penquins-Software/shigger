class_name KickPlayer
extends AudioStreamPlayer

@export var kick_75: AudioStream
@export var kick_100: AudioStream
@export var kick_120: AudioStream
@export var kick_150: AudioStream

@onready var kick_by_bpm: Dictionary = {
	RhythmMachine.BPM.BPM75 : kick_75,
	RhythmMachine.BPM.BPM100 : kick_100,
	RhythmMachine.BPM.BPM120 : kick_120,
	RhythmMachine.BPM.BPM150 : kick_150,
}


func _ready():
	RhythmMachine.bit_1_1.connect(sync)


func sync() -> void:
	if playing:
		var parts = get_playback_position() / RhythmMachine.get_current_bpm_in_seconds()
		var i_part = round(parts)
		var f_part = abs(parts - i_part)
		if f_part > 0.1:
			play(i_part * RhythmMachine.get_current_bpm_in_seconds())


func play_kicking(bpm: RhythmMachine.BPM) -> void:
	stream = kick_by_bpm[bpm]
	play(RhythmMachine.current_time)
