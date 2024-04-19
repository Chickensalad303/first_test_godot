extends State
@export var torch_character : CharacterBody2D
@export var move_speed : float = 100
@export var attack_threshold : float = 50

@export var group_name_of_player : String = "player"
@export var default_node_name : String = "default"
@export var attack_node_name : String = "attack"

var character_body : CharacterBody2D
func enter():
	character_body = get_tree().get_first_node_in_group(group_name_of_player)
	if !torch_character or !parameters.follow_threshold:
		push_error("please set the export variables of the State: ", name)
		push_error("also check if the parameters are being sent from the Transitioned signal")
		return 
	
func physics_update(delta : float):
	var direction = character_body.global_position - torch_character.global_position
	torch_character.direction = direction.normalized()
	torch_character.speed = move_speed
	if (direction.length() < attack_threshold):
		Transitioned.emit(self, attack_node_name, {})
	if (direction.length() > parameters.follow_threshold):
		Transitioned.emit(self, default_node_name)
	
	
	
