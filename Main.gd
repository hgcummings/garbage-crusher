extends Node2D

func _process(_delta):
	var braced_channels = []
	
	for channel in $Channels.get_children():
		if _check_if_braced(channel):
			braced_channels.append(channel)
			
	if braced_channels.empty():
		return
	
	var stress = max($LeftWall.stress, $RightWall.stress) / braced_channels.size()
	#print(stress, " ", $LeftWall.stress, " ", $RightWall.stress)
	
	braced_channels.shuffle()
	for channel in braced_channels:
		var broke = false
		for stick in channel.get_node("Contents").get_children():
			if stick.apply_force(stress):
				broke = true
				break
		if broke:
			$LeftWall.stress = 0
			$RightWall.stress = 0
			for stick in channel.get_node("Contents").get_children():
				stick.is_braced = false
			break
				
func _check_if_braced(channel):
	for stick in channel.get_node("Contents").get_children():
		if (stick.is_braced):
			return true
	return false
