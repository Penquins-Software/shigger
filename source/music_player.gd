extends AudioStreamPlayer

@export var audio_bpm75: AudioStream
@export var audio_bpm100: AudioStream
@export var audio_bpm120: AudioStream


func play_bpm(bpm: RhythmMachine.BPM) -> void:
	match bpm:
		RhythmMachine.BPM.BPM75:
			stream = audio_bpm75
		RhythmMachine.BPM.BPM100:
			stream = audio_bpm100
		RhythmMachine.BPM.BPM120:
			stream = audio_bpm120
		RhythmMachine.BPM.BPM150:
			pass
		RhythmMachine.BPM.BPM200:
			pass
	play()
