extends State

@export var enemy_character : CharacterBody2D
@export var move_speed : float = 100.0
var move_direction : Vector2
var wander_time : float

@export var knockback_node_name : String = "knockback"
@export var default_anim_name : String = "move"

func randomize_wander():
	#the direction & speed variable sets the ones from the State class,
	#which get accesed in torch_goblin.gd
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	#enemy_speed = move_speed
	wander_time = randf_range(1, 5)
	

func enter():
	if !enemy_character:
		push_error("please set the export variables of the State: ", name)
		return 
	knockback_node_name = knockback_node_name.to_lower()
	default_anim_name = default_anim_name.to_lower()
	playback.travel(default_anim_name)
	randomize_wander()
# Called when the node enters the scene tree for the first time.

#func take_damage(damage : float, knockback_force : Vector2):
	#enemy_damage_to_take = damage
	#enemy_knockback_to_take = knockback_force
	#print(enemy_damage_to_take)
	#Transitioned.emit(self, "Knockback", "test")

func update(delta : float):
	#print(direction, " - he")
	if wander_time > 0:
		wander_time = wander_time - delta
	else:
		Transitioned.emit(self, "attack", {})
		randomize_wander()
		
func physics_update(delta : float):
	if enemy_character:
		enemy_character.direction = move_direction
		enemy_character.speed = move_speed

