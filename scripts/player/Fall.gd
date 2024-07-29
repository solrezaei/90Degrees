extends State

var initial_direction: Vector2

const JUMP_GRACE: float = 0.2
const COYOTE_TIME: float = 0.1

func enter(_params = {}): 
	#owner.set_speed_walk()
	initial_direction = owner.get_direction()
	state_machine.get_anim_sprite().play("fall")
	
	if state_machine.get_prev_state().name in ["Idle", "Walk", "Run"]:
		$CoyoteTimer.start(COYOTE_TIME)

func physics_update(_delta: float):
	if owner.is_on_floor(): 
		if !$JumpBuffer.is_stopped(): 
			state_machine.transition_to(NodePath("Jump"))
			return
		state_machine.transition_to(NodePath("Walk"))
	
	_handle_movement()

func exit():
	$JumpBuffer.stop()
	$CoyoteTimer.stop()

func handle_input(event):
	if event.is_action_pressed("jump"):
		if !$CoyoteTimer.is_stopped(): 
			state_machine.transition_to(NodePath("Jump"))
			return
		$JumpBuffer.start(JUMP_GRACE) 
	elif event.is_action_pressed("blow"):
		state_machine.transition_to(NodePath("Blow"))

func _handle_movement(): 
	var axes = state_machine.get_movement_axes()
	
	if state_machine.is_idle(axes): 
		owner.set_speed_idle()
		return
	
	var new_direction = axes.normalized()
	if owner.target_speed > owner.walk_speed and initial_direction.dot(new_direction) <= .9:
		owner.set_speed_walk()
	
	owner.set_target_direction(new_direction)
