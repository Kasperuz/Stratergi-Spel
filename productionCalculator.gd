extends Timer

var pengar = []

func _ready():
	pengar.resize(MultiplayerManager.antal_lag)
	pengar.fill(10)

func _on_timeout():
	start(1.0)
	$"../Unit Maneger".antalGubbar.fill(0)
	for i in range(len($"../Unit Maneger".sizes)):
		$"../Unit Maneger".antalGubbar[$"../Unit Maneger".colors[i]] += $"../Unit Maneger".sizes[i]
	for x in range($"../Map-Information".size.x):
		for y in range($"../Map-Information".size.y):
			if !$"../Map-Information".land[x][y] == 0:
				pengar[$"../Map-Information".land[x][y]] += $"../Map-Information".production[x][y] * 0.01 
				update()
	#print("Pengar: ",pengar," AntalGubbar: ",$"../Unit Maneger".antalGubbar)
	for i in range(0,MultiplayerManager.antal_lag):
		pengar[i] -= ($"../Unit Maneger".antalGubbar[i] / 10)
		
func update():
	$"../CanvasLayer/Ui/VBoxContainer/Pengar/Label".text = "Pengar: "+str(floor(pengar[MultiplayerManager.nuvarande_lag]))
