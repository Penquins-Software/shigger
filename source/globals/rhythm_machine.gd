extends Node

signal bit_1_1
signal bit_1_5
signal bit_1_4
signal bit_1_3
signal bit_1_2
signal bit_2_3
signal bit_3_4
signal bit_4_5

signal bit_changed(bpm: BPM)

enum BPM {
	BPM75,
	BPM100,
	BPM120,
	BPM150,
	BPM200,
}

const bpm_in_seconds: Dictionary = {
	BPM.BPM75 : 0.8,
	BPM.BPM100 : 0.6,
	BPM.BPM120 : 0.5,
	BPM.BPM150 : 0.4,
	BPM.BPM200 : 0.3,
}

var current_bpm: BPM

var bpm_in_seconds_1_1: float
var bpm_in_seconds_1_5: float
var bpm_in_seconds_1_4: float
var bpm_in_seconds_1_3: float
var bpm_in_seconds_1_2: float
var bpm_in_seconds_2_3: float
var bpm_in_seconds_3_4: float
var bpm_in_seconds_4_5: float

var playing: bool = false
var current_time: float = 0

var _bit_1_5: bool = false
var _bit_1_4: bool = false
var _bit_1_3: bool = false
var _bit_1_2: bool = false
var _bit_2_3: bool = false
var _bit_3_4: bool = false
var _bit_4_5: bool = false


func _process(delta):
	if not playing:
		return
	
	current_time += delta
	
	if not _bit_1_5 and current_time > bpm_in_seconds_1_5:
		bit_1_5.emit()
		_bit_1_5 = true
	elif not _bit_1_4 and current_time > bpm_in_seconds_1_4:
		bit_1_4.emit()
		_bit_1_4 = true
	elif not _bit_1_3 and current_time > bpm_in_seconds_1_3:
		bit_1_3.emit()
		_bit_1_3 = true
	elif not _bit_1_2 and current_time > bpm_in_seconds_1_2:
		bit_1_2.emit()
		_bit_1_2 = true
	elif not _bit_2_3 and current_time > bpm_in_seconds_2_3:
		bit_2_3.emit()
		_bit_2_3 = true
	elif not _bit_3_4 and current_time > bpm_in_seconds_3_4:
		bit_3_4.emit()
		_bit_3_4 = true
	elif not _bit_4_5 and current_time > bpm_in_seconds_4_5:
		bit_4_5.emit()
		_bit_4_5 = true
	
	if current_time > bpm_in_seconds_1_1:
		bit_1_1.emit()
		reset(current_time - bpm_in_seconds_1_1)


func reset(time: float = 0) -> void:
	current_time = time
	_bit_1_5 = false
	_bit_1_4 = false
	_bit_1_3 = false
	_bit_1_2 = false
	_bit_2_3 = false
	_bit_3_4 = false
	_bit_4_5 = false


func set_bpm(bpm: BPM) -> void:
	bpm_in_seconds_1_1 = bpm_in_seconds[bpm]
	bpm_in_seconds_1_5 = bpm_in_seconds_1_1 / 5
	bpm_in_seconds_1_4 = bpm_in_seconds_1_1 / 4
	bpm_in_seconds_1_3 = bpm_in_seconds_1_1 / 3
	bpm_in_seconds_1_2 = bpm_in_seconds_1_1 / 2
	bpm_in_seconds_2_3 = bpm_in_seconds_1_1 * 2 / 3
	bpm_in_seconds_3_4 = bpm_in_seconds_1_1 * 3 / 4
	bpm_in_seconds_4_5 = bpm_in_seconds_1_1 * 4 / 5
	reset()
	current_bpm = bpm
	bit_changed.emit(bpm)


func start(from_start: bool) -> void:
	playing = true
	if from_start:
		reset()


func stop() -> void:
	playing = false
