extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 1

var velocity 

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(speed, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	move_and_collide(velocity)
