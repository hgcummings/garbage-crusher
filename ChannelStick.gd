extends KinematicBody2D

var FloorStick = load("res://FloorStick.tscn")
var Helpers = load("res://StickHelpers.gd")

var velocity = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var strength
var is_braced = false

var left_wall
var right_wall

func _ready():
	rng.randomize()
	strength = rng.randf_range(9, 12)
	left_wall = get_node("/root/Node2D/LeftWall")
	right_wall = get_node("/root/Node2D/RightWall")

func apply_force(force):
	if force > strength:
		self.queue_free()
		return true
	
	if force > 0.85 * strength:
		$Sprite_Alarm.visible = true

	return false

func as_floor_stick():
	var new_stick = FloorStick.instance()
	Helpers.transfer_stick_properties(self, new_stick)
	return new_stick

func as_channel_stick():
	return self

func get_length():
	# The width of a RectangleShape2D is twice the extent
	return $CollisionShape2D.shape.extents.x * 2

func _physics_process(delta):
	if is_braced:
		return
	
	remove_collision_exception_with(left_wall)
	remove_collision_exception_with(right_wall)
	move_and_collide(Vector2.ZERO)
	add_collision_exception_with(left_wall)
	add_collision_exception_with(right_wall)

func _process(delta):
	$Sprite_Braced.visible = is_braced
	if !is_braced:
		$Sprite_Alarm.visible = false

# Debug functionality
func _on_Stick_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		self.queue_free()
