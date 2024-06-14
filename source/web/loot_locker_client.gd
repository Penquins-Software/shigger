extends Node

signal authentication_completed
signal get_leaderboards_completed
signal received_player_score(score: int)
#signal get_leaderboards_old_completed
signal set_player_name_completed
signal get_player_name_completed(name: String)
signal submit_score_completed
#signal get_score_completed(score: int)

const PATH_TO_DATA_FILE: String = "user://LootLocker.data"

const API_KEY: String = "dev_fb7eb641411a4264ba4d9add7ead7815"
const LEADERBOARD_KEY: String = "22174"
#const LEADERBOARD_KEY: String = "22173"
#const LEADERBOARD_KEY_OLD: String = "22174"
const GAME_VERSION: String = "0.0.0.1"
const DEVELOPMENT_MODE: bool = true

var session_token: String = ""
var player_id: String = ""
var player_score: String = ""

var leaderboard_data: Array[LeaderboardData]
#var leaderboard_data_old: Array[LeaderboardData]


var getting_leaderboards: bool = false
var getting_name: bool = false
var setting_name: bool = false
var submitting_score: bool = false

var leaderboards_queue: bool = false


func _ready():
	authentication()


func _is_authenticated() -> bool:
	return session_token != ""


func _error_handler(error: Error) -> void:
	if not error == OK:
		push_error("An error occurred in the HTTP request: %" % error)


func authentication() -> void:
	if _is_authenticated():
		print("Player is already authorized. Session Token: %s" % session_token);
		return
	
	var player_session_exists: bool = false
	var player_identifier: String = ""
	
	var file = FileAccess.open(PATH_TO_DATA_FILE, FileAccess.READ)
	if not file == null:
		player_identifier = file.get_as_text()
		file.close()
		print("Player ID: %s" % player_identifier)
	
	if not player_identifier == "":
		player_session_exists = true
		print("Player session exists.")
	
	var url: String = "https://api.lootlocker.io/game/v2/session/guest"
	var headers: PackedStringArray = ["Content-Type: application/json"]
	var body: String
	if player_session_exists:
		body = JSON.stringify({
			"game_key" : API_KEY,
			"player_identifier" : player_identifier,
			"game_version" : GAME_VERSION,
			"development_mode" : DEVELOPMENT_MODE,
		})
	else:
		body = JSON.stringify({
			"game_key" : API_KEY,
			"game_version" : GAME_VERSION,
			"development_mode" : DEVELOPMENT_MODE,
		})
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_authentication.bind(http_request))
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	_error_handler(error);


func _on_authentication(_r: int, _rc: int, _h: PackedStringArray, body: PackedByteArray, httt_requst: HTTPRequest) -> void:
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.data
	
	if body == null or body.size() == 0:
		print("Connection lost.")
		return
	
	session_token = str(response["session_token"])
	player_id = str(response["player_id"])
	
	var file = FileAccess.open(PATH_TO_DATA_FILE, FileAccess.WRITE)
	file.store_string(response["player_identifier"] as String)
	file.close()
	
	print("Authentication completed. Player ID: %s" % player_id)
	
	authentication_completed.emit()
	httt_requst.queue_free()
	
	if leaderboards_queue:
		get_leaderboards()


func get_leaderboards() -> void:
	if not _is_authenticated():
		print("Player is not authorized.")
		leaderboards_queue = true
		return
	
	if getting_leaderboards:
		return
	
	getting_leaderboards = true
	print("Getting leaderboards.")
	
	var url = "https://api.lootlocker.io/game/leaderboards/%s/list?count=1000" % LEADERBOARD_KEY
	var headers = [ "Content-Type: application/json", "x-session-token: %s" % session_token]
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_get_leaderboards.bind(http_request))
	var error = http_request.request(url, headers, HTTPClient.METHOD_GET)
	_error_handler(error);


func _on_get_leaderboards(_r: int, _rc: int, _h: PackedStringArray, body: PackedByteArray, httt_requst: HTTPRequest) -> void:
	leaderboards_queue = false
	getting_leaderboards = false
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.data
	
	var items = response["items"]
	leaderboard_data.clear()
	
	for item in items:
		var item_rank = str(item["rank"])
		var item_id = str(item["member_id"])
		var item_name = str(item["player"]["name"])
		var item_score = str(item["score"])
		
		if item_id == player_id:
			player_score = item_score
			received_player_score.emit(int(player_score))
		
		leaderboard_data.append(LeaderboardData.new(item_rank, item_id, item_name, item_score))
	
	print("Leaderboard received. Number of records: %s" % leaderboard_data.size())
	
	get_leaderboards_completed.emit(leaderboard_data)
	httt_requst.queue_free()


func get_player_name() -> void:
	if not _is_authenticated():
		print("Player is not authorized.")
		return
	
	if getting_name:
		return
	
	getting_name = true
	print("Getting player name.")
	
	var url = "https://api.lootlocker.io/game/player/name"
	var headers = [ "Content-Type: application/json", "x-session-token: %s" % session_token]
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_get_player_name.bind(http_request))
	var error = http_request.request(url, headers, HTTPClient.METHOD_GET)
	_error_handler(error);


func _on_get_player_name(_r: int, _rc: int, _h: PackedStringArray, body: PackedByteArray, httt_requst: HTTPRequest) -> void:
	getting_name = false
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.data
	
	var p_name = str(response["name"])
	
	get_player_name_completed.emit(p_name)
	httt_requst.queue_free()


func set_player_name(p_name: String) -> void:
	if not _is_authenticated():
		print("Player is not authorized.")
		return
	
	if setting_name or p_name == "":
		return;
	
	setting_name = true
	print("Setting player name.")
	
	var url = "https://api.lootlocker.io/game/player/name"
	var headers = [ "Content-Type: application/json", "x-session-token: %s" % session_token]
	var body = JSON.stringify({
		"name" : p_name,
	})
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_set_player_name.bind(http_request))
	var error = http_request.request(url, headers, HTTPClient.METHOD_PATCH, body)
	_error_handler(error);


func _on_set_player_name(_r: int, _rc: int, _h: PackedStringArray, body: PackedByteArray, httt_requst: HTTPRequest) -> void:
	setting_name = false;
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.data
	
	print(response)
	
	set_player_name_completed.emit()
	httt_requst.queue_free()


func submit_score(score: int) -> void:
	if not _is_authenticated():
		print("Player is not authorized.")
	
	if submitting_score or score <= 0:
		return;
	
	submitting_score = true
	print("Uploading score.")
	
	var url = "https://api.lootlocker.io/game/leaderboards/%s/submit" % LEADERBOARD_KEY
	var headers = [ "Content-Type: application/json", "x-session-token: %s" % session_token]
	var body = JSON.stringify({
		"score" : score,
	})
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_submit_score.bind(http_request))
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	_error_handler(error);


func _on_submit_score(_r: int, _rc: int, _h: PackedStringArray, body: PackedByteArray, httt_requst: HTTPRequest) -> void:
	submitting_score = false
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.data
	
	print(response)
	
	submit_score_completed.emit()
	httt_requst.queue_free()
