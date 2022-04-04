extends Node2D

func _ready():
	$NewGame.color = Color.gainsboro
	$Quit.color = Color.gainsboro
	$SurvivedText.text = "You survived for %s seconds" % GlobalTimer.latest_time
	
func _on_NewGame_gui_input(event):
	if event is InputEventMouseButton:
		get_tree().change_scene("res://Main.tscn")

func _on_NewGame_mouse_entered():
	$NewGame.color = Color.slategray

func _on_NewGame_mouse_exited():
	$NewGame.color = Color.gainsboro
	
func _on_Quit_gui_input(event):
	if event is InputEventMouseButton:
		get_tree().quit()

func _on_Quit_mouse_entered():
	$Quit.color = Color.slategray

func _on_Quit_mouse_exited():
	$Quit.color = Color.gainsboro
