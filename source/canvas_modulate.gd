class_name GameCanvas
extends CanvasModulate


func start_lightened(value: float, bits: int) -> void:
	var part_value = value / bits
	for bit in bits:
		color = color.lightened(part_value)
		await RhythmMachine.bit_1_1
