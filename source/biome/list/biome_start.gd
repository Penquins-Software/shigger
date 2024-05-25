class_name BiomeStart
extends Biome


static var s_back_chunk: PackedScene = ResourceLoader.load("res://content/biomes/chunks/earth_background.tscn")
static var s_base_chunks: Array[PackedScene] = [
	ResourceLoader.load("res://content/biomes/chunks/earth_base_chunk_01.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/earth_base_chunk_02.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/earth_base_chunk_03.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/earth_base_chunk_04.tscn"),
]
static var s_solid_chunk: PackedScene = ResourceLoader.load("res://content/biomes/chunks/earth_solid_chunk.tscn")
static var s_background: PackedScene = ResourceLoader.load("res://content/biomes/earth_background.tscn")


func _init():
	width = 3
	base_chunk_possibility = 0.75
	solid_chunk_possibility = 0.1
	item_possibility = 0.025
	
	left_extreme_point = 3
	right_extreme_point = 5
	
	back_chunk = s_back_chunk
	base_chunks = s_base_chunks
	solid_chunk = s_solid_chunk
	background = s_background


func generate(path: PackedVector2Array, depth: int = 32) -> void:
	path.append(Constants.START_POINT)
	path.append(Vector2(Constants.MIDDLE_POINT, 1))
	path.append(Vector2(Constants.MIDDLE_POINT, 2))
	path.append(Vector2(Constants.MIDDLE_POINT, 3))
	
	_start_point = Vector2(Constants.MIDDLE_POINT, 3)
	continue_path(path, depth - 4)
	_start_point = Vector2(Constants.START_POINT)
	create_biome(path, depth - 1)
	
	var index = base_chunk_positions.find(Constants.START_POINT)
	if index > -1:
		base_chunk_positions.remove_at(index)
	index = solid_chunk_positions.find(Constants.START_POINT)
	if index > -1:
		solid_chunk_positions.remove_at(index)
	index = items_positions.find(Constants.START_POINT)
	if index > -1:
		items_positions.remove_at(index)
