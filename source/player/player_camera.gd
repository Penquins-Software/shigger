class_name PlayerCamera
extends Camera2D

var _default_degrees: float = 0.0
var _is_rotate: bool = false


func set_degrees(degrees: float) -> void:
	_default_degrees = degrees
	if not _is_rotate:
		rotation_degrees = _default_degrees


func rotate_for_time(degrees: float = 180, time: float = 2.0) -> void:
	_is_rotate = true
	rotation_degrees = degrees
	await get_tree().create_timer(time).timeout
	_is_rotate = false
	rotation_degrees = _default_degrees


func rotate_by_parts_in_bit(degrees: float = 180, parts: int = 4) -> void:
	_is_rotate = true
	
	var part_degrees = degrees / parts
	
	for part in parts:
		rotation_degrees = part_degrees * (part + 1)
		await RhythmMachine.bit_1_1
	
	_is_rotate = false
	rotation_degrees = _default_degrees
