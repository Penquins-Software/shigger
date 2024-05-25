extends Control


@export var menu_button: MenuButton

var locales: PackedStringArray


func _ready():
	locales = TranslationServer.get_loaded_locales()
	
	if (locales.size() < 2):
		menu_button.disabled = true
		return
	
	for locale in locales:
		menu_button.get_popup().add_item(TranslationServer.get_locale_name(locale))
	
	menu_button.text = TranslationServer.get_locale_name(Settings.locale)
	
	menu_button.get_popup().index_pressed.connect(_set_language)


func _set_language(id: int):
	menu_button.text = menu_button.get_popup().get_item_text(id)
	Settings.locale = locales[id]
