extends Node3D

@onready var blood = $blood
@onready var blood_sfx = $bloodSFX

func _ready():
	blood.emitting = true
	blood_sfx.play()
	top_level = true
