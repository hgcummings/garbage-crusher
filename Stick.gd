extends KinematicBody2D

const Wall = preload('Wall.gd')

var velocity = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var strength
var is_bracing = false

var alert_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	strength = rng.randf_range(85, 115)


func _physics_process(delta):
	is_bracing = false
	
	if (velocity.x != 0):
		var collision = move_and_collide(velocity)
		if collision:
			velocity = collision.collider.impart(velocity, self)
			if velocity.x == 0:
				is_bracing = true

	velocity = Vector2.ZERO
		
func impart(new_velocity, pusher):
	velocity = new_velocity
	return velocity

func apply_force(force):
	if force > strength:
		self.queue_free()
	elif force > 0.85 * strength:
		$Sprite_Alarm.visible = true
		

# Debug functionality
func _on_Stick_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		self.queue_free()
