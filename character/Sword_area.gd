extends Area2D
class_name sword_area2d

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
#when body enters check if damageable & do damage
	if ("TorchGoblin" in body.name):
		#print(body.state_machine.current_state.name, " = ")
		if ("Default" in body.state_machine.current_state.name):
			var default_state : State = body.state_machine.current_state
			var knockback_direction = global_position.direction_to(body.global_position)
			var knockback_force = knockback_direction * 20
			#print(type_string(typeof(knockback_force)), " hello")
			#print(body.state_machine)
			default_state.take_damage(20, knockback_force)
		
	
