extends Area2D
class_name sword_area2d
@export var torchgoblin_node_name : String = "TorchGoblin"
@export var knockback_strength : float = 300
@export var damage_to_deal : float = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
#when body enters check if damageable & do damage
	if (torchgoblin_node_name in body.name):
		#print(body.state_machine.current_state.name, " = ")
		var current : String = body.state_machine.current_state.name.to_lower()
		# enemy states that are allowed to be interrupted
		var interruptible_states : Array = ["default", "follow", "attack"]
		if (interruptible_states.has(current) == true):
			var current_position = global_position
			body.take_damage(damage_to_deal, knockback_strength, current_position)
		
	
