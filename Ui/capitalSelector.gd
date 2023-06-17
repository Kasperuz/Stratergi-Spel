extends Node2D
var krona = preload("res://Ui/capitalCrown.tscn")
var antal_click = 0
var huvudstadsPosition = Vector2i(0,0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $"Map-Information".capitals[$"CanvasLayer/Lag välgare".lag] == Vector2i(-1,-1):
		$CanvasLayer/Label.visible = true
		if Input.is_action_just_pressed("Left click"):
			antal_click += 1
			$CanvasLayer/Label.text = "Är du säker?"
			if antal_click == 2:
				if huvudstadsPosition == $TileMap.local_to_map(get_global_mouse_position()):
					$CanvasLayer/Label.visible = false
					$CanvasLayer/Label.text = "Välj en huvudstad"
					antal_click = -1
					$"Map-Information".capitals[$"CanvasLayer/Lag välgare".lag] = huvudstadsPosition
					var instance = krona.instantiate()
					instance.set_position($TileMap.map_to_local(huvudstadsPosition))
					add_child(instance)
					$"Map-Information".land[huvudstadsPosition.x][huvudstadsPosition.y] = $"CanvasLayer/Lag välgare".lag
					$"Map-Information".production[huvudstadsPosition.x][huvudstadsPosition.y] += 100
					$"Map-Information".updateTileMap()
				else:
					antal_click = 0
					$CanvasLayer/Label.text = "Välj en huvudstad"

			huvudstadsPosition = $TileMap.local_to_map(get_global_mouse_position())
			
