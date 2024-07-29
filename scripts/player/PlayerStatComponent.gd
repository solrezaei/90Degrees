extends Node

@export var stat_component: Resource

func _ready():
	reset()

func reset():
	stat_component.cur_health = stat_component.max_health

func take_damage(dam: int): 
	stat_component.cur_health = max(stat_component.cur_health - dam, 0)
	print("current health: " + str(stat_component.cur_health))
	if stat_component.cur_health == 0:
		owner.die()
	else: 
		%StateMachine.transition_to(NodePath("Flinch"))
