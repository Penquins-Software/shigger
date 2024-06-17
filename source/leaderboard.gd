class_name Leaderboard
extends RichTextLabel

var _data: Array[LeaderboardData]


func _ready():
	if OS.has_feature("yandex"):
		YandexClient.leaderboard_entries_loaded.connect(set_leaderboards)
		YandexClient.leaderboard_score_saved.connect(YandexClient.load_leaderboard_entries.bind(YandexClient.LEADERBOARD_NAME, true, 10, 20))
		YandexClient.load_leaderboard_entries(YandexClient.LEADERBOARD_NAME, true, 10, 20)
	else:
		LootLockerClient.get_leaderboards_completed.connect(set_leaderboards)
		LootLockerClient.get_leaderboards()
	Settings.locale_was_changed.connect(show_table)


func _exit_tree():
	if OS.has_feature("yandex"):
		YandexClient.leaderboard_entries_loaded.disconnect(set_leaderboards)
	else:
		LootLockerClient.get_leaderboards_completed.disconnect(set_leaderboards)
	Settings.locale_was_changed.disconnect(show_table)


func set_leaderboards(data: Array[LeaderboardData]) -> void:
	_data = data
	show_table()


func show_table() -> void:
	if _data.size() == 0:
		return
	
	var leaderboard_cells = "[cell]%s[/cell][cell]        %s        [/cell][cell]%s[/cell]" % [tr("Ранг"), tr("Игрок"), tr("Количество очков")]
	
	for item in _data:
		leaderboard_cells += "[cell][right]%s.[/right][/cell]" % item.rank
		leaderboard_cells += "[cell]%s[/cell]" % item.player_name
		leaderboard_cells += "[cell][left]%s[/left][/cell]" % HelpFunctions.format_integer(int(item.score))
	
	text = "[center][table=3]%s[/table]" % leaderboard_cells
