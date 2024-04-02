extends State

@export var enemy_character : CharacterBody2D
@export var move_speed : float = 100.0

#var move_direction : Vector2
var wander_time : float

func randomize_wander():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 5)
	

func enter():
	#playback.travel("move")
	randomize_wander()
# Called when the node enters the scene tree for the first time.

func update(delta : float):
	if wander_time > 0:
		wander_time = wander_time - delta
	else:
		randomize_wander()
		
func physics_update(delta : float):
	if enemy_character:
		enemy_character.velocity = direction * move_speed

