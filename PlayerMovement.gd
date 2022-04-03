extends KinematicBody2D

var ChannelStick = preload("ChannelStick.tscn")
var FloorStick = preload("FloorStick.tscn")
var rng = RandomNumberGenerator.new()

export var SPEED = 360
export var ANGULAR_SPEED_DEGS = 5
export var random_throw_velocity = 5.0
export var random_throw_angular_velocity = 1.0

var heldItem = null
export var player_number = 1

var inputLinearDirection = 0
var inputAngularDirection = 0
var movementVector = Vector2.ZERO

func convert_stick_type(stick, type):
	var new_stick
	if type == "floor":
		new_stick = FloorStick.instance()
	if type == "channel":
		new_stick = ChannelStick.instance()
	
	new_stick.strength = stick.strength
	return new_stick
	
func handle_pick_up():
	heldItem = $RayCast2D.get_collider()
	if heldItem == null:
		return
	
	if heldItem.has_method("get_interactable"):
		heldItem = heldItem.get_interactable()	
	
	if heldItem in get_node("/root/Node2D/Channels/Channel1/Contents").get_children():
		get_node("/root/Node2D/Channels/Channel1/Contents").call_deferred("remove_child", heldItem)
	elif heldItem in get_node("/root/Node2D/Channels/Channel2/Contents").get_children():
		get_node("/root/Node2D/Channels/Channel2/Contents").call_deferred("remove_child", heldItem)
	else:
		get_tree().get_root().call_deferred("remove_child", heldItem)
	
	$HeldItemSprite.add_child(heldItem.get_node("Sprite").duplicate())
	$HeldItemSprite.add_child(heldItem.get_node("CollisionShape2D").duplicate())

func handle_drop():
	heldItem = convert_stick_type(heldItem, "floor")
	
	var areas = $HeldItemSprite.get_overlapping_areas()
	
	for child in $HeldItemSprite.get_children():
		child.queue_free()
			
	if get_node("/root/Node2D/Channels/Channel1/") in areas:
		print("channel1")
	if get_node("/root/Node2D/Channels/Channel2/") in areas:
		print("channel2")	
	
	get_tree().get_root().call_deferred("add_child", heldItem)
	heldItem.global_position = $HeldItemSprite.global_position
	heldItem.angular_velocity = rng.randf_range(-random_throw_angular_velocity, random_throw_angular_velocity)
	heldItem.linear_velocity = rng.randf_range(0, random_throw_velocity) * ($HeldItemSprite.global_position - global_position)
	if rng.randi_range(0, 20) == 0:
		heldItem.linear_velocity = 20 * ($HeldItemSprite.global_position - global_position)
			
	heldItem = null

func process_inputs():
	# Process inputs
	inputLinearDirection = 0
	inputAngularDirection = 0
	if Input.is_action_pressed("up_%s" % player_number):
		inputLinearDirection += 1
	if Input.is_action_pressed("down_%s" % player_number):
		inputLinearDirection -= 0.5
	if Input.is_action_pressed("left_%s" % player_number):
		inputAngularDirection -= 1
	if Input.is_action_pressed("right_%s" % player_number):
		inputAngularDirection += 1 
	
	
	if Input.is_action_just_released("interact_%s" % player_number):
		if heldItem == null:
			handle_pick_up()
		else:
			handle_drop()
			
func _physics_process(delta):
	process_inputs()

	rotation_degrees += (inputAngularDirection * ANGULAR_SPEED_DEGS) % 360
	
	movementVector = Vector2(cos(rotation + PI / 2), sin(rotation + PI / 2)) * inputLinearDirection * SPEED
	
	move_and_slide(movementVector)
