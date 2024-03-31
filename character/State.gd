extends Node
class_name State

@export var is_attacking : bool = false

signal Transitioned
var character : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var next_state : State

func update(delta : float):
	pass

func physics_update(delta : float):
	pass

#func state_process(delta):
	#pass

#func state_input(event : InputEvent):
	#pass

func enter():
	pass

func exit():
	pass
