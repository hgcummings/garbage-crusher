extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision:
		velocity = collision.collider.impart(velocity)
		
func impart(new_velocity):
	if (velocity.x == 0):
		velocity = new_velocity
	
	return velocity



func _on_Stick_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		self.queue_free()
