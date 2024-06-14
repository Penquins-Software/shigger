extends Node2D

@export var text: RichTextLabel
@export var return_to_menu_button: Button
@export var share_button: Button
@export var animation_player: AnimationPlayer

@export_file("*.tscn") var next_scene_file


func _ready():
	text.text = "[center]%s\n\n%s" % [tr("Вас съели!"), tr("Ваш результат: %s очков.") %  HelpFunctions.format_integer(Game.s_points)];
	return_to_menu_button.pressed.connect(load_next_scene)
	
	if Settings.is_telegram:
		share_button.show()
		share_button.pressed.connect(TelegramClient.share_score)


func _input(event):
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("mouse_left"):
		animation_player.play("RESET")
		return_to_menu_button.grab_focus()


func load_next_scene() -> void:
	get_tree().change_scene_to_file(next_scene_file)
