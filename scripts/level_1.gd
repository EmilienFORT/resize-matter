extends Node3D

var cube_projectile = preload("res://models/cube.tscn")
@onready var falling_cube = $falling_cube

func _on_area_3d_body_exited(body):
	if body.is_in_group("Cube"):
		var c = cube_projectile.instantiate()
		falling_cube.add_child(c)
