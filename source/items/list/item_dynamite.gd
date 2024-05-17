class_name ItemDynamite
extends Item

@export var explosion_sound: AudioStream


func use() -> void:
	var points: int = 0
	points += _world.destroy_chunk_by_position(_world_position, true)
	points += _world.destroy_chunk_by_position(_world_position + Vector2.LEFT, true)
	points += _world.destroy_chunk_by_position(_world_position + Vector2.LEFT + Vector2.LEFT, true)
	points += _world.destroy_chunk_by_position(_world_position + Vector2.RIGHT, true)
	points += _world.destroy_chunk_by_position(_world_position + Vector2.RIGHT + Vector2.RIGHT, true)
	points += _world.destroy_chunk_by_position(_world_position + Vector2.DOWN, true)
	points += _world.destroy_chunk_by_position(_world_position + Vector2.DOWN + Vector2.DOWN, true)
	points += _world.destroy_chunk_by_position(_world_position + Vector2.UP, true)
	points += _world.destroy_chunk_by_position(_world_position + Vector2.UP + Vector2.UP, true)
	SFXPlayer.play(explosion_sound)
	Message.create(_world, _player.position, "[color=red]ВЗРЫВ! +%s" % points)
	queue_free()
