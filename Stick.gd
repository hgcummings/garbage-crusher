extends KinematicBody2D


var velocity = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var strength
var is_bracing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	strength = rng.randf_range(85, 115)


func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision:
		velocity = collision.collider.impart(velocity)

	velocity = Vector2.ZERO
		
func impart(new_velocity):
	velocity = new_velocity
	return velocity

# Debug functionality
func _on_Stick_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		self.queue_free()
