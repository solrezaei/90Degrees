class_name HitBox
extends Area3D

var damage = 1
@export var friendly: bool
@export var monitorable_by_default: bool = true

var timer: Timer 

signal hit

func _ready():
	monitorable = monitorable_by_default
	monitoring = false
	hit.connect(_on_hit)
	
	collision_layer = 32
	collision_mask =  0
	
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_deactivate)

func activate(duration: float = 1.0): 
	if monitorable_by_default: 
		return
	
	set_deferred("monitorable", true)
	timer.start(duration)

func _deactivate(): 
	set_deferred("monitorable", false)

func _on_hit(): 
	pass
