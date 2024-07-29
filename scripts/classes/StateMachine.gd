class_name StateMachine
extends Node

signal transitioned(state_name)

@export var initial_state = NodePath()
@export var anim_sprite: AnimatedSprite3D

@onready var current_state: State = get_node(initial_state)
var prev_state: State = null

func _ready():
	await owner.ready
	
	for child in get_children():
		child.state_machine = self
	
	_on_ready()
	
	current_state.enter()

func _unhandled_input(event):
	current_state.handle_input(event)

func _process(delta):
	current_state.update(delta)
	_on_process(delta)

func _physics_process(delta):
	current_state.physics_update(delta)
	_on_physics_process(delta)

func transition_to(target_state_path: NodePath, params: Dictionary = {}): 
	if not has_node(target_state_path): 
		return
	
	current_state.exit()
	
	prev_state = current_state
	current_state = get_node(target_state_path)
	
	current_state.enter(params)
	transitioned.emit(current_state)
	#print("state: ", current_state.name)

func _on_ready(): 
	pass

func _on_process(_delta):
	pass

func _on_physics_process(_delta):
	pass

func get_prev_state():
	return prev_state

func get_state():
	return current_state

func get_anim_sprite():
	return anim_sprite
