extends State

@export var attack_anim_name : String = "attack"

func enter():
	playback.travel(attack_anim_name)

func physics_update(delta : float):
	var current_anim = playback.get_current_node()
	var duration = playback.get_current_length()
	var current_duration = playback.get_current_play_position()
	#print(current_duration, "  -   ", duration)
	if duration == current_duration:
		Transitioned.emit(self, "default", {})
	
