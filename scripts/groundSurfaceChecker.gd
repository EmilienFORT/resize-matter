extends RayCast3D

@onready var player = $".."

@onready var walk_sfx_herbe = $walk_SFX_herbe
@onready var walk_sfx_plastique = $walk_SFX_plastique
@onready var walk_sfx_cailloux = $walk_SFX_cailloux
@onready var walk_sfx_metal = $walk_SFX_metal

func _ready():
	walk_sfx_herbe.stream_paused = true
	walk_sfx_plastique.stream_paused = true
	walk_sfx_cailloux.stream_paused = true
	walk_sfx_metal.stream_paused = true

func _process(_delta):
	if not player.is_on_floor():
		walk_sfx_herbe.stop()
		walk_sfx_plastique.stop()
		walk_sfx_cailloux.stop()
		walk_sfx_metal.stop()
	
	if is_colliding() && player.is_on_floor():
		if player.velocity.x != 0 or player.velocity.z != 0:
			
			var col = get_collider()
			if col == null:
				return
			
			if col.is_in_group("herbe"):
				if walk_sfx_herbe.playing == false:
					walk_sfx_herbe.play()
					
					walk_sfx_cailloux.stop()
					walk_sfx_metal.stop()
					walk_sfx_plastique.stop()
			else:
				pass
			
			if col.is_in_group("cailloux"): 
				if walk_sfx_cailloux.playing == false:
					walk_sfx_cailloux.play()
					
					walk_sfx_herbe.stop()
					walk_sfx_metal.stop()
					walk_sfx_plastique.stop()
			else:
				pass
			
			if col.is_in_group("plastique"): 
				if walk_sfx_plastique.playing == false:
					walk_sfx_plastique.play()
					
					walk_sfx_cailloux.stop()
					walk_sfx_metal.stop()
					walk_sfx_herbe.stop()
			else:
				pass
			
			if col.is_in_group("metal"): 
				if walk_sfx_metal.playing == false:
					walk_sfx_metal.play()
					
					walk_sfx_cailloux.stop()
					walk_sfx_herbe.stop()
					walk_sfx_plastique.stop()
			else:
				pass
			
		else:
			walk_sfx_herbe.stop()
			walk_sfx_plastique.stop()
			walk_sfx_cailloux.stop()
			walk_sfx_metal.stop()
