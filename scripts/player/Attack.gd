extends State

const DURATION: Array = [0.8, 0.8, 1.0]
const COMBO_TIME: float = .6
const SKIP_TIME: float = .4

var queued_action: NodePath
var combo_counter: int
var time: float

func enter(_params = {}):
	if state_machine.prev_state.name == "Attack": 
		combo_counter += 1
	else: 
		combo_counter = 0
	
	%AnimationPlayer.play("attack_" + str(combo_counter + 1))
	
	queued_action = NodePath("ReFoot")
	owner.set_speed_idle()
	time = 0

func physics_update(delta): 
	time += delta
	
	if time >= DURATION[combo_counter] \
	or (time >= DURATION[combo_counter] - SKIP_TIME and queued_action != NodePath("ReFoot")): 
		state_machine.transition_to(queued_action)
	
	# TODO: allow very slow movement with lowered rotation speed

func handle_input(event):
	if DURATION[combo_counter] - time > COMBO_TIME:
		return
	
	if event.is_action_pressed("primary_attack") and combo_counter < 2: 
		queued_action = NodePath("Attack")
	elif event.is_action_pressed("secondary_attack"): 
		queued_action = NodePath("Catch")
