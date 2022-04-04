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

const MARGIN = 0
const STICK_MARGIN = -1
				
func _check_if_braced(channel):
	var distance_between_walls = $RightWall.global_position.x - $LeftWall.global_position.x
	var sticks = channel.get_node("Contents").get_children()
	var sticks_length = 0
		
	for stick in sticks:
		sticks_length += stick.get_length() + STICK_MARGIN

	print(sticks_length, " ", distance_between_walls)

	var is_braced = distance_between_walls < sticks_length + MARGIN
	
	for stick in sticks:
		stick.is_braced = is_braced
		
	return is_braced	
