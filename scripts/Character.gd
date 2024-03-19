extends CharacterBody2D
#@onready var _animated_sprite = $Sprite2D/AnimationPlayer
#@onready var _child_anim_sprite = _animated_sprite.get_node("AnimatedSprite2D2")


@onready var anim_player = self.get_node("Sprite2D/AnimationPlayer")
@onready var sprite = self.get_node("Sprite2D")
@onready var dust_sprite = self.get_node("Sprite2D/Sprite2D")

# player state can be idle, attack, walk_horizontal,
# walk_vertical
var player_state = "idle"
const SPEED = 150.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
signal k_pressed
func _ready():
	pass

func _process(delta):
	pass
	


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("k_key"):
			# emit signal, so any script can connect to it
			k_pressed.emit()
			
			
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction.x == 0 and direction.y == 0:
		player_state = "idle"
	elif direction.x != 0:
		player_state = "walk_horizontal"
	elif direction.y != 0:
		player_state = "walk_vertical"
	
	
	#if Input.is_action_pressed("attack"):
		#player_state = "attack"
	
	#if Input.is_action_just_pressed("move_right"):
		#sprite.scale.x = 1
		#anim_player.play("walk_horizontal")
	#if Input.is_action_just_pressed("move_left"):
		#sprite.scale.x = -1
		#anim_player.play("walk_horizontal")
	#when using move_and_slide() there is no need for delta, move_and_slide() just takes velocity and multiplies it with delta and sets it as the new position
	velocity = direction * SPEED # * delta
	character_animation_player(delta, player_state)
	#position = position + velocity
	move_and_slide()


func character_animation_player(delta, player_state):
	#if player_state == "attack":
		#_animated_sprite.play(player_state)
	if Input.is_action_just_pressed("move_right"):
		# use scale.x to flip instead of this: _animated_sprite.flip_h = false, because it doesn't flip children
		sprite.scale.x = 1
		anim_player.play(player_state)
	if Input.is_action_just_pressed("move_left"):
		sprite.scale.x = -1
		anim_player.play(player_state)
	elif Input.is_action_just_pressed("move_up"):
		anim_player.play(player_state)
	elif Input.is_action_just_pressed("move_down"):
		anim_player.play(player_state)
	else:	
		anim_player.play(player_state)
	if player_state == "walk_horizontal":
		dust_sprite.modulate.a = lerpf(dust_sprite.modulate.a, 1, 0.2)
	else:
		dust_sprite.modulate.a = lerpf(dust_sprite.modulate.a, 0, 0.1)

