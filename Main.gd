extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	var braced_channels = []
	
	for channel in $Channels.get_children():
		if _check_if_braced(channel):
			braced_channels.append(channel)
			
	if braced_channels.empty():
		return
	
	var stress = $LeftWall.stress / braced_channels.size()
	
	for channel in braced_channels:
		var broke = false
		for stick in channel.get_node("Contents").get_children():
			if stick.apply_force(stress):
				broke = true
				break
		if broke:
			for stick in channel.get_node("Contents").get_children():
				stick.is_braced = false

				
func _check_if_braced(channel):
	for stick in channel.get_node("Contents").get_children():
		if (stick.is_braced):
			return true
	return false
