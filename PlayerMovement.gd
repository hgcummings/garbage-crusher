extends KinematicBody2D

var rng = RandomNumberGenerator.new()

export var SPEED = 500
export var random_throw_velocity = 2.0
export var random_throw_angular_velocity = 1.0

var heldItem = null

var inputDirection = Vector2.ZERO
var movementVector = Vector2.ZERO

func handle_pick_up():
	heldItem = $RayCast2D.get_collider()
	get_tree().get_root().remove_child(heldItem)

func handle_drop():
	heldItem.position = position
	heldItem.angular_velocity = rng.randf_range(-random_throw_angular_velocity, random_throw_angular_velocity)
	heldItem.linear_velocity = rng.randf_range(0, random_throw_velocity) * $RayCast2D.cast_to
	if rng.randi_range(0, 20) == 0:
		heldItem.linear_velocity = 20 * $RayCast2D.cast_to
		
	get_tree().get_root().add_child(heldItem)
	heldItem = null

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
		
	if Input.is_key_pressed(KEY_SPACE):
		if heldItem == null:
			handle_pick_up()
		else:
			handle_drop()

func _physics_process(delta):
	process_inputs()
	movementVector = inputDirection * SPEED
	move_and_slide(movementVector)
