extends Node2D

@onready var anim_player := $AnimationPlayer


func take_damage(amount: int): 
	anim_player.play("hit")
	print("damage taken:", amount)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
