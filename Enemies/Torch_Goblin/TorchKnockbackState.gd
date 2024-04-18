extends State

@export var enemy_character : CharacterBody2D
@export var knockback_limit : float = 50
@export var knockback_weight : float = 0.02
var knockback_to_apply : Vector2

@export var default_node_name : String = "default"
@export var get_hit_anim_name : String = "get_hit"

# Called when the node enters the scene tree for the first time.
func enter():
	if !enemy_character:
		push_error("please set the export variables of the State: ", name)
		return
	default_node_name = default_node_name.to_lower()
	get_hit_anim_name = get_hit_anim_name.to_lower()

	#print(parameters)
	enemy_character.speed = 0
	enemy_character.direction = Vector2.ZERO
	knockback_to_apply = parameters.knockback_force
	enemy_character.knockback = knockback_to_apply
	playback.travel(get_hit_anim_name)
	
	#enemy_health = enemy_health - enemy_damage_to_take
	#print(enemy_health)
	
	
func physics_update(delta : float):
	#print("Knockback: ", knockback_to_apply, " -  velocity: ", enemy_character.velocity)
	activate_knockback(knockback_limit)
	

func activate_knockback(knockback_limit : float):
	# length of vector2 is just pythagoras theorem, good way to compare 2 vectors
	if (knockback_to_apply.length() > knockback_limit):
		knockback_to_apply = lerp(knockback_to_apply, Vector2.ZERO, knockback_weight)
		#print(knockback_to_apply.length(), " > ", 50)
	else:
		knockback_to_apply = Vector2.ZERO
		Transitioned.emit(self, "default", {})
	enemy_character.knockback = knockback_to_apply
