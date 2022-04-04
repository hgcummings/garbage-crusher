extends Area2D

var ChannelStick = load("res://ChannelStick.tscn")
var contents

export var layer_zero_indexed = 0
const wall_layer = 8
const guide_layer = 14
const interactable_layer = 12

onready var walls = [
	get_node("/root/Node2D/LeftWall"),
	get_node("/root/Node2D/RightWall")
]

func _ready():
	contents = self.get_node("Contents")

func upgrade(stick):
	var target = stick.global_position.x
	var new_stick = stick.as_channel_stick() as KinematicBody2D
	
	var lower_bound = walls[0].global_position.x + new_stick.get_length() / 2
	var upper_bound = walls[1].global_position.x - new_stick.get_length() / 2
	
	for child_stick in contents.get_children():
		var position = child_stick.global_position.x
		if position < target:
			lower_bound = max(lower_bound, position + child_stick.get_length())
		else:
			upper_bound = min(upper_bound, position - child_stick.get_length())	

	if lower_bound > upper_bound:
		lower_bound -= 2
		upper_bound += 2
		
	if lower_bound > upper_bound:
		return false

	target = max(lower_bound, min(target, upper_bound))

	contents.add_child(new_stick)

	new_stick.rotation = 0
	new_stick.global_position = Vector2(target, self.global_position.y)
	
	new_stick.collision_layer = 0
	new_stick.collision_mask = 0
	
	new_stick.set_collision_layer_bit(layer_zero_indexed, true)
	new_stick.set_collision_mask_bit(wall_layer, true)
	new_stick.set_collision_mask_bit(guide_layer, true)
	new_stick.set_collision_mask_bit(layer_zero_indexed, true)
	new_stick.set_collision_mask_bit(interactable_layer, true)
	
	return true
	
func highlight():
	$Sprite.modulate = Color(2,2,2)

func unhighlight():
	$Sprite.modulate = Color(1,1,1)
