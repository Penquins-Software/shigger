extends CheckBox


func _ready():
	button_pressed = Settings.camera_shaking
	toggled.connect(Settings._set_camera_shaking)
