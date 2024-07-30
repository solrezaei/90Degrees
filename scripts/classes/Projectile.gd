@icon("res://icons/projectile_icon.svg")
class_name Projectile
extends Node3D

@export var homing_range: float = 20

var speed: float = 10
var direction: Vector3 = Vector3.FORWARD

var deflected: bool = false
var enemy_targeted: bool = false
var target: Node3D

var hitbox: HitBox = null
var hurtbox: HurtBox = null
var enemy_homing_detector: Area3D

const DEFLECT_SPEED: float = 20

func _ready():
	for child in get_children(): 
		if child is HitBox and hitbox == null: 
			hitbox = child
		elif child is HurtBox and hurtbox == null: 
			hurtbox = child
	
	if hitbox == null: 
		print("Warning: %s has no hitbox" % name)
	if hurtbox == null: 
		print("Warning: %s has no hurtbox" % name)
	
	enemy_homing_detector = load("res://mechanical_nodes/enemy_homing_detector.tscn").instantiate()
	add_child(enemy_homing_detector)
	
	enemy_homing_detector.get_node(NodePath("CollisionShape3D")).shape.radius = homing_range
	enemy_homing_detector.area_entered.connect(_home)
	
	_init()


func _physics_process(delta):
	global_rotation.y = Vector2(direction.z, direction.x).angle()
	global_position += speed * direction * delta
	
	if deflected: 
		#TODO: test this
		if enemy_targeted: 
			direction = lerp(direction, target.global_position - global_position, 5. * delta).normalized()
		
		return
	
	_physics_update(delta)

func deflect(dir: Vector3):
	deflected = true
	direction = dir
	hitbox.friendly = true
	hurtbox.force_deactivate()
	speed = DEFLECT_SPEED

func _home(enemy: Area3D): 
	enemy_targeted = true
	target = enemy


func _physics_update(_delta: float): 
	pass

func _init():
	pass

func destroy(): 
	print("Warning: destroy() function of %s not overwritten" % name)
