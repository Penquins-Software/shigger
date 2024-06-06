extends Control


@export_file("*.tscn") var next_scene_file
@export var animation_player: AnimationPlayer


func _ready():
	if OS.has_feature("web"):
		load_next_scene()
	else:
		animation_player.animation_finished.connect(load_next_scene)


func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("mouse_left"):
		load_next_scene()


func load_next_scene(_anim_name: StringName = ""):
	get_tree().change_scene_to_file(next_scene_file)
