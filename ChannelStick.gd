extends KinematicBody2D

var FloorStick = load("res://FloorStick.tscn")
var Helpers = load("res://StickHelpers.gd")

var tex_2 = preload("res://sprites/materials/sticks/2.png")
var tex_2_braced = preload("res://sprites/materials/sticks/2-braced.png")
var tex_2_alert = preload("res://sprites/materials/sticks/2-alert.png")

var tex_3 = preload("res://sprites/materials/sticks/3.png")
var tex_3_braced = preload("res://sprites/materials/sticks/3-braced.png")
var tex_3_alert = preload("res://sprites/materials/sticks/3-alert.png")

var tex_4 = preload("res://sprites/materials/sticks/4.png")
var tex_4_braced = preload("res://sprites/materials/sticks/4-braced.png")
var tex_4_alert = preload("res://sprites/materials/sticks/4-alert.png")

var tex_5 = preload("res://sprites/materials/sticks/5.png")
var tex_5_braced = preload("res://sprites/materials/sticks/5-braced.png")
var tex_5_alert = preload("res://sprites/materials/sticks/5-alert.png")

var velocity = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var strength
var level = 1
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

func upgrade(strength):
	if self.level >= 5:
		return false
		
	self.level += 1
	self.strength += strength
	if self.level == 2:
		$Sprite.texture = tex_2
		$Sprite_Braced.texture = tex_2_braced
		$Sprite_Alarm.texture = tex_2_alert
	elif self.level == 3:
		$Sprite.texture = tex_3
		$Sprite_Braced.texture = tex_3_braced
		$Sprite_Alarm.texture = tex_3_alert
	elif self.level == 4:
		$Sprite.texture = tex_4
		$Sprite_Braced.texture = tex_4_braced
		$Sprite_Alarm.texture = tex_4_alert
	elif self.level == 5:
		$Sprite.texture = tex_5
		$Sprite_Braced.texture = tex_5_braced
		$Sprite_Alarm.texture = tex_5_alert
	return true
	
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
