extends State
class_name AttackState

func enter():
	print("called")
	Transitioned.emit(self, "Default")

func state_input(event : InputEvent):
	if event.is_action_pressed("k_key"):
		print("hi")
func physics_update(delta : float):
	print("playing")
	Transitioned.emit(self, "default")
		
