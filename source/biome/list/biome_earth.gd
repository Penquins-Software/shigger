class_name BiomeEarth
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
	width = 5
	base_chunk_possibility = 0.75
	solid_chunk_possibility = 0.2
	item_possibility = 0.04
	pattern_possibility = 0.1
	trap_possibility = 0.01
	
	left_extreme_point = 2
	right_extreme_point = 6
	
	back_chunk = s_back_chunk
	base_chunks = s_base_chunks
	solid_chunk = s_solid_chunk
	background = s_background
	
	_patterns.append_array(Constants.BASE_PATTERNS)
