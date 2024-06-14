extends LineEdit

@export var confirm_button: Button
@export var menu: Menu


func _ready():
	text = Settings.player_name
	confirm_button.pressed.connect(_set_player_name)
	focus_entered.connect(_focus)
	
	if Settings.is_telegram:
		if OS.has_feature("web_android") or OS.has_feature("web_ios"):
			LootLockerClient.set_player_name(Settings.player_name)
			(get_parent() as Control).hide()


func _set_player_name() -> void:
	if text == null or text == "" or text == Settings.player_name:
		return
	
	Settings.player_name = text
	menu.set_nickame_label()
	LootLockerClient.set_player_name(text)


func _focus() -> void:
	if OS.has_feature("web_android") or OS.has_feature("web_ios"):
		text = JavaScriptBridge.eval("prompt('%s', '%s');" % ["Enter nickname:", text], true)
		find_valid_focus_neighbor(SIDE_RIGHT).grab_focus()
