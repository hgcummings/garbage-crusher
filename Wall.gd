extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1

var initial_velocity
var velocity 

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_velocity = Vector2(speed, 0)
	velocity = initial_velocity

func impart(new_velocity):
	velocity = Vector2.ZERO
	return velocity

func _physics_process(delta):
	velocity = initial_velocity
	var collision = move_and_collide(velocity)
	if collision:
		collision.collider.impart(velocity)
		
