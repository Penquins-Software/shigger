class_name BiomeSpace
extends Biome


static var s_back_chunk: PackedScene = ResourceLoader.load("res://content/biomes/chunks/space_background.tscn")
static var s_base_chunks: Array[PackedScene] = [
	ResourceLoader.load("res://content/biomes/chunks/space_base_chunk_01.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/space_base_chunk_02.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/space_base_chunk_03.tscn"),
]
static var s_solid_chunk: PackedScene = ResourceLoader.load("res://content/biomes/chunks/space_solid_chunk.tscn")
static var s_background: PackedScene = ResourceLoader.load("res://content/biomes/space_background.tscn")


func _init():
	width = 9
	base_chunk_possibility = 0.9
	solid_chunk_possibility = 0.35
	item_possibility = 0.06
	
	left_extreme_point = 0
	right_extreme_point = 8
	
	back_chunk = s_back_chunk
	base_chunks = s_base_chunks
	solid_chunk = s_solid_chunk
	background = s_background
	
	_patterns.append_array(Constants.BASE_PATTERNS)
	_specific_patterns.append_array([
	{
		"base" : [
			Vector2(1, 2), Vector2(1, 3)
		],
		"solid" : [ 
			Vector2(1, 1), 
			],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(0, 1), Vector2(2, 1)
		],
		"indestructible" : [],
	},
	])
	
