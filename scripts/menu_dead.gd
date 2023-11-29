extends Control

@onready var glitch_animation = $glitch_animation

func _on_restart_button_pressed():
	glitch_animation.play("button")
	await glitch_animation.animation_finished
	get_tree().paused = false
	get_tree().reload_current_scene()
