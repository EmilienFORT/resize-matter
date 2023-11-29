extends Control

@onready var white_animation = $white_animation
@onready var glitch_animation = $glitch_animation

func _ready():
	white_animation.play("white")

func _on_menu_button_pressed():
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
