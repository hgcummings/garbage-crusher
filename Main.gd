extends Node2D

const channel_groups = ["channel_1", "channel_2"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(delta):
	var bracing_channels = []
	
	for channel_group in channel_groups:
		if _check_if_bracing(channel_group):
			bracing_channels.append(channel_group)
			
	if bracing_channels.empty():
		return
	
	var force = $LeftWall.force / bracing_channels.size()
	print(force)
		
	for channel_group in bracing_channels:
		for stick in get_tree().get_nodes_in_group(channel_group):
			stick.apply_force(force)
				
func _check_if_bracing(group):
	for stick in get_tree().get_nodes_in_group(group):
		if (stick.is_bracing):
			return true
	return false
