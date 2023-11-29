extends Node

const SAVE_FILE_PATH = "user://savedata.save"
const SETTING_FILE_PATH = "user://settingdata.save"

var level_unlocked = [false,false,false]
var settings = [0,0]

var audio_bus = AudioServer.get_bus_index("Master")

func _ready():
	load_unlocked()
	load_settings()
	
	if level_unlocked != null:
		Gameplay.lv_2 = level_unlocked[0]
		Gameplay.lv_3 = level_unlocked[1]
		Gameplay.lv_4 = level_unlocked[2]
	
	if settings[0] == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if settings[1] == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	AudioServer.set_bus_volume_db(audio_bus,settings[1])

# NIVEAUX

func save_unlocked():
	var save_data = FileAccess.open(SAVE_FILE_PATH,FileAccess.WRITE)
	save_data.store_var(level_unlocked)

func load_unlocked():
	var save_data = FileAccess.open(SAVE_FILE_PATH,FileAccess.READ)
	if FileAccess.file_exists(SAVE_FILE_PATH):
		level_unlocked = save_data.get_var()
		return level_unlocked

# MENU OPTIONS 

func save_settings():
	var settings_data = FileAccess.open(SETTING_FILE_PATH,FileAccess.WRITE)
	settings_data.store_var(settings)

func load_settings():
	var settings_data = FileAccess.open(SETTING_FILE_PATH,FileAccess.READ)
	if FileAccess.file_exists(SETTING_FILE_PATH):
		if settings_data != null:
			settings = settings_data.get_var()
		return settings
