class_name Item
extends Node2D

static var _items: Dictionary = {
	0.1 : ResourceLoader.load("res://content/items/dynamite.tscn"),
	0.3 : ResourceLoader.load("res://content/items/stop_monster.tscn"),
	0.4 : ResourceLoader.load("res://content/items/random_rotation.tscn"),
	1.0 : ResourceLoader.load("res://content/items/treasure.tscn"),
}

@export var _area: Area2D
@export var light: Light2D
@export var increased_size: Vector2 = Vector2(1.2, 1.2)

var _world_position: Vector2

var _player: Player
var _monster: Monster
var _world: World



func _ready():
	RhythmMachine.bit_1_5.connect(bit_1_5)
	RhythmMachine.bit_1_1.connect(bit_1_1)


func bit_1_5() -> void:
	scale = Vector2.ONE


func bit_1_1() -> void:
	scale = increased_size


func place(world_position: Vector2, player: Player, monster: Monster, world: World) -> void:
	_world_position = world_position
	position = world_position * Constants.FACTOR + Constants.HALF_FACTOR_VECTOR
	
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


func explode() -> void:
	queue_free()


static func create_random_item() -> Item:
	var random = randf_range(0.0, 1.0)
	for item in _items:
		if item > random:
			return _items[item].instantiate() as Item
	return _items.values().pick_random().instantiate() as Item
