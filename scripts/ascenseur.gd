extends Node3D

@onready var button = $Button
@onready var animations = $Animations
@onready var interieur = $interieur
@onready var mur_invisible = $mur_invisible/mur_invisible

@onready var music = $Music
@onready var sfx_moving = $SFX_moving

func _input(_event):
	if Gameplay.ascenseur == true:
		animations.play("doors_open")
		Gameplay.ascenseur = false

func _on_interieur_body_entered(body):
	if body.is_in_group("Player"):
		print("fin du niveau")
		mur_invisible.disabled = false
		animations.play("doors_close")
		await animations.animation_finished
		animations.play("ascenseur_moving")
		sfx_moving.play()
		await get_tree().create_timer(5.0).timeout
		
		# Position
		Gameplay.ascenseur_position_x = position.x
		Gameplay.ascenseur_position_z = position.z
		
		Gameplay.player_position_x = body.position.x
		Gameplay.player_position_z = body.position.z
		
		# Rotation
		Gameplay.ascenseur_rotation_y = rotation.y
		Gameplay.player_rotation_y = body.rotation.y
		Gameplay.head_rotation_x = body.get_node("Head").rotation.x
		
		# Vers niveau suivant
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		var next_level_path = "res://scenes/levels/level_" + str(next_level_number) + ".tscn"
		
		if next_level_number == 2: # Débloque le niveau 2 dans le menu principal
			Gameplay.lv_2 = true
			Save.level_unlocked[0] = true
		if next_level_number == 3: # Débloque le niveau 3 dans le menu principal
			Gameplay.lv_3 = true
			Save.level_unlocked[1] = true
		if next_level_number == 4: # Débloque le niveau 3 dans le menu principal
			Gameplay.lv_4 = true
			Save.level_unlocked[2] = true
		Save.save_unlocked()
		
		get_tree().change_scene_to_file(next_level_path)
