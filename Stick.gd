extends KinematicBody2D

var velocity = Vector2(0,0)
var rng = RandomNumberGenerator.new()
var strength
var is_braced = false

# Called when the node enters the scene tree for the first time.
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

func _process(delta):
	$Sprite_Braced.visible = is_braced
	if !is_braced:
		$Sprite_Alarm.visible = false
		
	

# Debug functionality
func _on_Stick_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		self.queue_free()
