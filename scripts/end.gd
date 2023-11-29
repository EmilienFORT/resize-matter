extends Area3D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("fin du jeu")
		body.end = true
#		menu_end.visible = true
#		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#		get_tree().paused = true
