class_name BiomeBackground
extends Node2D

var _world_position: Vector2
var _player: Player


func place(world_position: Vector2, player: Player) -> void:
	_world_position = world_position
	_player = player
	
	position = _world_position * Constants.FACTOR
	
	RhythmMachine.bit_1_1.connect(check_position)


func check_position() -> void:
	if _player._world_position.y > _world_position.y + 64:
		RhythmMachine.bit_1_1.disconnect(check_position)
		queue_free()
