class_name BiomeBackMagma
extends Biome


static var s_back_chunk: PackedScene = ResourceLoader.load("res://content/biomes/chunks/magma_background.tscn")
static var s_base_chunks: Array[PackedScene] = [
	ResourceLoader.load("res://content/biomes/chunks/magma_base_chunk_01.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/magma_base_chunk_02.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/magma_base_chunk_03.tscn"),
	ResourceLoader.load("res://content/biomes/chunks/magma_base_chunk_04.tscn"),
]
static var s_solid_chunk: PackedScene = ResourceLoader.load("res://content/biomes/chunks/magma_solid_chunk.tscn")
static var s_background: PackedScene = ResourceLoader.load("res://content/biomes/magma_background.tscn")


func _init():
	width = 9
	base_chunk_possibility = 0.8
	solid_chunk_possibility = 0.35
	item_possibility = 0.05
	
	left_extreme_point = 0
	right_extreme_point = 8
	
	back_chunk = s_back_chunk
	base_chunks = s_base_chunks
	solid_chunk = s_solid_chunk
	background = s_background
	
