extends LineEdit


@export var confirm_button: Button


func _ready():
	text = Settings.player_name
	confirm_button.pressed.connect(_set_player_name)


func _set_player_name() -> void:
	if text == null or text == "" or text == Settings.player_name:
		return
	
	Settings.player_name = text
	LootLockerClient.set_player_name(text)
