class_name BiomeStart
extends Biome


static var s_back_chunk: PackedScene = ResourceLoader.load("res://scenes/biomes/chunks/earth_background.tscn")
static var s_base_chunks: Array[PackedScene] = [
	ResourceLoader.load("res://scenes/biomes/chunks/earth_base_chunk_01.tscn"),
	ResourceLoader.load("res://scenes/biomes/chunks/earth_base_chunk_02.tscn"),
	ResourceLoader.load("res://scenes/biomes/chunks/earth_base_chunk_03.tscn"),
	ResourceLoader.load("res://scenes/biomes/chunks/earth_base_chunk_04.tscn"),
]
static var s_solid_chunk: PackedScene = ResourceLoader.load("res://scenes/biomes/chunks/earth_solid_chunk.tscn")
static var s_background: PackedScene = ResourceLoader.load("res://scenes/biomes/earth_background.tscn")


func _init():
	width = 3
	base_chunk_possibility = 0.75
	solid_chunk_possibility = 0.1
	item_possibility = 0.02
	
	left_extreme_point = 3
	right_extreme_point = 5
	
	back_chunk = s_back_chunk
	base_chunks = s_base_chunks
	solid_chunk = s_solid_chunk
	background = s_background
