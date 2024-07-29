extends StateMachine

################################################################################
####### WARNING: DO NOT OVERRIDE _ready, _process OR _physics_process!!! #######
################################################################################

func get_movement_axes(): 
	# returns the left-right and forward-backward movement input axes
	var x_axis = Input.get_action_strength("right") - Input.get_action_strength("left")
	var z_axis = Input.get_action_strength("forward") - Input.get_action_strength("back")
	
	return Vector2(x_axis, z_axis)

func is_idle(dir: Vector2 = Vector2(2,0)): 
	# returns true iff no horizontal input is detected
	if dir == Vector2(2,0): 
		return (get_movement_axes().length_squared() < 0.01)
	
	return (dir.length_squared() < 0.01)
