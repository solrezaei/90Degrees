extends CharacterBody3D

@export var walk_speed: float = 14
@export var run_speed: float = 30
@export var horz_accel: float = 60
@export var horz_decel: float = 30 
@export var rotation_speed: float = 7
#@export var rotation_inertia: int = 7
@export var gravity: float = 40
@export var gravity_multiplier: float = 2
@export var jump_speed: float = 30
@export var jump_duration: float = .2

#@export var oof_sounds: AudioStreamRandomizer
#@export var death_sounds: AudioStreamRandomizer

@onready var pivot: Node3D = $Pivot

var direction: Vector2 = Vector2.ZERO
var target_direction: Vector2 = Vector2.ZERO
var target_speed: float = 0

var current_gravity: float
var current_speed: float = 0

var forward_axis: Vector3
var right_axis: Vector3

const DEFAULT_DIRECTION: Vector2 = Vector2.DOWN
const SPEED_LIMIT: float = 50
const WORLD_BOTTOM: float = -100

func _ready():
	current_gravity = gravity

func _physics_process(delta):
	if position.y < WORLD_BOTTOM and GameManager.get_alive(): 
		print("WORLD BOTTOM TOUCHED")
		die()
	
	_handle_movement(delta)
	move_and_slide()


func reset():
	target_direction = DEFAULT_DIRECTION
	_update_direction(1)
	halt()


func halt():
	target_speed = 0
	velocity = Vector3.ZERO


func set_axes(right:Vector3, forward:Vector3):
	right_axis = right.normalized()
	forward_axis = forward.normalized()


func _handle_movement(delta):
	_update_direction(delta)
	
	# transform target_velocity to the current coordinate system
	if current_speed <= target_speed: 
		current_speed = min(current_speed + horz_accel * delta, target_speed)
	else: 
		current_speed = max(current_speed - horz_decel * delta, 0.)
	
	velocity = current_speed * (direction.x * right_axis + direction.y * forward_axis) + velocity.y * Vector3.UP
	
	if !is_on_floor(): 
		velocity.y = max(velocity.y - gravity * delta, -SPEED_LIMIT)


func _update_direction(delta: float): 
	var angle = direction.angle()
	var target_angle = target_direction.angle()
	
	angle = lerp_angle(angle, target_angle, rotation_speed * delta)
	
	direction = Vector2.from_angle(angle)
	
	var temp: Vector3 = direction.x * right_axis + direction.y * forward_axis
	pivot.rotation.y = atan2(temp.x, temp.z)
	
	target_direction = direction


func die(): 
	$StateMachine.transition_to(NodePath("Die"))
	
	var temp = Timer.new()
	add_child(temp)
	temp.timeout.connect(get_tree().reload_current_scene)
	temp.start(1)
	
	#AudioManager3D.play(death_sounds, global_position)


func _on_take_damage():
	pass#AudioManager3D.play(oof_sounds, global_position)


func _set_modified_gravity(val: bool): 
	if val: 
		current_gravity = gravity * gravity_multiplier
	else: 
		current_gravity = gravity


func _on_jump_timeout(timer: Timer): 
	_set_modified_gravity(false)
	timer.call_deferred("queue_free")


func jump(duration: float = jump_duration): 
	velocity.y = jump_speed
	_set_modified_gravity(true)
	
	var temp = Timer.new()
	add_child(temp)
	temp.one_shot = true
	temp.timeout.connect(_on_jump_timeout.bind(temp))
	temp.start(duration)


func attack(): 
	
	%AttackSprite.play("attack")
	%HitBox.activate(.5)


func get_rotation_y():
	return pivot.rotation.y

func get_direction():
	return direction

func set_target_direction(val: Vector2):
	if val != Vector2.ZERO:
		target_direction = val

func set_speed_backfire(): 
	# FIXME: instead of this, apply a force in the opposite direction of the hit
	# so overwrite the velocity for a brief moment before turning controls back on
	target_speed = run_speed
	direction *= -1
	velocity.y = 10

func set_speed_idle(): 
	target_speed = 0

func set_speed_walk():
	target_speed = walk_speed

func set_speed_run(): 
	target_speed = run_speed



