extends KinematicBody2D

export var speed = 1

var velocity
var is_braced = false
var stress = 0

const channel_layers = [10,11]
const wall_layer = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(speed * 100, 0)
	collision_layer = 0
	self.set_collision_layer_bit(8, true)
	
	self.collision_mask = 0
	self.set_collision_mask_bit(wall_layer, true)
	for layer in channel_layers:	
		self.set_collision_mask_bit(layer, true)

func _physics_process(delta):
	var chain = [self]
		
	var chain_reaches_opposite_wall = false
	var dv = delta * velocity
		
	var collision = self.move_and_collide(dv, true, true, true)
	if collision:
		while (collision):
			var collider = collision.collider
			
			if chain.find(collider) != -1:
				break
			elif collider.get_script() == self.get_script():
				chain_reaches_opposite_wall = true
				break
			else:
				chain.append(collider)
				collision = collider.move_and_collide(dv, true, true, true)

	if chain_reaches_opposite_wall:
		stress += delta * speed
		
		while !chain.empty():
			chain.pop_back().is_braced = true
	else:
		stress = 0
		
		while !chain.empty():
			var elem = chain.pop_back()
			elem.move_and_collide(dv)
			elem.is_braced = false
