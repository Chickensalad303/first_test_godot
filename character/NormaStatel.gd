extends State
class_name NormalState

@export var slowed_state : State

# Called when the node enters the scene tree for the first time.
func state_input(event : InputEvent):
	if(event.is_action_pressed("attack")):
		set_slowed_status_effect()
		
		
func set_slowed_status_effect():
	next_state = slowed_state
