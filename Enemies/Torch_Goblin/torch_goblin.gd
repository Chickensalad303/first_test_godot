extends CharacterBody2D


@onready var anim_tree : AnimationTree = $Sprite2D/AnimationTree
@onready var state_machine : torch_state_machine = $EnemyStateMachine
@export var health : float = 20

@onready var sprite : Sprite2D = $Sprite2D
@export var attack_hitbox : Area2D

@export var knockback_state_name : String = "knockback"
var knockback : Vector2 = Vector2.ZERO
var direction : Vector2
var speed : float

func _ready():
	knockback_state_name = knockback_state_name.to_lower()
	anim_tree.active = true
	#s5tate_machine.current_state.enemy_health = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):

	velocity = direction * speed + knockback
	
	move_and_slide()
	update_animation()
	update_facing_direction()
	


func update_animation():
	anim_tree.set("parameters/move/blend_position", direction)

#make update facing direction here
func update_facing_direction():
	if (direction.x > 0):
		sprite.scale.x = 1
		attack_hitbox.scale.x = 1
	elif (direction.x < 0):
		sprite.scale.x = -1
		attack_hitbox.scale.x = -1
	
func take_damage(damage : float, knockback_strength : float, attacker_position : Vector2):
	var knockback_direction =  attacker_position.direction_to(global_position)
	var knockback_force = knockback_direction * knockback_strength
	
	#state_machine.current_state.enemy_damage_to_take = damage
	#state_machine.current_state.enemy_knockback_to_take = knockback_force
	#print(state_machine.current_state.enemy_knockback_to_take, " helll")
	var parameters : Dictionary = {"damage" : damage, "knockback_force" : knockback_force}
	#print(knockback_state_name, "hel")
	if (state_machine.current_state.name != knockback_state_name):
		state_machine.current_state.Transitioned.emit(state_machine.current_state, knockback_state_name, parameters)
	
	

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
	
	


