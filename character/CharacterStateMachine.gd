extends Node
class_name CharacterStateMachine

var states : Array[State]

@export var current_state : State
@export var character : CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			
			child.character = character
		else:
			push_warning("Child" + child.name + "is not a State for CharacterStateMachine")

# this should be called by Character.gd
func check_slowed():
	return current_state.is_slowed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
