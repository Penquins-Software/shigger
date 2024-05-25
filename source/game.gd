class_name Game
extends Node


@export var hud: HUD
@export var pause: Pause
@export var world: World
@export var player: Player
@export var monster: Monster
@export var music_player: MusicPlayer
@export var kick_player: KickPlayer

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
	131072,
	#524288,
]

var biomes: Array[Biome.Biomes]

var rhythm_time: float


func _ready():
	s_points = 0
	
	hud.pause_button.pressed.connect(pause_game)
	hud.skills.selected.connect(continue_game.bind(false))
	hud.preparation_screen.complete.connect(end_preparation_menu)
	pause.continue_button.pressed.connect(continue_game.bind(true))
	pause.return_button.pressed.connect(to_menu)
	
	player.die.connect(end_game)
	
	player.place(Constants.START_POINT)
	monster.place(Constants.START_POINT - Vector2(0, 16))
	
	RhythmMachine.hit.connect(hud.rhythm.pressed_in_bit)
	RhythmMachine.bit_1_1.connect(bit)
	set_level(Biome.Biomes.EARTH)


func pause_game() -> void:
	hud.hide()
	pause.show()
	pause.continue_button.grab_focus()
	pause.result_label.text = "[center]%s" % (tr("ResultPoints") % HelpFunctions.format_integer(points))
	RhythmMachine.stop()
	set_pause(true)


func continue_game(is_preparation: bool) -> void:
	hud.show()
	pause.hide()
	if not hud.skills.visible:
		set_pause(false, is_preparation)
	else:
		RhythmMachine.start(true)
		hud.rhythm.helper.spawn_all_elements()
		music_player.play_from_playback()


func set_pause(value: bool, is_preparation: bool = true) -> void:
	if value:
		world.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
		
		if hud.preparation_screen.visible:
			hud.preparation_screen.hide()
		else:
			rhythm_time = RhythmMachine.current_time
	elif is_preparation:
		show_preparation_menu()
	else:
		end_preparation_menu(false)


func show_preparation_menu() -> void:
	hud.preparation_screen.show_screen()
	RhythmMachine.start(true)
	hud.rhythm.helper.spawn_all_elements()
	kick_player.play_kicking(RhythmMachine.current_bpm)


func end_preparation_menu(check_player_hit: bool = true) -> void:
	if not pause.visible:
		world.call_deferred("set_process_mode", Node.PROCESS_MODE_INHERIT)
		music_player.play_from_playback()
		monster.call_deferred("move")
		if check_player_hit:
			player.call_deferred("check_hit_queue")
		kick_player.stop()


func to_menu() -> void:
	RhythmMachine.stop()
	LootLockerClient.submit_score(points)
	get_tree().call_deferred("change_scene_to_file", menu_scene_file)


func end_game() -> void:
	RhythmMachine.stop()
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
	elif not biomes.has(Biome.Biomes.CENTER) and player._world_position.y >= Constants.LEVEL_CHEESE:
		set_level(Biome.Biomes.CENTER)
		player.camera.set_degrees(90)
	elif not biomes.has(Biome.Biomes.BACK_CHEESE) and player._world_position.y >= Constants.LEVEL_CENTER:
		set_level(Biome.Biomes.BACK_CHEESE)
		player.camera.set_degrees(0)
	elif not biomes.has(Biome.Biomes.BACK_MAGMA) and player._world_position.y >= Constants.LEVEL_BACK_CHEESE:
		set_level(Biome.Biomes.BACK_MAGMA)
	elif not biomes.has(Biome.Biomes.BACK_EARTH) and player._world_position.y >= Constants.LEVEL_BACK_MAGMA:
		set_level(Biome.Biomes.BACK_EARTH)


func check_monster_position() -> void:
	if player._world_position.y > monster.world_position.y + monster.max_distance_to_player:
		var new_position = Vector2(Constants.MIDDLE_POINT, player._world_position.y - monster.max_distance_to_player)
		monster.place(new_position)


func set_level(biome: Biome.Biomes) -> void:
	biomes.append(biome)
	var bpm = music_player.play_biome(biome)
	monster.set_difficult(biome)
	player.set_animation_speed(bpm)
	RhythmMachine.set_bpm(bpm)
	RhythmMachine.start(false)


func add_points(value: int, pos: Vector2, show_message: bool = true) -> int:
	value = value * multiplier
	points += value
	if show_message:
		Message.create(self, pos, "[color=gray]+" + str(value))
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
		kick_player.play_kicking(RhythmMachine.current_bpm)
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
