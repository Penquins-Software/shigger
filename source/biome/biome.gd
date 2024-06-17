class_name Biome
extends Object

enum Biomes {
	START,
	EARTH,
	MAGMA,
	CHEESE,
	CENTER,
	BACK_CHEESE,
	BACK_MAGMA,
	BACK_EARTH,
	SEA,
	SKY,
	SPACE,
}

var back_chunk: PackedScene
var base_chunks: Array[PackedScene]
var solid_chunk: PackedScene
var background: PackedScene

static var s_indestructible: PackedScene = ResourceLoader.load("res://content/biomes/chunks/indestructible_chunk.tscn")
static var s_trap: PackedScene = ResourceLoader.load("res://content/traps/trap_cell.tscn")

var width: int = 3
var base_chunk_possibility: float = 0.5
var solid_chunk_possibility: float = 0.1
var item_possibility: float = 0.03
var pattern_possibility: float = 0.2
var trap_possibility: float = 0.05

var left_extreme_point: int = 0
var right_extreme_point: int = 8

var back_positions: PackedVector2Array
var base_chunk_positions: PackedVector2Array
var solid_chunk_positions: PackedVector2Array
var items_positions: PackedVector2Array
var used_positions: PackedVector2Array
var indestructible_positions: PackedVector2Array
var trap_positions: PackedVector2Array

var _start_point: Vector2
var _last_point: Vector2
var _prev_point: Vector2

var _patterns: Array
var _specific_patterns: Array


func generate(path: PackedVector2Array, depth: int = 32) -> void:
	_start_point = path[path.size() - 1]
	
	continue_path(path, depth)
	create_biome(path, depth)


func continue_path(path: PackedVector2Array, depth: int) -> void:
	_last_point = _start_point
	var temp_depth = depth
	while temp_depth > 0:
		var new_point = get_next_point()
		if new_point.y > _last_point.y:
			temp_depth -= 1
		_prev_point = _last_point
		_last_point = new_point
		path.append(new_point)


func get_next_point() -> Vector2:
	var left: bool = _last_point.x > left_extreme_point and _prev_point.x != _last_point.x - 1
	var right: bool = _last_point.x < right_extreme_point and _prev_point.x != _last_point.x + 1
	var down: bool = not left and not right # Если нельзя влево или вправо, то сразу вниз.
	
	var new_point: Vector2 = Vector2.ZERO
	
	var direction: int = randi_range(0, 10)
	if down or direction < 6:
		# Вниз.
		new_point.x = _last_point.x
		new_point.y = _last_point.y + 1
	else:
		direction = randi_range(0, 1)
		if left and direction == 0:
			# Влево.
			new_point.x = _last_point.x - 1
			new_point.y = _last_point.y
		elif right and direction == 1:
			# Вправо.
			new_point.x = _last_point.x + 1
			new_point.y = _last_point.y
		else:
			# Вниз.
			new_point.x = _last_point.x
			new_point.y = _last_point.y + 1
	
	return new_point


func create_biome(path: PackedVector2Array, depth: int) -> void:
	for y in range(_start_point.y, _start_point.y + depth):
		for x in range(left_extreme_point, right_extreme_point + 1):
			var point = Vector2(x, y)
			back_positions.append(point)
			# Размещение предмета.
			if not items_positions.has(point) and randf() < item_possibility:
				if not indestructible_positions.has(point):
					items_positions.append(point)
			if used_positions.has(point):
				continue
			# Размещение ловушки.
			if not trap_positions.has(point) and randf() < trap_possibility:
				if not indestructible_positions.has(point):
					trap_positions.append(point)
					continue
			# Генерация блока паттерна.
			if randf() < pattern_possibility:
				if create_pattern(point, depth):
					continue
			# Размещение блока.
			if randf() < base_chunk_possibility:
				if path.has(point):
					var top_point = point - Vector2.DOWN
					if path.has(top_point):
						continue
				if randf() < solid_chunk_possibility:
					solid_chunk_positions.append(point)
				else:
					base_chunk_positions.append(point)


func create_pattern(point: Vector2, depth: int) -> bool:
	if _patterns.size() < 1:
		return false
	
	var pattern: Dictionary
	if _specific_patterns.size() > 0:
		if randf_range(0.0, 1.0) < 0.7:
			pattern = _specific_patterns.pick_random()
		else:
			pattern = _patterns.pick_random()
	else:
		pattern = _patterns.pick_random()
	
	for base: Vector2 in pattern["base"]:
		var p = point + base
		if not p.x < left_extreme_point and not p.x > right_extreme_point and not p.y > _start_point.y + depth - 1:
			if not used_positions.has(p):
				used_positions.append(p)
				base_chunk_positions.append(p)
		
	for solid: Vector2 in pattern["solid"]:
		var p = point + solid
		if not p.x < left_extreme_point and not p.x > right_extreme_point and not p.y > _start_point.y + depth - 1:
			if not used_positions.has(p):
				used_positions.append(p)
				solid_chunk_positions.append(p)
	
	for item: Vector2 in pattern["items"]:
		var p = point + item
		if not p.x < left_extreme_point and not p.x > right_extreme_point and not p.y > _start_point.y + depth - 1:
			if not used_positions.has(p):
				used_positions.append(p)
				items_positions.append(p)
	
	for empty: Vector2 in pattern["empty"]:
		var p = point + empty
		if not used_positions.has(p):
			used_positions.append(p)
	
	if pattern.has("indestructible"):
		for indestructible: Vector2 in pattern["indestructible"]:
			var p = point + indestructible
			if not p.x < left_extreme_point and not p.x > right_extreme_point and not p.y > _start_point.y + depth - 1:
				used_positions.append(p)
				indestructible_positions.append(p)
	
	return true


func get_background_chunk() -> Node2D:
	return back_chunk.instantiate() as Node2D


func get_base_chunk() -> Chunk:
	return base_chunks[randi_range(0, base_chunks.size() - 1)].instantiate() as Chunk


func get_solid_chunk() -> Chunk:
	return solid_chunk.instantiate() as Chunk


func get_background() -> BiomeBackground:
	return background.instantiate() as BiomeBackground
