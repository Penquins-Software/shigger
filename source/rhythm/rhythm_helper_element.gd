class_name RhythmHelperElement
extends ColorRect

var _destination: Vector2
var _speed: float # Скорость измеряется в пикселях на музыкальный бит.
var _sign: int

var _start: bool = false


func _process(delta):
	if not _start:
		return
	
	position.x += _speed * delta
	if _sign == 1 and position.x > _destination.x:
		queue_free()
	elif _sign == -1 and position.x < _destination.x:
		queue_free()


func place(pos: Vector2, destination: Vector2, speed: float, shift: float = 0) -> void:
	pos.x -= pivot_offset.x
	position = pos
	_destination = destination
	
	_speed = speed
	_sign = sign(_speed)
	
	position.x += shift * _speed
	
	RhythmMachine.bit_changed.connect(destroy)
	
	_start = true


func destroy(_variant = null) -> void:
	queue_free()
