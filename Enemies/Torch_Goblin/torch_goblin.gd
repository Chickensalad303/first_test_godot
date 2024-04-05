extends CharacterBody2D


@onready var anim_tree : AnimationTree = $Sprite2D/AnimationTree
@onready var state_machine : enemy_state_machine = $EnemyStateMachine
@export var health : float = 20

@onready var sprite : Sprite2D = $Sprite2D
@onready var attack_hitbox : Area2D = $Attack

#var knockback : Vector2 = Vector2.ZERO
var state_direction : Vector2
var state_speed : float

func _ready():
	anim_tree.active = true
	state_machine.current_state.enemy_health = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	state_direction = state_machine.current_state.enemy_direction
	state_speed = state_machine.current_state.enemy_speed
	#print(direction)
	#print(direction, "and", speed)
	
	velocity = state_direction * state_speed
	move_and_slide()
	update_animation()
	update_facing_direction()
	

func update_animation():
	anim_tree.set("parameters/move/blend_position", state_direction)

#make update facing direction here
func update_facing_direction():
	if (state_direction.x > 0):
		sprite.scale.x = 1
		attack_hitbox.scale.x = 1
	elif (state_direction.x < 0):
		sprite.scale.x = -1
		attack_hitbox.scale.x
	
#func take_damage(damage : float, knockback_force : Vector2):
	#print("damage taken: ", damage)
	#health = health - damage
	##velocity = velocity + knockback_force
	#knockback = knockback_force
	#print(knockback)
	##velocity = direction * speed + knockback_force
	
	

