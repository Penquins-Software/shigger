class_name LeaderboardData
extends Object

var rank: String
var player_id: String
var player_name: String
var score: String


func _init(_rank: String, _player_id: String, _player_name: String, _score: String):
	rank = _rank
	player_id = _player_id
	if _player_name == "":
		_player_name = _player_id
	player_name = _player_name
	score = _score
