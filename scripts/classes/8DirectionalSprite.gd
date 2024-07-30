class_name DirectionalSprite3D
extends AnimatedSprite3D

var animation_name: StringName

var camera_direction: Vector3
var angle: float
var current_frame: int
var current_frame_progress: float

func test():
	sprite_frames = load("res://scripts/classes/directional_sprite_frames_test.tres")
	play_8d("test")

func _process(_delta):
	camera_direction = GameManager.get_camera().global_position - global_position
	angle = global_rotation.y - Vector2(camera_direction.x, camera_direction.z).angle()
	
	current_frame = frame
	current_frame_progress = frame_progress
	
	_update_animation()
	
	set_frame_and_progress(current_frame,current_frame_progress)

func play_8d(_name: StringName = &""): 
	animation_name = _name

func _update_animation():
	match roundi(4 / PI * angle + 4) % 8:
		0: 
			play(animation_name + "F")
		1: 
			play(animation_name + "FL")
		2: 
			play(animation_name + "L")
		3: 
			play(animation_name + "BL")
		4: 
			play(animation_name + "B")
		5: 
			play(animation_name + "BR")
		6: 
			play(animation_name + "R")
		7: 
			play(animation_name + "FR")
