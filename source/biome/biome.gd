class_name Biome
extends Object


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

var start_point: Vector2


func generate(path: PackedVector2Array, start_index: int, depth: int = 32) -> void:
	start_point = path[start_index]
	for y in range(start_point.y, start_point.y + depth):
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
