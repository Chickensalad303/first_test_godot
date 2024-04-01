extends State
class_name DefaultState

@export var attack_state : State
@export var attack_anim_name : String = "attack"

func state_input(event : InputEvent):
	if event.is_action_pressed("attack"):
		print(attack_state)
		attack()
	
func attack():
	next_state = attack_state
	
	playback.travel("attack")
