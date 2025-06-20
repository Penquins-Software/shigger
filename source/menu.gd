class_name Menu
extends Control


@export_group("Containers")
@export var main: MenuElement
@export var comic: Comic
@export var leaderboard: MenuElement
@export var settings: MenuElement
@export var authors: MenuElement
@export var nickname: Control

@export_group("Buttons")
@export var start_button: Button
@export var comic_button: Button
@export var leaderboard_button: Button
@export var settings_button: Button
@export var authors_button: Button
@export var share_button: Button
@export var login_button: Button
@export var exit_button: Button

@export var return_from_leaderboard_button: Button
@export var return_from_settings_button: Button
@export var return_from_authors_button: Button

@export var enter_nickname: Button

@export_group("Other")
@export var exit_confirmation_dialog: ConfirmationDialog
@export var nickname_edit: LineEdit
@export var player_name: RichTextLabel
@export var score: RichTextLabel

@export_group("Scenes")
@export_file("*.tscn") var game_scene_file
@export_file("*.tscn") var tutorial_scene_file


func _ready():
	start_button.pressed.connect(_start_game)
	
	comic_button.pressed.connect(_show_menu_element.bind(comic))
	comic_button.pressed.connect(silence_bit)
	comic.exit_button.pressed.connect(_show_main_menu.bind(comic))
	comic.exit_button.pressed.connect(turn_up_bit)
	
	leaderboard_button.pressed.connect(_show_menu_element.bind(leaderboard))
	return_from_leaderboard_button.pressed.connect(_show_main_menu.bind(leaderboard))
	
	settings_button.pressed.connect(_show_menu_element.bind(settings))
	return_from_settings_button.pressed.connect(_show_main_menu.bind(settings))
	
	authors_button.pressed.connect(_show_menu_element.bind(authors))
	return_from_authors_button.pressed.connect(_show_main_menu.bind(authors))
	
	exit_button.pressed.connect(exit_confirmation_dialog.show)
	exit_confirmation_dialog.confirmed.connect(exit_game)
	
	enter_nickname.pressed.connect(set_nickname)
	
	if Settings.is_telegram:
		share_button.show()
		share_button.pressed.connect(TelegramClient.share_score)
	
	if OS.has_feature("yandex"):
		login_button.pressed.connect(YandexClient.open_auth_dialog)
		_check_authorized(null)
		YandexClient.check_auth.connect(_check_authorized)
		YandexClient.authorized.connect(_check_authorized.bind(null))
		show_score()
		YandexClient.leaderboard_player_entry_loaded.connect(show_score)
		YandexClient.data_loaded.connect(show_score)
	else:
		LootLockerClient.get_leaderboards_completed.connect(show_score)
	
	main.show_and_focus()
	
	set_nickame_label()
	
	Settings.locale_was_changed.connect(show_score)
	Settings.player_name_was_changed.connect(set_nickame_label)
	
	if OS.has_feature("web"):
		exit_button.hide()
		nickname_edit.focus_entered.connect(_focus)


func _check_authorized(is_authorized) -> void:
	leaderboard_button.disabled = not YandexClient.is_authorized
	login_button.visible = not YandexClient.is_authorized


func _show_menu_element(menu_element: MenuElement) -> void:
	main.hide()
	menu_element.show_and_focus()


func _show_main_menu(menu_element: Control) -> void:
	main.show_and_focus()
	menu_element.hide()


func _start_game() -> void:
	if not OS.has_feature("yandex") and Settings.player_name == "":
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
	Settings.save_config()
	LootLockerClient.set_player_name(Settings.player_name)
	_start_game()


func set_nickame_label() -> void:
	if Settings.player_name == "":
		player_name.text = ""
	else:
		player_name.text = "[center][color=red]%s[/color]!" % Settings.player_name


func show_score(_response = null) -> void:
	var score_value: int = 0
	if OS.has_feature("yandex"):
		score_value = YandexClient.max_score
	else:
		if LootLockerClient.player_score == "":
			return
		score_value = int(LootLockerClient.player_score)
	
	if score_value > 0:
		score.show()
		score.text = tr("[center]Вы прокопали на [color=red]%s[/color] очков") % HelpFunctions.format_integer(score_value)


func silence_bit() -> void:
	$AudioStreamPlayer.volume_db = -INF


func turn_up_bit() -> void:
	$AudioStreamPlayer.volume_db = 0


func _focus() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		nickname_edit.text = JavaScriptBridge.eval("prompt('%s', '%s');" % ["Enter nickname:", nickname_edit.text], true)
		nickname_edit.find_valid_focus_neighbor(SIDE_BOTTOM).grab_focus()
