extends Node

const telegram_functions_url: String = "https://penquins.software/games/telegram_functions.php"
const public_key_url: String = "https://penquins.software/games/public.key"

var user_id: String
var inline_message_id: String

var public_key: CryptoKey


func _ready():
	user_id = HelpFunctions.get_parameter("user_id")
	inline_message_id = HelpFunctions.get_parameter("inline")
	
	LootLockerClient.received_player_score.connect(submit_score)
	
	#get_public_key()


func submit_score(score: int) -> void:
	if not Settings.is_telegram:
		return
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_submit_score.bind(http_request))
	http_request.request(telegram_functions_url + "?user_id=%s&inline=%s&score=%s" % [user_id, inline_message_id, score])


func _on_submit_score(_r: int, _rc: int, _h: PackedStringArray, _body: PackedByteArray, http_requst: HTTPRequest) -> void:
	http_requst.queue_free()


func share_score() -> void:
	if not Settings.is_telegram:
		return
	
	JavaScriptBridge.eval("TelegramGameProxy.shareScore()")


#func get_public_key() -> void:
	#var http = HTTPRequest.new()
	#add_child(http)
	#http.request_completed.connect(_on_get_public_key.bind(http))
	#http.request(public_key_url)


#func _on_get_public_key(_r: int, _rc: int, _h: PackedStringArray, body: PackedByteArray, http_requst: HTTPRequest) -> void:
	#public_key = CryptoKey.new()
	#public_key.load_from_string(body.get_string_from_utf8(), true)
	#http_requst.queue_free()
	#
	#var data = "Some data"
	#var crypto = Crypto.new()
	#var encrypted = crypto.encrypt(public_key, data.to_utf8_buffer())
	#
	#var json = JSON.stringify({
		#"data" : "test",
		#"encrypted" : encrypted,
	#})
	#var headers = ["Content-Type: application/json"]
	#
	#var http = HTTPRequest.new()
	#add_child(http)
	#http.request_completed.connect(_on)
	#http.request(telegram_functions_url + "?result", headers, HTTPClient.METHOD_POST, json)
#
#func _on(_r: int, _rc: int, _h: PackedStringArray, body: PackedByteArray):
	#print(_r)
	#print(_rc)
	#print(_h)
	#print(body)
