extends Area2D

var selected = []
var start_pos: Vector2
var newPositions = []
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Left click"):
		start_pos = get_global_mouse_position()
	if Input.is_action_pressed("Left click"):
		visible = true
		$CollisionShape2D.position = (get_global_mouse_position() - start_pos) / 2 + start_pos
		$ColorRect.position = start_pos
		var size = Vector2(get_global_mouse_position().x-start_pos.x,get_global_mouse_position().y-start_pos.y)
		if size.x < 0:
			size.x = start_pos.x - get_global_mouse_position().x
		if size.y < 0:
			size.y = start_pos.y - get_global_mouse_position().y
		$CollisionShape2D.shape.size = size
		$ColorRect.scale = Vector2(get_global_mouse_position().x-start_pos.x,get_global_mouse_position().y-start_pos.y)
		selected = []
		for i in get_overlapping_areas():
			if i.get_parent().color == MultiplayerManager.nuvarande_lag:
				selected.append(i.get_parent().index)
	else:
		visible = false
		$CollisionShape2D.shape.size = Vector2.ZERO 
	if Input.is_action_just_pressed("Right click"):
		newPositions = []
	if Input.is_action_pressed("Right click"):
		if !newPositions.has($"../TileMap".local_to_map(get_global_mouse_position())):
			newPositions.append($"../TileMap".local_to_map(get_global_mouse_position()))
		for i in newPositions:
			$"../TileMap".set_cell(1, i, 1, Vector2i(0,0))
	if Input.is_action_just_released("Right click"):
		var summa:int
		for i in selected:
			summa += $"../Unit Maneger".sizes[i]
		var newSize:int = summa / len(newPositions)
		var rest:int = summa - newSize * len(newPositions)
		for i2 in range(len(newPositions)):
			var curentNewSize = newSize
			if i2 < rest:
				curentNewSize += 1
			var newSelected = []
			for i in selected:
				if curentNewSize >= $"../Unit Maneger".sizes[i]:
					curentNewSize -= $"../Unit Maneger".sizes[i]
					$"../Unit Maneger".syncSetSchedule(i,[newPositions[i2]])
					await get_tree().create_timer(0.1).timeout
				else:
					if curentNewSize == 0:
						newSelected.append(i)
					else:
						$"../Unit Maneger".syncNewUnit($"../Unit Maneger".positions[i],$"../Unit Maneger".colors[i],$"../Unit Maneger".sizes[i]-curentNewSize)
				
						$"../Unit Maneger".syncSetSchedule(i,[newPositions[i2]])
						await get_tree().create_timer(0.1).timeout
						newSelected.append(len($"../Unit Maneger".nodes)-1)
						$"../Unit Maneger".syncSetSize(i,curentNewSize)
						await get_tree().create_timer(0.1).timeout
						curentNewSize = 0
			selected = newSelected
			
			
		for i in newPositions:
			$"../TileMap".set_cell(1, i, -1, Vector2i(0,0))
		newPositions = []
	
