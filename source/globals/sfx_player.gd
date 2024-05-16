extends Node


func play(sfx: AudioStream) -> void:
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.bus = &"SFX"
	audio_player.stream = sfx
	audio_player.finished.connect(_destroy_player.bind(audio_player))
	audio_player.play()


func _destroy_player(audio_player: AudioStreamPlayer) -> void:
	audio_player.queue_free()
