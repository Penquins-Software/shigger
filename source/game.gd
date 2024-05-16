class_name Game
extends Node


@export var hud: HUD
@export var pause: Pause
@export var world: World
@export var player: Player
@export var monster: Monster

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
	32768
]


func _ready():
	s_points = 0
	
	hud.pause_button.pressed.connect(pause_game)
	hud.skills.selected.connect(continue_game)
	pause.continue_button.pressed.connect(continue_game)
	pause.return_button.pressed.connect(to_menu)
	
	player.die.connect(end_game)
	player.in_bit.connect(hud.rhythm.pressed_in_bit)
	
	RhythmMachine.set_bpm(RhythmMachine.BPM.BPM75)
	RhythmMachine.start(true)


func pause_game() -> void:
	hud.hide()
	pause.show()
	pause.result_label.text = "[center]Ваш результат: %s очков!" % points
	world.process_mode = Node.PROCESS_MODE_DISABLED


func continue_game() -> void:
	hud.show()
	pause.hide()
	if not hud.skills.visible:
		world.process_mode = Node.PROCESS_MODE_INHERIT


func to_menu() -> void:
	LootLockerClient.submit_score(points)
	get_tree().change_scene_to_file(menu_scene_file)


func end_game() -> void:
	LootLockerClient.submit_score(points)
	get_tree().change_scene_to_file(ending_scene_file)


func add_points(value: int, show_message: bool = true) -> int:
	value = value * multiplier
	points += value
	if show_message:
		Message.create(self, player.position, "[color=gray]" + str(value))
	check_skills()
	s_points = points
	return value


func check_skills() -> void:
	if skills.size() == 0:
		return
	var first_element_points = skills[0]
	if first_element_points < points:
		skills.remove_at(0)
		print(skills)
		hud.skills.show_skills()
		world.process_mode = Node.PROCESS_MODE_DISABLED


func set_multiplier(hits: int) -> void:
	var factor: int = 1
	if hits < 15:
		factor = 1
	elif hits > 15:
		factor = 2
	elif hits > 31:
		factor = 4
	elif hits > 63:
		factor = 8
	elif hits > 127:
		factor = 16
	elif hits > 255:
		factor = 32
		
	multiplier = factor * extra_multiplier
