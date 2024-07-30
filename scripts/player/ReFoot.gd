extends State


func enter(_params = {}): 
	var temp = Timer.new()
	add_child(temp)
	temp.one_shot = true
	temp.timeout.connect(state_machine.transition_to.bind(NodePath("Idle")))
	temp.start(.1)
