extends KinematicBody2D

var rng = RandomNumberGenerator.new()

export var SPEED = 500
export var random_throw_velocity = 5.0
export var random_throw_angular_velocity = 1.0

var heldItem = null
export var player_number = 1

var inputDirection = Vector2.ZERO
var movementVector = Vector2.ZERO

func handle_pick_up():
	heldItem = $RayCast2D.get_collider()
	if heldItem == null:
		return
	get_tree().get_root().call_deferred("remove_child", heldItem)
	
	$HeldItemSprite.add_child(heldItem.get_node("Sprite").duplicate())

func handle_drop():
	get_tree().get_root().call_deferred("add_child", heldItem)
	$HeldItemSprite.get_node("Sprite").queue_free()
	
	heldItem.global_position = $HeldItemSprite.global_position
	heldItem.angular_velocity = rng.randf_range(-random_throw_angular_velocity, random_throw_angular_velocity)
	heldItem.linear_velocity = rng.randf_range(0, random_throw_velocity) * $RayCast2D.cast_to
	if rng.randi_range(0, 20) == 0:
		heldItem.linear_velocity = 20 * $RayCast2D.cast_to
		
	heldItem = null

func process_inputs():
	# Process inputs
	inputDirection = Vector2.ZERO
	if Input.is_action_pressed("up_%s" % player_number):
		inputDirection += Vector2.UP
	if Input.is_action_pressed("down_%s" % player_number):
		inputDirection += Vector2.DOWN
	if Input.is_action_pressed("left_%s" % player_number):
		inputDirection += Vector2.LEFT
	if Input.is_action_pressed("right_%s" % player_number):
		inputDirection += Vector2.RIGHT
		
	if Input.is_action_just_released("interact_%s" % player_number):
		if heldItem == null:
			handle_pick_up()
		else:
			handle_drop()

func _physics_process(delta):
	process_inputs()
	movementVector = inputDirection * SPEED
	move_and_slide(movementVector)
