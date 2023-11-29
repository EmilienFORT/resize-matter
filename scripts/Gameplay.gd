extends Node

# Niveaux bloqués ou non
var lv_2 = false
var lv_3 = false
var lv_4 = false

# Objets récupérés
var glove = true
var cube_gun = true

# Intercations
var grabbed = false
var ascenseur = false

# Transitions scènes
var ascenseur_position_x
var ascenseur_position_z
var player_position_x
var player_position_z

var head_rotation_x

var ascenseur_rotation_y
var player_rotation_y

# Niveau 3 : ennemis inoffensifs au début
var enemy_sleeping

