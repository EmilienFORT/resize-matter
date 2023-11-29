extends Node3D

@onready var interaction = $interaction
@onready var hand = $hand
@onready var player = $"../../.."
@onready var head = $"../.."

@onready var crosshair = $"../crosshair"
var crosshair1 = preload("res://textures/crosshair.png")
var crosshair2 = preload("res://textures/crosshair_hand_open.png")
var crosshair3 = preload("res://textures/crosshair_hand_closed.png")
var crosshair4 = preload("res://textures/crosshair_finger.png")

var target
var picked_object
var pull_power = 10

func _physics_process(_delta):
	if Gameplay.grabbed == false && Gameplay.ascenseur == false: # Reinitialise target
		target = null
	
	cross_hair() # Fonction pour affichage des différents réticules
	
	if Gameplay.grabbed == true: # Objet attrapé suit la main
		if target == null:
			Gameplay.grabbed = false
			return
		
		picked_object = target
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		picked_object.set_linear_velocity((b-a) * pull_power / target.mass)
		
		if hand.global_position.z - target.global_position.z > 4: # Si l'objet est trop loin, le lacher
			Gameplay.grabbed = false

func _input(_event):
	if Input.is_action_just_pressed("interact"):
		if target != null:
			remove_object()
		else:
			pick_object()

func pick_object():
	if interaction.is_colliding():
		target = interaction.get_collider()
		if target.is_in_group("Grabable"): # Attraper un objet attrapable
			Gameplay.grabbed = true
		if target.is_in_group("Bouton"): # Appuyer sur le bouton de l'ascenseur
			Gameplay.ascenseur = true

func remove_object(): # Lacher un objet attrapable
	target = null
	Gameplay.grabbed = false
	return

func cross_hair(): 
	var target_ch
	if interaction.is_colliding() == false && Gameplay.grabbed == false: # réticule normal
		crosshair.texture = crosshair1
	
	if interaction.is_colliding() == true && Gameplay.grabbed == false: # réticule "objet attrapable"
		target_ch = interaction.get_collider()
		if target_ch.is_in_group("Grabable"):
			crosshair.texture = crosshair2
		
	if Gameplay.grabbed == true: # réticule objet attrapé
		crosshair.texture = crosshair3
	
	if interaction.is_colliding() == true: # réticule bouton appuyable
		target_ch = interaction.get_collider()
		if target_ch.is_in_group("Bouton"):
			crosshair.texture = crosshair4
	
