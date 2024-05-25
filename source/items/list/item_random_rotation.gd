class_name ItemRandomRotation
extends Item


func use() -> void:
	_player.camera.rotate_by_parts_in_bit(randf_range(360, 720), randi_range(16, 24))
	Message.create(_world, _player.position, "[color=aqua]%s" % tr("Круговорот!"))
	queue_free()
