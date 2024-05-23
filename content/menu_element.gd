class_name MenuElement
extends Control

@export var focus_element: Control


func show_and_focus() -> void:
	show()
	focus_element.grab_focus()
