extends Node

signal rewarded_ad(result)
signal ad(result)
signal game_initialized()
signal player_initialized()
signal leaderboard_initialized()
signal data_loaded(data)
signal leaderboard_player_entry_loaded(data)
signal leaderboard_entries_loaded(data)
signal stats_loaded(stats)
signal check_auth(answer)

signal player_name(name: String)

signal authorized()

signal leaderboard_score_saved()

var is_game_initialized : bool = false
var is_player_initialized : bool = false
var is_leaderboard_initialized: bool = false
var is_authorized: bool = false

var callback_game_initialized = JavaScriptBridge.create_callback(_game_initialized)
var callback_player_initialized = JavaScriptBridge.create_callback(_player_initialized)
var callback_leaderboard_initialized = JavaScriptBridge.create_callback(_leaderboard_initialized)

var callback_rewarded_ad = JavaScriptBridge.create_callback(_rewarded_ad)
var callback_ad = JavaScriptBridge.create_callback(_ad)
var callback_is_authorized = JavaScriptBridge.create_callback(_is_authorized)

var callback_data_loaded = JavaScriptBridge.create_callback(_data_loaded)
var callback_stats_loaded = JavaScriptBridge.create_callback(_stats_loaded)
var callback_leaderboard_player_entry_loaded = JavaScriptBridge.create_callback(_leaderboard_player_entry_loaded)
var callback_leaderboard_entries_loaded = JavaScriptBridge.create_callback(_leaderboard_entries_loaded)

var callback_player_name = JavaScriptBridge.create_callback(_on_get_player_name)

var callback_auth = JavaScriptBridge.create_callback(_on_auth)

var callback_score_saved = JavaScriptBridge.create_callback(_on_score_saved)

@onready var window  = JavaScriptBridge.get_interface("window")

const LEADERBOARD_NAME: String = "leaderboard"

var max_score: int = 0


func _ready() -> void:
	if not OS.has_feature("yandex"):
		return
		
	game_initialized.connect(init_player)
	game_initialized.connect(init_leaderboard)
	player_initialized.connect(check_is_authorized)
	player_initialized.connect(get_player_name)
	
	init_game()
	load_leaderboard_player_entry(LEADERBOARD_NAME)


func open_auth_dialog():
	if not is_player_initialized:
		await player_initialized
	if not is_authorized:
		window.OpenAuthDialog(callback_auth)


func _on_auth(_args):
	is_authorized = true
	print("Пользователь авторизовался.")
	authorized.emit()
	get_player_name()


func check_is_authorized():
	print("Проверка авторизации")
	if not is_player_initialized:
		await player_initialized
	if not is_authorized:
		window.CheckAuth(callback_is_authorized)


func _is_authorized(answer):
	is_authorized = answer[0]
	#if is_authorized:
		#load_leaderboard_player_entry(LEADERBOARD_NAME)
	#else:
		#load_data( [ "score" ] )
	check_auth.emit(answer)


func init_leaderboard():
	if not is_leaderboard_initialized:
		window.InitLeaderboard(callback_leaderboard_initialized)


func init_game():
	if not is_game_initialized:
		var options = JavaScriptBridge.create_object("Object")
		window.InitGame(options, callback_game_initialized)


func show_ad():
	if not is_game_initialized :
		await game_initialized
	window.ShowAd(callback_ad)


func show_rewarded_ad():
	if not is_game_initialized :
		await game_initialized
	window.ShowAdRewardedVideo(callback_rewarded_ad)


func init_player():
	if not is_game_initialized:
		await game_initialized
	window.InitPlayer(false, callback_player_initialized)


func save_data(data: Dictionary, flush: bool = false):
	if not is_player_initialized:
		await player_initialized
	var saves = JavaScriptBridge.create_object("Object")
	for i in data.keys():
		saves[i] = data[i]
	window.SaveData(saves, flush)


func save_stats(stats: Dictionary):
	if not is_player_initialized:
		await player_initialized
	var saves = JavaScriptBridge.create_object("Object")
	for i in stats.keys():
		saves[i] = stats[i]
	window.SaveStats(saves)

func save_leaderboard_score(leaderboard_name, score, extra_data=""):
	if not is_leaderboard_initialized:
		await leaderboard_initialized
	
	if int(score) > max_score:
		max_score = int(score)
		window.SaveLeaderboardScore(leaderboard_name, score, extra_data, callback_score_saved)


func load_data(keys: Array):
	if not is_player_initialized:
		await player_initialized
	var saves = JavaScriptBridge.create_object("Array", keys.size())
	for i in range(keys.size()):
		saves[i] = keys[i]
	window.LoadData(saves, callback_data_loaded)


func load_stats(keys: Array):
	if not is_player_initialized:
		await player_initialized
	var saves = JavaScriptBridge.create_object("Array", keys.size())
	for i in range(keys.size()):
		saves[i] = keys[i]
	window.LoadStats(saves, callback_stats_loaded)


func load_leaderboard_player_entry(leaderboard_name: String):
	if not is_leaderboard_initialized:
		await leaderboard_initialized
	window.LoadLeaderboardPlayerEntry(leaderboard_name, callback_leaderboard_player_entry_loaded)


func load_leaderboard_entries(leaderboard_name: String, include_user: bool, quantity_around: int, quantity_top: int):
	if not is_leaderboard_initialized:
		await leaderboard_initialized
	window.LoadLeaderboardEntries(leaderboard_name, include_user, quantity_around, quantity_top, callback_leaderboard_entries_loaded)


func _rewarded_ad(args):
	print("rewarded ad res: ", args[0])
	rewarded_ad.emit(args)


func _ad(args):
	print("ad res: ", args[0])
	ad.emit(args[0])


func _data_loaded(args):
	if args[0] == 'loaded':
		var result := {}
		var keys = JavaScriptBridge.get_interface("Object").keys(args[1])
		var values = JavaScriptBridge.get_interface("Object").values(args[1])
		for i in range(keys.length):
			result[keys[i]] = values[i]
		#if result.has("score"):
			#GameController.best_score = int(result["score"])
			#GameController.anonim_best_score = int(result["score"])
		data_loaded.emit(result)
		

func _stats_loaded(args):
	if args[0] == 'loaded':
		var result := {}
		var keys = JavaScriptBridge.get_interface("Object").keys(args[1])
		var values = JavaScriptBridge.get_interface("Object").values(args[1])
		for i in range(keys.length):
			result[keys[i]] = values[i]
		stats_loaded.emit(result)
		

func _leaderboard_player_entry_loaded(args):
	if args[0] == 'loaded':
		var result := {}
		var keys = JavaScriptBridge.get_interface("Object").keys(args[1])
		var values = JavaScriptBridge.get_interface("Object").values(args[1])
		for i in range(keys.length):
			result[keys[i]] = values[i]
		max_score = int(result["formattedScore"])
		leaderboard_player_entry_loaded.emit(result)


func _leaderboard_entries_loaded(args):
	var leaderboard_data: Array[LeaderboardData]
	if args[0] == 'loaded':
		#var result := {}
		var keys = JavaScriptBridge.get_interface("Object").keys(args[1]["entries"])
		var values = JavaScriptBridge.get_interface("Object").values(args[1]["entries"])
		for i in range(keys.length):
			#result[keys[i]] = values[i]
			var p_name: String = values[i]["player"]["publicName"]
			if p_name == null or p_name == "":
				p_name = tr("Безымянный")
			leaderboard_data.append(LeaderboardData.new(str(values[i]["rank"]), p_name, p_name, str(values[i]["formattedScore"])))
		leaderboard_entries_loaded.emit(leaderboard_data)
	elif args[0] == 'error':
		print("Произошла ошибка при загрузке лидерборда.")


func _game_initialized(_args):
	is_game_initialized = true
	game_initialized.emit()


func _player_initialized(_args):
	is_player_initialized = true
	player_initialized.emit()
	
	
func _leaderboard_initialized(_args):
	is_leaderboard_initialized = true
	leaderboard_initialized.emit()


func get_player_name():
	if not is_player_initialized:
		await player_initialized
	window.GetPlayerName(callback_player_name)


func _on_get_player_name(args):
	player_name.emit(args[0])
	Settings.player_name = args[0]


func _on_score_saved(_args):
	leaderboard_score_saved.emit()
