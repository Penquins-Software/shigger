extends CheckBox


func _ready():
	button_pressed = Settings.additional_visualization
	toggled.connect(Settings._set_additional_visualization)
