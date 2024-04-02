extends Node
class_name CharacterStateMachine


@export var character : CharacterBody2D
@export var animation_tree : AnimationTree
@export var initial_state : State

var current_state : State # set this in the inspector to select default state

var states : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	#animation_tree = $"../../Sprite2D/AnimationTree"
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
			#here you can set the states up with what they need to function
			#child.character = character
			child.playback = animation_tree["parameters/playback"]
		
		else:
			push_warning("child", child.name, "is not a State for CharacterStateMachine")
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func get_current_animation():
	#return current_state.is_attacking
	return current_state.playback.get_current_node()
	
func _process(delta):
	if (current_state):
		current_state.update(delta)
		
func _physics_process(delta):
	if (current_state):
		current_state.physics_update(delta)


func on_child_transitioned(state, new_state_name):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
	
func _input(event : InputEvent):
	current_state.state_input(event)

#func _physics_process(delta):
	#if (current_state.next_state != null):
		#switch_states(current_state.next_state)
	#current_state.state_process(delta)

#func switch_states(new_state : State):
	#if (current_state != null):
		#current_state.exit()
		#current_state.next_state = null
	#current_state = new_state
	#current_state.enter()
	
	
#func _input(event : InputEvent):
	#current_state.state_input(event)
