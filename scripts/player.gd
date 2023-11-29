extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 7

@export var live = true
@export var end = false

var push_force = 1.0

@onready var head = $Head
@onready var raycast = $Head/Camera/RayCast
@onready var bras = $Head/Bras
@onready var hand_scene = $Head/Bras/hand

# Cameras
@onready var camera = $Head/Camera
@onready var sub_viewport = $Head/Camera/SubViewportContainer/SubViewport
@onready var guncam = %GunCam

var mouse_sensitivity_h = 0.1
var mouse_sensitivity_v = 0.05

@onready var animation_player = $AnimationPlayer

@onready var muzzle = $Head/Bras/muzzle
@onready var cube_projectile = preload("res://models/cube.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var shader = $Head/Camera/Shader
@onready var shader_2 = $Head/Camera/SubViewportContainer/SubViewport/GunCam/Shader2

var outlineShader = preload("res://materials/outlineShader.tres")
@onready var chromatic_ab = $Head/Camera/chromatic_ab
@onready var vignette_anim = $Head/Camera/vignette_anim
@onready var slowmo_sfx_1 = $SFX/slowmoSFX1
@onready var slowmo_sfx_2 = $SFX/slowmoSFX2
@onready var slowmo_sfx_heartbeat = $SFX/slowmoSFXheartbeat

@onready var gant_no_sfx = $SFX/gantNoSFX
@onready var gant_sfx_1 = $SFX/gantSFX1
@onready var gant_sfx_2 = $SFX/gantSFX2
@onready var cubegun = $SFX/cubegun

@onready var throw_sfx = $SFX/throwSFX

@onready var menu_pause = $menu_pause
@onready var menu_dead = $menu_dead
@onready var menu_end = $menu_end

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	outlineShader.set_shader_parameter("outlineColor",Color(0,0,0))
	chromatic_ab.visible = false
	
	var current_level = get_tree().current_scene
	if current_level.name == "level_1": # au début du niveau 1, le joueur n'a pas le gant
		Gameplay.glove = false
		bras.visible = false
	else:
		Gameplay.glove = true
		bras.visible = true
	
	menu_pause.visible = false
	menu_dead.visible = false
	menu_end.visible = false

##############
# MOUVEMENTS #
##############

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity_h))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity_v))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func _process(_delta):
	if Input.is_action_just_pressed("echap"):
		menu_pause.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	
	guncam.global_transform = camera.global_transform

func _physics_process(delta):
#	sub_viewport.size = DisplayServer.window_get_size(delta)
	
	if live == true:
		pass
	else:
		menu_dead.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	
	if end == false:
		pass
	else:
		menu_end.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	
	
	
	shoot()
	slowmo()
	
	if Gameplay.glove == true: # Tant que le joueur n'a pas récupéré le gant, son bras ne s'affiche pas
		bras.visible = true
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

########
# ARME #
########

func shoot():
	if Input.is_action_just_pressed("left_click") && Gameplay.glove == true: # la taille de la cible est multipliée par 2
		animation_player.stop()
		animation_player.play("thumbUp")
		if raycast.is_colliding():
			var target = raycast.get_collider()
			if target.is_in_group("Cube"):
				if target.scale < Vector3(3.9,3.9,3.9): # limite d'augmentation de taille
					gant_sfx_1.play()
					target.scale = target.scale * 2
					target.mass = target.mass * 2
				else:
					gant_no_sfx.play()
			if target.is_in_group("Enemy"):
				if target.scale < Vector3(0.9,0.9,0.9): # limite d'augmentation de taille
					gant_sfx_1.play()
					target.scale = target.scale * 2
					target.health = target.health * 2
				else:
					gant_no_sfx.play()
	
	if Input.is_action_just_pressed("right_click") && Gameplay.glove == true: # la taille de la cible est divisée par 2
		animation_player.stop()
		animation_player.play("thumbDown")
		if raycast.is_colliding():
			var target = raycast.get_collider()
			if target.is_in_group("Cube"):
				if target.scale > Vector3(1.1,1.1,1.1): # limite de réduction de taille
					gant_sfx_2.play()
					target.scale = target.scale / 2
					target.mass = target.mass / 2
				else:
					gant_no_sfx.play()
			if target.is_in_group("Enemy"):
				if target.scale > Vector3(0.6,0.6,0.6): # limite d'augmentation de taille
					gant_sfx_1.play()
					target.scale = target.scale / 2
					target.health = target.health / 2
				else:
					gant_no_sfx.play()
	
	if Input.is_action_just_pressed("throw"): # l'objet tenu en main est lancé vers l'avant
		if Gameplay.grabbed == false:
			if  Gameplay.cube_gun == true:
				if hand_scene.cube_amount == 0:
					gant_no_sfx.play()
				else:
					animation_player.stop()
					animation_player.play("cube_gun")
					cubegun.play()
					var c = cube_projectile.instantiate()
					muzzle.add_child(c)
					c.apply_central_impulse(Vector3(transform.basis.x.z,head.transform.basis.y.z,-transform.basis.x.x) * 20)
					hand_scene.cube_amount -= 1
	
		if Gameplay.grabbed == true:
			var target
			if raycast.is_colliding():
				target = raycast.get_collider()
				if target.is_in_group("Grabable"):
					throw_sfx.play()
					target.apply_central_impulse(Vector3(transform.basis.x.z,head.transform.basis.y.z,-transform.basis.x.x) * 10)
					Gameplay.grabbed = false
					target = null

###############
# BULLET TIME #
###############

func slowmo():
	if Input.is_action_just_pressed("bulletTime"):
		Engine.time_scale = 0.5
		slowmo_sfx_1.play()
		slowmo_sfx_heartbeat.play()
		outlineShader.set_shader_parameter("outlineColor",Color(1,1,1))
		chromatic_ab.visible = true
		vignette_anim.play("vignette_come")
		await vignette_anim.animation_finished
		vignette_anim.play("vignette_return")
		Engine.time_scale = 1
		slowmo_sfx_2.play()
		slowmo_sfx_heartbeat.stop()
		outlineShader.set_shader_parameter("outlineColor",Color(0,0,0))
		chromatic_ab.visible = false
