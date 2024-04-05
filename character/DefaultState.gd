extends State
class_name DefaultState


@export var attack_node_name : String = "attack"
@export var attack_anim_name : String = "attack"

@export var default_node_name : String = "default"
@export var default_anim_name : String = "move"

func enter():
	#print("default")
	playback.travel(default_anim_name)
	
	
func state_input(event : InputEvent):
	if event.is_action_pressed("attack"):
		attack()
	
func attack():
	Transitioned.emit(self, attack_node_name)

