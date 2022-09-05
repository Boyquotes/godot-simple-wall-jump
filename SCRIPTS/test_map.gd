extends Spatial


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit() # Quits the game


	if Input.is_action_just_pressed("ui_end"): # set full screen
		OS.window_fullscreen = !OS.window_fullscreen
	
	if Input.is_action_just_pressed("ui_home"): # reset
		get_tree().reload_current_scene()
