class_name ItemRandomRotation
extends Item


func use() -> void:
	_player.camera.rotate_by_parts_in_bit(randf_range(360, 720), randi_range(16, 24))
	Message.create(_world, position - Constants.HALF_FACTOR_VECTOR, "[color=%s]%s" % [Color(0.678, 0.812, 0.729).to_html(), tr("Круговорот!")])
	queue_free()
