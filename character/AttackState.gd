extends State
class_name AttackState
#@onready var anim_tree : AnimationTree = get_node("../../Sprite2D/AnimationTree")

@export var attack_node_name : String = "attack"
@export var attack_anim_name : String = "attack"

@export var default_node_name : String = "default"
@export var default_anim_name : String = "move"

func enter():
	print("called")
	playback.travel(attack_anim_name)

func update(delta : float):
	var current_anim = playback.get_current_node()
	var duration = playback.get_current_length()
	var current_duration = playback.get_current_play_position()
	#print(current_duration, "  -   ", duration)
	if duration == current_duration:
		Transitioned.emit(self, default_node_name)
		
		
	

#func _on_animation_tree_animation_finished(anim_name):
	#if (anim_name == "attack"):
		#print("true")
#func physics_update(delta : float):
	##print("playing")
	#if playback.is_playing():
		#
	#
	#Transitioned.emit(self, "default")
		#
