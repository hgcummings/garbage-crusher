extends KinematicBody2D

var SPEED = 500

var inputDirection = Vector2.ZERO
var movementVector = Vector2.ZERO

func process_inputs():
	# Process inputs
	inputDirection = Vector2.ZERO
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		inputDirection += Vector2.UP
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		inputDirection += Vector2.DOWN
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		inputDirection += Vector2.LEFT
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		inputDirection += Vector2.RIGHT

func _physics_process(delta):
	process_inputs()
	movementVector = inputDirection * SPEED
	move_and_slide(movementVector)
