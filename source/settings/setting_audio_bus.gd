extends Control

@export var bus: Settings.AudioBus

@export var slider: HSlider
@export var spin_box: SpinBox


func _ready():
	slider.value = Settings.get_audio_volume(bus)
	spin_box.value = slider.value
	
	slider.value_changed.connect(_slider_value_changed)
	spin_box.value_changed.connect(_spin_box_value_changed)


func _slider_value_changed(value: float):
	spin_box.value = slider.value;
	Settings.set_audio_volume(bus, int(value))


func _spin_box_value_changed(value: float):
	slider.value = spin_box.value
