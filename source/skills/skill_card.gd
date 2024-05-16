class_name SkillCard
extends Control

signal selected(skill_card: SkillCard)


var player: Player


func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)


func _accept() -> void:
	selected.emit(self)


func _on_mouse_entered() -> void:
	modulate = Color.ROSY_BROWN


func _on_mouse_exited() -> void:
	modulate = Color.WHITE


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		_accept()
