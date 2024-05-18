class_name Leaderboard
extends Node


@export var leaderboard_container: RichTextLabel


func _ready():
	LootLockerClient.get_leaderboards_completed.connect(set_leaderboards)
	LootLockerClient.get_leaderboards()


func _exit_tree():
	LootLockerClient.get_leaderboards_completed.disconnect(set_leaderboards)


func set_leaderboards(data: Array[LeaderboardData]) -> void:
	var leaderboard_cells = "[cell]Ранг[/cell][cell]        Игрок        [/cell][cell]Количество очков[/cell]"
	
	for item in data:
		leaderboard_cells += "[cell][right]%s.[/right][/cell]" % item.rank
		leaderboard_cells += "[cell]%s[/cell]" % item.player_name
		leaderboard_cells += "[cell][left]%s[/left][/cell]" % HelpFunctions.format_integer(int(item.score))
	
	leaderboard_container.text = "[center][table=3]%s[/table]" % leaderboard_cells
