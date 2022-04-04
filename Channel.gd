extends Area2D

var ChannelStick = load("res://ChannelStick.tscn")
var contents

export var layer_zero_indexed = 0
const wall_layer = 8
const interactable_layer = 12

func _ready():
	contents = self.get_node("Contents")

func upgrade(stick):
	var new_stick = stick.as_channel_stick() as KinematicBody2D

	contents.add_child(new_stick)
	

	new_stick.rotation = 0
	new_stick.global_position = stick.global_position
	new_stick.global_position.y = self.global_position.y
	
	new_stick.collision_layer = 0
	new_stick.collision_mask = 0
	
	new_stick.set_collision_layer_bit(layer_zero_indexed, true)
	new_stick.set_collision_mask_bit(wall_layer, true)
	new_stick.set_collision_mask_bit(layer_zero_indexed, true)
	new_stick.set_collision_mask_bit(interactable_layer, true)
	
	var collision = new_stick.move_and_collide(Vector2.ZERO, true, true, true)
	if collision:
		contents.remove_child(new_stick)
		if collision.collider in contents.get_children():
			return collision.collider.upgrade(new_stick)
		return false
	return true

func highlight():
	$Sprite.modulate = Color(2,2,2)

func unhighlight():
	$Sprite.modulate = Color(1,1,1)
