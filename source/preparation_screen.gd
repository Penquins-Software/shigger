class_name PreparationScreen
extends Control

signal complete

@export var _timer_label: RichTextLabel

var _bits: int = 0 

var increased_size: Vector2 = Vector2(1.5, 1.5)


func _ready():
	RhythmMachine.bit_1_1.connect(bit)
	RhythmMachine.bit_1_5.connect(bit_1_5)


func bit() -> void:
	if _bits <= 0:
		return
	
	_bits -= 1
	_timer_label.text = "[center]" + str(_bits)
	_timer_label.scale = increased_size
	if _bits <= 0:
		complete.emit()
		hide()


func bit_1_5() -> void:
	_timer_label.scale = Vector2.ONE


func show_screen(bits: int = 3) -> void:
	_bits = bits
	_timer_label.text = "[center]" + str(_bits)
	_timer_label.scale = increased_size
	show()
