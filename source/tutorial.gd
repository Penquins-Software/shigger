extends Control


@export_file("*.tscn") var next_scene_file
@export var confirm_button: Button


func _ready():
	confirm_button.pressed.connect(confirm)


func confirm() -> void:
	Settings.tutorial = true
	Settings.save_config()
	get_tree().change_scene_to_file(next_scene_file)
