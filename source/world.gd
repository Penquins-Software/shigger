class_name World
extends Node

@export var game: Game
@export var player: Player
@export var monster: Monster

var path: PackedVector2Array

var backs: Dictionary = {}
var chunks: Dictionary = {}
var items: Array[Item] = []

var current_level: int = 0


func _ready():
	RhythmMachine.bit_1_1.connect(bit)
	create()


func _get_prev_point() -> Vector2:
	if path.size() > 1:
		return path[path.size() - 2] as Vector2
	else:
		return Vector2.ZERO
	
	
func _get_last_point() -> Vector2:
	if path.size() > 0:
		return path[path.size() - 1] as Vector2
	else:
		return Vector2.ZERO


func _get_path_level() -> int:
	return _get_last_point().y


func create() -> void:
	randomize()
	
	var background = BiomeStart.s_background.instantiate() as BiomeBackground
	background.place(Vector2(Constants.MIDDLE_POINT, -64) * Constants.FACTOR, player)
	add_child(background)
	
	path.append(Vector2(Constants.MIDDLE_POINT, 0))
	path.append(Vector2(Constants.MIDDLE_POINT, 1))
	path.append(Vector2(Constants.MIDDLE_POINT, 2))
	path.append(Vector2(Constants.MIDDLE_POINT, 3))
	
	generate_next_biome(28)


func generate_next_biome(depth: int = 32) -> void:
	continue_path(depth)
	var biome = select_biome_by_level()
	biome.generate(path, current_level)
	current_level += depth
	create_biome(biome)


func continue_path(depth: int = 32) -> void:
	var prev_point: Vector2 = _get_prev_point()
	var last_point: Vector2 = _get_last_point()
	while depth > 0:
		var new_point = get_next_point(prev_point, last_point)
		if new_point.y > last_point.y:
			depth -= 1
		prev_point = last_point
		last_point = new_point
		path.append(new_point)


func get_next_point(prev_point: Vector2, last_point: Vector2) -> Vector2:
	var left: bool = last_point.x > Constants.LEFT_POINT and prev_point.x != last_point.x - 1
	var right: bool = last_point.x < Constants.RIGHT_POINT and prev_point.x != last_point.x + 1
	var down: bool = not left and not right # Если нельзя влево или вправо, то сразу вниз.
	
	var new_point: Vector2
	
	var direction: int = randi_range(0, 10)
	if down or direction < 6:
		# Вниз.
		new_point.x = last_point.x
		new_point.y = last_point.y + 1
	else:
		direction = randi_range(0, 1)
		if left and direction == 0:
			# Влево.
			new_point.x = last_point.x - 1
			new_point.y = last_point.y
		elif right and direction == 1:
			# Вправо.
			new_point.x = last_point.x + 1
			new_point.y = last_point.y
	
	return new_point


func select_biome_by_level() -> Biome:
	if current_level < Constants.LEVEL_START:
		return BiomeStart.new()
	elif current_level < Constants.LEVEL_EARTH:
		return BiomeEarth.new()
	elif current_level < Constants.LEVEL_MAGMA:
		return BiomeMagma.new()
	elif current_level < Constants.LEVEL_CHEESE:
		return BiomeCheese.new()
	else:
		return BiomeCheese.new()


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
		items.append(item)
		add_child(item)
		item.place(item_position, player, monster, self)
	var background = biome.get_background()
	background.place(Vector2(Constants.MIDDLE_POINT, biome.start_point.y), player)
	add_child(background)


func add_chunk(world_position: Vector2, chunk: Node2D) -> void:
	chunk.position = world_position * Constants.FACTOR


func bit() -> void:
	if player._world_position.y + 64 > _get_path_level():
		generate_next_biome(64)


func destroy_chunk_by_position(world_position: Vector2, explode: bool) -> int:
	if not chunks.has(world_position):
		return 0
	var chunk = chunks[world_position] as Chunk
	chunks.erase(world_position)
	var points = game.add_points(chunk.points, false)
	chunk.destoy(explode)
	return points
