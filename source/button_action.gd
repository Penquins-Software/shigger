extends Button

@export var _action: StringName
var _a: InputEventAction


func _ready():
	_a = InputEventAction.new()
	_a.action = _action
	_a.pressed = true
	
	pressed.connect(_emit_action)


func _emit_action():
	Input.parse_input_event(_a)
	release_focus()
