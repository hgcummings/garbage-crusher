extends RigidBody2D

var ChannelStick = load("res://ChannelStick.tscn")
var Helpers = load("res://StickHelpers.gd")

var strength

func fall_in_hole():
	queue_free()

func as_floor_stick():
	return self

func as_channel_stick():
	var new_stick = ChannelStick.instance()
	Helpers.transfer_stick_properties(self, new_stick)
	return new_stick
