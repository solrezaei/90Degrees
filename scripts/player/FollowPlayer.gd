extends Node3D

@export var camera_speed = 3 # [rad/ms]
@export var max_camera_distance = 5 # [m]

var camera: Camera3D
var raycast: RayCast3D

var player: CharacterBody3D
var mouse_movement = Vector2.ZERO
var cam_pos_sph: Vector2 # camera position in spherical coordinates [rad^2]
var mouse_fix = Vector2.ZERO

const CAMTHRESHOLD = 0.01 # minimum mouse velocity needed to move camera
const UPPERCAMANGLE = PI * 0.4
const LOWERCAMANGLE = -PI * 0.3
const RESETANGLE = PI/5
const FASTCAMTHRESH = 800 # determines how fast player has to move mouse for fast cam movement
const FASTCAMMULTIPLIER = 3 # multiplier for fast camera movement
const LERPSPEED = 20
const FOLLOWHEIGHT = Vector3.UP

# TODO: pan the camera to a set point in predetermined areas
# TODO: make the camera zoom out in mid-air (or maybe when the player moves at a large speed?)

func _ready():
	camera = $Camera3D
	raycast = $RayCast3D
	
	player = GameManager.get_player()
	
	mouse_fix = get_viewport().get_visible_rect().size/2
	GameManager.update_mouse()
	
	reset()

func _process(delta):
	if player == null: 
		return
	
	# move to position camera
	global_position = player.global_position + FOLLOWHEIGHT
	
	if Input.is_action_just_pressed("reset_camera"): 
		reset() 
	
	# record mouse movement & centre mouse via GameManager
	# TODO: there's a mouse velocity variable. use it
	mouse_movement = get_viewport().get_mouse_position() - mouse_fix
	mouse_fix = get_viewport().get_visible_rect().size/2
	GameManager.update_mouse()
	
	if GameManager.get_input_enabled():
		_handle_input(delta)
	
	# transform from coordinate space to spherical coords
	var cam_coords = Vector3(cos(cam_pos_sph.x) * cos(cam_pos_sph.y), sin(cam_pos_sph.y), sin(cam_pos_sph.x) * cos(cam_pos_sph.y))
	_update_cam_pos(cam_coords, delta)
	camera.look_at(position)

func _handle_input(delta):
	var mouse_mov_sqr = mouse_movement.length_squared()
		
	# move camera depending on mouse speed
	if mouse_mov_sqr > FASTCAMTHRESH: 
		mouse_movement = mouse_movement.normalized()
		cam_pos_sph += mouse_movement * camera_speed * delta * FASTCAMMULTIPLIER
		cam_pos_sph.y = clamp(cam_pos_sph.y, LOWERCAMANGLE,UPPERCAMANGLE)
	elif mouse_mov_sqr > CAMTHRESHOLD: 
		mouse_movement = mouse_movement.normalized()
		cam_pos_sph += mouse_movement * camera_speed * delta
		cam_pos_sph.y = clamp(cam_pos_sph.y, LOWERCAMANGLE,UPPERCAMANGLE) 

func _update_cam_pos(cam_coords, delta): 
	# update camera position to cam_coords (in spherical coords)
	
	var temp_pos = max_camera_distance * cam_coords
	
	# check if something is between the camera and player, if so move in the camera
	raycast.target_position = temp_pos
	if raycast.is_colliding(): 
		temp_pos = 0.75*(raycast.get_collision_point() - global_position).length() * cam_coords
	
	camera.position = lerp(camera.position, temp_pos, LERPSPEED * delta)
	
	# update the input axes to align with the camera
	var forward_axis = Vector3(camera.position.x,0,camera.position.z)
	var right_axis = Vector3.UP.cross(forward_axis)
	player.set_axes(right_axis, -forward_axis)

func reset():
	player = GameManager.get_player()
	var player_rotation = global_rotation.y - player.get_rotation_y() 
	cam_pos_sph = Vector2(player_rotation - PI/2, RESETANGLE)
