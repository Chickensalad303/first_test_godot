extends CharacterBody2D


@onready var anim_tree : AnimationTree = $Sprite2D/AnimationTree
@onready var state_machine : enemy_state_machine = $EnemyStateMachine
@export var health : float = 20

var direction : Vector2
func _ready():
	anim_tree.active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _physics_process(delta):
	direction = state_machine.current_state.direction
	print(direction)
	move_and_slide()
	update_animation()
	

func update_animation():
	anim_tree.set("parameters/move/blend_position", direction)

#make update facing direction here
