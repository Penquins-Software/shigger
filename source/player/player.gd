class_name Player
extends Node2D

signal die
signal in_bit

@export var _world: World

@export var shake_animation_player: AnimationPlayer

@export var character_animated_sprite: AnimatedSprite2D
@export var effect_animated_sprite: AnimatedSprite2D

@export var light: Light2D

@export var _area: Area2D

@export var camera: PlayerCamera


var _action: bool = false
var _bit_1_4: bool = false
var _bit_2_3: bool = false


var _world_position: Vector2
var series_of_hits: int = 0

var damage: int = 1
var extra_multiplier: int = 1

var flashlight: bool = false
var fugu: bool = false

var wide_shovel: bool = false
var sideways_shovel: bool = false
var drill: bool = false


func _ready():
	camera.position_smoothing_enabled = Settings.camera_shaking
	camera.rotation_smoothing_enabled = Settings.camera_shaking
	
	_area.area_entered.connect(_on_area_entered)
	
	character_animated_sprite.animation_finished.connect(_on_animation_finished)
	
	RhythmMachine.bit_1_1.connect(bit_1_1)
	RhythmMachine.bit_1_4.connect(bit_1_4)
	RhythmMachine.bit_2_3.connect(bit_2_3)
	
	RhythmMachine.bit_changed.connect(bit_reset)


func _input(event):
	if _action:
		return
	
	if event.is_action_pressed("left"):
		if check_action():
			move_left()
	elif event.is_action_pressed("right"):
		if check_action():
			move_right()
	elif event.is_action_pressed("dig"):
		if check_action():
			dig()


func check_action() -> bool:
	_action = true
	var result = _bit_2_3 or _bit_1_4
	if not result:
		series_of_hits = 0
		Message.create(self, position, "[color=purple]Мимо...")
	else:
		in_bit.emit()
	return result


func move_left() -> void:
	try_move_in_world(Vector2.LEFT)


func move_right() -> void:
	try_move_in_world(Vector2.RIGHT)


func place(world_position: Vector2) -> void:
	_world_position = world_position
	position = _world_position * Constants.FACTOR


func try_move_in_world(direction: Vector2) -> void:
	var new_position = _world_position + direction
	if not _world.backs.has(new_position):
		return
	if _world.chunks.has(new_position):
		# На пути есть блок. Можно попробовать забраться на него.
		var upper_player_position = _world_position + Vector2.UP
		var upper_chunk_position = new_position + Vector2.UP
		if _world.chunks.has(upper_player_position) or _world.chunks.has(upper_chunk_position):
			return
		if not _world.backs.has(upper_chunk_position):
			return
		new_position = upper_chunk_position
	place(new_position)


func dig() -> void:
	var new_position = _world_position + Vector2.DOWN
	if _world.chunks.has(new_position):
		## Вибрация контролера.
		## Может не работать, обещают исправить в версии 4.3.
		## --------------------------------------------------
		Input.start_joy_vibration(0, 0.5, 1, 0.2)
		## --------------------------------------------------
		play_dig_animation()
		series_of_hits += 1
		hit_chunk(new_position)
	else:
		place(new_position)


func hit_chunk(chunk_position: Vector2, apply_modificators: bool = true) -> bool:
	if not _world.chunks.has(chunk_position):
		return false
	var chunk = _world.chunks[chunk_position]
	var result = chunk.dig(self)
	if result:
		_world.chunks.erase(chunk_position)
		_world.game.add_points(chunk.points * extra_multiplier)
		chunk.destoy()
	
	if apply_modificators:
		_apply_wide_shovel(chunk_position)
		_apply_sideways_shovel(chunk_position)
		_apply_drill(chunk_position)
	
	return result


func _apply_wide_shovel(hit_position: Vector2) -> void:
	if not wide_shovel:
		return
	
	hit_chunk(hit_position + Vector2.LEFT, false)
	hit_chunk(hit_position + Vector2.RIGHT, false)


func _apply_sideways_shovel(hit_position: Vector2) -> void:
	if not sideways_shovel:
		return
	
	hit_chunk(hit_position + Vector2(-1, -1), false)
	hit_chunk(hit_position + Vector2(1, -1), false)


func _apply_drill(hit_position: Vector2) -> void:
	if not drill:
		return
	
	hit_chunk(hit_position + Vector2.DOWN, false)


func play_dig_animation() -> void:
	if Settings.camera_shaking:
		shake_animation_player.play("Shake")
	
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
			Message.create(self, position, "[color=green]Вас спасла рыба ФУГУ!")
			place(_world_position + Vector2.DOWN)
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
	
	light.scale = Vector2(1.5, 1.5)
	
	for item in _world.items:
		if not item == null:
			item.turn_on_light()


func bit_reset(_bpm: int = 0) -> void:
	_bit_1_4 = true
	_bit_2_3 = false


func bit_1_1() -> void:
	bit_reset()


func bit_1_4() -> void:
	_bit_1_4 = false
	if not _action:
		series_of_hits = 0
	_action = false


func bit_2_3() -> void:
	_bit_2_3 = true


func set_animation_speed(bpm: RhythmMachine.BPM) -> void:
	var bpm_75_in_seconds = RhythmMachine.bpm_in_seconds[RhythmMachine.BPM.BPM75]
	character_animated_sprite.speed_scale = bpm_75_in_seconds / RhythmMachine.bpm_in_seconds[bpm]
