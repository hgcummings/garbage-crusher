extends KinematicBody2D

var rng = RandomNumberGenerator.new()

export var MAX_SPEED = 360
export var ANGULAR_SPEED_DEGS = 5
export var random_throw_velocity = 5.0
export var random_throw_angular_velocity = 1.0

var speed = 0
var acceleration = MAX_SPEED * 3

var initial_delay = 1
var initial_speed = MAX_SPEED / 2

onready var channel1 = get_node("/root/Node2D/Channels/Channel1")
onready var channel2 = get_node("/root/Node2D/Channels/Channel2")

onready var initial_exceptions = [
	get_node("/root/Node2D/Chute1"),
	get_node("/root/Node2D/Chute2"),
	get_node("/root/Node2D/TopWall"),
	get_node("/root/Node2D/BottomWall")
]

var heldItem = null
export var player_number = 1
export(Texture) var idle_sprite setget set_idle_sprite
export(Texture) var holding_sprite
export(Texture) var busy_sprite


var inputLinearDirection = 0
var inputAngularDirection = 0
var movementVector = Vector2.ZERO
var highlighted_object = null;

func set_idle_sprite(tex):
	idle_sprite = tex
	if Engine.editor_hint:
		get_node("Sprite").texture = idle_sprite
		
func _ready():
	get_node("Sprite").texture = idle_sprite
	
func handle_pick_up():
	var tempItem = $RayCast2D.get_collider()
	if not tempItem:
		return
		
	if tempItem.has_method("get_interactable"):
		tempItem = tempItem.get_interactable()	
		
	if tempItem.has_method("as_channel_stick"):
		heldItem = tempItem
	else: 
		return
	
	if heldItem in channel1.get_node("Contents").get_children():
		channel1.get_node("Contents").call_deferred("remove_child", heldItem)
	elif heldItem in channel2.get_node("Contents").get_children():
		channel2.get_node("Contents").call_deferred("remove_child", heldItem)
	else:
		get_tree().get_root().call_deferred("remove_child", heldItem)
	
	$HeldItemSprite.add_child(heldItem.get_node("Sprite").duplicate())

func handle_drop():
	heldItem = heldItem.as_floor_stick()
	heldItem.global_position = $HeldItemSprite.global_position
	
	var object = $RayCast2D.get_collider()
	
	if is_instance_valid(object) && object.has_method("upgrade"):
		if !object.upgrade(heldItem):
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
	
	var is_busy = false
	
	if Input.is_action_pressed("up_%s" % player_number):
		inputLinearDirection += 1
		is_busy = true
	if Input.is_action_pressed("down_%s" % player_number):
		inputLinearDirection -= 0.5
		is_busy = true
	if Input.is_action_pressed("left_%s" % player_number):
		inputAngularDirection -= 1
		is_busy = true
	if Input.is_action_pressed("right_%s" % player_number):
		inputAngularDirection += 1
		is_busy = true
	
	if Input.is_action_pressed("interact_%s" % player_number):
		is_busy = true

	if Input.is_action_just_released("interact_%s" % player_number):
		if heldItem == null:
			handle_pick_up()
		else:
			handle_drop()
			
	if is_busy:
		get_node("Sprite").texture = busy_sprite
	elif heldItem:
		get_node("Sprite").texture = holding_sprite
	else:
		get_node("Sprite").texture = idle_sprite
			
func _physics_process(delta):
	if initial_delay > 0:
		initial_delay -= delta
		return
	elif initial_speed > 0:
		for object in initial_exceptions:
			add_collision_exception_with(object)
		
		speed = initial_speed
		inputLinearDirection = 1
		initial_speed -= (delta * acceleration / 4)
	else:
		if initial_exceptions:
			for object in initial_exceptions:
				remove_collision_exception_with(object)
				initial_exceptions = null
			
		process_inputs()

		rotation_degrees += (inputAngularDirection * ANGULAR_SPEED_DEGS) % 360
		
		if inputLinearDirection == 0:
			speed = 0
		else:
			speed += acceleration * delta
			speed = min(speed, MAX_SPEED)	

	movementVector = Vector2(cos(rotation + PI / 2), sin(rotation + PI / 2)) * inputLinearDirection * speed
	move_and_slide(movementVector)

func _process(delta):
	$RayCast2D.set_collision_mask_bit(13, heldItem != null)
	
	var object = $RayCast2D.get_collider()
	if object && object.has_method("get_interactable"):
		object = object.get_interactable()	
		
	if object != highlighted_object:
		if highlighted_object && is_instance_valid(highlighted_object) && highlighted_object.has_method("unhighlight"):
			highlighted_object.unhighlight()
	if object && object.has_method("highlight"):
		highlighted_object = object
		highlighted_object.highlight()
		
