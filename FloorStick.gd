extends RigidBody2D

var ChannelStick = load("res://ChannelStick.tscn")
var Helpers = load("res://StickHelpers.gd")

var strength
var level = 1
var stick_status = "default"
var stick_material = "wood"

func _ready():
	$Sprite.texture = Helpers.texture(stick_material, stick_status, level)

func fall_in_hole():
	queue_free()

func as_floor_stick():
	return self

func as_channel_stick():
	var new_stick = ChannelStick.instance()
	Helpers.transfer_stick_properties(self, new_stick)
	return new_stick

func highlight():
	$Sprite.modulate = Color(2,2,2)

func unhighlight():
	$Sprite.modulate = Color(1,1,1)
