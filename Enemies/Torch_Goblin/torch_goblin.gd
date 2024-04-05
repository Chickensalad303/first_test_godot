extends CharacterBody2D


@onready var anim_tree : AnimationTree = $Sprite2D/AnimationTree
@onready var state_machine : enemy_state_machine = $EnemyStateMachine
@export var health : float = 20

@onready var sprite : Sprite2D = $Sprite2D
@onready var attack_hitbox : Area2D = $Attack

var knockback : Vector2 = Vector2.ZERO
var direction : Vector2
var speed : float

func _ready():
	anim_tree.active = true
	#s5tate_machine.current_state.enemy_health = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	#direction = state_machine.current_state.enemy_direction
	#state_speed = state_machine.current_state.enemy_speed
	#print(direction)
	#print(direction, "and", speed)
	#print(knockback)
	velocity = direction * speed + knockback
	
	move_and_slide()
	update_animation()
	update_facing_direction()
	
	## length of vector2 is just pythagoras theorem, good way to compare 2 vectors
	#if (knockback.length() > 50):
		#knockback = lerp(knockback, Vector2.ZERO, 0.02)
		#print(knockback.length(), " > ", 2)
	#else:
		#knockback = Vector2.ZERO

func update_animation():
	anim_tree.set("parameters/move/blend_position", direction)

#make update facing direction here
func update_facing_direction():
	if (direction.x > 0):
		sprite.scale.x = 1
		attack_hitbox.scale.x = 1
	elif (direction.x < 0):
		sprite.scale.x = -1
		attack_hitbox.scale.x
	
func take_damage(damage : float, knockback_strength : float, attacker_position : Vector2):
	var knockback_direction =  attacker_position.direction_to(global_position)
	var knockback_force = knockback_direction * knockback_strength
	
	#state_machine.current_state.enemy_damage_to_take = damage
	#state_machine.current_state.enemy_knockback_to_take = knockback_force
	#print(state_machine.current_state.enemy_knockback_to_take, " helll")
	var parameters : Dictionary = {"damage" : damage, "knockback_force" : knockback_force}
	state_machine.current_state.Transitioned.emit(state_machine.current_state, "Knockback", parameters)

	#var default_state : State = body.state_machine.current_state
	#var knockback_direction = global_position.direction_to(body.global_position)
	#var knockback_force = knockback_direction * 20
	
	
#func take_damage(damage : float, knockback_force : Vector2):
	#print("damage taken: ", damage)
	#health = health - damage
	##velocity = velocity + knockback_force
	#knockback = knockback_force
	#print(knockback)
	##velocity = direction * speed + knockback_force
	
	

