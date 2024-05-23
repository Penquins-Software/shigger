class_name SkillCard
extends Control

signal selected(skill_card: SkillCard)

@export var _texture: Texture2D
@export var _arrow_label: RichTextLabel

var player: Player

var increased_size: Vector2 = Vector2(1.05, 1.05)


func _ready():
	pass


func _enter_tree():
	RhythmMachine.bit_1_5.connect(bit_1_5)
	RhythmMachine.bit_1_1.connect(bit_1_1)


func _exit_tree():
	RhythmMachine.bit_1_5.disconnect(bit_1_5)
	RhythmMachine.bit_1_1.disconnect(bit_1_1)


func press() -> void:
	modulate = Color.INDIAN_RED


func bit_1_5() -> void:
	scale = Vector2.ONE
	modulate = Color.WHITE


func bit_1_1() -> void:
	scale = increased_size


func _accept() -> void:
	selected.emit(self)


func left() -> void:
	_arrow_label.text = "[center]←"


func right() -> void:
	_arrow_label.text = "[center]→"


func _on_mouse_entered() -> void:
	modulate = Color.ROSY_BROWN


func _on_mouse_exited() -> void:
	modulate = Color.WHITE


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		_accept()
