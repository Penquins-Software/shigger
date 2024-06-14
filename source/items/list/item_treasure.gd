class_name ItemTreasure
extends Item

@export var _points: int = 16


func use() -> void:
	var result_points = _points * (1 + int(position.y) / 2048)
	result_points = _world.game.add_points(result_points, position, false)
	Message.create(_world, position - Constants.HALF_FACTOR_VECTOR, "[color=gold]%s +%s" % [tr("Сокровище!"), result_points])
	queue_free()
