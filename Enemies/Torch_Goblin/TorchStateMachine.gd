extends Node
class_name enemy_state_machine

@export var initial_state : State
@export var animation_tree : AnimationTree

var current_state : State
var states : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if (child is State):
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
			child.playback = animation_tree["parameters/playback"]
		
		else:
			push_warning("child", child.name, "is not a State for CharacterStateMachine")
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func get_movement_direction():
	current_state.direction

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_state:
		current_state.update(delta)
		
func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)



func on_child_transitioned(state, new_state_name, dict : Dictionary):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.parameters = dict
	current_state.enter()
	

