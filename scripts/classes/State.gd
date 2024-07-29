class_name State
extends Node

var state_machine: StateMachine = null

#receives events from _unhandled_input()
func handle_input(_event: InputEvent): 
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func enter(_params = {}): 
	#enters the state with dictionary of necessary intialisation parameters
	pass

func exit():
	#exits the state
	pass
