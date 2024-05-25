class_name ItemTreasure
extends Item

@export var _points: int = 32


func use() -> void:
	var points: int = _world.game.add_points(_points, position, false)
	Message.create(_world, _player.position, "[color=gold]%s +%s" % [tr("Сокровище!"), points])
	queue_free()
