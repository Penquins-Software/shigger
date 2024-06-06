extends CheckBox


func _ready():
	button_pressed = Settings.impact_sound
	toggled.connect(Settings._set_impact_sound)
