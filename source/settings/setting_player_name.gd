extends LineEdit


@export var confirm_button: Button


func _ready():
	text = Settings.player_name
	confirm_button.pressed.connect(_set_player_name)
	focus_entered.connect(_focus)


func _set_player_name() -> void:
	if text == null or text == "" or text == Settings.player_name:
		return
	
	Settings.player_name = text
	LootLockerClient.set_player_name(text)


func _focus() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		text = JavaScriptBridge.eval("prompt('%s', '%s');" % ["Enter nickname:", text], true)
		find_valid_focus_neighbor(SIDE_RIGHT).grab_focus()
