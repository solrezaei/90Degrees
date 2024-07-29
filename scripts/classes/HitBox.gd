class_name HitBox
extends Area3D

var damage = 1

@export var friendly: bool

signal hit

func _ready():
	monitorable = true
	monitoring = false
	hit.connect(_on_hit)
	
	collision_layer = 32
	collision_mask =  0

func _on_hit(): 
	pass
