extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1

var initial_velocity
var velocity
var force = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_velocity = Vector2(speed, 0)
	velocity = initial_velocity

func _physics_process(delta):
	if velocity.x == 0:
		force += (delta * abs(speed))
	else:
		force = 0
	
	var chain = []
	var collision = self.move_and_collide(initial_velocity, true, true, true)
	if collision:
		while (collision):
			var collider = collision.collider
			
			if collider is Wall:
				velocity = Vector2.ZERO
				return
			else:
				chain.append(collider)
				collision = collider.move_and_collide(initial_velocity, true, true, true)
				
	
			
		
func impart(new_velocity, pusher):
	velocity = Vector2.ZERO
	return velocity
