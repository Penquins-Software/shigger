class_name Item
extends Node2D

static var _item_scenes: Array[PackedScene] = [
	ResourceLoader.load("res://content/items/stop_monster.tscn"),
	ResourceLoader.load("res://content/items/treasure.tscn"),
	ResourceLoader.load("res://content/items/dynamite.tscn"),
]

@export var _area: Area2D
@export var light: Light2D

var _world_position: Vector2

var _player: Player
var _monster: Monster
var _world: World


func place(world_position: Vector2, player: Player, monster: Monster, world: World) -> void:
	_world_position = world_position
	position = world_position * Constants.FACTOR
	
	_player = player
	_monster = monster
	_world = world
	
	_area.area_entered.connect(_on_area_entered)
	
	if not light == null:
		light.visible = player.flashlight


func use() -> void:
	queue_free()


func turn_on_light() -> void:
	if not light == null:
		light.visible = true


func turn_off_light() -> void:
	if not light == null:
		light.visible = false


func _on_area_entered(area: Area2D) -> void:
	if area is MonsterArea:
		queue_free()
	elif area is PlayerArea:
		use()


static func create_random_item() -> Item:
	return _item_scenes.pick_random().instantiate() as Item
