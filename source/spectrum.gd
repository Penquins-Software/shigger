class_name Spectrum
extends Control

@export var fill_color: Color
@export var outline_color: Color

@export var vu_count: int = 32
@export var freq_max: float = 11050.0

@export var height_scale: float = 8.0
@export var mib_db = 60
@export var animation_speed = 0.08

@export var x_mirror: bool
@export var x_mirror_shift: float = 0.0

var spectrum
var min_values = []
var max_values = []


func _ready():
	spectrum = AudioServer.get_bus_effect_instance(2, 0)
	min_values.resize(vu_count)
	max_values.resize(vu_count)
	min_values.fill(0.0)
	max_values.fill(0.0)
	
	RhythmMachine.every_sixteenth_bit.connect(queue_redraw)


func _process(_delta):
	var data = []
	var prev_hz = 0

	for i in range(1, vu_count + 1):
		var hz = i * freq_max / vu_count
		var magnitude = spectrum.get_magnitude_for_frequency_range(prev_hz, hz).length()
		var energy = clampf((mib_db + linear_to_db(magnitude)) / mib_db, 0, 1)
		var height = energy * size.y * height_scale
		data.append(height)
		prev_hz = hz

	for i in range(vu_count):
		if data[i] > max_values[i]:
			max_values[i] = data[i]
		else:
			max_values[i] = lerp(max_values[i], data[i], animation_speed)

		if data[i] <= 0.0:
			min_values[i] = lerp(min_values[i], 0.0, animation_speed)


func _draw():
	if spectrum == null:
		return
	var w = size.x / vu_count
	for i in range(vu_count):
		var min_height = min_values[i]
		var max_height = max_values[i]
		var height = lerp(min_height, max_height, animation_speed)

		draw_rect(
				Rect2(w * i, size.y - height, w - 2, height),
				fill_color
				#Color.from_hsv(float(VU_COUNT * 0.6 + i * 0.5) / VU_COUNT, 0.5, 0.6)
		)
		draw_line(
				Vector2(w * i, size.y - height),
				Vector2(w * i + w - 2, size.y - height),
				outline_color,
				#Color.from_hsv(float(VU_COUNT * 0.6 + i * 0.5) / VU_COUNT, 0.5, 1.0),
				2.0,
				false
		)
		
		if x_mirror:
			draw_rect(
				Rect2(-w * (i + 1) - x_mirror_shift, size.y - height, w - 2, height),
				fill_color
			)
			draw_line(
					Vector2(-w * (i + 1) - x_mirror_shift, size.y - height),
					Vector2(-w * (i + 1) + w - 2 - x_mirror_shift, size.y - height),
					outline_color,
					2.0,
					false
			)
