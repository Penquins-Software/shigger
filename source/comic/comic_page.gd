class_name ComicPage
extends Control

@export var _animation_player: AnimationPlayer
@onready var frames: int = _animation_player.get_animation_list().size() - 1

var current_frame: int = 0


func prev_frame() -> bool:
	var new_frame = current_frame - 1
	if new_frame > -1 and new_frame < frames:
		current_frame = new_frame
		play_current_frame(true)
		return false
	else:
		return true


func next_frame() -> bool:
	var new_frame = current_frame + 1
	if new_frame < frames:
		current_frame = new_frame
		play_current_frame()
		return false
	else:
		return true


func to_first() -> void:
	current_frame = 0
	_animation_player.play("RESET")
	_animation_player.play("0")


func play_current_frame(from_end: bool = false) -> void:
	_animation_player.play("RESET")
	_animation_player.play(str(current_frame), -1, 1.0, from_end)
