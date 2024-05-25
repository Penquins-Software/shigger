class_name World
extends Node

@export var game: Game
@export var player: Player
@export var monster: Monster

var path: PackedVector2Array

var backs: Dictionary = {}
var chunks: Dictionary = {}
var items: Dictionary = {}


func _ready():
	RhythmMachine.bit_1_1.connect(bit)
	create()


func _get_prev_point() -> Vector2:
	if path.size() > 1:
		return path[path.size() - 2] as Vector2
	else:
		return Constants.START_POINT
	
	
func _get_last_point() -> Vector2:
	if path.size() > 0:
		return path[path.size() - 1] as Vector2
	else:
		return Constants.START_POINT


func _get_path_level() -> float:
	return _get_last_point().y


func create() -> void:
	randomize()
	
	var background = BiomeStart.s_background.instantiate() as BiomeBackground
	background.place(Vector2(Constants.MIDDLE_POINT, -32), player)
	add_child(background)
	
	generate_next_biome()


func generate_next_biome(depth: int = 32) -> void:
	var biome = select_biome_by_level()
	biome.generate(path, depth)
	create_biome(biome)


func select_biome_by_level() -> Biome:
	var current_level = _get_path_level()
	if current_level < Constants.LEVEL_START:
		return BiomeStart.new()
	elif current_level < Constants.LEVEL_EARTH:
		return BiomeEarth.new()
	elif current_level < Constants.LEVEL_MAGMA:
		return BiomeMagma.new()
	elif current_level < Constants.LEVEL_CHEESE:
		return BiomeCheese.new()
	elif current_level < Constants.LEVEL_CENTER:
		return BiomeCenter.new()
	elif current_level < Constants.LEVEL_BACK_CHEESE:
		return BiomeBackCheese.new()
	elif current_level < Constants.LEVEL_BACK_MAGMA:
		return BiomeBackMagma.new()
	elif current_level < Constants.LEVEL_BACK_EARTH:
		return BiomeBackEarth.new()
	else:
		return BiomeBackEarth.new()


func create_biome(biome: Biome) -> void:
	for back_position in biome.back_positions:
		var back = biome.get_background_chunk()
		backs[back_position] = back
		add_chunk(back_position, back)
	for base_chunk_position in biome.base_chunk_positions:
		var base = biome.get_base_chunk()
		chunks[base_chunk_position] = base
		add_chunk(base_chunk_position, base)
	for solid_chunk_position in biome.solid_chunk_positions:
		var solid = biome.get_solid_chunk()
		chunks[solid_chunk_position] = solid
		add_chunk(solid_chunk_position, solid)
	for item_position in biome.items_positions:
		var item = Item.create_random_item()
		items[item_position] = item
		add_child(item)
		item.place(item_position, player, monster, self)
	var background = biome.get_background()
	background.place(Vector2(Constants.MIDDLE_POINT, biome._start_point.y), player)
	add_child(background)


func add_chunk(world_position: Vector2, chunk: Node2D) -> void:
	add_child(chunk)
	chunk.position = world_position * Constants.FACTOR


func bit() -> void:
	if player._world_position.y + 64 > _get_path_level():
		generate_next_biome()


func destroy_chunk_by_position(world_position: Vector2, explode: bool) -> int:
	if not chunks.has(world_position):
		return 0
	if chunks[world_position] == null or chunks[world_position].is_queued_for_deletion():
		return 0 
	var chunk = chunks[world_position] as Chunk
	chunks.erase(world_position)
	var points = game.add_points(chunk.points, world_position * Constants.FACTOR, false)
	chunk.destoy(explode)
	return points


func destroy_item_by_position(world_position: Vector2) -> void:
	if not items.has(world_position):
		return
	if items[world_position] == null or items[world_position].is_queued_for_deletion():
		return 
	var item = items[world_position] as Item
	items.erase(world_position)
	item.explode()


func destroy_all_in_position(world_position: Vector2, explode: bool) -> int:
	destroy_item_by_position(world_position)
	return destroy_chunk_by_position(world_position, explode)
