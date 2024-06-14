class_name ItemStop
extends Item

@export var bits: int = 8


func use() -> void:
	_monster.set_speed(8, bits)
	Message.create(_world, position - Constants.HALF_FACTOR_VECTOR, "[color=orange]%s" % tr("Монстр замедлен!"))
	queue_free()
