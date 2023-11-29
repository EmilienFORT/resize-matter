extends Label3D

@onready var glitch_animation = $glitch_animation
@onready var tuto_apparition = $tuto_apparition

func _on_tuto_apparition_body_entered(body):
	if body.is_in_group("Player"):
		glitch_animation.play("glitch")
		tuto_apparition.set_deferred("monitoring",false)
		
