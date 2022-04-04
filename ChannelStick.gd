extends KinematicBody2D

var FloorStick = load("res://FloorStick.tscn")
var Helpers = load("res://StickHelpers.gd")

var velocity = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var strength
var level = 1
var is_braced = false

var left_wall
var right_wall

var stick_material = "wood"
var stick_status = "default"

func _ready():
	rng.randomize()
	
	if stick_material == "wood":
		strength = rng.randf_range(10, 50)
	else:
		strength = rng.randf_range(250, 350)

	left_wall = get_node("/root/Node2D/LeftWall")
	right_wall = get_node("/root/Node2D/RightWall")
	$Sprite.texture = Helpers.texture(stick_material, stick_status, level)

func apply_force(force):
	if force > strength:
		self.queue_free()
		return true
	
	if force > 0.85 * strength:
		stick_status = "alert"
	else:
		stick_status = "braced"

	$Sprite.texture = Helpers.texture(stick_material, stick_status, level)

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

func upgrade(upgrade_stick):
	if self.level >= 5:
		return false
		
	if self.stick_material != upgrade_stick.stick_material:
		return false
		
	self.level += 1
	self.strength += upgrade_stick.strength
	return true

func highlight():
	$Sprite.modulate = Color(2,2,2)
	
func unhighlight():
	$Sprite.modulate = Color(1,1,1)
	
func _physics_process(delta):
	if is_braced:
		return
	
	remove_collision_exception_with(left_wall)
	remove_collision_exception_with(right_wall)
	move_and_collide(Vector2.ZERO)
	add_collision_exception_with(left_wall)
	add_collision_exception_with(right_wall)

func _process(delta):
	if !is_braced:
		stick_status = "default"
	$Sprite.texture = Helpers.texture(stick_material, stick_status, level)

# Debug functionality
func _on_Stick_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		self.queue_free()
