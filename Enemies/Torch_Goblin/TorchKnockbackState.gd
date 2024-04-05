extends State


# Called when the node enters the scene tree for the first time.
func enter():
	#playback.travel()
	print("entered knockback, damage: ", enemy_damage_to_take, "knockback: ", enemy_knockback_to_take)
	enemy_health = enemy_health - enemy_damage_to_take
	print(enemy_health)
	
	#print("damage taken: ", damage)
	#health = health - damage
	#velocity = velocity + knockback_force
	#knockback = knockback_force
	#print(knockback)
	#velocity = direction * speed + knockback_force


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
