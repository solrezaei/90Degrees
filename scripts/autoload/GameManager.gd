extends Node3D

var is_alive: bool = true
var input_enabled: bool = true
var mouse_fixed = true

func _ready():
	# make mouse invisible
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		get_tree().quit()

func _notification(what):
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_IN: 
		mouse_fixed = true
	if what == MainLoop.NOTIFICATION_APPLICATION_FOCUS_OUT: 
		mouse_fixed = false

func update_mouse(): 
	# called by movecamera
	
	if !mouse_fixed: 
		return 
	
	var mouse_fix = get_viewport().get_visible_rect().size/2
	get_viewport().warp_mouse(mouse_fix)

func get_player():
	return get_tree().current_scene.get_node(NodePath("Player"))

func set_alive(val: bool):
	is_alive = val

func get_alive():
	return is_alive

func set_input_enabled(val: bool):
	input_enabled = val

func get_input_enabled():
	return input_enabled
