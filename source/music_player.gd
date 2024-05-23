class_name MusicPlayer
extends AudioStreamPlayer

@export var audio_earth: AudioStream
@export var audio_magma: AudioStream
@export var audio_cheese: AudioStream
@export var audio_back_earth: AudioStream
@export var audio_back_magma: AudioStream
@export var audio_back_cheese: AudioStream


func play_biome(biome: Biome.Biomes) -> RhythmMachine.BPM:
	var bpm: RhythmMachine.BPM
	match biome:
		Biome.Biomes.EARTH:
			stream = audio_earth
			bpm = RhythmMachine.BPM.BPM75
		Biome.Biomes.MAGMA:
			stream = audio_magma
			bpm = RhythmMachine.BPM.BPM100
		Biome.Biomes.CHEESE:
			stream = audio_cheese
			bpm = RhythmMachine.BPM.BPM120
		Biome.Biomes.CENTER:
			stream = audio_cheese
			bpm = RhythmMachine.BPM.BPM120
		Biome.Biomes.BACK_CHEESE:
			stream = audio_back_cheese
			bpm = RhythmMachine.BPM.BPM120
		Biome.Biomes.BACK_MAGMA:
			stream = audio_back_magma
			bpm = RhythmMachine.BPM.BPM100
		Biome.Biomes.BACK_EARTH:
			stream = audio_back_earth
			bpm = RhythmMachine.BPM.BPM75
		_:
			return RhythmMachine.BPM.BPM75
	play()
	return bpm


func play_from_playback() -> void:
	var parts = get_playback_position() / RhythmMachine.get_current_bpm_in_seconds()
	play(int(parts) * RhythmMachine.get_current_bpm_in_seconds())
