class_name MusicPlayer
extends AudioStreamPlayer

@export var audio_earth: AudioStream
@export var audio_magma: AudioStream
@export var audio_cheese: AudioStream


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
		_:
			return RhythmMachine.BPM.BPM75
	play()
	return bpm
