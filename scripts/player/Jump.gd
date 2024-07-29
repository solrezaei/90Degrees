extends State

func enter(_params = {}):
	owner.jump()
	state_machine.transition_to(NodePath("Fall"))

"""
func physics_update(_delta: float): 
	_handle_movement()


func _handle_movement(): 
	var axes = state_machine.get_movement_axes()
	
	if state_machine.is_idle(axes): 
		state_machine.transition_to(NodePath("Idle"))
		return
	
	owner.set_direction(axes.normalized())
"""
