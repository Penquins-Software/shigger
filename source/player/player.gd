class_name Player
extends Node2D

signal die

@export var _world: World

@export var shake_animation_player: AnimationPlayer

@export var character_animated_sprite: AnimatedSprite2D
@export var effect_animated_sprite: AnimatedSprite2D

@export var light: Light2D

@export var _area: Area2D

@export var camera: PlayerCamera


var _world_position: Vector2
var series_of_hits: int = 0

var damage: int = 1
var extra_multiplier: int = 1

var flashlight: bool = false
var fugu: bool = false

var wide_shovel: bool = false
var sideways_shovel: bool = false
var drill: bool = false

var wide_shovel_p: bool = false
var sideways_shovel_p: bool = false
var drill_p: bool = false

var hit_queue: InputEvent
var first_bit: bool = true


func _ready():
	#camera.position_smoothing_enabled = Settings.camera_shaking
	#camera.rotation_smoothing_enabled = Settings.camera_shaking
	
	_area.area_entered.connect(_on_area_entered)
	
	character_animated_sprite.animation_finished.connect(_on_animation_finished)
	
	RhythmMachine.hit.connect(hit)
	RhythmMachine.miss.connect(miss)


func hit(event: InputEvent) -> void:
	if not get_parent().process_mode == PROCESS_MODE_INHERIT:
		hit_queue = event
		return
	
	if first_bit:
		first_bit = false
	
	if event.is_action_pressed("left"):
		move_left()
	elif event.is_action_pressed("right"):
		move_right()
	elif event.is_action_pressed("dig"):
		dig(_world_position + Vector2.DOWN)


func miss() -> void:
	if not get_parent().process_mode == PROCESS_MODE_INHERIT:
		hit_queue = null
		return
	
	if first_bit:
		first_bit = false
		return
	
	series_of_hits = 0
	#Message.create(self, position, "[color=purple]%s" % tr("Мимо..."))


func check_hit_queue() -> void:
	if hit_queue != null:
		hit(hit_queue);


func move_left() -> void:
	if sideways_shovel_p:
		dig(_world_position + Vector2.LEFT, false)
	else:
		try_move_in_world(Vector2.LEFT)


func move_right() -> void:
	if sideways_shovel_p:
		dig(_world_position + Vector2.RIGHT, false)
	else:
		try_move_in_world(Vector2.RIGHT)


func place(world_position: Vector2) -> void:
	_world_position = world_position
	position = _world_position * Constants.FACTOR


func try_move_in_world(direction: Vector2) -> void:
	var new_position = _world_position + direction
	if not _world.backs.has(new_position):
		return
	
	var is_active_trap: bool = false
	if _world.traps.has(new_position) and is_instance_valid(_world.traps[new_position]):
		is_active_trap = (_world.traps[new_position] as Trap).active
	
	if (_world.chunks.has(new_position) and is_instance_valid(_world.chunks[new_position])) or is_active_trap:
		# На пути есть блок. Можно попробовать забраться на него.
		var upper_player_position = _world_position + Vector2.UP
		var upper_chunk_position = new_position + Vector2.UP
		if _world.chunks.has(upper_player_position) or _world.chunks.has(upper_chunk_position):
			return
		if _world.traps.has(upper_player_position) and is_instance_valid(_world.traps[upper_player_position]):
			if (_world.traps[upper_player_position] as Trap).active:
				return
		if _world.traps.has(upper_chunk_position) and is_instance_valid(_world.traps[upper_chunk_position]):
			if (_world.traps[upper_chunk_position] as Trap).active:
				return
		if not _world.backs.has(upper_chunk_position):
			return
		new_position = upper_chunk_position
	
	if _world.traps.has(new_position) and is_instance_valid(_world.traps[new_position]):
		play_dig_animation()
		series_of_hits += 1
		var trap = _world.traps[new_position] as Trap
		if not trap.move_to():
			return
	
	place(new_position)


func dig(new_position: Vector2, apply_modificators: bool = true) -> void:
	if _world.chunks.has(new_position):
		play_dig_animation()
		series_of_hits += 1
		hit_chunk(new_position, apply_modificators)
	elif _world.traps.has(new_position) and is_instance_valid(_world.traps[new_position]):
		play_dig_animation()
		series_of_hits += 1
		var trap = _world.traps[new_position] as Trap
		if trap.move_to():
			place(new_position)
	else:
		place(new_position)


func hit_chunk(chunk_position: Vector2, apply_modificators: bool = true, play_sound: bool = true) -> bool:
	if wide_shovel_p and _world.items.has(chunk_position) and is_instance_valid(_world.items[chunk_position]):
		_world.items[chunk_position].use()
	#if wide_shovel_p and _world.items.has(chunk_position) and not _world.items[chunk_position] == null:
		#if not _world.items[chunk_position].is_queued_for_deletion():
			#_world.items[chunk_position].use()
	if not _world.chunks.has(chunk_position) or not is_instance_valid(_world.chunks[chunk_position]):
		return false
	#if not _world.chunks.has(chunk_position) or _world.chunks[chunk_position] == null:
		#return false
	#if _world.chunks[chunk_position].is_queued_for_deletion():
		#return false
	var chunk = _world.chunks[chunk_position]
	var result = chunk.dig(self, play_sound)
	if result:
		_world.chunks.erase(chunk_position)
		_world.game.add_points(chunk.points, chunk_position * Constants.FACTOR)
		Input.start_joy_vibration(0, 0.4, 0.6, 0.1)
	else:
		Input.start_joy_vibration(0, 0.6, 1.0, 0.15)
	
	if apply_modificators:
		_apply_wide_shovel(chunk_position)
		_apply_sideways_shovel(chunk_position)
		_apply_drill(chunk_position)
	
	return result


func _apply_wide_shovel(hit_position: Vector2) -> void:
	if not wide_shovel:
		return
	
	hit_chunk(hit_position + Vector2.LEFT, false, false)
	hit_chunk(hit_position + Vector2.RIGHT, false, false)


func _apply_sideways_shovel(hit_position: Vector2) -> void:
	if not sideways_shovel:
		return
	
	hit_chunk(hit_position + Vector2(-1, -1), false, false)
	hit_chunk(hit_position + Vector2(1, -1), false, false)


func _apply_drill(hit_position: Vector2) -> void:
	if not drill:
		return
	
	if drill_p and _world.chunks.has(hit_position + Vector2.DOWN):
		hit_chunk(hit_position + Vector2.DOWN + Vector2.DOWN, false, false)
	hit_chunk(hit_position + Vector2.DOWN, false, false)


func play_dig_animation() -> void:
	if Settings.camera_shaking:
		shake_animation_player.play("Shake")
	
	character_animated_sprite.frame = 0
	character_animated_sprite.play("digging")
	character_animated_sprite.modulate = Color(0.7, 0.7, 0.7)
	effect_animated_sprite.play("default")


func _on_area_entered(area: Area2D) -> void:
	if area is MonsterArea:
		if fugu:
			fugu = false
			var monster = area.get_parent() as Monster
			monster.set_speed(8, 24)
			monster.place(monster.world_position - Vector2(0, 4))
			Message.create(self, position, "[color=green]%s" % tr("Вас спасла рыба ФУГУ!"))
			place(_world_position + Vector2.DOWN)
			_world.game.hud.darker_skill_icon("Fugu")
		else:
			die.emit()


func _on_animation_finished() -> void:
	if character_animated_sprite.animation == "digging":
		character_animated_sprite.play("idle")
		character_animated_sprite.modulate = Color.WHITE


func get_damage() -> int:
	return damage


func get_flashlight() -> void:
	flashlight = true
	
	var animation_reset = shake_animation_player.get_animation("RESET")
	animation_reset.track_set_key_value(0, 0, Vector2(0.9, 0.9))
	
	var animation_shake = shake_animation_player.get_animation("Shake")
	animation_shake.track_set_key_value(0, 0, Vector2(0.9, 0.9))
	animation_shake.track_set_key_value(0, 1, Vector2.ONE)
	animation_shake.track_set_key_value(0, 2, Vector2(0.9, 0.9))
	
	shake_animation_player.play("RESET")
	
	light.scale = Vector2(1.5, 1.5)
	
	for item in _world.items:
		if is_instance_valid(_world.items[item]):
			_world.items[item].turn_on_light()
		#if not _world.items[item] == null:
			#if not _world.items[item].is_queued_for_deletion():
				#_world.items[item].turn_on_light()


func set_animation_speed(bpm: RhythmMachine.BPM) -> void:
	var bpm_75_in_seconds = RhythmMachine.bpm_in_seconds[RhythmMachine.BPM.BPM75]
	character_animated_sprite.speed_scale = bpm_75_in_seconds / RhythmMachine.bpm_in_seconds[bpm]


func start_darkened(value: float, bits: int) -> void:
	var part_value = value / bits
	for bit in bits:
		light.color = light.color.darkened(part_value)
		await RhythmMachine.bit_1_1
