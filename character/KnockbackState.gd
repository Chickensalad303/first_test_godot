extends State

@export var character_body : CharacterBody2D
@export var knockback_limit : float = 50
@export var knockback_weight : float = 0.02
var knockback_to_apply : Vector2

func enter():
	if !character_body:
		push_error("please assign all the exports, they neeeeeeeeeeded to worki")
		return
	
	print("Help iva bean noonoked bucks  -  params -  ", parameters)
	character_body.speed = 0
	character_body.direction = Vector2.ZERO
	knockback_to_apply = parameters.knockback_force
	character_body.knockback = knockback_to_apply
	
func physics_update(delta : float):
	activate_knockback(knockback_limit)
	
func activate_knockback(knockback_limit: float):
	# length of vector2 is just pythagoras theorem, good way to compare 2 vectors
	if (knockback_to_apply.length() > knockback_limit):
		knockback_to_apply = lerp(knockback_to_apply, Vector2.ZERO, knockback_weight)
		#print(knockback_to_apply.length(), " > ", 50)
	else:
		knockback_to_apply = Vector2.ZERO
		Transitioned.emit(self, "default", {})
	character_body.knockback = knockback_to_apply
	

