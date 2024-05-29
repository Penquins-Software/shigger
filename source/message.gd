class_name Message
extends RichTextLabel


static var prefab: PackedScene = ResourceLoader.load("res://content/message.tscn")
static var is_left: bool = false
static var shift_speed: Vector2 = Vector2(0, -32)
static var shift_start: Vector2 = Vector2(32, 16)

static var increased_size: Vector2 = Vector2(1.15, 1.15)


func _process(delta):
	position += shift_speed * delta


func show_message(message: String, bits: int = 6) -> void:
	text = "[center]" + message
	if is_left:
		rotation_degrees = randf_range(-5.0, -1.0)
		position.x -= randf_range(8.0, 12.0)
	else:
		rotation_degrees = randf_range(1.0, 5.0)
		position.x += randf_range(8.0, 12.0)
	is_left = not is_left
	
	for bit in bits:
		await RhythmMachine.bit_1_1
		scale = increased_size
		await RhythmMachine.bit_1_5
		scale = Vector2.ONE
		modulate.a = 1 - bit / float(bits)
	
	queue_free()


static func create(sender: Node, pos: Vector2, _text: String, bits: int = 6) -> void:
	var message = prefab.instantiate() as Message
	sender.add_child(message)
	pos -= message.size / 2
	pos += shift_start
	message.position = pos
	message.show_message(_text, bits)
