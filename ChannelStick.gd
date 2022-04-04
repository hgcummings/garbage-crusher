extends KinematicBody2D

var FloorStick = load("res://FloorStick.tscn")
var Helpers = load("res://StickHelpers.gd")

var velocity = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var strength
var is_braced = false

func _ready():
	rng.randomize()
	strength = rng.randf_range(2.5, 3.5)

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

func _process(delta):
	$Sprite_Braced.visible = is_braced
	if !is_braced:
		$Sprite_Alarm.visible = false

# Debug functionality
func _on_Stick_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		self.queue_free()
