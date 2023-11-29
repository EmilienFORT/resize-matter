extends Control

@onready var main = $main
@onready var levels = $levels
@onready var settings_label = $settings_label
@onready var settings = $settings
@onready var back = $back

@onready var glitch_animation = $"../../glitch_animation"

@onready var level_2 = $levels/VBoxContainer/level2
@onready var level_3 = $levels/VBoxContainer/level3
@onready var level_4 = $levels/VBoxContainer/level4

@onready var menu_SFX = $"../../AudioStreamPlayer3D"
var audio_bus = AudioServer.get_bus_index("Master")
@onready var display = $settings/VBoxContainer/display
@onready var audio = $settings/VBoxContainer/audio

# Called when the node enters the scene tree for the first time.
func _ready():
	main.visible = true
	levels.visible = false
	settings_label.visible = false
	settings.visible = false
	back.visible = false
	
	display.selected = Save.settings[0]
	audio.value = Save.settings[1]
	
	# Niveaux bloqués / débloqués
	if Gameplay.lv_2 == false:
		level_2.disabled = true
	else:
		level_2.disabled = false
	
	if Gameplay.lv_3 == false:
		level_3.disabled = true
	else:
		level_3.disabled = false
	
	if Gameplay.lv_4 == false:
		level_4.disabled = true
	else:
		level_4.disabled = false

#########
# START #
#########

func _on_start_button_pressed():
	glitch_animation.play("button")
	main.visible = false
	levels.visible = true
	back.visible = true

func _on_setting_button_pressed():
	glitch_animation.play("button")
	main.visible = false
	settings_label.visible = true
	settings.visible = true
	back.visible = true

func _on_quit_button_pressed():
	glitch_animation.play("button")
	await glitch_animation.animation_finished
	get_tree().quit()

########
# BACK #
########

func _on_back_button_pressed():
	glitch_animation.play("button")
	main.visible = true
	levels.visible = false
	settings_label.visible = false
	settings.visible = false
	back.visible = false
	Save.settings[0] = display.selected
	Save.settings[1] = audio.value
	Save.save_settings()

func _input(_event):
	if Input.is_action_just_pressed("echap"):
		if main.visible == true: # Si Echap quand on est dans le menu principal, on quitte le jeu
			glitch_animation.play("button")
			await glitch_animation.animation_finished
			get_tree().quit()
		else: # Si Echap quand on est dans un autre menu, on revient au menu principal
			glitch_animation.play("button")
			main.visible = true
			levels.visible = false
			settings_label.visible = false
			settings.visible = false
			back.visible = false
			Save.settings[0] = display.selected
			Save.settings[1] = audio.value
			Save.save_settings()

##########
# LEVELS #
##########

func _on_level_1_pressed():
	glitch_animation.play("button")
	await glitch_animation.animation_finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_level_2_pressed():
	glitch_animation.play("button")
	await glitch_animation.animation_finished
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")

func _on_level_3_pressed():
	glitch_animation.play("button")
	await glitch_animation.animation_finished
	get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn")

func _on_level_4_pressed():
	glitch_animation.play("button")
	await glitch_animation.animation_finished
	get_tree().change_scene_to_file("res://scenes/levels/level_4.tscn")

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
