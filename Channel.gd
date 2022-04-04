extends Area2D

var ChannelStick = load("res://ChannelStick.tscn")
var contents

export var layer_zero_indexed = 0
const wall_layer = 8

func _ready():
	contents = self.get_node("Contents")

func add_stick(stick):
	var new_stick = stick.as_channel_stick() as KinematicBody2D
	print(new_stick)

	contents.add_child(new_stick)
	

	new_stick.rotation = 0
	new_stick.global_position = stick.global_position
	new_stick.global_position.y = self.global_position.y
	
	
	
	new_stick.collision_layer = 0
	new_stick.collision_mask = 0
	
	new_stick.set_collision_layer_bit(layer_zero_indexed, true)
	new_stick.set_collision_mask_bit(wall_layer, true)
	new_stick.set_collision_mask_bit(layer_zero_indexed, true)
	
	if new_stick.move_and_collide(Vector2.ZERO, true, true, true):
		contents.remove_child(new_stick)
		return false
	
	return true
