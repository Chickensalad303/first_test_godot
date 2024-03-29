extends Node
class_name State

@export var is_slowed : bool = false

var character : CharacterBody2D
var next_state : State

func state_input(event: InputEvent):
	pass


func on_enter():
	pass

func on_exit():
	pass
