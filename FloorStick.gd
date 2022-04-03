extends RigidBody2D

var strength


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func fall_in_hole():
	queue_free()
