extends Node


@export var size: Vector2i

@export var land: Array

@export var speedNoise: Noise
@export var speed: Array

@export var productionNoise: Noise
@export var production: Array

@export var defenceNoise: Noise
@export var defence: Array

enum mapModes{ speed = 0, production = 1, defence = 2 }

var rng = RandomNumberGenerator.new()

@onready var tileMap := $"../TileMap"

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	for x in range(size.x-1):
		speed.append([])
		production.append([])
		defence.append([])
		land.append([])
		for y in range(size.y-1):
			speed[x].append((speedNoise.get_noise_2d(x,y)+1)*0.5)
			production[x].append((productionNoise.get_noise_2d(x,y)+1)*0.5)
			defence[x].append((defenceNoise.get_noise_2d(x,y)+1)*0.5)
			land[x].append(0)
	updateTileMap()

func updateTileMap():
	for x in range(size.x -1):
		for y in range(size.y -1):
			var tempCordinate: int
			if $"../CanvasLayer/Map mode ui".mapMode == mapModes.speed:
				tempCordinate = floor(speed[x][y] * 10)
			elif $"../CanvasLayer/Map mode ui".mapMode == mapModes.production:
				tempCordinate = floor(production[x][y] * 10)
			elif $"../CanvasLayer/Map mode ui".mapMode == mapModes.defence:
				tempCordinate = floor(defence[x][y] * 10)
				
			tileMap.set_cell(0, Vector2i(x,y), 0, Vector2i(land[x][y], tempCordinate))
