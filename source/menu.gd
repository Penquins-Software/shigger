class_name Menu
extends Control


@export_group("Containers")
@export var main: Control
@export var leaderboard: Control
@export var settings: Control
@export var authors: Control
@export var nickname: Control

@export_group("Buttons")
@export var start_button: Button
@export var leaderboard_button: Button
@export var settings_button: Button
@export var authors_button: Button
@export var exit_button: Button

@export var return_from_leaderboard_button: Button
@export var return_from_settings_button: Button
@export var return_from_authors_button: Button

@export var enter_nickname: Button

@export_group("Other")
@export var exit_confirmation_dialog: ConfirmationDialog
@export var nickname_edit: LineEdit

@export_group("Scenes")
@export_file("*.tscn") var game_scene_file
@export_file("*.tscn") var tutorial_scene_file


func _ready():
	start_button.pressed.connect(_start_game)
	
	leaderboard_button.pressed.connect(_show_menu_element.bind(leaderboard))
	return_from_leaderboard_button.pressed.connect(_show_main_menu.bind(leaderboard))
	
	settings_button.pressed.connect(_show_menu_element.bind(settings))
	return_from_settings_button.pressed.connect(_show_main_menu.bind(settings))
	
	authors_button.pressed.connect(_show_menu_element.bind(authors))
	return_from_authors_button.pressed.connect(_show_main_menu.bind(authors))
	
	exit_button.pressed.connect(exit_confirmation_dialog.show)
	exit_confirmation_dialog.confirmed.connect(exit_game)
	
	enter_nickname.pressed.connect(set_nickname)


func _show_menu_element(menu_element: Control) -> void:
	main.hide()
	menu_element.show()


func _show_main_menu(menu_element: Control) -> void:
	main.show()
	menu_element.hide()


func _start_game() -> void:
	if Settings.player_name == "":
		nickname.show()
		return
	
	if not Settings.tutorial:
		get_tree().change_scene_to_file(tutorial_scene_file)
		return
	
	get_tree().change_scene_to_file(game_scene_file)


func exit_game() -> void:
	get_tree().quit()


func set_nickname() -> void:
	if nickname_edit.text == "":
		return
	
	Settings.player_name = nickname_edit.text
	LootLockerClient.set_player_name(Settings.player_name)
	_start_game()
