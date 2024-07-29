extends State

func enter(_params = {}): 
	owner.set_speed_backfire()
	state_machine.get_anim_sprite().play("flinch")
	
	var temp = Timer.new()
	add_child(temp)
	temp.one_shot = true
	temp.timeout.connect(state_machine.transition_to.bind(NodePath("Idle")))
	temp.start(.2)
