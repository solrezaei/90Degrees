class_name EnemyStatComponent
extends Node

@export var max_health: int = 5
var cur_health: int

func _ready():
	reset()

func reset():
	cur_health = max_health

func take_damage(hitbox: HitBox): 
	cur_health = max(cur_health - hitbox.damage, 0)
	print(("%s current health: " % owner.name) + str(cur_health))
	if cur_health == 0:
		owner.queue_free()
		#owner.die()
	#else: 
	#	%StateMachine.transition_to(NodePath("Flinch"))
