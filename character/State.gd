extends Node
class_name State

@export var is_attacking : bool = false

signal Transitioned
var character : CharacterBody2D
var playback : AnimationNodeStateMachinePlayback
var next_state : State
#parameters to pass along when transitioning from state to state
var parameters : Dictionary

#ffor enemy
#var enemy_health : float
#var enemy_direction : Vector2
#var enemy_speed : float
#var enemy_damage_to_take : float
#var enemy_knockback_to_take : Vector2

func update(delta : float):
	pass

func physics_update(delta : float):
	pass

#the same as the physics_update function
#func state_process(delta):
	#pass

func state_input(event : InputEvent):
	pass

func enter():
	pass

func exit():
	pass

##for enemy
#func take_damage(damage : float, knockback_force : Vector2):
	#pass
