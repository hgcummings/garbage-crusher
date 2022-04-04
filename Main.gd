extends Node2D

func _process(_delta):
	var braced_channels = []
	
	for channel in $Channels.get_children():
		if _check_if_braced(channel):
			braced_channels.append(channel)
			
	if braced_channels.empty():
		$LeftWall.is_braced = false
		$RightWall.is_braced = false
		return
	else:
		$LeftWall.is_braced = true
		$RightWall.is_braced = true
	
	var stress = max($LeftWall.stress, $RightWall.stress) / braced_channels.size()
	#print(stress, " ", $LeftWall.stress, " ", $RightWall.stress)
	
	braced_channels.shuffle()
	var broke = false
	for channel in braced_channels:
		for stick in channel.get_node("Contents").get_children():
			if stick.apply_force(stress):
				broke = true
				break
		if broke:
			for stick in channel.get_node("Contents").get_children():
				stick.is_braced = false
			break

	if (broke && braced_channels.size() == 1):
		$LeftWall.is_braced = false
		$RightWall.is_braced = false

				
func _check_if_braced(channel):
	for stick in channel.get_node("Contents").get_children():
		if (stick.is_braced):
			return true
	return false
