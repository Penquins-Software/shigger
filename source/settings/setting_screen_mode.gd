extends MenuButton


func _ready():
	text = get_popup().get_item_text(get_popup().get_item_index(Settings.screen_mode))
	get_popup().index_pressed.connect(_set_screen_mode)
	if OS.has_feature("mobile") or OS.has_feature("web"):
		(get_parent() as Control).hide()


func _set_screen_mode(index: int) -> void:
	Settings.screen_mode = get_popup().get_item_id(index)
	text = get_popup().get_item_text(index);
	
