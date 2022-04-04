extends KinematicBody2D

var rng = RandomNumberGenerator.new()

export var MAX_SPEED = 360
export var ANGULAR_SPEED_DEGS = 5
export var random_throw_velocity = 5.0
export var random_throw_angular_velocity = 1.0

var speed = 0
var acceleration = MAX_SPEED * 3

onready var channel1 = get_node("/root/Node2D/Channels/Channel1")
onready var channel2 = get_node("/root/Node2D/Channels/Channel2")
var heldItem = null
export var player_number = 1
export(Texture) var idle_sprite setget set_idle_sprite
export(Texture) var busy_sprite

var inputLinearDirection = 0
var inputAngularDirection = 0
var movementVector = Vector2.ZERO

func set_idle_sprite(tex):
	idle_sprite = tex
	if Engine.editor_hint:
		get_node("Sprite").texture = idle_sprite
		
func _ready():
	get_node("Sprite").texture = idle_sprite
	
func handle_pick_up():
	heldItem = $RayCast2D.get_collider()
	if heldItem == null:
		return
	
	if heldItem.has_method("get_interactable"):
		heldItem = heldItem.get_interactable()	
	
	if heldItem in channel1.get_node("Contents").get_children():
		channel1.get_node("Contents").call_deferred("remove_child", heldItem)
	elif heldItem in channel2.get_node("Contents").get_children():
		channel2.get_node("Contents").call_deferred("remove_child", heldItem)
	else:
		get_tree().get_root().call_deferred("remove_child", heldItem)
	
	$HeldItemSprite.add_child(heldItem.get_node("Sprite").duplicate())

func handle_drop():
	heldItem = heldItem.as_floor_stick()
	
	var areas = $HeldItemSprite.get_overlapping_areas()
	heldItem.global_position = $HeldItemSprite.global_position
	
	if channel1 in areas:
		if not channel1.add_stick(heldItem):
			return
	elif channel2 in areas:
		if not channel2.add_stick(heldItem):
			return
	else:
		get_tree().get_root().call_deferred("add_child", heldItem)
		heldItem.angular_velocity = rng.randf_range(-random_throw_angular_velocity, random_throw_angular_velocity)
		heldItem.linear_velocity = rng.randf_range(0, random_throw_velocity) * ($HeldItemSprite.global_position - global_position)
		if rng.randi_range(0, 20) == 0:
			heldItem.linear_velocity = 20 * ($HeldItemSprite.global_position - global_position)
			
	$HeldItemSprite.get_node("Sprite").queue_free()
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
	
	if inputLinearDirection == 0:
		speed = 0
	else:
		speed += acceleration * delta
	
	movementVector = Vector2(cos(rotation + PI / 2), sin(rotation + PI / 2)) * inputLinearDirection * speed
	
	move_and_slide(movementVector)
