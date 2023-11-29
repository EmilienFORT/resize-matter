extends Node3D

#@onready var player = 
@onready var ascenseur = $"."

@onready var animations = $Animations
@onready var interieur = $interieur

#func _ready():
#	# POSITION
#	player.position.x = - (Gameplay.ascenseur_position_x - Gameplay.player_position_x)
#	player.position.z = - (Gameplay.ascenseur_position_z - Gameplay.player_position_z)

	# ROTATION
#	ascenseur.rotation.y = Gameplay.ascenseur_rotation_y
#	player.rotation.y = Gameplay.player_rotation_y
#
#	player.get_node("Head").rotation.x = Gameplay.head_rotation_x


func _on_interieur_body_exited(body):
	if body.is_in_group("Player"):
		print("fin du niveau")
		animations.play("doors_close")
		await animations.animation_finished
		interieur.set_deferred("monitoring",false)
