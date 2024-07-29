extends State

func enter(_params = {}):
	owner.set_speed_walk()
	state_machine.get_anim_sprite().play("walk")

func update(_delta: float):
	if not owner.is_on_floor(): 
		state_machine.transition_to(NodePath("Fall"))
		return

func physics_update(_delta: float): 
	if state_machine.is_idle():
		state_machine.transition_to(NodePath("Idle"))
	
	_handle_movement()

func _handle_movement(): 
	var axes = state_machine.get_movement_axes()
	
	if state_machine.is_idle(axes): 
		state_machine.transition_to(NodePath("Idle"))
		return
	
	owner.set_target_direction(axes.normalized())

func handle_input(event):
	if event.is_action_pressed("jump"):
		state_machine.transition_to(NodePath("Jump"))
	elif event.is_action_pressed("run"):
		state_machine.transition_to(NodePath("Run"))
	elif event.is_action_pressed("primary_attack"): 
		state_machine.transition_to(NodePath("Attack"))
	elif event.is_action_pressed("secondary_attack"): 
		state_machine.transition_to(NodePath("Catch"))
	elif event.is_action_pressed("blow"):
		state_machine.transition_to(NodePath("Blow"))
