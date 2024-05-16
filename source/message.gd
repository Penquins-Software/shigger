class_name Message
extends RichTextLabel


static var prefab: PackedScene = ResourceLoader.load("res://Scenes/message.tscn")
static var is_left: bool = false
static var shift_speed: Vector2 = Vector2(0, -64)
static var shift_start: Vector2 = Vector2(32, 16)


var time: float = 2.0
var current_time: float = 0.0


func _process(delta):
	current_time += delta
	if current_time > time:
		queue_free()
		return
	
	position += shift_speed * delta
	modulate.a = current_time / time


func show_message(message: String, showing_time: float = 2.0) -> void:
	text = "[center]" + message
	time = showing_time
	if is_left:
		rotation_degrees = randf_range(-10.0, -5.0)
		position.x -= randf_range(16.0, 24.0)
	else:
		rotation_degrees = randf_range(5.0, 10.0)
		position.x += randf_range(16.0, 24.0)
	is_left = not is_left


static func create(sender: Node, pos: Vector2, text: String, showing_time: float = 2.0, delay: float = 0.1) -> void:
	await sender.get_tree().create_timer(delay, false)
	
	var message = prefab.instantiate() as Message
	sender.add_child(message)
	pos -= message.size / 2
	pos += shift_start
	message.position = pos
	message.show_message(text, showing_time)
