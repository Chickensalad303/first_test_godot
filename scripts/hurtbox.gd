class_name HurtboxTest
extends Area2D

func _init():
	collision_layer = 0
	collision_mask = 8
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self._on_area_entered)


func _on_area_entered(hitbox: HitboxTest): 
	if hitbox == null:
		return
	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
