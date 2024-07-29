extends State


func enter(_params = {}): 
	print("Player has died")
	owner.set_speed_idle()
	state_machine.get_anim_sprite().play("die")
