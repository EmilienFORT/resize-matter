extends Node3D

@onready var cube = $cube
@onready var cube_animation = $cube_animation
@onready var zone = $zone
@onready var glove_sfx = $gloveSFX

func _on_zone_body_entered(body):
	if body.is_in_group("Player"):
		print("cube gun récupéré")
		Gameplay.cube_gun = true
		cube.visible = false
		glove_sfx.play()
		Gameplay.enemy_sleeping = false
		zone.set_deferred("monitoring",false)
