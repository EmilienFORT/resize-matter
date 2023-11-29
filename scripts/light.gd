extends MeshInstance3D
@onready var flicker = $flicker

func _physics_process(_delta):
	var random_number = randi() % 100
	if random_number < 1:
		flicker.play("flicker")
		await flicker.animation_finished
	else:
		pass
