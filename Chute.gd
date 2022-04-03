extends StaticBody2D

const FloorStick = preload("res://FloorStick.tscn")
var rng = RandomNumberGenerator.new()

const avg_spawn_interval_s = 3
var y_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	y_direction = ((get_viewport_rect().size / 2) - self.position).normalized().y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if rng.randf() < (delta / avg_spawn_interval_s):
		var new_stick = FloorStick.instance() as RigidBody2D
		new_stick.position = self.position
		new_stick.angular_velocity = rng.randf_range(-0.5, 0.5)
		new_stick.linear_velocity = Vector2(rng.randf_range(-100, 100), rng.randf_range(50, 150) * y_direction)
		get_tree().get_root().add_child(new_stick)

