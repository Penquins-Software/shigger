class_name ItemRandomRotation
extends Item


func use() -> void:
	_player.camera.rotate_for_time_by_parts(randf_range(360, 720), randf_range(4, 8), randi_range(32, 64))
	Message.create(_world, _player.position, "[color=aqua]%s" % tr("ItemRandomRotation"))
	queue_free()
