extends Area2D

@export var knockback_strength : float = 300
@export var damage_to_deal : float = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func enter():
	#print("torchattackarea")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if ("CharacterBody2D" in body.name):
		if ("Default" in body.state_machine.current_state.name):
			
			#var default_state : State = body.state_machine.current_state
			#var knockback_direction = global_position.direction_to(body.global_position)
			#var knockback_force = knockback_direction * knockback_strength
			var current_position = global_position
			#print(type_string(typeof(knockback_force)), " hello")
			#print(body.state_machine)
			body.take_damage(damage_to_deal, knockback_strength, current_position)
