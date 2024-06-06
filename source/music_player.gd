class_name MusicPlayer
extends AudioStreamPlayer

@export var audio_earth: AudioStream
@export var audio_magma: AudioStream
@export var audio_cheese: AudioStream
@export var audio_back_cheese: AudioStream
@export var audio_back_magma: AudioStream
@export var audio_back_earth: AudioStream
@export var audio_sea: AudioStream
@export var audio_sky: AudioStream

@onready var audio_by_biome: Dictionary = {
	Biome.Biomes.EARTH : [audio_earth, RhythmMachine.BPM.BPM75],
	Biome.Biomes.MAGMA : [audio_magma, RhythmMachine.BPM.BPM100],
	Biome.Biomes.CHEESE : [audio_cheese, RhythmMachine.BPM.BPM120],
	Biome.Biomes.CENTER : [audio_cheese, RhythmMachine.BPM.BPM120],
	Biome.Biomes.BACK_CHEESE : [audio_back_cheese, RhythmMachine.BPM.BPM120],
	Biome.Biomes.BACK_MAGMA : [audio_back_magma, RhythmMachine.BPM.BPM100],
	Biome.Biomes.BACK_EARTH : [audio_back_earth, RhythmMachine.BPM.BPM75],
	Biome.Biomes.SEA : [audio_sea, RhythmMachine.BPM.BPM150],
	Biome.Biomes.SKY : [audio_sky, RhythmMachine.BPM.BPM120],
	Biome.Biomes.SPACE : [audio_magma, RhythmMachine.BPM.BPM100],
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


func play_biome(biome: Biome.Biomes) -> RhythmMachine.BPM:
	var audio: AudioStream = audio_by_biome[biome][0]
	var bpm: RhythmMachine.BPM = audio_by_biome[biome][1]
	if not audio == stream:
		stream = audio
		play()
	return bpm


func play_from_playback() -> void:
	var parts = get_playback_position() / RhythmMachine.get_current_bpm_in_seconds()
	play(round(parts) * RhythmMachine.get_current_bpm_in_seconds())
