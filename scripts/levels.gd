extends Node3D

@onready var ascenseur = $ascenseur_begin
@onready var player = $Player

# Called when the node enters the scene tree for the first time.
func _ready():
	if Gameplay.ascenseur_position_x != null && Gameplay.player_position_x != null && Gameplay.ascenseur_position_z != null && Gameplay.player_position_z != null && Gameplay.player_rotation_y != null && Gameplay.head_rotation_x != null:
		# POSITION
		player.position.x = - (Gameplay.ascenseur_position_x - Gameplay.player_position_x)
		player.position.z = - (Gameplay.ascenseur_position_z - Gameplay.player_position_z)

		# ROTATION
		player.rotation.y = Gameplay.player_rotation_y

		player.get_node("Head").rotation.x = Gameplay.head_rotation_x
	else:
		pass

