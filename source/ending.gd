extends Node2D

@export var text: RichTextLabel
@export var return_to_menu_button: Button
@export var animation_player: AnimationPlayer

@export_file("*.tscn") var next_scene_file


func _ready():
	text.text = "[center]Вас съели!\n\nВаш результат: %s очков." % Game.s_points;
	return_to_menu_button.pressed.connect(load_next_scene)


func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("mouse_left"):
		animation_player.play("RESET")
		return_to_menu_button.grab_focus()


func load_next_scene() -> void:
	get_tree().change_scene_to_file(next_scene_file)
