class_name BiomeCheese
extends Biome


static var s_back_chunk: PackedScene = ResourceLoader.load("res://content/biomes/chunks/cheese_background.tscn")
static var s_base_chunks: Array[PackedScene] = [
	ResourceLoader.load("res://content/biomes/chunks/cheese_base_chunk_01.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/cheese_base_chunk_02.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/cheese_base_chunk_03.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/cheese_base_chunk_04.tscn"),
]
static var s_solid_chunk: PackedScene = ResourceLoader.load("res://content/biomes/chunks/cheese_solid_chunk.tscn")
static var s_background: PackedScene = ResourceLoader.load("res://content/biomes/cheese_background.tscn")


func _init():
	width = 9
	base_chunk_possibility = 0.85
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
							   Vector2(1, 0),                Vector2(3, 0),
				Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(3, 1), Vector2(4, 1),
							   Vector2(1, 2),                Vector2(3, 2),
				Vector2(0, 3), Vector2(1, 3), Vector2(2, 3), Vector2(3, 3), Vector2(4, 3),
							   Vector2(1, 4),                Vector2(3, 4)],
			"solid" : [],
			"items" : [
				Vector2(2, 2)
			],
			"empty" : [
				Vector2(0, 0), Vector2(2, 0), Vector2(4, 0),
				Vector2(0, 2),                Vector2(4, 2),
				Vector2(0, 4), Vector2(2, 4), Vector2(4, 4),
			],
		},
		{
			"base" : [
				Vector2(0, 0), Vector2(2, 0),
				Vector2(1, 1),
				Vector2(0, 2), Vector2(2, 2),
			],
			"solid" : [],
			"items" : [],
			"empty" : [
				Vector2(1, 0),
				Vector2(0, 1), Vector2(2, 1),
				Vector2(1, 2),
			],
		},
	])
