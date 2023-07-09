extends Camera2D

# Lower cap for the `_zoom_level`.
@export var min_zoom := Vector2(0.001,0.001)
# Upper cap for the `_zoom_level`.
@export var max_zoom := Vector2(10,10)
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
@export var zoom_factor := Vector2(1.1,1.1)

@export var cameraSpeed := 10

func _unhandled_input(event):
	if event.is_action_pressed("zoom_in"):
		if zoom < max_zoom:
			zoom *= zoom_factor
	if event.is_action_pressed("zoom_out"):
		if zoom > min_zoom:
			zoom /= zoom_factor
	
func _process(_delta):
	position += Input.get_vector("A","D","W","S") * cameraSpeed / zoom
