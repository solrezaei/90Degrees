extends Node

@export var destroy_on_hit: bool = true
@export var max_hits: int = 5
var hits: int

func _ready():
	reset()

func reset():
	hits = 0

func take_damage(_hitbox: HitBox): 
	hits += 1
	
	if hits == max_hits:
		owner.destroy()
	else: 
		var dir = owner.global_position - GameManager.get_player().global_position
		dir.y = 0
		owner.deflect(dir.normalized())

func _on_hit():
	if destroy_on_hit: 
		owner.destroy()
