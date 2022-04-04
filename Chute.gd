extends StaticBody2D

var FloorStick = load("res://FloorStick.tscn")
var rng = RandomNumberGenerator.new()

const avg_spawn_interval_s = 2.5
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
		new_stick.strength = rng.randf_range(2.5, 3.5)
		if rng.randf() < 0.2:
			new_stick.stick_material = "metal"
		get_tree().get_root().add_child(new_stick)

