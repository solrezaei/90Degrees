class_name HurtBox
extends Area3D

#@export var ignore_layers = 1
@export var friendly: bool
@export var invincibility_time: float = 1.

var timer: Timer

signal hurt

func _ready():
	connect("area_entered", _on_area_entered)
	monitorable = false
	monitoring = true
	collision_layer = 0
	collision_mask =  32
	
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_reactivate)

func _on_area_entered(hitbox: HitBox):
	if hitbox.friendly == friendly: # hitbox == null or 
		return
	
	
	hitbox.hit.emit()
	hurt.emit()
	
	_deactivate(invincibility_time)
	
	%StatComponent.take_damage(hitbox.damage)

func _deactivate(duration: float): 
	if not timer.is_stopped(): 
		print("Overwriting HurtBox deactivation timer")
	
	set_deferred("monitoring", false)
	timer.start(duration)

func _reactivate(): 
	set_deferred("monitoring", true)
