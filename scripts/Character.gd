extends CharacterBody2D
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _child_anim_sprite = _animated_sprite.get_node("AnimatedSprite2D2")

var player_state = "idle"
const SPEED = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	pass

func _process(delta):
	pass
	
func _input(event):
	pass

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0:
		player_state = "run"
	elif direction.y != 0:
		player_state = "run_up"
	#when using move_and_slide() there is no need for delta, move_and_slide() just takes velocity and multiplies it with delta and sets it as the new position
	velocity = direction * SPEED # * delta
	character_animation_player(delta, player_state)
	#position = position + velocity
	move_and_slide()


func character_animation_player(delta, player_state):
	if Input.is_action_pressed("move_right"):
		# use scale.x to flip instead of this: _animated_sprite.flip_h = false, because it doesn't flip children
		_animated_sprite.scale.x = 1
		_animated_sprite.play(player_state)
		_child_anim_sprite.play("run_dust")
	elif Input.is_action_pressed("move_left"):
		_animated_sprite.scale.x = -1
		_animated_sprite.play(player_state)
		_child_anim_sprite.play("run_dust")
	elif Input.is_action_pressed("move_up"):
		_animated_sprite.play(player_state)
	elif Input.is_action_pressed("move_down"):
		_animated_sprite.play(player_state)
	else:	
		_animated_sprite.play(player_state)	
	if player_state == "run":
		_child_anim_sprite.modulate.a = lerpf(_child_anim_sprite.modulate.a, 1, 0.2)
	else:
		_child_anim_sprite.modulate.a = lerpf(_child_anim_sprite.modulate.a, 0, 0.1)


