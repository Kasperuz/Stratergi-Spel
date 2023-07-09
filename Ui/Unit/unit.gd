extends Node2D

@export var color: int
@export var size: int
@export var index: int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.region_rect.position.x = 32 * (color -1)
func _process(delta):
	if size < 1000:
		$Label.text = str(size)
	else:
		$Label.text = str(floor(float(size)*0.01)*0.1) + "k" 
