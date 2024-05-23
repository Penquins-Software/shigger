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


func play_kicking(bpm: RhythmMachine.BPM) -> void:
	stream = kick_by_bpm[bpm]
	play(RhythmMachine.current_time)
