extends Node2D

@export var color: int
@export var size: int
@export var index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.region_rect.position.x = 32 * (color -1)
func _process(_delta):
	if size < 1000:
		$Label.text = str(size)
	else:
		$Label.text = str(floor(float(size)*0.01)*0.1) + "k" 
	if ! multiplayer.is_server():
		var x = $"../TileMap".local_to_map(position).x
		var y = $"../TileMap".local_to_map(position).y
		$"../Map-Information".land[x][y] = color
		var tempCordinate: int
		if $"../CanvasLayer/Ui/Map mode ui".mapMode == $"../Map-Information".mapModes.speed:
			tempCordinate = floor($"../Map-Information".speed[x][y] * 10)
			if (tempCordinate > 10):
				tempCordinate = 10
		elif $"../CanvasLayer/Ui/Map mode ui".mapMode == $"../Map-Information".mapModes.production:
			tempCordinate = floor($"../Map-Information".production[x][y] * 10)
			if (tempCordinate > 10):
				tempCordinate = 0
		elif $"../CanvasLayer/Ui/Map mode ui".mapMode == $"../Map-Information".mapModes.defence:
			tempCordinate = floor($"../Map-Information".defence[x][y] * 10)
			if (tempCordinate > 10):
				tempCordinate = 10
			
		$"../TileMap".set_cell(0, Vector2i(x,y), 0, Vector2i(color, tempCordinate))
