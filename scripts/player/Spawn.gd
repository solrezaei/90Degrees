extends State


func enter(_params = {}): 
	state_machine.transition_to(NodePath("Idle"))
