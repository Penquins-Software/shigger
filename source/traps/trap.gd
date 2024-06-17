class_name Trap
extends AnimatedSprite2D

@export var _area: Area2D

var _world_position: Vector2
var _player: Player
var _world: World

var active: bool = false


func place(world_position: Vector2, player: Player, world: World) -> void:
	_world_position = world_position
	position = world_position * Constants.FACTOR + Constants.HALF_FACTOR_VECTOR
	
	_player = player
	_world = world
	
	_area.body_entered.connect(_on_area_entered)
	
	setting()


func setting() -> void:
	pass


func move_to() -> bool:
	return true


func destroy() -> void:
	pass


func explode() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is MonsterArea:
		queue_free()
