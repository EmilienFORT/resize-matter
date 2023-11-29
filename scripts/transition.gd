extends Node3D

@onready var ascenseur = $ascenseur
@onready var player = $Player
#var player_character = preload("res://scenes/player.tscn")

@onready var ascenseur_movement = $ascenseur_movement

func _ready():
	ascenseur_movement.play("light_flicker")
	
	# POSITION
	player.position.x = - (Gameplay.ascenseur_position_x - Gameplay.player_position_x)
	player.position.z = - (Gameplay.ascenseur_position_z - Gameplay.player_position_z)
	
	# ROTATION
	ascenseur.rotation.y = Gameplay.ascenseur_rotation_y
	player.rotation.y = Gameplay.player_rotation_y
	
	player.get_node("Head").rotation.x = Gameplay.head_rotation_x
	
	await ascenseur_movement.animation_finished
	ascenseur_movement.play("moving")
	
	await get_tree().create_timer(5.0).timeout
#	check_position()
	
	get_tree().change_scene_to_file("res://scenes/levels/level_2test.tscn")
	
#	ResourceLoader.load("res://scenes/levels/level_2.tscn")

#func check_position():
#	# Position
#	Gameplay.ascenseur_position_x = position.x
#	Gameplay.ascenseur_position_z = position.z
#
#	Gameplay.player_position_x = player.position.x
#	Gameplay.player_position_z = player.position.z
#
#	# Rotation
#	Gameplay.ascenseur_rotation_y = rotation.y
#	Gameplay.player_rotation_y = player.rotation.y
#	Gameplay.head_rotation_x = player.get_node("Head").rotation.x
#	pass


