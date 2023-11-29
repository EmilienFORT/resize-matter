extends Node3D

@onready var cube = $cube
@onready var cube_amount_label = $cube_amount_label

@export var cube_amount = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	var current_level = get_tree().current_scene
	if current_level.name == "level_1" or current_level.name == "level_2" or current_level.name == "level_3": 
		# au début des niveaux 1, 2 et 3, le joueur n'a pas le cube gun
		Gameplay.cube_gun = false
		cube.visible = false
		cube_amount_label.visible = false
	else:
		Gameplay.cube_gun = true
		cube.visible = true
		cube_amount_label.visible = true

func _physics_process(_delta):
	if Gameplay.cube_gun == true: 
		# Tant que le joueur n'a pas récupéré le cube gun, son cube gun ne s'affiche pas
		cube.visible = true
		cube_amount_label.visible = true
		cube_amount_label.text = str(cube_amount)
