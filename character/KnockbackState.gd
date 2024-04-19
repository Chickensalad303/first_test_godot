extends State

@export var character_body : CharacterBody2D
@export var knockback_limit : float = 50
@export var knockback_weight : float = 0.02
var knockback_to_apply : Vector2

@export var get_hit_anim_name : String = "get_hit"
func enter():
	if !character_body:
		push_error("please assign all the exports, they neeeeeeeeeeded to worki")
		return
	playback.travel(get_hit_anim_name)
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
		# instead of below, do it in animationplayer, more efficient
		#get_node("../../Sprite2D").get_material().set_shader_parameter("is_active", true)
		knockback_to_apply = lerp(knockback_to_apply, Vector2.ZERO, knockback_weight)
		#print(knockback_to_apply.length(), " > ", 50)
	else:
		knockback_to_apply = Vector2.ZERO
		Transitioned.emit(self, "default", {})
	character_body.knockback = knockback_to_apply
	

