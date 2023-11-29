extends CharacterBody3D

@export_enum ("ROAMING", "CHASING", "ALERT", "DEAD") var state = "ROAMING"
@onready var animations = $AnimationPlayer
@onready var enemy_fov = $enemy_fov
@onready var enemy_fov_idle = $enemy_fov/enemy_fov_idle
@onready var enemy_fov_alert = $enemy_fov/enemy_fov_alert
#@onready var raycast = $RayCast
@onready var state_echo = $state_echo

@onready var eyes = $eyes
@onready var attack_area = $attack_area
var target
var target_friend
#var target_raycast
const TURN_SPEED = 2

const IDLE_SPEED = 1
const CHASE_SPEED = 4

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var nav_agent = $NavigationAgent3D

# Informations combat
@export var health = 100
@onready var dead_body = preload("res://models/enemy_dead.tscn")
@onready var damage_area = $damage_area
@onready var collision_shape_3d = $CollisionShape3D
@onready var death_spawn = $death_spawn
@onready var armature = $Armature

@onready var ambient_sfx = $SFX/ambientSFX
@onready var idlevoice_sfx_1 = $SFX/idlevoiceSFX1
@onready var idlevoice_sfx_2 = $SFX/idlevoiceSFX2
@onready var idlevoice_sfx_3 = $SFX/idlevoiceSFX3
@onready var idlevoice_sfx_4 = $SFX/idlevoiceSFX4
@onready var alertvoice_sfx = $SFX/alertvoiceSFX
@onready var chasingvoice_sfx_1 = $SFX/chasingvoiceSFX1
@onready var chasingvoice_sfx_2 = $SFX/chasingvoiceSFX2

func _ready():
	enemy_fov_idle.disabled = false
	enemy_fov_alert.disabled = true
	attack_area.set_deferred("monitoring",false)
	
#	target_raycast = get_parent_node_3d().get_node("Player")
	
	var current_level = get_tree().current_scene
	if current_level.name == "level_3":
		Gameplay.enemy_sleeping = true
	else:
		Gameplay.enemy_sleeping = false

func _process(_delta):
	if scale > Vector3(0.7,0.7,0.7) && state == "CHASING":
		attack_area.set_deferred("monitoring",true)
	else:
		attack_area.set_deferred("monitoring",false)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	match state:
		"ROAMING":
			if Gameplay.enemy_sleeping == true:
				animations.play("Idle_sleep") # Au début du niveau 3, les ennemis sont inactifs
			if Gameplay.enemy_sleeping == false:
				animations.play("Idle_awake") # En récupérant le gant, ils deviennent actifs
				
#				if target_raycast != null:
#					raycast.look_at(Vector3(target_raycast.position.x,target_raycast.position.y + 0.59,target_raycast.position.z),Vector3.UP,true)
				
				# BRUITAGES
				if idlevoice_sfx_1.playing == true or idlevoice_sfx_2.playing == true or idlevoice_sfx_3.playing == true or idlevoice_sfx_4.playing == true:
					return
				else:
					var random_number = randi() % 300
					if random_number == 0:
						if scale > Vector3(0.7,0.7,0.7):
							idlevoice_sfx_1.pitch_scale = 1
						else:
							idlevoice_sfx_1.pitch_scale = 1.5
						idlevoice_sfx_1.play()
					elif random_number == 1:
						if scale > Vector3(0.7,0.7,0.7):
							idlevoice_sfx_2.pitch_scale = 1
						else:
							idlevoice_sfx_2.pitch_scale = 1.5
						idlevoice_sfx_2.play()
					elif random_number == 2:
						if scale > Vector3(0.7,0.7,0.7):
							idlevoice_sfx_3.pitch_scale = 1
						else:
							idlevoice_sfx_3.pitch_scale = 1.5
						idlevoice_sfx_3.play()
					elif random_number == 3:
						if scale > Vector3(0.7,0.7,0.7):
							idlevoice_sfx_4.pitch_scale = 1
						else:
							idlevoice_sfx_4.pitch_scale = 1.5
						idlevoice_sfx_4.play()
					else:
						pass
					
				if scale < Vector3(0.9,0.9,0.9):
					state = "ALERT"
				
				var state_echo_size = state_echo.get_overlapping_bodies()
				if state_echo_size.size() > 1:
					for target_friend in state_echo_size:
						if target_friend.state == "CHASING":
							state = "ALERT"
						if target_friend.state == "ROAMING":
							return
		
		"CHASING":
			if target_friend != null: # Si l'ennemi chasse le joueur, il oublie son "ami"
				target_friend = null
			
			state_echo.set_deferred("monitoring",false)
			
			animations.play("Move_chase")
			eyes.look_at(target.global_transform.origin, Vector3.UP)
			rotate_y(deg_to_rad(- eyes.rotation.y * TURN_SPEED))
			var current_location = global_transform.origin
			var next_location = nav_agent.get_next_path_position()
			var direction = (next_location - current_location).normalized()
			velocity.x = direction.x * CHASE_SPEED
			velocity.z = direction.z * CHASE_SPEED
			position.move_toward(target.position, 0.1)
			
			nav_agent.target_position = target.transform.origin
			
			move_and_slide()
			
			
			# BRUITAGES
			if chasingvoice_sfx_1.playing == true or chasingvoice_sfx_2.playing == true:
				return
			else:
				var random_number = randi() % 200
				if random_number == 0:
					if scale > Vector3(0.7,0.7,0.7):
						chasingvoice_sfx_1.pitch_scale = 1
					else:
						chasingvoice_sfx_1.pitch_scale = 1.5
					chasingvoice_sfx_1.play()
				elif random_number == 1:
					if scale > Vector3(0.7,0.7,0.7):
						chasingvoice_sfx_2.pitch_scale = 1
					else:
						chasingvoice_sfx_2.pitch_scale = 1.5
					chasingvoice_sfx_2.play()
				else:
					pass
		
		"ALERT":
			if Gameplay.enemy_sleeping == true:
				return # Au début du niveau 3, les ennemis sont inactifs
			if Gameplay.enemy_sleeping == false:
				enemy_fov_idle.disabled = true
				enemy_fov_alert.disabled = false
				
				# BRUITAGES
				if alertvoice_sfx.playing == true:
					return
				else:
					var random_number = randi() % 4
					if random_number == 0:
						if scale > Vector3(0.7,0.7,0.7):
							alertvoice_sfx.pitch_scale = 1
						else:
							alertvoice_sfx.pitch_scale = 1.5
						alertvoice_sfx.play()
					else:
						pass
		
		"DEAD":
			attack_area.set_deferred("monitoring",false)
			return
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * 0.5)

func _on_enemy_fov_body_entered(body):
	if Gameplay.enemy_sleeping == true:
		return
	if Gameplay.enemy_sleeping == false:
		if body.is_in_group("Player"): # Si Player est dans le champ de vision
#			if raycast.is_colliding():
#				var col = raycast.get_collider()
#				if col.is_in_group("Player"): # Et si Player n'est pas derrière un mur
					target = body
					state = "CHASING"
#					ambient_sfx_attack.play()
#				else:
#					col = null
#					return

func _on_state_echo_body_entered(body):
	if Gameplay.enemy_sleeping == true:
		return
	if Gameplay.enemy_sleeping == false:
		if body.is_in_group("Enemy"): # Si ennemi proche est en état "CHASING"
			target_friend = body
			if target_friend.state == "ROAMING":
				return
			if target_friend.state == "CHASING":
				state = "ALERT"
			

func _on_damage_area_body_entered(body):
	var body_layer = body.get_collision_layer_value(4)
	var body_velocity = abs((body.linear_velocity.x + body.linear_velocity.y + body.linear_velocity.z)/3)
	var body_scale = (body.scale.x + body.scale.y + body.scale.z) / 3
	if body_layer == true:
		if body_velocity < 0.1 or Gameplay.grabbed == true:
			return
		else:
			var damage = 10 * body_velocity * body_scale
			health -= damage
			if state == "ROAMING":
				state = "ALERT"
			else:
				pass
			if health <= 0: # Si la vie est inférieure ou égale à zéro, il meurt
				var d = dead_body.instantiate()
				death_spawn.add_sibling(d)
				damage_area.set_deferred("monitoring",false)
				ambient_sfx.stop()
#				ambient_sfx_attack.stop()
				armature.visible = false
				collision_shape_3d.disabled = true
				state = "DEAD"

func _on_attack_area_body_entered(body):
	if Gameplay.enemy_sleeping == true:
		return # Au début du niveau 3, les ennemis sont inactifs
	if Gameplay.enemy_sleeping == false:
		if body.is_in_group("Player"):
			body.live = false
