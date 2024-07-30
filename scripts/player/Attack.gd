extends State

func enter(_params = {}):
	owner.attack()
	state_machine.transition_to(NodePath("Idle"))
