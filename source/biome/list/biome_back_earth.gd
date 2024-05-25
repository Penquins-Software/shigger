class_name BiomeBackEarth
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
	width = 9
	base_chunk_possibility = 0.75
	solid_chunk_possibility = 0.3
	item_possibility = 0.06
	
	left_extreme_point = 0
	right_extreme_point = 8
	
	back_chunk = s_back_chunk
	base_chunks = s_base_chunks
	solid_chunk = s_solid_chunk
	background = s_background
