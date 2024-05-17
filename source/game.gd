class_name Game
extends Node


@export var hud: HUD
@export var pause: Pause
@export var world: World
@export var player: Player
@export var monster: Monster
@export var music_player: MusicPlayer

@export_file("*.tscn") var menu_scene_file
@export_file("*.tscn") var ending_scene_file

static var s_points: int = 0
var points: int = 0
var multiplier: int = 1
var extra_multiplier: int = 1

var skills: Array = [
	64,
	512,
	2048,
	8192,
	32768,
]

var biomes: Array[Biome.Biomes]


func _ready():
	s_points = 0
	
	hud.pause_button.pressed.connect(pause_game)
	hud.skills.selected.connect(continue_game)
	pause.continue_button.pressed.connect(continue_game)
	pause.return_button.pressed.connect(to_menu)
	
	player.die.connect(end_game)
	player.in_bit.connect(hud.rhythm.pressed_in_bit)
	
	player.place(Constants.START_POINT)
	monster.place(Constants.START_POINT - Vector2(0, 16))
	
	RhythmMachine.bit_1_1.connect(bit)
	set_level(Biome.Biomes.EARTH)


func pause_game() -> void:
	hud.hide()
	pause.show()
	pause.result_label.text = "[center]Ваш результат: %s очков!" % points
	set_pause(true)


func continue_game() -> void:
	hud.show()
	pause.hide()
	if not hud.skills.visible:
		set_pause(false)


func set_pause(value: bool) -> void:
	if value:
		world.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
		RhythmMachine.stop()
	else:
		world.call_deferred("set_process_mode", Node.PROCESS_MODE_INHERIT)
		RhythmMachine.start(false)


func to_menu() -> void:
	LootLockerClient.submit_score(points)
	get_tree().call_deferred("change_scene_to_file", menu_scene_file)


func end_game() -> void:
	LootLockerClient.submit_score(points)
	get_tree().call_deferred("change_scene_to_file", ending_scene_file)


func bit() -> void:
	if pause.visible or hud.skills.visible:
		return
	
	check_level()
	check_monster_position()
	set_multiplier(player.series_of_hits)
	hud.set_points(points, multiplier * extra_multiplier, player.series_of_hits)


func check_level() -> void:
	if not biomes.has(Biome.Biomes.START) and player._world_position.y > Constants.LEVEL_START:
		monster.set_size(5)
		biomes.append(Biome.Biomes.START)
	elif not biomes.has(Biome.Biomes.MAGMA) and player._world_position.y >= Constants.LEVEL_EARTH:
		set_level(Biome.Biomes.MAGMA)
		monster.set_size(7)
	elif not biomes.has(Biome.Biomes.CHEESE) and player._world_position.y >= Constants.LEVEL_MAGMA:
		set_level(Biome.Biomes.CHEESE)
		monster.set_size(9)


func check_monster_position() -> void:
	if player._world_position.y > monster.world_position.y + monster.max_distance_to_player:
		var new_position = Vector2(Constants.MIDDLE_POINT, player._world_position.y - monster.max_distance_to_player)
		monster.place(new_position)


func set_level(biome: Biome.Biomes) -> void:
	biomes.append(biome)
	var bpm = music_player.play_biome(biome)
	monster.set_difficult(biome)
	RhythmMachine.set_bpm(bpm)
	RhythmMachine.start(true)


func add_points(value: int, show_message: bool = true) -> int:
	value = value * multiplier
	points += value
	if show_message:
		Message.create(self, player.position, "[color=gray]+" + str(value))
	check_skills()
	s_points = points
	return value


func check_skills() -> void:
	if skills.size() == 0 or hud.skills.get_skills_count() == 0:
		return
	var first_element_points = skills[0]
	if first_element_points <= points:
		skills.remove_at(0)
		hud.skills.show_skills()
		set_pause(true)


func set_multiplier(hits: int) -> void:
	var factor: int = 1
	if hits > 255:
		factor = 32
	elif hits > 127:
		factor = 16
	elif hits > 63:
		factor = 8
	elif hits > 31:
		factor = 4
	elif hits > 15:
		factor = 2
	else:
		factor = 1
		
	multiplier = factor * extra_multiplier * player.extra_multiplier
