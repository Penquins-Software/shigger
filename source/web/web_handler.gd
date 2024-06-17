extends Node

signal focus()
signal blur()

var callback_focus = JavaScriptBridge.create_callback(_on_focus)
var callback_blur = JavaScriptBridge.create_callback(_on_blur)

#var _db: float


func _ready():
	if not OS.has_feature("web"):
		queue_free()
		return
	
	#_db = linear_to_db(Settings.master_volume / 100.0)
	
	var window = JavaScriptBridge.get_interface("window")
	window.addEventListener("focus", callback_focus)
	window.addEventListener("blur", callback_blur)


func _on_focus(_event):
	focus.emit()
	AudioServer.set_bus_volume_db(0, linear_to_db(Settings.master_volume / 100.0))


func _on_blur(_event):
	blur.emit()
	#_db = AudioServer.get_bus_volume_db(0)
	AudioServer.set_bus_volume_db(0, linear_to_db(0))
