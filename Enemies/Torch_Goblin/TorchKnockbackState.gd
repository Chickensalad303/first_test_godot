extends State

@export var enemy_character : CharacterBody2D
@export var knockback_limit : float = 50
@export var knockback_weight : float = 0.02
var knockback_to_apply : Vector2

# Called when the node enters the scene tree for the first time.
func enter():
	if !enemy_character:
		push_error("please set the export variables of the State: ", name)
		return 
	#playback.travel()
	#print("entered knockback, damage: ", enemy_damage_to_take, "knockback: ", enemy_knockback_to_take)
	print(parameters)
	enemy_character.speed = 0
	enemy_character.direction = Vector2.ZERO
	knockback_to_apply = parameters.knockback_force
	enemy_character.knockback = knockback_to_apply
	
	#enemy_health = enemy_health - enemy_damage_to_take
	#print(enemy_health)
	
	#print("damage taken: ", damage)
	#health = health - damage
	#velocity = velocity + knockback_force
	#knockback = knockback_force
	#print(knockback)
	#velocity = direction * speed + knockback_force
	
func physics_update(delta : float):
	#print("Knockback: ", knockback_to_apply, " -  velocity: ", enemy_character.velocity)
	activate_knockback(knockback_limit)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#enemy_character.knockback = lerp(enemy_character.knockback, Vector2.ZERO, 0.1)
	pass

func activate_knockback(knockback_limit : float):
	# length of vector2 is just pythagoras theorem, good way to compare 2 vectors
	if (knockback_to_apply.length() > knockback_limit):
		knockback_to_apply = lerp(knockback_to_apply, Vector2.ZERO, knockback_weight)
		print(knockback_to_apply.length(), " > ", 2)
	else:
		knockback_to_apply = Vector2.ZERO
	
	enemy_character.knockback = knockback_to_apply
