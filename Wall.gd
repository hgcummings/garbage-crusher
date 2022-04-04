extends KinematicBody2D

export var direction = 1

const SPEED = 0.25
const ACCELERATION_RATE = 0.1

var acceleration
var velocity
var is_braced = false
var stress = 0
var player

const channel_layers = [10,11]
const wall_layer = 8

func _ready():
	acceleration = SPEED * ACCELERATION_RATE
	velocity = Vector2(SPEED * direction, 0)
	collision_layer = 0
	self.set_collision_layer_bit(8, true)
	
	self.collision_mask = 0
	self.set_collision_mask_bit(wall_layer, true)
	for layer in channel_layers:	
		self.set_collision_mask_bit(layer, true)
	
	player = get_node("/root/Node2D/Player")

func _physics_process(delta):
	if is_braced:
		stress += abs(velocity.x)
	else:
		stress = 0
		add_collision_exception_with(player)
		move_and_collide(velocity)
		remove_collision_exception_with(player)


