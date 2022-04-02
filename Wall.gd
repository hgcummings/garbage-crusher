extends KinematicBody2D

export var speed = 1

var velocity
var is_braced = false
var stress = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(speed * 100, 0)

func _physics_process(delta):	
	var chain = [self]
		
	var chain_reaches_opposite_wall = false
	var dv = delta * velocity
		
	var collision = self.move_and_collide(dv, true, true, true)
	if collision:
		while (collision):
			var collider = collision.collider
			#print(chain.size())
			
			if chain.find(collider) != -1:
				break
			elif collider.get_script() == self.get_script():
				chain_reaches_opposite_wall = true
				break
			else:
				chain.append(collider)
				collision = collider.move_and_collide(dv, true, true, true)
				#print(collision)

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
