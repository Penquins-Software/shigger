class_name RhythmHelper
extends Control

@export var helper_element_scene: PackedScene
@export var container: Control

var _center: Vector2

var _left_1: Vector2
var _left_2: Vector2
var _left_3: Vector2
var _left_4: Vector2

var _right_1: Vector2
var _right_2: Vector2
var _right_3: Vector2
var _right_4: Vector2

@export var _distance_1: int = 160
var _distance_2: int
var _distance_3: int
var _distance_4: int

var _speed: float


func _ready():
	_center = Vector2(size.x / 2, 0)
	
	_distance_2 = _distance_1 * 2
	_distance_3 = _distance_1 * 3
	_distance_4 = _distance_1 * 4
	
	_left_1 = Vector2(_center.x - _distance_1, 0)
	_left_2 = Vector2(_center.x - _distance_2, 0)
	_left_3 = Vector2(_center.x - _distance_3, 0)
	_left_4 = Vector2(_center.x - _distance_4, 0)
	
	_right_1 = Vector2(_center.x + _distance_1, 0)
	_right_2 = Vector2(_center.x + _distance_2, 0)
	_right_3 = Vector2(_center.x + _distance_3, 0)
	_right_4 = Vector2(_center.x + _distance_4, 0)
	
	RhythmMachine.bit_changed.connect(set_bpm)
	RhythmMachine.bit_1_1.connect(spawn_side_elements)


func set_bpm(_bpm: RhythmMachine.BPM) -> void:
	_speed = _distance_1 / RhythmMachine.get_current_bpm_in_seconds()
	
	spawn_all_elements()


func spawn_all_elements(shift: float = 0) -> void:
	clear_elements()
	add_element(_left_1, _speed, shift)
	add_element(_right_1, -_speed, shift)
	add_element(_left_2, _speed, shift)
	add_element(_right_2, -_speed, shift)
	spawn_side_elements(shift)
	add_element(_left_4, _speed, shift)
	add_element(_right_4, -_speed, shift)


func spawn_side_elements(shift: float = 0) -> void:
	add_element(_left_3, _speed, shift)
	add_element(_right_3, -_speed, shift)


func add_element(pos: Vector2, speed: float, shift: float = 0) -> RhythmHelperElement:
	var element = helper_element_scene.instantiate() as RhythmHelperElement
	container.add_child(element)
	element.place(pos, _center, speed, shift)
	return element


func clear_elements() -> void:
	for child in container.get_children():
		child.queue_free()
