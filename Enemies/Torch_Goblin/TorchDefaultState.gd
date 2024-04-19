extends State
var move_direction : Vector2
var wander_time : float
@export var move_speed : float = 100.0

@export var torch_character : CharacterBody2D
@export var follow_node_name : String = "follow"
@export var knockback_node_name : String = "knockback"
@export var attack_node_name : String = "attack"
@export var default_anim_name : String = "move"

@export var follow_threshold : float = 250
@export var group_name_of_player : String = "player"
var character_body : CharacterBody2D


func enter():
	if !torch_character:
		push_error("please set the export variables of the State: ", name)
		return 
	character_body = get_tree().get_first_node_in_group(group_name_of_player)
	knockback_node_name = knockback_node_name.to_lower()
	follow_node_name = follow_node_name.to_lower()
	attack_node_name = attack_node_name.to_lower()
	playback.travel(default_anim_name)
	randomize_wander()

func update(delta : float):
	#print(direction, " - he")
	if wander_time > 0:
		wander_time = wander_time - delta
	else:
		Transitioned.emit(self, attack_node_name, {})
		randomize_wander()
		
func physics_update(delta : float):
	torch_character.direction = move_direction
	torch_character.speed = move_speed
	var distance_to_enemy = character_body.global_position - torch_character.global_position
	if (distance_to_enemy.length() < follow_threshold):
		Transitioned.emit(self, follow_node_name, {"follow_threshold": follow_threshold})



func randomize_wander():
	#the direction & speed variable sets the ones from the State class,
	#which get accesed in torch_goblin.gd
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	#enemy_speed = move_speed
	wander_time = randf_range(1, 5)
