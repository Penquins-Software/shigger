extends Node

signal locale_was_changed

const PATH_TO_CONFIG = "user://config.ini"

enum AudioBus {
	MASTER,
	SFX,
	MUSIC,
}

var audio_bus_name: Dictionary = {
	AudioBus.MASTER : &"Master",
	AudioBus.SFX : &"SFX",
	AudioBus.MUSIC : &"Music",
}

var config: ConfigFile

var player_name: String = "" : set = _set_player_name
var locale: String = OS.get_locale() : set = _set_locale
var screen_mode: DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_WINDOWED : set = _set_screen_mode

var master_volume: int = 50 : set = _set_master_volume
var sfx_volume: int = 50 : set = _set_sfx_volume
var music_volume: int = 50 : set = _set_music_volume

var intro: bool = false
var tutorial: bool = false
var camera_shaking: bool = true : set = _set_camera_shaking
var additional_visualization: bool = true : set = _set_additional_visualization
var impact_sound: bool = true : set = _set_impact_sound

var is_telegram: bool = false


func _set_player_name(new_name: String) -> void:
	player_name = new_name
	print("Player name: %s" % player_name);

func _set_locale(new_locale: String) -> void:
	locale = new_locale
	TranslationServer.set_locale(locale)
	locale_was_changed.emit()
	print("Locale: %s" % locale);

func _set_screen_mode(mode: DisplayServer.WindowMode) -> void:
	screen_mode = mode
	DisplayServer.window_set_mode(screen_mode)
	print("Screen mode: %s" % screen_mode);

func _set_master_volume(value: int) -> void:
	master_volume = value
	var db: float = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus_name[AudioBus.MASTER]), db)
	print("%s bus volume is set to %s db." % [audio_bus_name[AudioBus.MASTER], db]);

func _set_sfx_volume(value: int) -> void:
	sfx_volume = value
	var db: float = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus_name[AudioBus.SFX]), db)
	print("%s bus volume is set to %s db." % [audio_bus_name[AudioBus.SFX], db]);

func _set_music_volume(value: int) -> void:
	music_volume = value
	var db: float = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(audio_bus_name[AudioBus.MUSIC]), db)
	print("%s bus volume is set to %s db." % [audio_bus_name[AudioBus.MUSIC], db]);

func _set_camera_shaking(value: bool) -> void:
	camera_shaking = value
	print("Camera shaking: %s" % value);

func _set_additional_visualization(value: bool) -> void:
	additional_visualization = value
	print("Additional visualization: %s" % value);

func _set_impact_sound(value: bool) -> void:
	impact_sound = value
	print("Impact sound: %s" % value);


func _enter_tree():
	load_config()


func _exit_tree():
	save_config()


func save_config() -> void:
	print("Saving settings.")
	if config == null:
		config = ConfigFile.new()
	
	config.set_value("profile", "player_name", player_name)
	
	config.set_value("general_settings", "locale", locale)
	
	config.set_value("screen_settings", "mode", int(screen_mode))
	
	config.set_value("audio_settings", "master_volume", master_volume)
	config.set_value("audio_settings", "sfx_volume", sfx_volume)
	config.set_value("audio_settings", "music_volume", music_volume)
	
	config.set_value("game_settings", "intro", intro)
	config.set_value("game_settings", "turorial", tutorial)
	config.set_value("game_settings", "shaking", camera_shaking)
	config.set_value("game_settings", "additional_visualization", additional_visualization)
	config.set_value("game_settings", "impact_sound", impact_sound)
	
	config.save(PATH_TO_CONFIG)


func load_config() -> void:
	print("Loading settings.")
	if config == null:
		config = ConfigFile.new()
	
	var error = config.load(PATH_TO_CONFIG)
	if error == OK:
		player_name = config.get_value("profile", "player_name", "")
		
		locale = config.get_value("general_settings", "locale", "en")
		
		screen_mode = config.get_value("screen_settings", "mode", DisplayServer.WINDOW_MODE_WINDOWED)
		
		master_volume = config.get_value("audio_settings", "master_volume", 50)
		sfx_volume = config.get_value("audio_settings", "sfx_volume", 50)
		music_volume = config.get_value("audio_settings", "music_volume", 50)
		
		intro = config.get_value("game_settings", "intro", true)
		camera_shaking = config.get_value("game_settings", "shaking", true)
		tutorial = config.get_value("game_settings", "turorial", true)
		additional_visualization = config.get_value("game_settings", "additional_visualization", true)
		impact_sound = config.get_value("game_settings", "impact_sound", true)
		
		print("Configuration file loaded successfully!")
	else:
		print("Failed to read configuration file: %s" % error)
	
	var first_name = HelpFunctions.get_parameter("user_first_name")
	var user_name = HelpFunctions.get_parameter("username")
	if not first_name == "" or not user_name == "":
		is_telegram = true
		if player_name == "" or player_name == "<null>":
			if not user_name == "":
				player_name = user_name
			else:
				player_name = first_name


func set_audio_volume(bus: AudioBus, value: int) -> void:
	match bus:
		AudioBus.MASTER:
			master_volume = value
		AudioBus.SFX:
			sfx_volume = value
		AudioBus.MUSIC:
			music_volume = value


func get_audio_volume(bus: AudioBus) -> int:
	match bus:
		AudioBus.MASTER:
			return master_volume
		AudioBus.SFX:
			return sfx_volume
		AudioBus.MUSIC:
			return music_volume
		_:
			return 0
