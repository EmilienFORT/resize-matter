extends Node3D

@onready var glove = $Glove
@onready var cylinder = $Cylinder
@onready var zone = $zone
@onready var glove_sfx = $gloveSFX

func _on_zone_body_entered(body):
	if body.is_in_group("Player"):
		print("gant récupéré")
		Gameplay.glove = true
		glove.visible = false
		cylinder.visible = false
		glove_sfx.play()
		zone.set_deferred("monitoring",false)
