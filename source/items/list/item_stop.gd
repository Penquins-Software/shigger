class_name ItemStop
extends Item

@export var bits: int = 8


func use() -> void:
	_monster.set_speed(8, bits)
	Message.create(_world, _player.position, "[color=orange]%s" % tr("MonsterSlowed"))
	queue_free()
