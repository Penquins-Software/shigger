extends Button

@export var _action: StringName
var _a: InputEventAction


func _ready():
	_a = InputEventAction.new()
	_a.action = _action
	_a.pressed = true
	
	pressed.connect(Input.parse_input_event.bind(_a))
