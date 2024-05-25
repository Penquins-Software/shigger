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


var width: int = 3
var base_chunk_possibility: float = 0.5
var solid_chunk_possibility: float = 0.1
var item_possibility: float = 0.03

var left_extreme_point: int = 0
var right_extreme_point: int = 8

var back_positions: PackedVector2Array
var base_chunk_positions: PackedVector2Array
var solid_chunk_positions: PackedVector2Array
var items_positions: PackedVector2Array

var _start_point: Vector2
var _last_point: Vector2
var _prev_point: Vector2


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
			if randf() < item_possibility:
				items_positions.append(point)
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


func get_background_chunk() -> Node2D:
	return back_chunk.instantiate() as Node2D


func get_base_chunk() -> Chunk:
	return base_chunks[randi_range(0, base_chunks.size() - 1)].instantiate() as Chunk


func get_solid_chunk() -> Chunk:
	return solid_chunk.instantiate() as Chunk


func get_background() -> BiomeBackground:
	return background.instantiate() as BiomeBackground
