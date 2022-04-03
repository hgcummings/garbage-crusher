extends Node2D

const channel_groups = ["channel_1", "channel_2"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	var braced_channels = []
	
	for channel_group in channel_groups:
		if _check_if_braced(channel_group):
			braced_channels.append(channel_group)
			
	if braced_channels.empty():
		return
	
	var stress = $LeftWall.stress / braced_channels.size()
	
	for channel_group in braced_channels:
		var broke = false
		for stick in get_tree().get_nodes_in_group(channel_group):
			if stick.apply_force(stress):
				broke = true
				break
		if broke:
			for stick in get_tree().get_nodes_in_group(channel_group):
				stick.is_braced = false

				
func _check_if_braced(group):
	for stick in get_tree().get_nodes_in_group(group):
		if (stick.is_braced):
			return true
	return false
