extends Control

@onready var main = $pause/main
@onready var back = $pause/back
@onready var settings_label = $pause/settings_label
@onready var settings = $pause/settings

@onready var glitch_animation = $glitch_animation

@onready var menu_SFX = $AudioStreamPlayer
var audio_bus = AudioServer.get_bus_index("Master")
@onready var display = $pause/settings/VBoxContainer/display
@onready var audio = $pause/settings/VBoxContainer/audio

func _ready():
	main.visible = true
	back.visible = false
	settings_label.visible = false
	settings.visible = false
	
	display.selected = Save.settings[0]
	audio.value = Save.settings[1]

#########
# PAUSE #
#########

func _on_resume_button_pressed():
	glitch_animation.play("button")
	await glitch_animation.animation_finished
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	get_tree().paused = false

func _on_setting_button_pressed():
	glitch_animation.play("button")
	main.visible = false
	back.visible = true
	settings_label.visible = true
	settings.visible = true

func _on_main_button_pressed():
	# Reset position
	Gameplay.ascenseur_position_x = null
	Gameplay.ascenseur_position_z = null
	
	Gameplay.player_position_x = null
	Gameplay.player_position_z = null
	
	# Reset rotation
	Gameplay.ascenseur_rotation_y = null
	Gameplay.player_rotation_y = null
	Gameplay.head_rotation_x = null
	
	glitch_animation.play("button")
	await glitch_animation.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu_main.tscn")

########
# BACK #
########

func _on_back_button_pressed():
	glitch_animation.play("button")
	main.visible = true
	settings_label.visible = false
	settings.visible = false
	back.visible = false
	Save.settings[0] = display.selected
	Save.settings[1] = audio.value
	Save.save_settings()

func _input(_event):
	if Input.is_action_just_pressed("echap"):
		if main.visible == true: # Si Echap quand on est dans le menu principal, on revient dans la partie
			glitch_animation.play("button")
			await glitch_animation.animation_finished
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			visible = false
			get_tree().paused = false
		else: # Si Echap quand on est dans un autre menu, on revient au menu pause
			glitch_animation.play("button")
			main.visible = true
			settings_label.visible = false
			settings.visible = false
			back.visible = false
			Save.settings[0] = display.selected
			Save.settings[1] = audio.value
			Save.save_settings()

############
# SETTINGS #
############

func _on_display_item_selected(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_audio_value_changed(value):
	AudioServer.set_bus_volume_db(audio_bus,value)
	menu_SFX.play()
