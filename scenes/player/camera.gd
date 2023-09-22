extends Camera2D


func _input(event):
	if event.is_action_pressed("camera_zoom_in"):
		zoom += Vector2(0.1, 0.1)
	elif event.is_action_pressed("camera_zoom_out"):
		zoom -= Vector2(0.1, 0.1)
