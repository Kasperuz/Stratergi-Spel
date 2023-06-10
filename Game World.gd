extends Node2D
var krona = preload("res://krona.tscn")
var antal_click = 0
var huvudstadsPosition = Vector2i(0,0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if antal_click != -1:
		if Input.is_action_just_pressed("Left click"):
			antal_click += 1
			$CanvasLayer/Label.text = "Är du säker?"
			if antal_click == 2:
				if huvudstadsPosition == $TileMap.local_to_map(get_global_mouse_position()):
					$CanvasLayer/Label.visible = false
					$CanvasLayer/Label.text = "Välj en huvudstad"
					antal_click = -1
					$"Map-Information".huvudstäder[$"CanvasLayer/Lag välgare".lag] = huvudstadsPosition
					var instance = krona.instantiate()
					instance.set_position($TileMap.map_to_local(huvudstadsPosition))
					add_child(instance)
					
				else:
					antal_click = 0
					$CanvasLayer/Label.text = "Välj en huvudstad"

			huvudstadsPosition = $TileMap.local_to_map(get_global_mouse_position())
			
