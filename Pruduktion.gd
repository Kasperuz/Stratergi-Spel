extends Timer

var pengar = []

func _ready():
	pengar.resize($"../CanvasLayer/Lag välgare".antal_lag)
	pengar.fill(0)

func _on_timeout():
	start(1.0)
	for x in range($"../Map-Information".size.x):
		for y in range($"../Map-Information".size.y):
			if !$"../Map-Information".land[x][y] == 0:
				pengar[$"../Map-Information".land[x][y]-1] += $"../Map-Information".production[x][y]
	$"../CanvasLayer/Pengar/Label".text = "Pengar: "+str(floor(pengar[$"../CanvasLayer/Lag välgare".lag-1]))
