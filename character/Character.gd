extends CharacterBody2D


@onready var anim_player : AnimationPlayer = self.get_node("Sprite2D/AnimationPlayer")
@onready var sprite : Sprite2D = self.get_node("Sprite2D")
@onready var dust_sprite : Sprite2D = self.get_node("Sprite2D/Sprite2D")

@onready var anim_tree : AnimationTree = $Sprite2D/AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var sword_hitbox : Area2D = $Sword


# player state can be idle, attack, walk_horizontal, walk_vertical
var player_state = "idle"
var SPEED = 150.0
var direction : Vector2 = Vector2.ZERO

func _ready():
	anim_tree.active = true


#func _input(event : InputEvent):
	#if (event.is_action_pressed("attack")):
		#print("here")
		#player_state = "attack"
		##handle_player_attacks(player_state)
	#
	
	#if event is InputEventKey:
		#if event.is_action_pressed("k_key"):
			## emit signal, so any script can connect to it
			#k_pressed.emit()
			
			
func _physics_process(delta):
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#if (state_machine.check_if_attacking()):
		#print("yasssss")
	
	if (direction.x == 0 and direction.y == 0):
		player_state = "idle"
	elif (direction.x != 0):
		player_state = "walk_horizontal"
	elif (direction.y != 0):
		player_state = "walk_vertical"
	
	#when hit by certain enemy attack you recieve a slowed status effect
	#state_machine.current_state.is_slowed = false
	
	#if state_machine.check_slowed() == true:
		#sprite.modulate = "#A020F0"
		#SPEED = 50.0
		
	#when using move_and_slide() there is no need for delta, move_and_slide() just takes velocity and multiplies it with delta and sets it as the new position
	velocity = direction * SPEED # * delta
	
	#position = position + velocity
	move_and_slide()
	update_animation()
	update_facing_direction()
	
	

func update_animation():
	anim_tree.set("parameters/move/blend_position", direction)
	
	
func update_facing_direction():
	if (state_machine.get_current_animation() == "attack"):
		return # makes so cannot turn during attack
	
	if (direction.x > 0):
		sprite.scale.x = 1
		sword_hitbox.scale.x = 1
	elif (direction.x < 0):
		sprite.scale.x = -1
		sword_hitbox.scale.x = -1
	#fade dust anim in and out when walking horizontally
	if (direction.x != 0):
		dust_sprite.modulate.a = lerpf(dust_sprite.modulate.a, 1, 0.2)
	else:
		dust_sprite.modulate.a = lerpf(dust_sprite.modulate.a, 0, 0.1)
		


func handle_player_movement(player_state : String):
	
	if Input.is_action_just_pressed("move_right"):
		# use scale.x to flip instead of this: _animated_sprite.flip_h = false, because it doesn't flip children
		sprite.scale.x = 1
		anim_player.play(player_state)
	if Input.is_action_just_pressed("move_left"):
		sprite.scale.x = -1
		anim_player.play(player_state)
	elif Input.is_action_just_pressed("move_up"):
		#sprite.scale.x = -1
		anim_player.play_backwards(player_state)
	elif Input.is_action_just_pressed("move_down"):
		#sprite.scale.x = 1
		anim_player.play(player_state)
	else:	
		anim_player.play(player_state)
	if player_state == "walk_horizontal":
		dust_sprite.modulate.a = lerpf(dust_sprite.modulate.a, 1, 0.2)
	else:
		dust_sprite.modulate.a = lerpf(dust_sprite.modulate.a, 0, 0.1)

