extends RichTextLabel

@export var _version: String = "1.0.0"


func _ready():
	set_version()
	Settings.locale_was_changed.connect(set_version)


func set_version() -> void:
	text = "%s: %s" % [tr("Версия"), _version]
